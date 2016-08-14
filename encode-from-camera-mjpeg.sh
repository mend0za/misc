#!/bin/sh

ffmpeg -i $1 -c:v libx264 -preset slow -threads 6 -crf 18 -c:a copy -pix_fmt yuv420p $2
