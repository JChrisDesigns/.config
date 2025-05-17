#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --animate exp 5 \
               --set $NAME \
               background.color=0xFFD9342E \
               icon.padding_right=12 \
               icon.padding_left=12 \
               label.background.border_width=0
else
    sketchybar --animate exp 5 \
               --set $NAME \
               label.background.border_width=0 \
               background.color=0x00D9342E \
               icon.padding_left=8 \
               icon.padding_right=8
fi