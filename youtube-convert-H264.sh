#!/bin/sh

if [ $# -ne 2 ]
then
	echo Converter for youtube:
	echo 	$0 inputfile outputfile
	exit 0
fi

if [ ! -f "$1" ]
then 
	echo Input file "'$1'" not found
	exit 1
fi


ffmpeg -i "$1" -c:v libx264 -threads 6 -preset slow -crf 18 -c:a libfdk_aac -b:a 128k -pix_fmt yuv420p "$2"

