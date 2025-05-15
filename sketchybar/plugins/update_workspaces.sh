AERO="/opt/homebrew/bin/aerospace"
SKETCHYBAR="/opt/homebrew/bin/sketchybar"

seen=()

while IFS='|' read -r app_raw ws_raw; do
  app=$(echo "$app_raw" | sed 's/^[ \t]*//;s/[ \t]*$//')
  ws=$(echo "$ws_raw" | sed 's/^[ \t]*//;s/[ \t]*$//')

  # Skip if already seen
  [[ " ${seen[*]} " == *" $app "* ]] && continue
  seen+=("$app")

  # Record canonical item name
  item_name="app.${app// /_}"
  open_apps+=("$item_name")

  app_color=0xFFFFFFFF

  # Icon mapping
  case "$app" in
    "Notion Mail") app_icon="";;
    "Notion") app_icon="" ;;
    "Figma") app_icon="" ;;
    "Notes") app_icon="" ;;
    "Safari") app_icon="" ;;
    "Messages") app_icon="󰭹" ;;
    "Goodnotes") app_icon="" ;;
    "Brave Browser") app_icon="" ;;
    "Ghostty") app_icon="" ;;
    "Code") app_icon="" app_color=0xFF1D88EB;;
    "Finder") app_icon="" ;;
    "Print Center") app_icon="" ;;
    "System Settings") app_icon="" ;;
    "Spotify") app_icon="" app_color=0xFF24D34E;;
    "Legcord") app_icon="" ;;
    "Preview") app_icon="" ;;
    "Dev Server") app_icon="" ;;
    *) app_icon="" ;;
  esac

  # Use app name as Sketchybar item name
  item_name="app.${app// /_}" # Replace spaces with underscores

  # Set label only if icon is defined
  if [[ -n "$app_icon" ]]; then
    "$SKETCHYBAR" --add item "$item_name" left \
                  --set "$item_name" label="$app_icon" label.padding_right=0 label.color="$app_color" \
                  --move "$item_name" after "space.$ws"
  fi

done < <("$AERO" list-windows --all --format "%{app-name} | %{workspace}")

# Now remove any app.* item that is no longer open
existing_app_items=$("$SKETCHYBAR" --query bar | jq -r '.items[] | select(startswith("app."))')

for item in $existing_app_items; do
  if [[ ! " ${open_apps[*]} " =~ " $item " ]]; then
    "$SKETCHYBAR" --remove "$item"
  fi
done