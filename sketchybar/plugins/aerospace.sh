#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --animate exp 5 \
               --set $NAME \
               background.color=0x25FFFFFF \
               label.padding_left=0 \
               icon.background.border_width=0 \
               icon.padding_left=12 \
               icon.padding_right=12 \
               icon.background.border_color=0xFFFFFFFF
else
    sketchybar --animate exp 5 \
               --set $NAME \
               background.color=0x00000000 \
               label.padding_left=0 \
               icon.background.color=0x00000000 \
               icon.background.border_width=0 \
               icon.padding_left=8 \
               icon.padding_right=8
fi