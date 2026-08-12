#!/usr/bin/env bash
# Shared media detection helpers for conversion scripts.

is_valid_file() {
    local input_file="$1"
    local min_size=1024

    if [[ ! -f "$input_file" || ! -r "$input_file" ]]; then
        return 1
    fi

    local file_size
    file_size=$(stat -c%s "$input_file" 2>/dev/null || echo 0)
    if [[ $file_size -lt $min_size ]]; then
        return 1
    fi

    if ! ffprobe -v error -show_format "$input_file" >/dev/null 2>&1; then
        return 1
    fi

    return 0
}

detect_audio_streams() {
    local input_file="$1"
    local audio_streams
    audio_streams=$(ffprobe -v error -select_streams a -show_entries stream=codec_name -of csv=p=0 "$input_file" 2>/dev/null)
    if [[ -z "$audio_streams" ]]; then
        echo "none"
    else
        echo "$audio_streams"
    fi
}

has_audio_streams() {
    [[ $(detect_audio_streams "$1") != "none" ]]
}

has_aac_audio() {
    local input_file="$1"
    local audio_streams
    audio_streams=$(detect_audio_streams "$input_file")
    if [[ "$audio_streams" == "none" ]]; then
        return 1
    fi
    if echo "$audio_streams" | grep -q "aac"; then
        return 0
    else
        return 1
    fi
}

has_video_streams() {
    local input_file="$1"
    local video_streams
    video_streams=$(ffprobe -v error -select_streams v -show_entries stream=codec_type -of csv=p=0 "$input_file" 2>/dev/null)
    [[ -n "$video_streams" ]]
}

is_audio_only() {
    has_audio_streams "$1" && ! has_video_streams "$1"
}

detect_video_codec() {
    local input_file="$1"
    local video_codec
    video_codec=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 "$input_file" 2>/dev/null || true)
    if [[ -z "$video_codec" ]]; then
        echo "none"
    else
        echo "$video_codec"
    fi
}

get_unique_filename() {
    local dir="$1"
    local name="$2"
    local ext="$3"
    local counter=1
    if [[ ! -f "$dir/$name.$ext" ]]; then
        echo "$name.$ext"
        return 0
    fi
    while [[ -f "$dir/$name ($counter).$ext" ]]; do
        ((counter++))
    done
    echo "$name ($counter).$ext"
}

replace_original_with() {
    local original="$1"
    local tmp_output="$2"
    local new_basename="$3"

    local dir new_path
    dir="$(dirname "$original")"
    new_path="$dir/$new_basename"

    mv "$original" "${original}.bak"
    mv "$tmp_output" "$new_path"
    rm -f "${original}.bak"
}
