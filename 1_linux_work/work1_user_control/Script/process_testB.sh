#!/bin/bash

#4 如果存在testB用户，删除它再创建testB用户
#5 将/ home/testA目录下的A目录cp到/ home/ testB目录下,变为B目录，修改B目录属主为testB
#6 遍历B目录下的文件，输出每个文件的文件名以及前文件内容的5个字符，要求每3秒遍历一个文件

#creat testB if not exists
USER2_DIR_NAME="/home/testB"
FILENAME="/home/testA/filename.txt"
FILECONTENT="/home/testA/filecontent.txt"
userinfoB=`egrep -s "testB" /etc/passwd`
if [ -n "$userinfoB" ] ; then
	userdel testB
	rm -rf ${USER2_DIR_NAME}
	rm -rf /var/spool/mail/testB
	echo "delete testB success"
fi
useradd testB
passwd testB
echo "add testB success"
cp -r /home/testA/. ${USER2_DIR_NAME}
chown -R testB:testB ${USER2_DIR_NAME}
chmod 700 ${USER2_DIR_NAME}
echo "copy the testA to testB"

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
	sleep 3
done
echo "===========End===========" >> ${FILENAME}
echo "===End===" >> ${FILECONTENT}

