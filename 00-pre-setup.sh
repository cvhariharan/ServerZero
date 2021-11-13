# setup firewall using ufw
sudo apt update
sudo apt install ufw openssl
sudo systemctl start ufw
sudo systemctl enable ufw

sudo ufw default allow outgoing
sudo ufw default deny incoming

sudo ufw allow from 192.168.1.0/24 to any port 22 proto tcp
sudo ufw allow from 192.168.1.0/24 to any port 80 proto tcp
sudo ufw allow from 192.168.1.0/24 to any port 443 proto tcp

sudo ufw enable

# install libseccomp2 https://docs.linuxserver.io/faq#my-host-is-incompatible-with-images-based-on-ubuntu-focal
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC 648ACFD622F3D138
echo "deb http://deb.debian.org/debian buster-backports main" | sudo tee -a /etc/apt/sources.list.d/buster-backports.list
sudo apt update
sudo apt install -t buster-backports libseccomp2

# install docker
sudo apt-get install apt-transport-https ca-certificates software-properties-common -y
curl -fsSL get.docker.com -o get-docker.sh && sudo sh get-docker.sh

sudo apt-get install -y docker-compose

# create new user to run the services
if [ -d "/home/userzero" ]; then
    sudo rm -rf /home/userzero
fi
sudo cp -r /home/$USER/ServerZero /home/userzero
sudo useradd userzero -d /home/userzero
sudo passwd userzero
sudo chown userzero /home/userzero


sudo chown userzero /home/userzero/* /home/userzero/.env /home/userzero/traefik/conf/* /home/userzero/traefik/*
sudo chmod 600 /home/userzero/traefik/acme.json

sudo usermod -aG ssh,docker userzero

sudo systemctl start docker
sudo systemctl enable docker

su - userzero
