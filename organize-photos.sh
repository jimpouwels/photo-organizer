# Date: 2018-05-04
# Author: Jim Pouwels <jim.pouwels@gmail.com>
SOURCE_FOLDER="$1"
TARGET_PATH="$2"

find "$SOURCE_FOLDER" -type f ! -path "*/@eaDir/*" | while read -r photo
do
  PHOTO_DATE=$(stat -c %y "$photo")
  PHOTO_YEAR=$(echo "$PHOTO_DATE" | cut -d "-" -f 1)
  PHOTO_MONTH=$(echo "$PHOTO_DATE" | cut -d "-" -f 2)
  FINAL_TARGET_BASE="${TARGET_PATH}/${PHOTO_YEAR}_${PHOTO_MONTH}"
  FINAL_TARGET_MOBILE="${TARGET_PATH}/${PHOTO_YEAR}_${PHOTO_MONTH}/mobile"
  FINAL_TARGET_VIDEO="${FINAL_TARGET_BASE}/video"
  
  BASENAME=$(basename "$photo")

  if [[ "${BASENAME,,}" =~ ^(dsc_|dji_) ]]; then
    echo "Deleting non-phone file: $photo"
    rm -f "$photo"
    continue
  fi

  mkdir -p "$FINAL_TARGET_BASE"
  
  if [[ "${BASENAME,,}" == *.mov ]] || [[ "${BASENAME,,}" == *.mp4 ]]; then
    mkdir -p "$FINAL_TARGET_VIDEO"
    mv "$photo" "$FINAL_TARGET_VIDEO/"
    echo "moved video $photo → $FINAL_TARGET_VIDEO"
  else
    mkdir -p "$FINAL_TARGET_MOBILE"
    mv "$photo" "$FINAL_TARGET_MOBILE/"
    echo "moved photo $photo → $FINAL_TARGET_MOBILE"
  fi
done
