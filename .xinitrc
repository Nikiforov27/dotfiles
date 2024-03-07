feh --bg-scale ~/Pictures/waal/gruvbox-dark-rainbow.png &
./.bar.sh &
picom --config ~/.config/picom/picom.conf  --frame-opacity=0.8 --inactive-opacity=0.93 --active-opacity=0.93 --backend glx -f &

exec dwm
