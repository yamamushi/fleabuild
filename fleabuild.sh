#!/bin/bash

#Player detection
PLATFORM="`uname`"
echo $PLATFORM
if [[ "$PLATFORM" == "Linux" ]]; then
PLAYER=mplayer
else
PLAYER=afplay
fi
echo $PLAYER

usage()
{
    echo "usage: fleabiuld options:<f|d|h>"
}

while getopts ":f:h:?:d:" opt; do
  case $opt in
    f)
      audiotarget=$OPTARG
      ;;
    h|\?)
      echo "Example Usage: fleabuild -f audiofile" >&2
      ;;
    d)
	# Internal Field Separator set to newline, so file names with
	# spaces do not break our script.
IFS='
'

if [[ -d "$OPTARG" ]]
then
	star="/*.mp3"
	files=($OPTARG$star)
	audiotarget=${files[RANDOM % ${#files[@]}]}
fi
      ;;
  esac
done

if [ -z $audiotarget ]
then
   echo "No arguments were given"
   usage
   exit
fi

$PLAYER $audiotarget & fleapid=$! 
trap 'kill $fleapid' EXIT HUP TERM INT

time -p sh -c 'cmake .. && make'

kill $fleapid 
