#!/bin/bash

# Set GPIO 24 as input
gpio -g mode 24 in

# Function to clear shell and display IP and MAC addresses for each interface
display_info() {
    clear
    echo "Network Interface Information:"
    echo ""

    # Get a list of network interfaces excluding lo
    interfaces=$(ifconfig | grep -o -E '^[^[:space:]]+' | grep -v 'lo')

    # Loop through each interface
    for interface in $interfaces; do
        echo "Interface: $interface"
        echo "IP Address:"
        ip addr show $interface | grep -o -E '\b([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}' | awk '{print "  " $1}'
        echo "MAC Address:"
        ifconfig $interface | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' | head -n 1 | awk '{print "  " $1}'
        echo ""
    done
}

# Loop indefinitely
while true; do
    # Check if GPIO 24 is pressed
    if [ $(gpio -g read 24) -eq 1 ]; then
        display_info
        # Wait for button release
        while [ $(gpio -g read 24) -eq 1 ]; do
            sleep 0.1
        done
    fi
    sleep 0.1
done
