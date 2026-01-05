#!/bin/bash

if [ "$EUID" -ne 0 ]; then 
    echo "Error: Use sudo"
    exit 1
fi

CONFIG_FILE="/etc/systemd/resolved.conf"

if grep -q "^DNSStubListener=no" "$CONFIG_FILE" 2>/dev/null; then
    CURRENT_STATE="disabled"
else
    CURRENT_STATE="enabled"
fi

echo "Actual status: $CURRENT_STATE"
echo ""

if [ "$CURRENT_STATE" = "enabled" ]; then
    echo "Désactivating DNS Stub"
    
    
    if grep -q "^\[Resolve\]" "$CONFIG_FILE"; then
        
        if grep -q "^#*DNSStubListener" "$CONFIG_FILE"; then
            
            sed -i 's/^#*DNSStubListener=.*/DNSStubListener=no/' "$CONFIG_FILE"
        else
            
            sed -i '/^\[Resolve\]/a DNSStubListener=no' "$CONFIG_FILE"
        fi
    else
        
        echo -e "\n[Resolve]\nDNSStubListener=no" >> "$CONFIG_FILE"
    fi
    
    systemctl restart systemd-resolved
    echo "DNS Stub désactivated - Port 53 free for Responder"
    
else
    echo "Activating DNS Stub..."
    
    sed -i 's/^DNSStubListener=no/#DNSStubListener=no/' "$CONFIG_FILE"
    
    systemctl restart systemd-resolved
    echo "DNS Stub activated"
fi

echo ""
echo "Port 53 check:"
ss -tulpn | grep :53
