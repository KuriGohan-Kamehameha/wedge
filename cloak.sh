sudo apt update && sudo apt install -y macchanger && sudo tee /etc/systemd/system/macchanger.service <<EOF
[Unit]
Description=MAC Address Changer
After=network.target

[Service]
Type=oneshot
ExecStartPre=/sbin/ifconfig eth0 down
ExecStart=/usr/bin/macchanger eth0 --mac=00:00:36:ff:ff:01
ExecStartPost=/sbin/ifconfig eth0 up
RemainAfterExit=yes
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable macchanger && sudo systemctl start macchanger
