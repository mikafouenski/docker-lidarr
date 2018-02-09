# mikafouenski/lidarr
Dockerize [Lidarr](https://github.com/lidarr/Lidarr)

Inspired by [linuxserver.io](https://www.linuxserver.io)

## Usage

```
docker create \
    --name lidarr \
    -p 8686:8686 \
    -e PUID=<UID> -e PGID=<GID> \
    -e TZ=<timezone> \ 
    -v </path/to/appdata>:/config \
    -v <path/to/music>:/music \
    -v <path/to/downloads>:/downloads \
    mikafouenski/lidarr
```

* `-p 8989` - the port lidarr webinterface
* `-v /config` - database and lidarr configs
* `-v /music` - location of Music library on disk
* `-v /etc/localtime` for timesync - see [Localtime](#localtime) for important information
* `-e TZ` for timezone information, Europe/Paris - see [Localtime](#localtime) for important information
* `-e PGID` for for GroupID - see below for explanation
* `-e PUID` for for UserID - see below for explanation

Docker-compose exemple :
```
  lidarr:
    image: 'mikafouenski/lidarr'
    container_name: 'lidarr'
    restart: 'unless-stopped'
    environment:
      - PUID=<UID>
      - PGID=<GID>
      - TZ=<timezone>
    volumes:
      - '</path/to/appdata>:/config'
      - '<path/to/downloads>:/downloads'
      - '<path/to/music>:/music'
```

It is based on debian stretch with [S6 overlay](http://skarnet.org/software/s6/index.html).

## Localtime

It is important that you either set `-v /etc/localtime:/etc/localtime:ro` or the TZ variable, mono will throw exceptions without one of them set.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" <sup>TM</sup>.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application
Access the webui at `<your-ip>:8686`.

