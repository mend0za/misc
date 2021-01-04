#!/bin/bash

set -e

CUE=$1
CUE1=normalized-1-$1
CUE2=normalized-2-$1
FLAC1=$2
FLAC2=$3
PREFIX1=A
PREFIX2=B

if [ $# -lt 2 ]
then
	echo Usage:
	echo "	$0 file.cue file1.flac [file2.flac]"
	exit 0
fi

# Test if the FLAC file corrupted, then fix it
flac_fix()
{
	echo "Fixing '$1'"
	mv -v "$1" "$1".orig
	ffmpeg -i "$1".orig -err_detect ignore_err "$1"
}

test -f "$FLAC1" && ( echo "Checking integrity of '$FLAC1'"; flac -wst "$FLAC1" || flac_fix "$FLAC1" )
test -f "$FLAC2" && ( echo "Checking integrity of '$FLAC2'"; flac -wst "$FLAC2" || flac_fix "$FLAC2" )


# strip index from track name
sed -i 's/TITLE "[ABCD][0-9]\+ /TITLE "/g' "$CUE"
echo "" >>"$CUE"

test -f "$FLAC1" && sed 's/\r$//g' "$CUE" >"$CUE1"
test -f "$FLAC2" && sed 's/\r$//g' "$CUE" >"$CUE2"


if [ -f "$FLAC2" ]
then
	sed -i '/^FILE.*'"$FLAC2"'.*WAVE/,$ d' "$CUE1"
	#sed -i '/^FILE.*'"2.flac"'.*WAVE/,$ d' "$CUE1"
	sed -i '/^FILE/,/^FILE/ d; /^TITLE /a FILE \"'"$FLAC2"'\" WAVE' "$CUE2"
fi

#cat "$CUE1"
#exit


test -f "$FLAC1" && flacsplt -c "$CUE1" -o "$PREFIX1@n - @t" -a "$FLAC1"
test -f "$FLAC2" && flacsplt -c "$CUE2" -o "$PREFIX2@n - @t" -a "$FLAC2"
 
rm -fv "$CUE1" "$CUE2"

ARTIST=`sed -n 's/\"//g; s/^PERFORMER //gp' <"$CUE"`
YEAR=`sed -n 's/^REM DATE //gp' <"$CUE"`
GENRE=`sed -n 's/^REM GENRE //gp' <"$CUE"`
ALBUM=`sed -n 's/\"//g; s/^TITLE //gp' <"$CUE"`

if [ -f "$FLAC1" -a -f "$FLAC2" ]
then
	cuetag "$CUE" "$PREFIX1"[0-9]*.flac "$PREFIX2"[0-9]*.flac
	lltag --flac --yes --verbose --ARTIST "$ARTIST" --DATE "$YEAR" --ALBUM "$ALBUM" --GENRE "$GENRE" "$PREFIX1"[0-9]*.flac "$PREFIX2"[0-9]*.flac
else
	cuetag "$CUE" "$PREFIX1"[0-9]*.flac 
	lltag --flac --yes --verbose --ARTIST "$ARTIST" --DATE "$YEAR" --ALBUM "$ALBUM" --GENRE "$GENRE" "$PREFIX1"[0-9]*.flac
fi


