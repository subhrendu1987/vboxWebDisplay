#!/bin/bash

[ -z "$1" ] && echo "Error: No target argument given" && exit 1;

sshHost=$(awk -F@ '{print $2}' <<<$1)

echo "Trying to connect "${sshHost}
sshpass -p $SSH_PASSWD ssh -o StrictHostKeyChecking=no -p $SSH_PORT $1 "hostname"
sshpass -p $SSH_PASSWD ssh -o StrictHostKeyChecking=no -p $SSH_PORT $1 "killall vboxwebsrv"
sshpass -p $SSH_PASSWD ssh -o StrictHostKeyChecking=no -p $SSH_PORT -L 0.0.0.0:18083:$sshHost:$PORT $1 "killall vboxwebsrv; \"$VBOXWEBSRVPATH\" -p $PORT -A null -H $sshHost"