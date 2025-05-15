#!/bin/sh

# Set full paths in case environment is limited
AERO="/opt/homebrew/bin/aerospace"
SKETCHYBAR="/opt/homebrew/bin/sketchybar"

# Get app names and workspaces
tmpfile=$(mktemp)
"$AERO" list-windows --all --format "%{app-name} | %{workspace}" > "$tmpfile"

# Get all workspace IDs
for sid in $("$AERO" list-workspaces --all); do
    label=$(awk -F '|' -v sid="$sid" '
        {
            gsub(/^[ \t]+|[ \t]+$/, "", $1);  # trim app
            gsub(/^[ \t]+|[ \t]+$/, "", $2);  # trim workspace

            app = $1
            color = "0xFFFFFF"
            # Here is where you add your icons
                if (app == "Notion Mail") {
                    app = ""
                } else if (app == "Notion") {
                    app = ""
                } else if (app == "Figma") {
                    app = ""
                } else if (app == "Notes") {
                    app = ""
                } else if (app == "Safari") {
                    app = ""
                } else if (app == "Messages") {
                    app = "󰭹"
                } else if (app == "Goodnotes") {
                    app = ""
                } else if (app == "Brave Browser") {
                    app = ""
                } else if (app == "Ghostty") {
                    app = ""
                } else if (app == "Code") {
                    app = ""
                } else if (app == "Finder") {
                    app = ""
                } else if (app == "Print Center") {
                    app = ""
                } else if (app == "System Settings") {
                    app = ""
                } else if (app == "Spotify") {
                    app = ""
                } else if (app == "Legcord") {
                    app = ""
                } else if (app == "Preview") {
                    app = ""
                } else if (app == "Dev Server") {
                    app = ""
                }

            if ($2 == sid) {
                # Avoid duplicate apps
                if (!seen[$1]++) apps = (apps ? apps "  " : "") app
            }
        }
        END {
            print (apps ? apps : null)
        }
    ' "$tmpfile")

    # Need to add logic in that makes it so that the labels are calculated and added all together
    if [[ "$label" == "" ]]; then
        "$SKETCHYBAR" --set space.$sid label.drawing=off
    else
        "$SKETCHYBAR" --set space.$sid label="$label" label.drawing=on
    fi
    
  
done

rm -f "$tmpfile"