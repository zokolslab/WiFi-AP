#!/bin/bash

"""
# Semi-Automagic WiFi-AP setup script
# Author: Heikki Juva (heikki@juva.lu)

# Tested on Ubuntu 22.04 LTS
# Tested with following WiFi-dongles:
# * TP-Link Archer T3U Plus
"""

# Check if running as root
if ! [ $(id -u) -eq 0 ]; then
	echo "ERROR! Script is not running as root"
	exit 1
fi

# Set your desired SSID, password, country, and channel
IP_RANGE="10.0.0.1/24"
IP="10.0.0.1"
DHCP_RANGE="10.0.0.10,10.0.0.250,12h"
NAMESERVER="8.8.8.8"
SSID="red"
PASSWORD="red12345"
COUNTRY="FI"
CHANNEL="1"

get_settings(){
# Prompt for user input using dialog
dialog --clear --backtitle "WiFi AP settings" \
       --title "WiFi AP settings" \
       --form "Enter the following parameters:" 0 0 0 \
       "IP range:" 1 1 "$IP_RANGE" 1 20 20 0 \
       "IP address:" 2 1 "$IP" 2 20 20 0 \
       "DHCP range:" 3 1 "$DHCP_RANGE" 3 20 20 0 \
       "Nameserver:" 4 1 "$NAMESERVER" 4 20 20 0 \
       "SSID:" 5 1 "$SSID" 5 20 20 0 \
       "Password:" 6 1 "$PASSWORD" 6 20 20 0 \
       "Country:" 7 1 "$COUNTRY" 7 20 20 0 \
       "Channel:" 8 1 "$CHANNEL" 8 20 20 0 \
       3>&1 1>&2 2>/tmp/input_values.txt
       
input_values=($(< /tmp/input_values.txt))
IP_RANGE=${input_values[0]}
IP=${input_values[1]}
DHCP_RANGE=${input_values[2]}
NAMESERVER=${input_values[3]}
SSID=${input_values[4]}
PASSWORD=${input_values[5]}
COUNTRY=${input_values[6]}
CHANNEL=${input_values[7]}

dialog --clear --msgbox "hostapd and dnsmasq will be configured for interface $selected_ap_interface\nIP_RANGE: $IP_RANGE\nIP address: $IP\nDHCP range: $DHCP_RANGE\nNameserver: $NAMESERVER\nSSID: $SSID\nPassword: $PASSWORD\nCountry: $COUNTRY\nChannel: $CHANNEL" 0 0
}

# Function to get available network interfaces
get_wired_interfaces() {
    interfaces=($(ip -o link show | awk -F': ' '{print $2}' | grep -o "en[^:]*"))
}

# Function to get available network interfaces
get_wireless_interfaces() {
    interfaces=($(ip -o link show | awk -F': ' '{print $2}' | grep -o "wl[^:]*"))
}

# Function to display the interface selection menu
select_ap_menu() {
    selected_ap_interface=""
    prompt="Select interface for WiFi AP:"

    # Generate menu options for dialog command
    menu_options=()
    for i in "${!interfaces[@]}"; do
        menu_options+=("$((i+1))" "${interfaces[$i]}")
    done
    
    # Display interface menu using ncurses dialog
    selected_interface=$(dialog --clear --backtitle "WiFi AP selection" --title "WiFi AP selection" --menu "$prompt" 0 0 0 "${menu_options[@]}" 3>&1 1>&2 2>&3)

    # Read the selected interface from the temporary file
    selected_index=$selected_interface

    # Check if user selected an interface
    if [ -n "$selected_index" ]; then
        selected_ap_interface=${interfaces[$((selected_index-1))]}
        #echo "You selected: $selected_ap_interface"
    else
        echo "No interface selected"
        exit 1
    fi
}

# Function to display the interface selection menu
select_wan_menu() {
    selected_wan_interface=""
    prompt="Select interface for WAN:"

    # Generate menu options for dialog command
    menu_options=()
    for i in "${!interfaces[@]}"; do
        menu_options+=("$((i+1))" "${interfaces[$i]}")
    done
    
    # Display interface menu using ncurses dialog
    selected_interface=$(dialog --clear --backtitle "WAN selection" --title "WAN selection" --menu "$prompt" 0 0 0 "${menu_options[@]}" 3>&1 1>&2 2>&3)

    # Read the selected interface from the temporary file
    selected_index=$selected_interface

    # Check if user selected an interface
    if [ -n "$selected_index" ]; then
        selected_wan_interface=${interfaces[$((selected_index-1))]}
        #echo "You selected: $selected_wan_interface"
    else
        echo "No interface selected"
        exit 1
    fi
}

setup_ap() {
# Flush interface settings
if ! ip addr flush dev $selected_ap_interface; then
	"Error: Failed to flush $selected_ap_interface"
	exit 1
fi

# Assign the IP address
if ! ip addr add $IP_RANGE dev $selected_ap_interface; then
	"Error: Failed to assign IP address to $selected_ap_interface"
	exit 1
fi

# Bring the interface up
if ! ip link set $selected_ap_interface up; then
	"Error: Failed to bring up $selected_ap_interface"
	exit 1
fi

echo "Interface $selected_ap_interface is up with IP $IP_RANGE"

# Configure NetworkManager to use dnsmasq
if grep -q "dns=dnsmasq" /etc/NetworkManager/NetworkManager.conf; then
        echo "Configuration already exists"
else
	echo -e "[main]\ndns=dnsmasq" | tee -a /etc/NetworkManager/NetworkManager.conf
fi

# Restart NetworkManager service
if ! systemctl restart NetworkManager; then
    echo "Error: Failed to restart Network Manager"
    exit 1
fi

# Setup dnsmasq (if config exists, delete it and redo)
if test -f /etc/NetworkManager/dnsmasq.d/wifi_ap.conf; then
	rm /etc/NetworkManager/dnsmasq.d/wifi_ap.conf
fi

touch /etc/NetworkManager/dnsmasq.d/wifi_ap.conf
cat <<EOT >> /etc/NetworkManager/dnsmasq.d/wifi_ap.conf
interface=wl*
dhcp-range=$DHCP_RANGE
dhcp-option=3,$IP
dhcp-option=6,$IP
server=$NAMESERVER
log-queries
log-dhcp
EOT

# Restart NetworkManager service
if ! systemctl restart NetworkManager; then
    echo "Error: Failed to restart Network Manager"
    #exit 1
fi

# Setup hostapd (if config exists, delete it and redo)
if test -f /etc/hostapd/hostapd.conf; then
	rm /etc/hostapd/hostapd.conf
fi

touch /etc/hostapd/hostapd.conf
cat <<EOT >> /etc/hostapd/hostapd.conf
interface=$selected_ap_interface
ctrl_interface=/var/run/hostap
ctrl_interface_group=0
auth_algs=1
wpa_key_mgmt=WPA-PSK
beacon_int=100
ssid=$SSID
channel=$CHANNEL
hw_mode=g
ieee80211n=0
wpa_passphrase=$PASSWORD
wpa=2
wpa_pairwise=CCMP
country_code=FI
ignore_broadcast_ssid=0
EOT

#cp /usr/share/doc/hostapd/examples/hostapd.conf /etc/hostapd/hostapd.conf
# Update the hostapd configuration file with the interface name, SSID, password, country, and channel
#sed -i "s/^interface=.*/interface=$selected_ap_interface/" /etc/hostapd/hostapd.conf
#sed -i "s/^ssid=.*/ssid=$SSID/" /etc/hostapd/hostapd.conf
#sed -i "s/^wpa_passphrase=.*/wpa_passphrase=$PASSWORD/" /etc/hostapd/hostapd.conf
#sed -i "s/^country_code=.*/country_code=$COUNTRY/" /etc/hostapd/hostapd.conf
#sed -i "s/^channel=.*/channel=$CHANNEL/" /etc/hostapd/hostapd.conf
#sed -i "s/^wpa_key_mgmt=.*/wpa_key_mgmt=WPA-PSK/" /etc/hostapd/hostapd.conf
#sed -i "s/^wpa_pairwise=.*/wpa_pairwise=CCMP/" /etc/hostapd/hostapd.conf
#sed -i "s/^rsn_pairwise=.*/rsn_pairwise=CCMP/" /etc/hostapd/hostapd.conf
#sed -i "s/^wpa=.*/wpa=2/" /etc/hostapd/hostapd.conf

# Check if hostapd service is unmasked
if [[ $(systemctl is-enabled hostapd) == "enabled" ]]; then
    	echo "hostapd service is unmasked and enabled."
else
	# Unmask hostapd service
	if ! systemctl unmask hostapd; then
	    echo "Error: Failed to unmask hostapd"
	    #exit 1
	fi

	# Enable hostapd service
	if ! systemctl enable hostapd; then
	    echo "Error: Failed to enable hostapd"
	    #exit 1
	fi
fi

# Restart hostapd service
if ! systemctl restart hostapd; then
    echo "Error: Failed to restart hostapd"
    #exit 1
fi

dialog --clear --msgbox "hostapd configured for interface $selected_ap_interface, SSID $SSID, password $PASSWORD, country $COUNTRY, and channel $CHANNEL" 0 0
}

# Setup NAT for AP
setup_nat() {
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain
iptables --table nat --append POSTROUTING --out-interface $selected_wan_interface -j MASQUERADE
iptables --append FORWARD --in-interface $selected_ap_interface --out-interface $selected_wan_interface -j ACCEPT
iptables --append FORWARD --in-interface $selected_wan_interface --out-interface $selected_ap_interface -j ACCEPT
sysctl -w net.ipv4.ip_forward=1

dialog --clear --msgbox "WiFi Access Point defined to route traffic between $selected_ap_interface and $selected_wan_interface" 0 0
}

# Main script

# Check if dialog (part of ncurses) is installed
if ! command -v dialog &> /dev/null; then
    echo "Dialog (ncurses) package is required but not installed. Please install it."
    exit 1
fi

get_settings

get_wireless_interfaces
select_ap_menu

get_wired_interfaces
select_wan_menu


echo "AP interface: $selected_ap_interface"
echo "WAN interface: $selected_wan_interface"

setup_ap
setup_nat
clear