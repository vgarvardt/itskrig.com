# itskrig.com

> Blog of Vladimir Garvardt built on top of [rKlotz](https://github.com/vgarvardt/rklotz)

## Deploy on Ubuntu 17.04

1. [Install `docker-ce`](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)
2. Pull latest blog docker image - `docker pull vgarvardt/itskrig.com`
3. Install `runit` - `sudo apt-get install runit runit-systemd`
4. Add new service to `runit` to run teh blog:

```bash
sudo -i
# create service dir
mkdir -p /etc/sv/rklotz/log
# create logs dir
mkdir -p /var/log/rklotz
# create logs config
echo "# rotate if log file size > s<size> bytes" > /var/log/rklotz/config
echo "s52428800" >> /var/log/rklotz/config
echo "# keep at most n<num> log files" >> /var/log/rklotz/config
echo "n10" >> /var/log/rklotz/config
# create service run script
echo "#!/bin/sh" > /etc/sv/rklotz/run
echo "exec 2>&1 && docker run -p 80:8080 vgarvardt/itskrig.com" >> /etc/sv/rklotz/run
chmod a+x echo "#!/bin/sh" > /etc/sv/rklotz/run
# create service log run script
echo "#!/bin/sh" > /etc/sv/rklotz/log/run
echo "exec svlogd /var/log/rklotz" >> /etc/sv/rklotz/log/run
chmod a+x /etc/sv/rklotz/log/run
# make service active
cd /etc/service
ln -s /etc/sv/rklotz rklotz
```
