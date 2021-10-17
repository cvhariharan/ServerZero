## Server Zero
A minimal Raspberry Pi home server.

### Services
- Pi-hole
- Joplin Server
- Etebase
- Flame dashboard
- Miniflux
- Paperless-ng
- Postgres
- Traefik

### Installation
Clone this repo and create a `.env` file based on the example file. Then run
```bash
./00-pre-setup.sh
```
This script will setup a basic firewall using UFW to allow only ssh, http and https traffic from the specified subnet. The subnet can be changed in this script. It also downloads Docker and creates a new user 
`userzero` to run the services.

Now run
```bash
./01-setup.sh
```
This will create a docker network and certificates.  

```bash
docker-compose up -d
```

Once all the services are started, you can navigate to Pi-hole and setup local dns. The format is {serviceName}.{domainNameFromEnv}. You can also navigate to Traefik dashboard at https://{piIPAddress}:9000 
and get the domain names from there.
