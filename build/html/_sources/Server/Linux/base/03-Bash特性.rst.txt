LINUX上bash的基础特性(一）
==============================================================

命令历史
-----------------------------------------------------------------

环境变量

-   HISTSIZE:命令历史的条数
-   HISTFILE:默认为'~/.bash_history'
-   HISTFILESIZE:HISTFILE文件记录历史的条数

history 常用命令

-d              删除指定的命令
-c              清空命令
-a              手工追加当前会话的命令历史到历史文件中去

调用历史命令

* !#:重复执行第#条命令
* !!:重复执行上一条命令
* !str:执行指定str开头的命令（最后一个）


控制命令历史的记录方式

主要和HISTCONTROL这个环境变量有关（"/etc/profile"）

-   ignoredups:忽略重复
-   ignorespace:忽略空白开头
-   ignoreboth:上面2个都启用

命令补全
---------------------------------------------------------

tab补全

路径补全
-----------------------------------------------------------------

tab补全

目录管理类命令
--------------------------------------------------------------------------------

mkdir
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

用法： mkdir [option] directoy...

-p          没有父目录就一起创建了
-v          显示创建目录过程
-m          指定权限

.. code-block:: bash

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
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

用法： tree [option] directory

-d          只显示目录
-L          只显示指定的level级别
-P          只显示匹配指定的路径

命令行展开
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

~，{},~username

命令的执行结果状态
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

$?：获取上一个命令的执行状态码

文件查看命令
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

more

less

head

-n              获取前n行
-c              获取前n个字符

tail

-n              获取后n行
-c              获取后n个字符
-f              动态显示

文件管理
----------------------------------------------------

cp
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

用法： cp src dst

情况1：测试src是文件，目标不存在

.. code-block:: bash

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

    [root@centos6 dirtest]# cp a.tx  p
    cp: overwrite 'p'? y
    [root@centos6 dirtest]# cp a.tx  a
    [root@centos6 dirtest]# ll a
    total 4
    -rw-r--r--. 1 root root    0 Aug  7 07:11 a.tx
    drwxr-xr-x. 3 root root 4096 Aug  7 06:47 b

情况3：测试src是目录,dst不存在

.. code-block:: bash

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

rm 

-i          交互
-f          强制
-r          递归
