#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --animate exp 5 \
               --set bracket.$1 \
               background.color=0xFF1E2127 \
               --set space.$1 \
               icon.padding_left=12 \
               icon.padding_right=12

else
    sketchybar --animate exp 5 \
               --set space.$1 \
               label.background.border_width=0 \
               background.color=0x00D9342E \
               icon.padding_left=8 \
               icon.padding_right=8 \
               --set bracket.$1 \
               background.color=0x751E2127
fi