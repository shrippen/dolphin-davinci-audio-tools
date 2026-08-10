#!/usr/bin/env bash
# Shared KDE batch progress dialog for multi-file conversions.
# Progress and ETA are weighted by media duration, not file count.
#
# Usage:
#   source "$SCRIPT_DIR/lib_batch_progress.sh"
#   batch_progress_start "Title" "FLAC" "${FILES[@]}"
#   trap 'batch_progress_close' EXIT
#   for ...; do
#     ffmpeg_with_batch_progress ffmpeg -y -i "$IN" ... "$OUT"
#     batch_progress_advance
#   done
#   batch_progress_close
#
# Note: callers often set IFS=$'\n\t'. This library must not rely on
# word-splitting on spaces (kdialog dbus refs contain a space).

BP_KDIALOG="${KDIALOG:-/usr/bin/kdialog}"
BP_QDBUS=""
BP_DBUS_SERVICE=""
BP_DBUS_PATH=""
BP_ACTION=""
BP_FILES=()
BP_NAMES=()
BP_DURS=()
BP_COUNT=0
BP_INDEX=0
BP_TOTAL_MEDIA_SEC=0
BP_DONE_MEDIA_SEC=0
BP_WALL_START=0
BP_LAST_PCT=-1
BP_LAST_LABEL=""
BP_LAST_UI_WALL=0

media_duration_sec() {
  local input_file="$1"
  local dur hours minutes seconds

  dur=$(ffprobe -v error -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 "$input_file" 2>/dev/null || true)
  if [[ -n "$dur" && "$dur" != "N/A" ]]; then
    # Locale-safe: ffprobe always uses '.' as decimal separator.
    dur=${dur%%.*}
    [[ "$dur" =~ ^[0-9]+$ ]] || dur=0
    echo "$dur"
    return 0
  fi

  dur=$("${FFMPEG:-ffmpeg}" -i "$input_file" 2>&1 | grep "Duration" | awk '{print $2}' | tr -d , || true)
  if [[ -z "$dur" || "$dur" == "N/A" ]]; then
    echo 0
    return 0
  fi
  hours=${dur:0:2}
  minutes=${dur:3:2}
  seconds=${dur:6:2}
  echo $((10#$hours * 3600 + 10#$minutes * 60 + 10#$seconds))
}

format_duration_short() {
  local s=${1:-0}
  if (( s < 0 )); then s=0; fi
  local h=$((s / 3600))
  local m=$(((s % 3600) / 60))
  local sec=$((s % 60))
  if (( h > 0 )); then
    printf '%dh %dm' "$h" "$m"
  elif (( m > 0 )); then
    printf '%dm %ds' "$m" "$sec"
  else
    printf '%ds' "$sec"
  fi
}

_bp_find_qdbus() {
  if command -v qdbus6 >/dev/null 2>&1; then
    BP_QDBUS="qdbus6"
  elif command -v qdbus >/dev/null 2>&1; then
    BP_QDBUS="qdbus"
  else
    echo "Neither qdbus6 nor qdbus found (needed for kdialog progress)." >&2
    return 1
  fi
}

# Split "service path" without depending on IFS word-splitting.
_bp_parse_dbus_ref() {
  local ref="$1"
  BP_DBUS_SERVICE="${ref%% *}"
  BP_DBUS_PATH="${ref#* }"
  # Trim possible CR/newlines from kdialog output
  BP_DBUS_SERVICE="${BP_DBUS_SERVICE//$'\r'/}"
  BP_DBUS_SERVICE="${BP_DBUS_SERVICE//$'\n'/}"
  BP_DBUS_PATH="${BP_DBUS_PATH//$'\r'/}"
  BP_DBUS_PATH="${BP_DBUS_PATH//$'\n'/}"
}

_bp_qdbus() {
  [[ -n "$BP_QDBUS" && -n "$BP_DBUS_SERVICE" && -n "$BP_DBUS_PATH" ]] || return 0
  "$BP_QDBUS" "$BP_DBUS_SERVICE" "$BP_DBUS_PATH" "$@" >/dev/null 2>&1 || true
}

_bp_set_value() {
  local value="$1"
  # Prefer the portable Properties.Set API (works with qdbus and qdbus6).
  _bp_qdbus org.freedesktop.DBus.Properties.Set \
    org.kde.kdialog.ProgressDialog value "$value"
}

_bp_set_label() {
  _bp_qdbus org.kde.kdialog.ProgressDialog.setLabelText "$1"
}

_bp_set_auto_close() {
  _bp_qdbus org.freedesktop.DBus.Properties.Set \
    org.kde.kdialog.ProgressDialog autoClose "$1"
}

_bp_close_dialog() {
  _bp_qdbus org.kde.kdialog.ProgressDialog.close
}

_bp_pending_list() {
  local i
  local names=()
  local max_show=6
  for ((i = BP_INDEX; i < BP_COUNT; i++)); do
    names+=("${BP_NAMES[$i]}")
  done
  if ((${#names[@]} == 0)); then
    echo "(none)"
    return
  fi
  if ((${#names[@]} > max_show)); then
    local shown=("${names[@]:0:max_show}")
    local rest=$((${#names[@]} - max_show))
    local joined
    joined=$(printf '%s, ' "${shown[@]}")
    printf '%s… (+%d more)' "${joined%, }" "$rest"
  else
    local joined
    joined=$(printf '%s, ' "${names[@]}")
    printf '%s' "${joined%, }"
  fi
}

_bp_build_label() {
  local file_out_sec=${1:-0}
  local current="${BP_NAMES[$BP_INDEX]:-?}"
  local pending
  pending=$(_bp_pending_list)

  local overall=$((BP_DONE_MEDIA_SEC + file_out_sec))
  local wall_now wall_elapsed eta_text="…"
  wall_now=$(date +%s)
  wall_elapsed=$((wall_now - BP_WALL_START))

  if ((wall_elapsed >= 2 && overall > 0 && BP_TOTAL_MEDIA_SEC > overall)); then
    local remaining=$((BP_TOTAL_MEDIA_SEC - overall))
    local eta_sec=$((remaining * wall_elapsed / overall))
    eta_text=$(format_duration_short "$eta_sec")
  elif ((BP_TOTAL_MEDIA_SEC > 0 && overall >= BP_TOTAL_MEDIA_SEC)); then
    eta_text="0s"
  fi

  printf 'File %d of %d: %s → %s\nPending: %s\nETA ~ %s' \
    "$((BP_INDEX + 1))" "$BP_COUNT" "$current" "$BP_ACTION" "$pending" "$eta_text"
}

_bp_update_ui() {
  local file_out_sec=${1:-0}
  local force=${2:-0}
  local cur_dur=${BP_DURS[$BP_INDEX]:-0}
  if ((file_out_sec < 0)); then file_out_sec=0; fi
  if ((cur_dur > 0 && file_out_sec > cur_dur)); then file_out_sec=$cur_dur; fi

  local overall=$((BP_DONE_MEDIA_SEC + file_out_sec))
  local pct=0
  if ((BP_TOTAL_MEDIA_SEC > 0)); then
    pct=$((overall * 100 / BP_TOTAL_MEDIA_SEC))
  elif ((BP_COUNT > 0)); then
    pct=$((BP_INDEX * 100 / BP_COUNT))
  fi
  if ((pct < 0)); then pct=0; fi
  if ((pct > 100)); then pct=100; fi

  local wall_now
  wall_now=$(date +%s)
  # Throttle dbus traffic: update at least every second, or when percent changes.
  if ((force == 0 && pct == BP_LAST_PCT && wall_now == BP_LAST_UI_WALL)); then
    return 0
  fi
  BP_LAST_UI_WALL=$wall_now

  local label
  label=$(_bp_build_label "$file_out_sec")

  if ((pct != BP_LAST_PCT)); then
    _bp_set_value "$pct"
    BP_LAST_PCT=$pct
  fi
  if [[ "$label" != "$BP_LAST_LABEL" ]]; then
    _bp_set_label "$label"
    BP_LAST_LABEL="$label"
  fi
}

# batch_progress_start TITLE ACTION file1 [file2 ...]
batch_progress_start() {
  local title="$1"
  local action="$2"
  shift 2

  BP_ACTION="$action"
  BP_FILES=("$@")
  BP_COUNT=${#BP_FILES[@]}
  BP_NAMES=()
  BP_DURS=()
  BP_TOTAL_MEDIA_SEC=0
  BP_DONE_MEDIA_SEC=0
  BP_INDEX=0
  BP_LAST_PCT=-1
  BP_LAST_LABEL=""
  BP_DBUS_SERVICE=""
  BP_DBUS_PATH=""

  if ((BP_COUNT == 0)); then
    return 0
  fi

  local f dur
  for f in "${BP_FILES[@]}"; do
    BP_NAMES+=("$(basename "$f")")
    dur=$(media_duration_sec "$f")
    [[ "$dur" =~ ^[0-9]+$ ]] || dur=0
    BP_DURS+=("$dur")
    BP_TOTAL_MEDIA_SEC=$((BP_TOTAL_MEDIA_SEC + dur))
  done

  _bp_find_qdbus || return 1

  if [[ ! -x "$BP_KDIALOG" ]]; then
    if command -v kdialog >/dev/null 2>&1; then
      BP_KDIALOG="$(command -v kdialog)"
    else
      echo "kdialog not found." >&2
      return 1
    fi
  fi

  local initial ref
  initial=$(_bp_build_label 0)
  ref=$("$BP_KDIALOG" --title "$title" --progressbar "$initial" 100)
  _bp_parse_dbus_ref "$ref"
  _bp_set_value 0
  # Keep dialog open across files; close explicitly at the end.
  _bp_set_auto_close false
  BP_WALL_START=$(date +%s)
  BP_LAST_LABEL="$initial"
}

batch_progress_tick() {
  _bp_update_ui "${1:-0}" "${2:-0}"
}

# Mark current file finished and move to the next pending entry.
batch_progress_advance() {
  if ((BP_INDEX < BP_COUNT)); then
    BP_DONE_MEDIA_SEC=$((BP_DONE_MEDIA_SEC + ${BP_DURS[$BP_INDEX]:-0}))
    BP_INDEX=$((BP_INDEX + 1))
  fi
  if ((BP_INDEX < BP_COUNT)); then
    _bp_update_ui 0 1
  else
    _bp_set_value 100
    _bp_set_label "Done."
    BP_LAST_PCT=100
  fi
}

batch_progress_close() {
  if [[ -n "$BP_DBUS_SERVICE" ]]; then
    _bp_close_dialog
    BP_DBUS_SERVICE=""
    BP_DBUS_PATH=""
  fi
}

# Run ffmpeg (or compatible) with -progress pipe:1 and feed ticks into the dialog.
# Returns ffmpeg's exit status.
ffmpeg_with_batch_progress() {
  local exit_file out_ms out_sec
  exit_file=$(mktemp)

  # Use a subshell so PIPESTATUS is captured next to the pipeline.
  # Progress callbacks only talk to D-Bus; they do not need parent locals.
  (
    # -progress before other options so it is always honored as a global flag.
    "$@" -nostats -progress pipe:1 2>/dev/null | while IFS= read -r line || [[ -n "$line" ]]; do
      if [[ "$line" =~ out_time_ms=([0-9]+) ]]; then
        out_ms=${BASH_REMATCH[1]}
        out_sec=$((out_ms / 1000000))
        batch_progress_tick "$out_sec"
      fi
    done
    echo "${PIPESTATUS[0]}" >"$exit_file"
  )

  local ec
  ec=$(cat "$exit_file" 2>/dev/null || echo 1)
  rm -f "$exit_file"
  return "$ec"
}
