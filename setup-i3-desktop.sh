#!/bin/ash

# Update package repositories
apk update

# Install minimal X.org components and i3wm
apk add --no-cache \
    xorg-server \
    xf86-video-fbdev \
    xf86-input-libinput \
    i3wm \
    i3status \
    dmenu \
    terminus-font \
    dbus \
    xterm \
    alpine-conf \
    netsurf-gtk \
    vim \
    vim-syntax \
    htop

# Create minimal .xinitrc
cat > /home/$USER/.xinitrc << EOF
#!/bin/sh
exec dbus-launch --exit-with-session i3
EOF

# Set permissions
chmod +x /home/$USER/.xinitrc

# Create basic i3 config
mkdir -p /home/$USER/.config/i3
cat > /home/$USER/.config/i3/config << EOF
# i3 config file (v4)
font pango:monospace 8

# Use Windows key as mod
set \$mod Mod4

# Start terminal
bindsym \$mod+Return exec xterm

# Start web browser
bindsym \$mod+w exec netsurf-gtk

# Start vim editor
bindsym \$mod+e exec xterm -e vim

# Kill focused window
bindsym \$mod+Shift+q kill

# Start dmenu
bindsym \$mod+d exec dmenu_run

# Change focus
bindsym \$mod+Left focus left
bindsym \$mod+Down focus down
bindsym \$mod+Up focus up
bindsym \$mod+Right focus right

# Move focused window
bindsym \$mod+Shift+Left move left
bindsym \$mod+Shift+Down move down
bindsym \$mod+Shift+Up move up
bindsym \$mod+Shift+Right move right

# Split orientation
bindsym \$mod+h split h
bindsym \$mod+v split v

# Enter fullscreen mode
bindsym \$mod+f fullscreen toggle

# System mode
mode "system" {
    bindsym r exec reboot
    bindsym s exec poweroff
    bindsym Escape mode "default"
}
bindsym \$mod+Shift+s mode "system"
EOF

# Add X server startup to profile
echo "if [ -z \"\$DISPLAY\" ] && [ \"\$(tty)\" = \"/dev/tty1\" ]; then" >> /home/$USER/.profile
echo "    startx" >> /home/$USER/.profile
echo "fi" >> /home/$USER/.profile

# Set ownership of config files
chown -R $USER:$USER /home/$USER/.xinitrc /home/$USER/.config

# Create i3status config
mkdir -p /home/$USER/.config/i3status
cat > /home/$USER/.config/i3status/config << EOF

# i3status configuration file
general {
    colors = true
    interval = 5
}

order += "cpu_usage"
order += "memory"
order += "disk"
order += "tztime local"

cpu_usage {
    format = "CPU: %usage"
}

memory {
    format = "Mem: %used / %total"
    threshold_degraded = "1G"
    format degraded = "MEMORY < %available"
}

tztime local {
    format = "%Y-%m-%d %H:%M:%S"
}
EOF

# Add i3status bar to i3 config
cat >> /home/$USER/.config/i3/config << EOF

# Status bar
bar {
    status_command i3status
    position top
}
# Resource monitor shortcut
bindsym \$mod+m exec xterm -e htop
EOF

# Set ownership of i3status config
chown -R $USER:$USER /home/$USER/.config/i3status

# Create minimal vim config
mkdir -p /home/$USER/.vim
cat > /home/$USER/.vimrc << EOF
syntax on
set number
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set showmatch
set ruler
set incsearch
set hlsearch
colorscheme default
EOF

# Set ownership of vim config
chown -R $USER:$USER /home/$USER/.vim /home/$USER/.vimrc
