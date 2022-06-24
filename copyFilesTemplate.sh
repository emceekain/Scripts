SRC='/path/to/source/folder/'
DST='/path/to/destination/folder/'

declare -a fileArray=(
    'path/to/file1'
    'path/to/file2'
    'path/to/file3'
)

for file in "${fileArray[@]}"
do
    cp "$SRC/$file" "$DST/$file"
done