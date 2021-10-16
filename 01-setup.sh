export $(grep -v '^#' .env | xargs)

if docker network ls | grep web -q
then
    echo "Docker network web created"
else
    docker network create web
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
