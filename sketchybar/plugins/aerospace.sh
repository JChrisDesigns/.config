#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --animate exp 5 \
               --set $NAME \
               background.color=0x50FFFFFF \
               label.background.border_width=0
else
    sketchybar --animate exp 5 \
               --set $NAME \
               label.background.border_width=0 \
               background.color=0x00000000 \
               icon.padding_left=8 \
               icon.padding_right=8
fi