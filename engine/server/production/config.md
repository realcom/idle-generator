## Server configuration

### Server CD pipeline setup

- Install docker
```sh
sudo apt update && sudo apt upgrade -y
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

- Configure user group
```sh
sudo usermod -a -G docker $USER
source ~/.bashrc
```

- Install aws-cli
```sh
sudo snap install aws-cli --classic
```

- Configure AWS
  * Use authorized AWS Access Key ID
  * Use authorized AWS Secret Access Key
```sh
aws configure
```
```yaml
AWS Access Key ID: (AWS Access Key ID)
AWS Secret Access Key: (AWS Secret Access Key)
Default region name: ap-southeast-1
```

- Configure docker
```sh
aws ecr get-login-password | docker login --username AWS --password-stdin 246743264504.dkr.ecr.ap-southeast-1.amazonaws.com/puzzlemonsters/idlez-server:latest
```

- Configure git credentials
```sh
git config --global credential.helper store
```

- Clone the client repo
  * Use authorized github username 
  * Use authorized github PAT 
```sh
cd /home/ubuntu
git clone --depth 1 --no-checkout https://github.com/puzzlemonsters/idlez-client -b production-resources
cd idlez-client
git config core.sparseCheckout true
echo "Client/Assets/PatchResources/*" >> .git/info/sparse-checkout
git checkout HEAD
```

- Download run.py
```sh
cd /home/ubuntu
git clone --depth 1 --no-checkout https://github.com/puzzlemonsters/idlez-server -b production
cd idlez-server
git config core.sparseCheckout true
echo "production/*" >> .git/info/sparse-checkout
git checkout HEAD
chmod +x production/run.py
cd production
```

- Place `Config.json` plus an untracked `Config.local.json` to the home directory, or provide secrets through environment variables.

- Set up a cron job
```sh
crontab -e
```

- Install the required packages for monitor
```sh
sudo apt install python3-pip -y
python3 -m pip install psutil --break-system-packages
```

- Add the following line
```sh
@reboot cd /home/ubuntu/idlez-server/production/ && ./monitor.py
* * * * * cd /home/ubuntu/idlez-server/production/ && ./run.py
```

- Add slack secrets
  * Open /home/ubuntu/idlez-server/production/secrets.sh
  * Add the following lines
```sh
!#/bin/bash

SLACK_TOKEN="(SLACK_TOKEN)"
SLACK_CHANNEL="(SLACK_CHANNEL)"
SLACK_CHANNEL_EMERGENCY="(SLACK_CHANNEL_EMERGENCY)"
```

### Nginx configuration

- Install nginx
```sh
sudo apt install nginx -y
```

- Configure nginx
```sh
sudo cp /home/ubuntu/idlez-server/production/web.conf /etc/nginx/sites-available/web.conf
sudo ln -s /etc/nginx/sites-available/web.conf /etc/nginx/sites-enabled/web.conf
sudo systemctl restart nginx
```

- Install certbot
```sh
sudo snap install --classic certbot
sudo apt install python3-certbot-nginx -y
```

- Obtain a certificate
```sh
sudo certbot --nginx --agree-tos --no-eff-email --redirect --staple-ocsp
```

- Add websocket configuration
```sh
sudo cp /home/ubuntu/idlez-server/production/websocket.conf /etc/nginx/sites-available/websocket.conf
sudo ln -s /etc/nginx/sites-available/websocket.conf /etc/nginx/sites-enabled/websocket.conf
sudo systemctl restart nginx
```
