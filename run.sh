#!/bin/sh

# Download and install XRay
mkdir /tmp/xray
curl -L -H "Cache-Control: no-cache" -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip /tmp/xray/xray.zip -d /tmp/xray
install -m 755 /tmp/xray/xray /usr/local/bin/xray

# Remove temporary directory
rm -rf /tmp/xray

# XRay new configuration
install -d /usr/local/etc/xray
cat << EOF > /usr/local/etc/xray/config.json
{
    "policy": {
        "levels": {
            "0": {
                "handshake": 3,
                "connIdle": 120,
                "uplinkOnly": 0,
                "downlinkOnly": 0
            }
        }
    },
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "f86886e7-a5cb-4ad3-8891-d140c1ec3902"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "/xray"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "settings": {},
            "tag": "ip-out"
        }
    ]
}
EOF

# Run XRay
/usr/local/bin/xray run -config /usr/local/etc/xray/config.json
