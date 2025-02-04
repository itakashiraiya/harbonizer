bind t run-shell "./init.lua test"
set-hook window-layout-changed "display wow"
move-window -s1 -t2
neww
killw -t2
