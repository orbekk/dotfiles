#!bash

max_duration=$((4*3600))

if [[ $# -ne 1 ]]; then
    echo 1>&2 "Usage: $0 <media-file>"
    exit 1
fi

input_file="$1"

base="$(basename $input_file | perl -pe 's/(.*)\.([^.]*)$/$1/')"
extension="$(echo $input_file | perl -pe 's/(.*)\.([^.]*)$/$2/')"
if [[ $extension == "m4b" ]]; then
  extension=m4a
fi

ffmpeg -i "${input_file}" -metadata title="%03d" -c copy -f segment -segment_time $max_duration \
       "${base}-%03d.${extension}"
