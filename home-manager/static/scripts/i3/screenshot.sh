# The base directory in which the screenshot is saved
BASE_FOLDER=$1
# Options to scrot program
OPTS=$2

mkdir -p $BASE_FOLDER

file_path="$BASE_FOLDER/Screenshot-$(date '+%Y-%m-%d_%H-%M-%S').png"

maim $OPTS ${file_path}
