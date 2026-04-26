files_to_dirs() {
  local target="${1:-.}"

  for f in "$target"/*; do
    [ -f "$f" ] || continue

    filename=$(basename "$f")
    dirname="${filename%.*}"

    mkdir -p "$target/$dirname"
    mv "$f" "$target/$dirname/"
  done
}