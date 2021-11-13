gotify push -t "Backup Started" -p 5 ""

sudo mount -a
sudo rsync -avzP --append-verify /home/userzero /mnt/backup
