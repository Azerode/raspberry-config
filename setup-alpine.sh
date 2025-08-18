#!/bin/ash

# Set variables for setup-alpine
HOSTNAME="raspberrypi-test"
DISK="/dev/nvme0n1"  # Adjust this to your disk
BOOT_SIZE="256"  # Boot partition size in MB
SWAP_SIZE="0"    # No swap for minimal memory usage

# Run setup-alpine with automated responses
setup-alpine -q \
    -e -k fr -l fr_FR.UTF-8 \  # Keyboard and locale settings
    -r $HOSTNAME \             # System hostname
    -d "virt" \                # Drive media type
    -s "1" \                   # System disk mode
    -c "chrony" \              # Time synchronization
    -b "nvme0n1" \             # Boot device
    -m "${DISK}p1" \           # Boot partition
    -u "${DISK}p2" \           # Root partition
    -B "${BOOT_SIZE}" \        # Boot size in MB
    -S "${SWAP_SIZE}" \        # Swap size (disabled)
    -a                         # Auto mode

# Update repositories
echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main" > /etc/apk/repositories
echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories

# Set root password
echo "root:alpine" | chpasswd

# Create user
adduser -D -g "" worker
echo "worker:raspberry" | chpasswd
addgroup worker wheel

# Add sudo capabilities
apk add doas
echo "permit persist :wheel" > /etc/doas.d/doas.conf

# Make doas.conf secure
chmod 440 /etc/doas.d/doas.conf

# Make the script executable
chmod +x setup-i3-desktop.sh

# Run i3 setup script
./setup-i3-desktop.sh