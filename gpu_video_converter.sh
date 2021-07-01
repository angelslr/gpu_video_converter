#! /bin/bash
echo "Convert all videos in a folder without losing metadata (NVIDIA GPU)"
echo "Input format:"
read inputFormat
echo "Output format:"
read outputFormat
echo "Min bitrate (e.g. 1.5M 2M, 10M):"
read minBitrate
echo "Max bitrate (e.g. 1.5M 2M, 10M):"
read maxBitrate
echo "Output path (it must be another folder and end with '/'.):"
read outputPath

for fileSource in *.$inputFormat
do
	if [ -f "$fileSource" ]; then
		ffmpeg -hwaccel nvdec -i "$fileSource" -c:v h264_nvenc -pix_fmt yuv420p -preset slow -rc vbr -b:v $minBitrate -maxrate:v $maxBitrate -c:a copy $outputPath"${fileSource%.*}.$outputFormat"
		exiftool -TagsFromFile "$fileSource" "-all:all>all:all" "-FileModifyDate>FileModifyDate" -overwrite_original $outputPath"${fileSource%.*}.$outputFormat"
	else
		echo "no file $fileSource found!"
	fi
done
