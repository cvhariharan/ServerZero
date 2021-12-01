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
sed "s/CLOUDFLARE_EMAIL/$CLOUDFLARE_EMAIL/" traefik/conf/traefik-template.yml > traefik/conf/traefik.yml

unset $(grep -v '^#' .env | sed -E 's/(.*)=.*/\1/' | xargs)
