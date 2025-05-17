#!/bin/bash

get_app_icon() {
  case "$1" in
    "Notion Mail") echo "" ;;
    "Notion") echo "" ;;
    "Figma") echo "" ;;
    "Notes") echo "" ;;
    "Safari") echo "" ;;
    "Messages") echo "󰭹" ;;
    "Goodnotes") echo "" ;;
    "Brave Browser") echo "󰾔" ;;
    "Ghostty") echo "󰊠" ;;
    "Code") echo "" ;;
    "Finder") echo "" ;;
    "Print Center") echo "" ;;
    "System Settings") echo "" ;;
    "Spotify") echo "" ;;
    "Legcord") echo "" ;;
    "Preview") echo "" ;;
    "Dev Server") echo "" ;;
    *) echo "" ;;
  esac
}

get_app_color() {
  case "$1" in
    "Messages") echo "0xFF4BF15B" ;;
    "Brave Browser") echo "0xFFE44C21" ;;
    "Code") echo "0xFF1D88EB" ;;
    "Spotify") echo "0xFF24D34E" ;;
    *) echo "0xFFFFFFFF" ;;
  esac
}
