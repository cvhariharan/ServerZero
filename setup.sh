# Setup Firewall using UFW
sudo apt update
sudo apt install ufw
sudo systemctl start ufw
sudo systemctl enable ufw

sudo ufw default allow outgoing
sudo ufw default deny incoming

sudo ufw allow from 192.168.1.0/24 to any port 22 proto tcp
sudo ufw allow from 192.168.1.0/24 to any port 80 proto tcp
sudo ufw allow from 192.168.1.0/24 to any port 443 proto tcp

sudo ufw enable

export $(grep -v '^#' .env | xargs)

if sudo docker network ls | grep web -q
then
    echo "Docker network web created"
else
    sudo docker network create web
fi

if [[ -z "$DOMAIN_NAME" ]]; then
    echo "Please set DOMAIN_NAME"
    exit 1
fi

mkdir -p traefik/certs/
mkdir -p traefik/conf/
sed "s/DOMAIN_NAME/$DOMAIN_NAME/" traefik/conf/traefik-template.yml > traefik/conf/traefik.yml


openssl req -newkey rsa:4096 -x509 -sha256 -days 3650 -nodes -out traefik/certs/$DOMAIN_NAME.crt -keyout traefik/certs/$DOMAIN_NAME.key

unset $(grep -v '^#' .env | sed -E 's/(.*)=.*/\1/' | xargs)
