#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --animate exp 5 \
               --set $NAME icon.background.color=0xFFf55636 background.color=0xFF333333 icon.padding_left=16 icon.padding_right=16
else
    sketchybar --animate exp 5 \
               --set $NAME icon.background.color=0xFF333333 background.color=0x75333333 icon.padding_left=8 icon.padding_right=8
fi