##### 一、考察内容

1、脚本的创建及运行；

2、用户与组的创建；

3、目录的创建与删除；

4、脚本及函数的传参；

5、周期或定时执行命令。

##### 二、思考总结

1、脚本解释器路径#!/bin/bash要规范完整，以免出现环境变量等问题；

2、通过判断/etc/passwd文件中的内容来判断用户是否存在；

3、要注意在不同用户下创建目录的所属用户、所属组以及权限的问题；

4、对于经常使用的目录路径可以使用宏定义；

5、学会使用echo进行调试，判断程序是否正确（重要！！！）；

6、rm -rf命令要谨慎使用，在使用可以使用echo打印出目录路径，确保正确；

7、对于函数或者脚本的参数$1,$2等，可以将其赋给一个有意义的变量名，并做好注释；

8、切换用户执行命名或者脚本需要经常用到，很多时候需要root用户来进行过渡；

9、使用expect来实现免密码切换用户。

##### 三、遗留问题

1、使用免密码切换用户后，后续的命令仍然不会执行；

2、使用su - root -s shell.sh可以切换用户执行脚本，但不能切换用户执行函数。

