#!/bin/bash

#1 如果存在testA用户，删除它再创建testA用户
#2 切换到A用户，在/ home/ test A目录下，如果不存在A目录，创建A目录;如果存在，删除A目录，再创建A目录。
#3 A目录下创建20个文件，文件名为当前的系统的时间，并且随机生成10个字符写入这个文件，每隔5秒创建一个文件。
#4 如果存在testB用户，删除它再创建testB用户
#5 将/ home/testA目录下的A目录cp到/ home/ testB目录下,变为B目录，修改B目录属主为testB
#6 遍历B目录下的文件，输出每个文件的文件名以及前文件内容的5个字符，要求每3秒遍历一个文件


#第一个参数是用户1
function process_root ()
{
user1=$1
USER1_DIR_NAME="/home/$user1"
userinfoA=`egrep -s "$user1" /etc/passwd`
if [ -n "$userinfoA" ] ; then
        userdel $user1
        rm -rf ${USER1_DIR_NAME}
        rm -rf /var/spool/mail/$user1
        echo "delete $user1 success"
fi
useradd $user1
passwd $user1
echo "add $user1 success"

#creat the home directory for testA if not exists
if [ -d "${USER1_DIR_NAME}" ] ; then
        rm -rf ${USER1_DIR_NAME}
	#echo ${USER1_DIR_NAME}
fi
mkdir ${USER1_DIR_NAME}
cp -r /etc/skel/. ${USER1_DIR_NAME}
chown -R $user1:$user1 ${USER1_DIR_NAME}
chmod 700 ${USER1_DIR_NAME}
echo "make the home directory of testA success"
}

#第一个参数是用户1，第二个参数是时间间隔
function process_user1 ()
{
user1=$1
USER1_DIR_NAME="/home/$user1"
cd ${USER1_DIR_NAME}
for (( i=1;i<=20;i++ ));
do
        TIME=$(date "+%Y-%m-%d_%H:%M:%S")
        touch "$TIME.txt"
        head /dev/urandom | tr -dc A-Za-z0-9 | head -c 10  > "${USER1_DIR_NAME}/$TIME.txt"
        sleep $2
done
}

#第一个参数是用户1，第二个参数是用户2，第三个参数是时间间隔
function process_user2 ()
{
user1=$1
user2=$2
USER1_DIR_NAME="/home/$user1"
USER2_DIR_NAME="/home/$user2"
FILENAME="/home/$user1/filename.txt"
FILECONTENT="/home/$user1/filecontent.txt"
userinfoB=`egrep -s "$user2" /etc/passwd`
if [ -n "$userinfoB" ] ; then
        userdel $user2
        rm -rf ${USER2_DIR_NAME}
        rm -rf /var/spool/mail/$user2
        echo "delete $user2 success"
fi
useradd $user2
passwd $user2
echo "add $user2 success"
cp -r /home/$user1/. ${USER2_DIR_NAME}
chown -R $user2:$user2 ${USER2_DIR_NAME}
chmod 700 ${USER2_DIR_NAME}
echo "copy the $user1 to $user2"

#traversing the directory of /home/testB
cd ${USER2_DIR_NAME}
index=1
echo "==========Begin==========" >> ${FILENAME}
echo "==Begin==" >> ${FILECONTENT}
for file in $(ls *); do
        echo "$index:$file" >> ${FILENAME}
        content=`cat "${USER2_DIR_NAME}/$file"`
        echo "$index:${content:0:5}" >> ${FILECONTENT}
        let index++
        sleep $3
done
echo "===========End===========" >> ${FILENAME}
echo "===End===" >> ${FILECONTENT}
}

user1_name="testA"
user2_name="testB"
time1_interval=1
time2_interval=1
#. ./su_root.sh
#su_root
process_root $user1_name
#su - $user1_name
process_user1 $user1_name $time1_interval
#echo 'alias su_root="/usr/bin/su_root.sh"' >> /home/$user1_name/.bashrc
process_user2 $user1_name $user2_name $time2_interval
