# vboxWebDisplay
## Scenario
```
{[phpVboxDocker (P)] [WebServer (W)]} <----> [VM Server (V)]

{[pp.pp.pp.pp  ] [ww.ww.ww.ww  ]} <----> [vv.vv.vv.vv]
```

## Setup SSH key-pair between `docker-WebServ (W)` and `VM (V)`
```
sudo docker run \
    --rm \
    --name vbox_websrv_1 \
    -e USE_KEY=0 \
    -v $(pwd)/ssh:/root/.ssh \
    -v $(pwd)/init_run.sh:/run.sh \
    -it \
    jazzdd/vboxwebsrv \
    subhrendu@192.168.2.5
```

```
sudo docker run --name vbox_http --restart=always \
    -p 8080:80 \
    -e TZ=Europe/Paris \
    -e ID_HOSTPORT=192.168.2.5:18083 \
    -e ID_NAME=subhrendu \
    -e ID_USER=subhrendu \
    -e ID_PW='265555' \
    -e CONF_browserRestrictFolders="/data,/home" \
    -d joweisberg/phpvirtualbox
```

## docker-compose.yml
```
version: "3.5"
services:
    vbox_http:
        container_name: vbox_http
        image: joweisberg/phpvirtualbox
        restart: always
        depends_on:
            - vbox_websrv
        ports:
            - 8080:80
        environment:
            - TZ:"Asia/Kolkata"
            - SRV1_HOSTPORT:"vbox_websrv_1:18083"
            - SRV1_NAME:"Server1"
            - SRV1_USER:"user1"
            - SRV1_PW:"test"
            - CONF_browserRestrictFolders:"/home,/usr/lib/virtualbox,"
            - CONF_noAuth:"true"

    vbox_websrv:
        container_name: vbox_websrv_1
        image: jazzdd/vboxwebsrv
        command: subhrendu@127.0.0.1
        restart: always
        environment:
            - USE_KEY: 1
        volumes:
            - "./ssh:/root/.ssh"
```
