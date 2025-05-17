#!/bin/bash

AERO="/opt/homebrew/bin/aerospace"
SKETCHYBAR="/opt/homebrew/bin/sketchybar"
STATE_FILE="/tmp/sketchybar_app_state.json"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/app_config.sh"

index=0
open_apps=()
curr_state="[]"

# Load previous state
if [[ -f "$STATE_FILE" ]]; then
  prev_state=$(<"$STATE_FILE")
else
  prev_state="[]"
fi

# Read Aero output into an array
IFS=$'\n' read -d '' -r -a aero_lines < <("$AERO" list-windows --all --format "%{app-name} | %{workspace}" && printf '\0')

for line in "${aero_lines[@]}"; do
  app_raw=${line%%|*}
  ws_raw=${line#*|}

  app=$(echo "$app_raw" | sed 's/^[ \t]*//;s/[ \t]*$//')
  ws=$(echo "$ws_raw" | sed 's/^[ \t]*//;s/[ \t]*$//')

  item_name="app.${app// /_}_$index"
  index=$((index + 1))
  open_apps+=("$item_name")

  # Check if it moved or is new
  changed=$(echo "$prev_state" | jq -e --arg item "$item_name" --arg ws "$ws" \
    'map(select(.item_name == $item and .workspace == $ws)) | length == 0')

  if [[ "$changed" == "true" ]]; then
    app_icon=$(get_app_icon "$app")
    app_color=$(get_app_color "$app")

    if [[ -n "$app_icon" ]]; then
      "$SKETCHYBAR" --add item "$item_name" left \
                    --set "$item_name" label="$app_icon" \
                    label.padding_right=4 label.padding_left=0 \
                    padding_left=0 label.color="$app_color" \
                    --move "$item_name" after "space.$ws"
    fi
  fi

  curr_state=$(echo "$curr_state" | jq --arg item "$item_name" --arg app "$app" --arg ws "$ws" \
    '. += [{"item_name": $item, "app": $app, "workspace": $ws}]')
done

# Remove stale items
existing_app_items=$("$SKETCHYBAR" --query bar | jq -r '.items[] | select(startswith("app."))')

for item in $existing_app_items; do
  if [[ ! " ${open_apps[*]} " =~ " $item " ]]; then
    "$SKETCHYBAR" --remove "$item"
  fi
done

# Save current state
echo "$curr_state" > "$STATE_FILE"
