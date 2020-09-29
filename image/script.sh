# Create directory
sudo mkdir -p /opt/webapp-server/bin /opt/webapp-server/conf/
sudo curl -L -o /opt/webapp-server/bin/webapp-server https://bit.ly/2GjP1QG
sudo chmod +x /opt/webapp-server/bin/webapp-server


# Edit config file
sudo sed -i "s|^name=.*|name=${FirstName} ${LastName}|" /tmp/file.conf
sudo sed -i "s|^logo_url=.*|logo_url=${logo_url}|" /tmp/file.conf
sudo mv /tmp/file.conf /opt/webapp-server/conf/webapp-server.conf


# Create unit-file
cat << EOF | sudo tee /etc/systemd/system/webapp-server.service
[Unit]
Description=Simple WebApp Server
After=network.target

[Service]
Type=simple
EnvironmentFile=-/opt/webapp-server/conf/webapp-server.conf
ExecStart=/opt/webapp-server/bin/webapp-server
ExecStop=/bin/kill -s QUIT $MAINPID

[Install]
WantedBy=multi-user.target
EOF


# Start webserver 
sudo systemctl start webapp-server && sudo systemctl enable webapp-server