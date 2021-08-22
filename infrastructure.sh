echo '############## install docker and docker-compose ###################'
# Install some required packages first
sudo apt update
sudo apt install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

# Get the Docker signing key for packages
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -

# Add the Docker official repos
echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
     $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list

# Install Docker
sudo apt update
sudo apt install -y --no-install-recommends \
    docker-ce \
    cgroupfs-mount

echo '############## enable docker service ###################'
# Startup docker service    
sudo systemctl enable docker
sudo systemctl start docker

# Install docker-compose
sudo apt -y install python3-pip
sudo pip3 install docker-compose
docker-compose version

sudo groupadd docker
sudo usermod -aG docker $USER

echo '############## setting mosquitto service ###################'
# 建立data-mosquitto資料夾
sudo mkdir /opt/data-mosquitto

# 在data-mosquitto資料夾建立子資料夾config, data和log
sudo mkdir /opt/data-mosquitto/config /opt/data-mosquitto/data /opt/data-mosquitto/log

# 設定子資料夾config, data和log的使用權限只有讀取和執行
sudo chmod 777 -R /opt/data-mosquitto/config /opt/data-mosquitto/data /opt/data-mosquitto/log

# 建立mosquitto的設定檔
sudo echo 'persistence true
persistence_location /mosquitto/data/

log_dest file /mosquitto/log/mosquitto.log
log_dest stdout

allow_anonymous true
#password_file /mosquitto/config/mosquitto.passwd
listener 1883' > /opt/data-mosquitto/config/mosquitto.conf

echo '############## setting zewelor/bt-mqtt-gateway service ###################'
#切換到opt資料夾
cd /opt

#下載設定檔
sudo git clone https://github.com/awlchang/custom-workers-for-zewelor-bt-mqtt-gateway.git

#修改custom-workers-for-zewelor-bt-mqtt-gateway資料夾名稱
sudo mv /opt/custom-workers-for-zewelor-bt-mqtt-gateway /opt/bt-mqtt-gateway

sudo rm -R /opt/bt-mqtt-gateway/workers

sudo rm /opt/bt-mqtt-gateway/gateway.py

#設定權限為可編輯
sudo chmod 777 -R /opt/bt-mqtt-gateway/

sudo mkdir -p /home/pi/hassio
sudo mkdir -p /home/pi/hassio/{scripts,data,portainer}

sudo mkdir /opt/bt2mqtt
sudo mkdir /opt/bt2mqtt/config
# 建立bt2mqtt的設定檔
sudo echo '{
  "BASEPATH": "/application",
  "ENFORCE_BASEPATH": true
}' > /opt/bt2mqtt/config/settings.conf

echo '############## finished and reboot now ###################'
sudo reboot now
