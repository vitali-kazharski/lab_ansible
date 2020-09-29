# Create directory
sudo mkdir -p /opt/webapp-server/bin /opt/webapp-server/conf/
sudo curl -L -o /opt/webapp-server/bin/webapp-server https://bit.ly/2GjP1QG
sudo chmod +x /opt/webapp-server/bin/webapp-server

# Interolate variable
envsubst < /tmp/webapp-server.conf | sudo tee /opt/webapp-server/conf/webapp-server.conf

sudo mv /tmp/webapp-server.service /etc/systemd/system/webapp-server.service
# Start webserver 
sudo systemctl start webapp-server && sudo systemctl enable webapp-server