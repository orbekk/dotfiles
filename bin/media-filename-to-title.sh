#!bash

for f in *; do
    ffmpeg -i "$f" -metadata title="$(basename $f)" -c copy "new_$f"
    mv "new_$f" "$f"
done

