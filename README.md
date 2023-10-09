# vboxWebDisplay
## Scenario
```
{[phpVboxDocker (P)] [WebServer (W)]} <----> [VM Server (V)]

{[pp.pp.pp.pp  ] [ww.ww.ww.ww  ]} <----> [vv.vv.vv.vv]
```

## Setup SSH key-pair between `docker-WebServ (W)` and `VM (V)` (Not Working)
```
sudo docker run \
    --rm \
    --name vbox_websrv_init \
    -e USE_KEY=0 \
    -v $(pwd)/ssh:/root/.ssh \
    -v $(pwd)/init_run.sh:/run.sh \
    -it \
    jazzdd/vboxwebsrv \
    <USERNAME V>@<vv.vv.vv.vv>
```
## Command

```
sudo docker run --name vbox_http --restart=always \
    -p 8080:80 \
    -e TZ=Europe/Paris \
    -e ID_HOSTPORT=<vv.vv.vv.vv>:18083 \
    -e ID_NAME=subhrendu \
    -e ID_USER=<USERNAME V> \
    -e ID_PW='<PASSWD V>' \
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
            TZ: "Asia/Kolkata"
            SRV1_HOSTPORT: "vbox_websrv_1:18083"
            SRV1_NAME: "Server1"
            SRV1_USER: "user1"
            SRV1_PW: "test"
            CONF_browserRestrictFolders: "/home,/usr/lib/virtualbox,"
            CONF_noAuth: "true"

    vbox_websrv:
        container_name: vbox_websrv_1
        build:
            context: .
            dockerfile: Dockerfile-vboxwebsrv
        image: vboxwebsrv
        command: <USERNAME V>@<vv.vv.vv.vv>
        #restart: always
        environment:
            - USE_KEY=1
            - SSH_PORT=22
            - SSH_PASSWD=<PASSWORD V>
        volumes:
            #- "./ssh:/root/.ssh"
            - "./init_run.sh:/run.sh"
        #stdin_open: true
        #tty: true
        #entrypoint: ["bash"]
        #command: ["tail", "-f", "/dev/null"]
```
