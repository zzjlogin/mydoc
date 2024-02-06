.. _Linux-bash:

======================================================================================================================================================
bash的基础特性
======================================================================================================================================================

:Date: 2018-09-02

.. contents::

命令历史
======================================================================================================================================================

环境变量
    - PWD:保存当前目录路径
    - OLDPWD:保存上一次目录的路径
    - PATH: 系统环境变量(默认环境变量:)
    - LANG:系统字符(默认语言en_US.UTF-8)
    - SHELL:当前用户的Shell类型(默认/bin/bash)
    - HISTSIZE:命令历史记录的数量(默认1000条)
    - HISTFILE:报错命令历史的记录文件(用户家目录的.bash_history)
    - HISTFILESIZ:HISTFILE文件记录历史的条数(默认和HISTSIZE一样1000条)

history 常用参数
    -d              删除指定的命令
    -c              清空命令
    -a              手工追加当前会话的命令历史到历史文件中去

调用历史命令
    * !#:重复执行第#条命令
    * !!:重复执行上一条命令
    * !str:执行指定str开头的命令（最后一个）


控制命令历史的记录方式

主要和HISTCONTROL这个环境变量有关（"/etc/profile"）
    - ignoredups:忽略重复
    - ignorespace:忽略空白开头
    - ignoreboth:上面2个都启用

补全(命令/路径)
======================================================================================================================================================

tab键补全


文件及目录管理类命令
======================================================================================================================================================

常用命令：
    mkdir：创建目录
    tree：显示目录树结构
    cp：复制
    more、less、head：文件内容查看
    mv：移动文件位置或者文件重命名
    rm：文件/目录删除

mkdir
------------------------------------------------------------------------------------------------------------------------------------------------------

用法
    mkdir [option] directoy...

-p          没有父目录就一起创建了
-v          显示创建目录过程
-m          指定权限

.. code-block:: bash
    :linenos:

    [root@centos6 dirtest]# mkdir -pv /app/dirtest/a/b/c/d
    mkdir: created directory '/app/dirtest/a'
    mkdir: created directory '/app/dirtest/a/b'
    mkdir: created directory '/app/dirtest/a/b/c'
    mkdir: created directory '/app/dirtest/a/b/c/d'
    [root@centos6 dirtest]# mkdir -m 0744 d
    [root@centos6 dirtest]# ls
    a  d
    [root@centos6 dirtest]# ll
    total 8
    drwxr-xr-x. 3 root root 4096 Aug  7 06:47 a
    drwxr--r--. 2 root root 4096 Aug  7 06:47 d

tree
------------------------------------------------------------------------------------------------------------------------------------------------------

用法： tree [option] directory

-d          只显示目录
-L          只显示指定的level级别
-P          只显示匹配指定的路径

命令行展开
------------------------------------------------------------------------------------------------------------------------------------------------------

~，{},~username

命令的执行结果状态
------------------------------------------------------------------------------------------------------------------------------------------------------

echo $?
    获取上一个命令的执行状态码，如果是0则执行正确结束。非零则为报错提示异常退出。

文件查看命令
------------------------------------------------------------------------------------------------------------------------------------------------------

more

less

head

-n              获取前n行
-c              获取前n个字符

tail

-n              获取后n行
-c              获取后n个字符
-f              动态显示


cp
------------------------------------------------------------------------------------------------------------------------------------------------------

用法： cp src dst

情况1：测试src是文件，目标不存在

.. code-block:: bash
    :linenos:

    [root@centos6 dirtest]# touch a.tx
    [root@centos6 dirtest]# ls
    a  a.tx  bin  d  sbin  usr  x  x_m  x_n  y_m  y_n
    [root@centos6 dirtest]# cp a.tx p
    [root@centos6 dirtest]# ll
    total 40
    drwxr-xr-x. 3 root root 4096 Aug  7 06:47 a
    -rw-r--r--. 1 root root    0 Aug  7 07:09 a.tx
    drwxr-xr-x. 2 root root 4096 Aug  7 07:01 bin
    drwxr--r--. 2 root root 4096 Aug  7 06:47 d
    -rw-r--r--. 1 root root    0 Aug  7 07:09 p
    drwxr-xr-x. 2 root root 4096 Aug  7 07:01 sbin
    drwxr-xr-x. 4 root root 4096 Aug  7 07:01 usr
    drwxr-xr-x. 3 root root 4096 Aug  7 06:59 x
    drwxr-xr-x. 2 root root 4096 Aug  7 07:00 x_m
    drwxr-xr-x. 2 root root 4096 Aug  7 07:00 x_n
    drwxr-xr-x. 2 root root 4096 Aug  7 07:00 y_m
    drwxr-xr-x. 2 root root 4096 Aug  7 07:00 y_n

情况2：测试src是文件，dst存在

.. code-block:: bash
    :linenos:

    [root@centos6 dirtest]# cp a.tx  p
    cp: overwrite 'p'? y
    [root@centos6 dirtest]# cp a.tx  a
    [root@centos6 dirtest]# ll a
    total 4
    -rw-r--r--. 1 root root    0 Aug  7 07:11 a.tx
    drwxr-xr-x. 3 root root 4096 Aug  7 06:47 b

情况3：测试src是目录,dst不存在

.. code-block:: bash
    :linenos:

    [root@centos6 dirtest]# cp -r a ap
    [root@centos6 dirtest]# ll
    total 44
    drwxr-xr-x. 3 root root 4096 Aug  7 07:11 a
    drwxr-xr-x. 3 root root 4096 Aug  7 07:12 ap
    -rw-r--r--. 1 root root    0 Aug  7 07:09 a.tx
    drwxr-xr-x. 2 root root 4096 Aug  7 07:01 bin
    drwxr--r--. 2 root root 4096 Aug  7 06:47 d
    -rw-r--r--. 1 root root    0 Aug  7 07:11 p
    drwxr-xr-x. 2 root root 4096 Aug  7 07:01 sbin
    drwxr-xr-x. 4 root root 4096 Aug  7 07:01 usr
    drwxr-xr-x. 3 root root 4096 Aug  7 06:59 x
    drwxr-xr-x. 2 root root 4096 Aug  7 07:00 x_m
    drwxr-xr-x. 2 root root 4096 Aug  7 07:00 x_n
    drwxr-xr-x. 2 root root 4096 Aug  7 07:00 y_m
    drwxr-xr-x. 2 root root 4096 Aug  7 07:00 y_n
    [root@centos6 dirtest]# ll a ap
    a:
    total 4
    -rw-r--r--. 1 root root    0 Aug  7 07:11 a.tx
    drwxr-xr-x. 3 root root 4096 Aug  7 06:47 b

    ap:
    total 4
    -rw-r--r--. 1 root root    0 Aug  7 07:12 a.tx
    drwxr-xr-x. 3 root root 4096 Aug  7 07:12 b


情况4：测试src是目录，dst存在

.. code-block:: bash
    :linenos:

    [root@centos6 dirtest]# cp -r a ap
    [root@centos6 dirtest]# ll ap
    total 8
    drwxr-xr-x. 3 root root 4096 Aug  7 07:14 a
    -rw-r--r--. 1 root root    0 Aug  7 07:12 a.tx
    drwxr-xr-x. 3 root root 4096 Aug  7 07:12 b
    [root@centos6 dirtest]# cd a
    [root@centos6 a]# ls
    a.tx  b
    [root@centos6 a]# tree ap
    ap [error opening dir]

    0 directories, 0 files
    [root@centos6 a]# ls
    a.tx  b
    [root@centos6 a]# cd ..
    [root@centos6 dirtest]# ls
    a  ap  a.tx  bin  d  p  sbin  usr  x  x_m  x_n  y_m  y_n
    [root@centos6 dirtest]# tree ap
    ap
    ├── a
    │   ├── a.tx
    │   └── b
    │       └── c
    │           └── d
    ├── a.tx
    └── b
        └── c
            └── d

    7 directories, 2 files


mv
    文件移动/重命名

rm
    删除文件及目录(删除空目录也可以用rmdir)

-i          交互
-f          强制
-r          递归



命令别名
======================================================================================================================================================

alias cdnet="cd /etc/sysconfig/network-scripts"

针对用户的别名： "~/.bashrc"

针对系统的别名："/etc/bashrc"

重读配置文件:source /path/to/config.file

unalias:撤销别名



bash快捷键盘
======================================================================================================================================================

- ctrl+L:作用和clear命令相同。清空当前屏幕输出内容。然后把光标移动到屏幕最上方。
- ctrl+a:把光标移动到输入内容的最左侧(开始的位置)。
- ctrl+e:把光标移动到出入内容的最右侧。
- ctrl+u:清除剪切光标之前的内容
- ctrl+k: 清除剪切光标及光标之后的内容

bash重定向(i/o)
======================================================================================================================================================

重定向分为以下几种:
    - >:覆盖输出重定向，会覆盖文件原有内容。从第一行开始覆盖。
    - >>:追加输出重定向，会追加到文件末尾。
    - 2>:错误输出
    - 2>>:错误追加
    - > a.txt 2 > &1：标准输出覆盖输出到a.txt。如果a.txt文件原来有内容则覆盖，并把标准错误重定向到标准输出。
    - >>a.txt 2>> &1:标准输出追加到a.txt，标准错误追加输出到标准输出。

tr

.. code-block:: bash
    :linenos:

    [root@centos6 dirtest]# tr 'a-z' 'A-Z' < /etc/fstab 

    #
    # /ETC/FSTAB
    # CREATED BY ANACONDA ON TUE NOV  7 15:31:40 2017
    #
    # ACCESSIBLE FILESYSTEMS, BY REFERENCE, ARE MAINTAINED UNDER '/DEV/DISK'
    # SEE MAN PAGES FSTAB(5), FINDFS(8), MOUNT(8) AND/OR BLKID(8) FOR MORE INFO
    #
    UUID=AA4C5795-C48C-4E21-B5A2-31198C603E8D /                       EXT4    DEFAULTS        1 1
    UUID=0733A859-9567-48D3-88B1-B8D1FBEBBBA0 /APP                    EXT4    DEFAULTS        1 2
    UUID=53B38D7C-322C-484D-B108-5C8191251531 /BOOT                   EXT4    DEFAULTS        1 2
    UUID=38651A9B-10AB-4218-960B-D0EBB9CBAA54 SWAP                    SWAP    DEFAULTS        0 0
    TMPFS                   /DEV/SHM                TMPFS   DEFAULTS        0 0
    DEVPTS                  /DEV/PTS                DEVPTS  GID=5,MODE=620  0 0
    SYSFS                   /SYS                    SYSFS   DEFAULTS        0 0
    PROC                    /PROC                   PROC    DEFAULTS        0 0

文本处理工具
======================================================================================================================================================

文件处理一般常用命令及常用参数包括:

wc
    -l              行数
    -c              字符数量
    -w              单词个数

cut
    -d              分割符号
    -f              提取

sort
    -f              忽略大小写
    -k              指定字段排序
    -t              分割
    -n              数字排序
    -u              去重连续的重复
    -r              逆序

uniq
    -c              显示重复的次数
    -d              只显示重复的行
    -u              只显示不重复的行



编程环境
======================================================================================================================================================

shell脚本的组成部分
    - 关键字、控制语句:if...else...，for,do...done
    - shell命令,例如:echo，exit等
    - 文本处理命令,例如:awk,grep,cut,sed等
    - 函数

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

本地变量：
    name='value'

环境变量：
    export name=value,declare -x name=value

查看环境变量：
    env,export,printenv变量

bash的配置文件
------------------------------------------------------------------------------------------------------------------------------------------------------

全局配置文件
    - /etc/profile
    - /etc/profile.d/\*.sh
个人的配置文件
    - ~/.bash_profile
    - ~/.bashrc

profile:
    用于定义环境变量和脚本

bashrc：
    用于定义命令别名和本地变量

算数运算
    -  let a=expr
    -  $[expr]
    -  $((expr))
    -  expr a1 op a2

运算符使用举例:

.. code-block:: bash
    :linenos:

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
    - test expr
    - [ expr ]
    - [[ expr ]]

.. literalinclude:: /Server/res/demo/program/shell/shell-demo.sh
    :linenos:
    :lines: 135-208
    :language: bash

语句控制
    if 

.. code-block:: bash
    :linenos:

    if expr ; then 
        sate
    fi 


for 

.. code-block:: bash
    :linenos:

    for var in [] ; do 
        sate 
    done








