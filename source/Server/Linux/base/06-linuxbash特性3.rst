Linux上bash的基础特性（三）
===============================================

编程环境
-----------------------------------------

shell脚本的组成部分

- shebang
- 各种命令组合

编程变量种类

- 本地变量： 仅仅在当前的shell生效
- 环境变量： 在当前和子shell生效
- 局部变量： shell进程某代码片段
- 位置变量： $1,$2来表示，用与获取脚本接受的参数
- 特殊变量： 一些特殊变量

特殊变量如下

- $?:上一个命令的执行返回码
- $#:参数个数
- $*:参数
- $0:命令本身
- $@:所有参数

本地变量： name='value'

环境变量：export name=value,declare -x name=value

查看环境变量： env,export,printenv变量

bash的配置文件

- 全局配置文件
    - /etc/profile
    - /etc/profile.d/\*.sh
- 个人的配置文件
    - ~/.bash_profile
    - ~/.bashrc

profile:用于定义环境变量和脚本

bashrc：用于定义命令别名和本地变量

算数运算
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  let a=expr
-  $[expr]
-  $((expr))
-  expr a1 op a2

.. code-block:: bash

    [root@centos6 x]# let a=10
    [root@centos6 x]# $[10+20]
    -bash: 30: command not found
    [root@centos6 x]# echo $[10+20]
    30
    [root@centos6 x]# echo $((10+20))
    30
    [root@centos6 x]# echo `expr 10 + 20`
    30

条件测试
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- test expr
- [ expr ]
- [[ expr ]]

测试类型
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- -gt
- -lt
- -eq
- -ge
- -le
- -ne

字符测试
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- ==
- >
- <
- !=
- =~
- -z
- -n

文件测试
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- -a
- -e
- -b
- -c
- -d 
- -f
- -S:存在且为socket 
- -p 
- -h -L
- -r 
- -w 
- -x
- -g
- -u
- -k
- -s:存在且非空
- -t fd：表示文件表叔父是否已经打开且与某个终端先关
- -N :文件自上次被读取之后是否被修改过
- -O:是否是文件属主
- -G:是否是文件组
- file2 -ef file2: 相同inode文件
- file1 -nt file2:file1比file2新
- file1 -ot file2:file1比file2旧

组合测试
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- && 
- || 
- -a
- -o
- !

语句控制
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
if 

.. code-block:: bash

    if expr ; then 
        sate
    fi 

for 

.. code-block:: bash

    for var in [] ; do 
        sate 
    done


