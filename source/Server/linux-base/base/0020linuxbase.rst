.. _linux_base:

======================================================================================================================================================
Linux入门基础
======================================================================================================================================================

:Date: 2018-09-02

.. contents::


计算机一般是计算机硬件和软件的综合体的统称。

Linux系统安装
======================================================================================================================================================

.. toctree::
   :maxdepth: 2
   :glob:
   
   systemInstall/*




终端的概念
======================================================================================================================================================

概念： 是一个或者多个设备的组合。

在Linux系统中可以用一句话来说明所有的设备及文件。即 ``一切皆文件`` 。

linux无论是用显示器键盘鼠标登陆系统还是远程通过ssh/svn登陆系统，都可以理解为一个通过一个终端来登陆系统。

终端分类
------------------------------------------------------------------------------------------------------------------------------------------------------

Linux系统中所有的设备在Linux系统中都表现为一个文件，一般是在 ``/dev`` 目录下面。

物理终端
    本机自带的，显示器，键盘和鼠标等，表示为 ``/dev/control`` 。
虚拟终端
    系统提供的终端（软件实现），表示为 ``/dev/tty#`` 。

    系统本地登陆则登陆显示为tty#,其中 ``#`` 默认从1开始。

    
图形终端
    附加在物理终端之上，用软件方式实现的终端，提供图形界面。

伪终端
    图形界面下打开的命令行接口,还有基于远程协议打开的命令行界面，表示为"/dev/pts#"。

    pts/ptmx：pts(pseudo-terminal slave)是pty的实现方法，与ptmx(pseudo-terminal master)配合使用实现pty。
    man里面是这样说的：ptmx and pts - pseudo-terminal master and slave，pts是所谓的伪终端或虚拟终端，具体表现就是你打开一个终端，
    这个终端就叫pts/0，如果你再打开一个终端，这个新的终端就叫pts /1。

    ssh链接服务器，一般登陆后用 ``last`` 和 ``who`` 来登陆用户信息时可以看到pts/1

- 查看当前的登陆的终端类型：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# tty
    /dev/pts/1

- 交互式程序分类

    GUI
        图形化界面（GNOME,KDE,XFCE）
    CLI
        命令行界面


``[root@zzjlogin ~]#`` 我们成为PS1,设置我们使用命令的前缀的。

查看当前的PS1设置

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# echo $PS1
    [\u@\h \W]\$

说明：

.. code-block:: text
    :linenos:

    \e 和\033一样的。
    \e[33m相当与开始颜色配置，33代表指定的颜色，可以修改。
    \e[0m代表颜色结束控制。
    \u 用户名
    \w 当前目录名字
    \W当前目录基名
    \#开机后命令历史数


详细的PS1设置可以通过"man bash \|grep PS1 -A 40"获得

.. code-block:: text
    :linenos:

    \a     an ASCII bell character (07)
    \d     the date in "Weekday Month Date" format (e.g., "Tue May 26")
    \D{format}
            the format is passed to strftime(3) and the result  is  inserted
            into the prompt string; an empty format results in a locale-spe‐
            cific time representation.  The braces are required
    \e     an ASCII escape character (033)
    \h     the hostname up to the first '.' 短主机名字
    \H     the hostname 全主机名
    \j     the number of jobs currently managed by the shell
    \l     the basename of the shell's terminal device name
    \n     newline
    \r     carriage return
    \s     the name of the shell, the basename of $0 (the portion following
            the final slash)
    \t     the current time in 24-hour HH:MM:SS format 24小时的格式
    \T     the current time in 12-hour HH:MM:SS format 24小时的格式
    \@     the current time in 12-hour am/pm format    12小时的上下午格式
    \A     the current time in 24-hour HH:MM format    24的时分没秒的格式
    \u     the username of the current user   用户名
    \v     the version of bash (e.g., 2.00)   bash的版本
    \V     the release of bash, version + patch level (e.g., 2.00.0) 补丁版本
    \w     the  current  working  directory,  with $HOME abbreviated with a
            tilde (uses the value of the PROMPT_DIRTRIM variable) 长工作目录名字
    \W     the basename of the current working directory, with $HOME abbre‐
            viated with a tilde  短工作目录名字
    \!     the history number of this command 当前命令的历史号
    \#     the command number of this command 命令提示符，表示管理员和普通用户的
    \$     if the effective UID is 0, a #, otherwise a $ 用户的uid
    \nnn   the character corresponding to the octal number nnn
    \\     a backslash 
    \[     begin a sequence of non-printing characters, which could be used
            to embed a terminal control sequence into the prompt
    \]     end a sequence of non-printing characters


查看命令对应的执行程序全路径

.. code-block:: bash
    :linenos:

    [root@zzjlogin user1]# which ls
    alias ls='ls --color=auto'
    /usr/bin/ls
    [root@zzjlogin user1]# which ls --skip-alias
    /usr/bin/ls

查看命令帮助文档位置

.. code-block:: bash
    :linenos:

    [root@zzjlogin user1]# whereis ls
    ls: /usr/bin/ls /usr/share/man/man1/ls.1.gz /usr/share/man/man1p/ls.1p.gz



文件系统
======================================================================================================================================================

文件系统特性
    - 文件名区分大小写
    - 文件名除了'/'的任意字符都可以，不建议特殊字符
    - 文件名长度不能超过255字符
    - 所有'.'开头的文件都是隐藏文件或者目录

路径分类：
    - 绝对路径： 从根目录开始的路径
    - 相对路径： 从当前目录开始的路径

文件类型有一下几类
    - \-            普通文件
    - d             目录文件
    - b             块设备文件
    - c             字符设备文件
    - s             socket文件
    - p             管道文件
    - l             连接文件

Linux命令获取帮助方式
    1. COMMAND --help
    #. man
    #. info
    #. 程序自身的帮助文档，如README,INSTALL,CHANGELOG.
    #. 程序的官方文档
    #. 发行版的官方文档
    #. GOOGLE

基础命令学习
------------------------------------------------------------------------------------------------------------------------------------------------------

hash命令学习
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash
    :linenos:

    [root@zzjlogin user1]# help hash
    hash: hash [-lr] [-p pathname] [-dt] [name ...]
        Remember or display program locations.
        Options:
        -d		forget the remembered location of each NAME 清空指定的命令hash
        -l		display in a format that may be reused as input 显示所有的
        -p pathname	use PATHNAME is the full pathname of NAME   
        -r		forget all remembered locations     清空所有命令的hash
        -t		print the remembered location of each NAME, preceding
            each location with the corresponding NAME if multiple
            NAMEs are given 打印hash记录的命令位置



查询命令的所属章节
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash
    :linenos:

    [root@centos74 test]$ man -f ls
    ls (1)               - list directory contents
    ls (1p)              - list directory contents
    [root@zzjlogin user1]# whatis ls
    ls (1)               - list directory contents
    ls (1p)              - list directory contents
    [root@zzjlogin user1]# man 1 ls

命令的分类
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. 用户命令
#. 系统调用
#. 库调用
#. 设备及特殊文件
#. 配置文件
#. 游戏
#. 杂项
#. 管理命令

man文档的配置文件
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- centos6: "/etc/man.config"
- centos7: "/etc/man_db.conf"

man手册段落含义
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* name: 命令的名字或简要说明
* description: 命令功能的详细描述
* options: 支持的选项
* sysnopsis: 使用格式
* examples： 使用样例
* notes:相关的注意事项
* files：相关的配置文件
* see also：相关的参考



时钟的修改
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# hwclock --hctosys # hc to sys 硬件去修改系统
    [root@zzjlogin ~]# hwclock --systohc # sys to hc 系统去修改硬件

相关环境变量
======================================================================================================================================================
- PWD:保存当前目录路径
- OLDPWD:保存上一次目录的路径
- PATH: 系统环境变量(默认环境变量:)
- LANG:系统字符(默认语言en_US.UTF-8)
- SHELL:当前用户的Shell类型(默认/bin/bash)
- HISTSIZE:命令历史记录的数量(默认1000条)
- HISTFILE:报错命令历史的记录文件(用户家目录的.bash_history)
- HISTFILESIZ:HISTFILE文件记录历史的条数(默认和HISTSIZE一样1000条)

whatis
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# whatis ls
    ls (1)               - list directory contents
    ls (1p)              - list directory contents

    #centos6:makewhat命令创建帮助手册和对应关键字的数据库
    #cnetos7:mandb





