## Server Zero
A minimal Raspberry Pi home server.

### Services
- [Bookstack](https://github.com/BookStackApp/BookStack)
- [Pi-hole](https://github.com/pi-hole/pi-hole)
- [Gitea](https://github.com/go-gitea/gitea)
- [Send](https://github.com/timvisee/send)
- [Jellyfin](https://github.com/linuxserver/docker-jellyfin)
- [Joplin Server](https://github.com/cvhariharan/joplin-server)
- [Etebase](https://github.com/cvhariharan/etebase)
- [Flame dashboard](https://github.com/pawelmalak/flame)
- [Metube](https://github.com/alexta69/metube)
- [Gotify](https://github.com/gotify/server)
- [Miniflux](https://github.com/miniflux/v2)
- [Postgres](https://github.com/postgres/postgres)
- [InfluxDB](https://github.com/influxdata/influxdb)
- [Grafana](https://github.com/grafana/grafana)
- [Traefik](https://github.com/traefik/traefik)

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

Once all the services are started, you can navigate to Pi-hole and setup local dns. The format is `{service-name}.{domain-name-from-env}`. You can also navigate to Traefik dashboard at `https://{raspi-ip}:9000`
and get the domain names from there.  

A systemd unit file is also included.   

### Setting up Telegraf and InfluxDB
Before the InfluxDB container is created, modify the username and password in `create-telegraf.iql`. This will be used to initialize InfluxDB.  
Use the newly created credentials to connect from Telegraf and Grafana.

*Should work on Debian based systems. Tested only on the latest version of Raspberry Pi OS Lite* 
