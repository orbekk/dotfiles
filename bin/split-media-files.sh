max_duration=$((4*3600))

if [[ $# -ne 1 ]]; then
    echo 1>&2 "Usage: $0 <media-file>"
    exit 1
fi

input_file="$1"

base="$(basename $input_file | perl -pe 's/(.*)\.([^.]*)$/$1/')"

ffmpeg -i "${input_file}" \
       -f segment -segment_time $max_duration -segment_start_number 1 \
       -segment_format mp3 -qscale:a 5 \
       "${base}-%02d.mp3"
