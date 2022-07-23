# Script to lazily call Phonify.py
relativePlaylistPath=$1
device=$2
mode="default"
dated="false"
for i in "$@"
do
    case $i in
        -u|--utf8)
        mode="utf8"
        shift # past argument=value
        ;;
        -d|--dated)
        dated="true"
        shift # past argument=value
        ;;
        --default)
        mode="default"
        shift # past argument with no value
        ;;
        *)
              # unknown option
        ;;
    esac
done

python ~/Development/Scripts/Phonify.py $relativePlaylistPath $device $mode $dated
