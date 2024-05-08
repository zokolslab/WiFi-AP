
# Check if running as root
if ! [ $(id -u) -eq 0 ]; then
	echo "ERROR! Script is not running as root"
	exit 1
fi

# Delete dnsmasq configuration file
if test -f /etc/NetworkManager/dnsmasq.d/wifi_ap.conf; then
	rm /etc/NetworkManager/dnsmasq.d/wifi_ap.conf
fi

# Delete hostapd configuration file
if test -f /etc/hostapd/hostapd.conf; then
	rm /etc/hostapd/hostapd.conf
fi


# Enable hostapd service
if ! systemctl stop hostapd; then
    echo "Error: Failed to stop hostapd"
    #exit 1
fi

# Unmask hostapd service
if ! systemctl mask hostapd; then
    echo "Error: Failed to mask hostapd"
    #exit 1
fi

# Enable hostapd service
if ! systemctl disable hostapd; then
    echo "Error: Failed to disable hostapd"
    #exit 1
fi

# Restart NetworkManager service
if ! systemctl restart NetworkManager; then
    echo "Error: Failed to restart Network Manager"
    #exit 1
fi

iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain

exit 0