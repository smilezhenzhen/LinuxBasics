#!/bin/bash

#1 如果存在testA用户，删除它再创建testA用户
#2 切换到A用户，在/ home/ test A目录下，如果不存在A目录，创建A目录;如果存在，删除A目录，再创建A目录。
#3 A目录下创建20个文件，文件名为当前的系统的时间，并且随机生成10个字符写入这个文件，每隔5秒创建一个文件。
USER1_DIR_NAME="/home/testA"
userinfoA=`egrep -s "testA" /etc/passwd`
if [ -n "$userinfoA" ] ; then
        userdel testA
        rm -rf ${USER1_DIR_NAME}
        rm -rf /var/spool/mail/testA
        echo "delete testA success"
fi
useradd testA
passwd testA
echo "add testA success"

#creat the home directory for testA if not exists
if [ -d "${USER1_DIR_NAME}" ] ; then
        rm -rf ${USER1_DIR_NAME}
fi
mkdir ${USER1_DIR_NAME}
cp -r /etc/skel/. ${USER1_DIR_NAME}
chown -R testA:testA ${USER1_DIR_NAME}
chmod 700 ${USER1_DIR_NAME}
echo "make the home directory of testA success"
