#切換到Desktop
cd /home/pi/Desktop

echo '############## start to git clone ###################'
sudo git clone https://github.com/awlchang/hassio-docker-compose.git

#切換到homeassistant-docker-compose資料夾
cd hassio-docker-compose/

echo '############## docker-compose up -d ###################'
#執行docker-compose.yml內的services
sudo docker-compose up -d