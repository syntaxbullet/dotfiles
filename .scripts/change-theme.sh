#!/bin/bash

# load the wallpaper directory using pywal
wal -i $HOME/.wallpapers

# obtain the loaded wallpaper
wallpaper=$(cat $HOME/.cache/wal/wal)

## generate a hyprpaper config file for the loaded wallpaper

### the config file looks like this:
# preload = (path to wallpaper)
# wallpaper = ,(path to wallpaper)

hyprpaper_config="$HOME/.config/hypr/hyprpaper.conf"

# if the config file exists, delete it
if [ -f $hyprpaper_config ]; then
    rm $hyprpaper_config
fi

# create the config file
touch $hyprpaper_config

# write the config file
echo "preload = $wallpaper" >> $hyprpaper_config
echo "wallpaper = ,$wallpaper" >> $hyprpaper_config

# restart hyprpaper process
killall hyprpaper
hyprpaper &

# in the hyprland.conf file there are two lines that need to be changed
#     col.active_border = rgba(33ccffee)
#    col.inactive_border = rgba(595959aa)

# the first line is the active border color
# the second line is the inactive border color

# we want to replace those colors with the colors from the pywal theme

# get the colors from the pywal theme color 1 and color 2
inactive_border=$(cat $HOME/.cache/wal/colors | head -n 1)
active_border=$(cat $HOME/.cache/wal/colors | head -n 2 | tail -n 1)

# remove the # from the colors and add FF to the end
active_border="rgba(${active_border:1}FF)"
inactive_border="rgba(${inactive_border:1}FF)"


# get the line numbers of the colors in the hyprland.conf file
active_border_line=$(grep -n "col.active_border" $HOME/.config/hypr/hyprland.conf | cut -d ":" -f 1)
inactive_border_line=$(grep -n "col.inactive_border" $HOME/.config/hypr/hyprland.conf | cut -d ":" -f 1)

# replace the colors in the hyprland.conf file
sed -i "${active_border_line}s/.*/col.active_border = $active_border/" $HOME/.config/hypr/hyprland.conf
sed -i "${inactive_border_line}s/.*/col.inactive_border = $inactive_border/" $HOME/.config/hypr/hyprland.conf