#!/bin/bash

echo "Relevant Environment variables:"
echo "\t SSH CONN STRING:${1}"
echo "\t SSH_PASSWD:${SSH_PASSWD}"
echo "\t SSH_PORT:${SSH_PORT}"
[ -z "$1" ] && echo "Error: No target argument given" && exit 1;

sshHost=$(awk -F@ '{print $2}' <<<$1)

echo "Trying to connect "${sshHost}
echo "Hostname of VM:"
sshpass -p $SSH_PASSWD ssh -o StrictHostKeyChecking=no -p $SSH_PORT $1 "hostname"
# sshpass -p $SSH_PASSWD ssh -o StrictHostKeyChecking=no -p 22 server2@192.168.150.221 "hostname"
echo "Kill already running vboxwebsrv in VM:"
sshpass -p $SSH_PASSWD ssh -o StrictHostKeyChecking=no -p $SSH_PORT $1 "killall vboxwebsrv"
echo "Relaunch vboxwebsrv in VM:"
sshpass -p $SSH_PASSWD ssh -o StrictHostKeyChecking=no -p $SSH_PORT -L 0.0.0.0:18083:$sshHost:$PORT $1 "killall vboxwebsrv; \"$VBOXWEBSRVPATH\" -p $PORT -A null -H $sshHost"