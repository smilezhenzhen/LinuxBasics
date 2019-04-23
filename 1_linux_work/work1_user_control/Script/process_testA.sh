#!/bin/bash

#creat 20 files every 5 seconds in the directory of /home/testA
USER1_DIR_NAME="/home/testA"
cd ${USER1_DIR_NAME}
for (( i=1;i<=20;i++ ));
do
        TIME=$(date "+%Y-%m-%d_%H:%M:%S")
        touch "$TIME.txt"
        head /dev/urandom | tr -dc A-Za-z0-9 | head -c 10  > "${USER1_DIR_NAME}/$TIME.txt"
        sleep 5
done

