#!/data/data/com.termux/files/usr/bin/bash

INPUT="$1"
WORK="boot2vid_tmp"
FRAMES="frames"
OUTPUT="bootanimation.mp4"

if [ -z "$INPUT" ]; then
echo "Usage:"
echo "./boot2vid.sh bootanimation.zip"
exit
fi

echo "Boot2Vid starting..."

rm -rf $WORK
mkdir $WORK
cd $WORK

echo "Extracting bootanimation..."
unzip ../$INPUT > /dev/null

mkdir $FRAMES

FPS=$(head -n1 desc.txt | awk '{print $3}')

echo "FPS: $FPS"

i=0

for p in part*; do
for f in $p/*.png; do
printf -v n "%05d" $i
cp "$f" "$FRAMES/$n.png"
i=$((i+1))
done
done

echo "Rendering video..."

ffmpeg -framerate $FPS -i $FRAMES/%05d.png -pix_fmt yuv420p -c:v libx264 temp.mp4

if [ -f bootaudio.mp3 ]; then

echo "Adding audio..."

ffmpeg -i temp.mp4 -i bootaudio.mp3 -c:v copy -c:a aac -shortest ../$OUTPUT

else

mv temp.mp4 ../$OUTPUT

fi

cd ..
rm -rf $WORK

echo ""
echo "Done!"
echo "Output: $OUTPUT"