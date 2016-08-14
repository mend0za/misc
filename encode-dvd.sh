#!/bin/sh


TITLE=`lsdvd 2>&1|awk -F": " '/Disc Title/ {print $2}'`
TRACKS=`lsdvd 2>&1|awk -F": " '/^Title/ {print $2}'|awk -F, '{print $1}'`

for i in $TRACKS
do
	mencoder dvd://$i -o "$i-$TITLE.avi" \
	-ovc xvid -oac mp3lame \
	-xvidencopts bvhq=1:vhq=2:cartoon:chroma_opt:quant_type=mpeg:pass=2:bitrate=1500:aspect=4/3 \
	-lameopts vbr=3

done
