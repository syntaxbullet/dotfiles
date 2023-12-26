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

