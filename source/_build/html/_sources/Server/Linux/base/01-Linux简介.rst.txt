.. highlight:: bash

LINUX简介
======================================================

操作系统与硬件
-----------------------------------------------------






分层结构如下：


.. math::
   :nowrap:

   \begin{eqnarray}
      y    & = & ax^2 + bx + c \\
      f(x) & = & x^2 + 2xy + y^2
   \end{eqnarray}










* 硬件
* 内核
* 库
* 应用程序

终端的概念
-------------------------------------------------------

概念： 是一个或者多个设备的组合。

分类：

物理终端
  本机自带的，显示器，键盘和鼠标等，表示为"/dev/control"。
虚拟终端 
  系统提供的终端（软件实现），表示为"/dev/tty#"。
图形终端
  附加在物理终端之上，用软件方式实现的终端，提供图形界面。
伪终端
  图形界面下打开的命令行接口,还有基于远程协议打开的命令行界面，表示为"/dev/pts#"。

查看当前的登陆的终端类型：

.. code-block:: bash

  [root@mail ~]# tty
  /dev/pts/2

交互式程序分类

GUI
  图形化界面（GNOME,KDE,XFCE）
CLI
  命令行界面

查看当前的shell类型

.. code-block:: bash

  [root@mail ~]# echo $SHELL
  /bin/bash

查看系统支持的所有shell类型

.. code-block:: bash

  [root@mail ~]# cat /etc/shells
  /bin/sh
  /bin/bash
  /sbin/nologin
  /usr/bin/sh
  /usr/bin/bash
  /usr/sbin/nologin
  /bin/tcsh
  /bin/csh

命令提示符
-----------------------------------------------------

"[root@mail ~]#" 我们成为PS1,设置我们使用命令的前缀的。

查看当前的PS1设置

.. code-block:: bash

  [root@mail ~]# echo $PS1
  [\u@\h \W]\$

详细的PS1设置可以通过"man bash \|grep PS1 -A 40"获得

.. code-block:: text

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

  [root@mail user1]# which ls
  alias ls='ls --color=auto'
    /usr/bin/ls
  [root@mail user1]# which ls --skip-alias
  /usr/bin/ls

查看命令帮助文档位置

.. code-block:: bash

  [root@mail user1]# whereis ls
  ls: /usr/bin/ls /usr/share/man/man1/ls.1.gz /usr/share/man/man1p/ls.1p.gz

shell命令分类

内建命令 
  由shell自带。
外部命令
  某路径下的可执行程序文件。

查看命令类型

.. code-block:: bash

  [root@mail user1]# type cd
  cd is a shell builtin
  [root@mail user1]# type service
  service is /usr/sbin/service

文件系统
--------------------------------

文件系统特性

- 文件名区分大小写
- 文件名除了'/'的任意字符都可以，不建议特殊字符
- 文件名长度不能超过255字符
- 所有'.'开头的文件都是隐藏文件或者目录

路径分类：

- 绝对路径： 从根目录开始的路径
- 相对路径： 从当前目录开始的路径

LINUX命令获取帮助方式

#. COMMAND --help
#. man
#. info
#. 程序自身的帮助文档，如README,INSTALL,CHANGELOG.
#. 程序的官方文档
#. 发行版的官方文档
#. GOOGLE

基础命令学习
---------------------------------------------------

hash命令学习
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

  [root@mail user1]# help hash
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


history命令学习
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

  [root@mail user1]# help history
  history: history [-c] [-d offset] [n] or history -anrw [filename] or history -ps arg [arg...]
      Display or manipulate the history list.
      
      Display the history list with line numbers, prefixing each modified
      entry with a '*'.  An argument of N lists only the last N entries.
      
      Options:
        -c	clear the history list by deleting all of the entries 清空命令历史
        -d offset	delete the history entry at offset OFFSET. 删除指定位置的命令历史
      
        -a	append history lines from this session to the history file 追加历史行到历史文件中
        -n	read all history lines not already read from the history file 从历史文件中读取所有命令历史
        -r	read the history file and append the contents to the history
        list 读取所有命令历史文件追加history 列表中
        -w	write the current history to the history file 
        and append them to the history list 写当前的历史记录到文件中去
      
        -p	perform history expansion on each ARG and display the result
        without storing it in the history list 
        -s	append the ARGs to the history list as a single entry
      
      If FILENAME is given, it is used as the history file.  Otherwise,
      if $HISTFILE has a value, that is used, else ~/.bash_history.
      
      If the $HISTTIMEFORMAT variable is set and not null, its value is used
      as a format string for strftime(3) to print the time stamp associated
      with each displayed history entry.  No time stamps are printed otherwise.


查询命令的所属章节
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

        [root@centos74 test]$ man -f ls
        ls (1)               - list directory contents
        ls (1p)              - list directory contents
        [root@mail user1]# whatis ls
        ls (1)               - list directory contents
        ls (1p)              - list directory contents
        [root@mail user1]# man 1 ls

命令的分类
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. 用户命令
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

练习
-------------------------------------------------------------------------- 

date命令使用
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

  NAME
        date - print or set the system date and time 打印或者设置日期

  SYNOPSIS
        date [OPTION]... [+FORMAT] 打印功能
        date [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]] 设置日期

  DESCRIPTION
        Display the current time in the given FORMAT, or set the system date.

        Mandatory arguments to long options are mandatory for short options too.

        -d, --date=STRING
                display time described by STRING, not 'now'

        -f, --file=DATEFILE
                like --date once for each line of DATEFILE

        -I[TIMESPEC], --iso-8601[=TIMESPEC]
                output  date/time  in  ISO  8601 format.  TIMESPEC='date' for date only
                (the default), 'hours', 'minutes', 'seconds', or 'ns' for date and time
                to the indicated precision.

        -r, --reference=FILE
                display the last modification time of FILE

        -R, --rfc-2822
                output  date  and  time  in RFC 2822 format.  Example: Mon, 07 Aug 2006
                12:34:56 -0600
        
        --rfc-3339=TIMESPEC
                output date and time in RFC 3339 format.   TIMESPEC='date',  'seconds',
                or  'ns'  for  date and time to the indicated precision.  Date and time
                components are separated by a single space: 2006-08-07 12:34:56-06:00

        -s, --set=STRING
                set time described by STRING

        -u, --utc, --universal
                print or set Coordinated Universal Time (UTC)

        --help display this help and exit

        --version
                output version information and exit

        FORMAT controls the output.  Interpreted sequences are:

        %%     a literal % 显示百分号

        %a     locale's abbreviated weekday name (e.g., Sun) 显示星期简单名字

        %A     locale's full weekday name (e.g., Sunday) 显示星期长名字

        %b     locale's abbreviated month name (e.g., Jan)显示月份短名字

        %B     locale's full month name (e.g., January) 显示月份长名字

        %c     locale's date and time (e.g., Thu Mar  3 23:05:25 2005)

        %C     century; like %Y, except omit last two digits (e.g., 20)显示世纪

        %d     day of month (e.g., 01)显示日

        %D     date; same as %m/%d/%y    月日年

        %e     day of month, space padded; same as %_d 带空格填充的月

        %F     full date; same as %Y-%m-%d 年月日

        %g     last two digits of year of ISO week number (see %G)

        %G     year of ISO week number (see %V); normally useful only with %V

        %h     same as %b

        %H     hour (00..23) 24小时

        %I     hour (01..12) 12小时

        %j     day of year (001..366)年内日

        %k     hour, space padded ( 0..23); same as %_H 带空格的24小时

        %l     hour, space padded ( 1..12); same as %_I 带空格的12小时

        %m     month (01..12) 月

        %M     minute (00..59)分钟

        %n     a newline 空行

        %N     nanoseconds (000000000..999999999)

        %p     locale's equivalent of either AM or PM; blank if not known 上午下午

        %P     like %p, but lower case 小写的上下午

        %r     locale's 12-hour clock time (e.g., 11:11:04 PM) 

        %R     24-hour hour and minute; same as %H:%M 小时和分钟的

        %s     seconds since 1970-01-01 00:00:00 UTC  总秒数从70年开始

        %S     second (00..60)秒

        %t     a tab   制表符

        %T     time; same as %H:%M:%S  时分秒

        %u     day of week (1..7); 1 is Monday 指定日期在一周中是第几天

        %U     week number of year, with Sunday as first day of week (00..53) 指定日期在这年中是第几周

        %V     ISO week number, with Monday as first day of week (01..53)

        %w     day of week (0..6); 0 is Sunday 指定日期在一周中是第几天

        %W     week number of year, with Monday as first day of week (00..53)

        %x     locale's date representation (e.g., 12/31/99)

        %X     locale's time representation (e.g., 23:13:48)

        %y     last two digits of year (00..99) 2位数字的年

        %Y     year 年

        %z     +hhmm numeric time zone (e.g., -0400)

        %:z    +hh:mm numeric time zone (e.g., -04:00)

        %::z   +hh:mm:ss numeric time zone (e.g., -04:00:00)

        %:::z  numeric time zone with : to necessary precision (e.g., -04, +05:30)

        %Z     alphabetic time zone abbreviation (e.g., EDT)

        By default, date pads numeric fields  with  zeroes.   The  following  optional
        flags may follow '%':

        -      (hyphen) do not pad the field

        _      (underscore) pad with spaces

        0      (zero) pad with zeros

        ^      use upper case if possible

        #      use opposite case if possible

date显示和修改日期

.. code-block:: bash

  [root@mail ~]# date '+%Y-%m-%d %H:%M:%S'
  2017-11-06 09:15:34
  [root@mail ~]# date 120108022012.59
  Sat Dec  1 08:02:59 CST 2012
  [root@mail ~]# date '+%Y-%m-%d %H:%M:%S'
  2012-12-01 08:03:23

时钟的修改

.. code-block:: bash

  [root@mail ~]# hwclock --hctosys # hc to sys 硬件去修改系统
  [root@mail ~]# hwclock --systohc # sys to hc 系统去修改硬件

日历的查看

.. code-block:: bash

  [root@mail ~]# cal 
      November 2017   
  Su Mo Tu We Th Fr Sa
            1  2  3  4
  5  6  7  8  9 10 11
  12 13 14 15 16 17 18
  19 20 21 22 23 24 25
  26 27 28 29 30

  [root@mail ~]# cal 2016
                                2016                               

        January               February                 March       
  Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
                  1  2       1  2  3  4  5  6          1  2  3  4  5
  3  4  5  6  7  8  9    7  8  9 10 11 12 13    6  7  8  9 10 11 12
  10 11 12 13 14 15 16   14 15 16 17 18 19 20   13 14 15 16 17 18 19
  17 18 19 20 21 22 23   21 22 23 24 25 26 27   20 21 22 23 24 25 26
  24 25 26 27 28 29 30   28 29                  27 28 29 30 31
  31
          April                   May                   June        
  Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
                  1  2    1  2  3  4  5  6  7             1  2  3  4
  3  4  5  6  7  8  9    8  9 10 11 12 13 14    5  6  7  8  9 10 11
  10 11 12 13 14 15 16   15 16 17 18 19 20 21   12 13 14 15 16 17 18
  17 18 19 20 21 22 23   22 23 24 25 26 27 28   19 20 21 22 23 24 25
  24 25 26 27 28 29 30   29 30 31               26 27 28 29 30

          July                  August                September     
  Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
                  1  2       1  2  3  4  5  6                1  2  3
  3  4  5  6  7  8  9    7  8  9 10 11 12 13    4  5  6  7  8  9 10
  10 11 12 13 14 15 16   14 15 16 17 18 19 20   11 12 13 14 15 16 17
  17 18 19 20 21 22 23   21 22 23 24 25 26 27   18 19 20 21 22 23 24
  24 25 26 27 28 29 30   28 29 30 31            25 26 27 28 29 30
  31
        October               November               December      
  Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
                    1          1  2  3  4  5                1  2  3
  2  3  4  5  6  7  8    6  7  8  9 10 11 12    4  5  6  7  8  9 10
  9 10 11 12 13 14 15   13 14 15 16 17 18 19   11 12 13 14 15 16 17
  16 17 18 19 20 21 22   20 21 22 23 24 25 26   18 19 20 21 22 23 24
  23 24 25 26 27 28 29   27 28 29 30            25 26 27 28 29 30 31
  30 31


cd
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

  [root@mail ~]# cd /var/log    #change directory 切换到/var/log日志
  [root@mail log]# cd ~         #切换到家目录
  [root@mail ~]# pwd            #print workspace directory 打印工作目录
  /root
  [root@mail ~]# cd ~user1      #切换到user1的家目录，默认位置为/home/用户名
  [root@mail user1]# pwd        #打印目录
  /mnt/home/user1
  [root@mail user1]# cd -       #切换到上一个目录
  /root

相关环境变量

- PWD:保存当前目录路径
- OLDPWD:保存上一次目录的路径

ls
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

  NAME
        ls - list directory contents   列出目录的内容

  SYNOPSIS
        ls [OPTION]... [FILE]...

  DESCRIPTION
        List  information  about  the  FILEs (the current directory by default).  Sort
        entries alphabetically if none of -cftuvSUX nor --sort is specified.

        Mandatory arguments to long options are mandatory for short options too.

        -a, --all
                do not ignore entries starting with . 列出所有的， 包括隐藏文件

        -A, --almost-all
                do not list implied . and ..   列出所有文件， 不包括.和..这2个

        --author
                with -l, print the author of each file 列出作者

        -b, --escape
                print C-style escapes for nongraphic characters 打印非打印符号用c-style

        --block-size=SIZE
                scale sizes by SIZE before printing them; e.g., '--block-size=M' prints
                sizes in units of 1,048,576 bytes; see SIZE format below 指定大小单位

        -B, --ignore-backups
                do not list implied entries ending with ~  不列出结尾是~的条目

        -c     with  -lt:  sort by, and show, ctime (time of last modification of file
                status information); with -l: show ctime and sort by  name;  otherwise:
                sort by ctime, newest first

        -C     list entries by columns 列方式列出条目

        --color[=WHEN]
                colorize  the  output;  WHEN  can  be 'never', 'auto', or 'always' (the
                default); more info below 设置输出颜色

        -d, --directory
                list directories themselves, not their contents 列出目录自身

        -D, --dired
                generate output designed for Emacs' dired mode  列出emacs目录模式

        -f     do not sort, enable -aU, disable -ls --color 不做排序

        -F, --classify
                append indicator (one of */=>@|) to entries 在目录后面添加/

        --file-type
                likewise, except do not append '*'

        --format=WORD
                across -x, commas -m, horizontal -x, long -l, single-column -1, verbose
                -l, vertical -C

        --full-time
                like -l --time-style=full-iso

        -g     like -l, but do not list owner 不列出所有者

        --group-directories-first
                group directories before files; 先列目录，在列出文件

                can  be augmented with a --sort option, but any use of --sort=none (-U)
                disables grouping

        -G, --no-group
                in a long listing, don't print group names 不打印组名字

        -h, --human-readable   文件大小自动调整为合适单位
                with -l, print sizes in human readable format (e.g., 1K 234M 2G)

        --si   likewise, but use powers of 1000 not 1024 使用1000作为k,m的换算单位而不是1024

        -H, --dereference-command-line
                follow symbolic links listed on the command line 追踪符号连接

        --dereference-command-line-symlink-to-dir
                follow each command line symbolic link

                that points to a directory

        --hide=PATTERN
                do not list implied entries matching shell PATTERN (overridden by -a or
                -A) 不列出匹配的正则

        --indicator-style=WORD
                append  indicator with style WORD to entry names: none (default), slash
                (-p), file-type (--file-type), classify (-F)

        -i, --inode
                print the index number of each file 打印inode号

        -I, --ignore=PATTERN
                do not list implied entries matching shell PATTERN 不列出匹配的正则

        -k, --kibibytes
                default to 1024-byte blocks for disk usage

        -l     use a long listing format 使用长格式显示

        -L, --dereference
                when showing file information for a symbolic link, show information for
                the file the link references rather than for the link itself 符号链接，显示连接到的文件

        -m     fill width with a comma separated list of entries 条目逗号分割

        -n, --numeric-uid-gid
                like -l, but list numeric user and group IDs 类似-l，只是用户名和组使用数字，而不是名字

        -N, --literal
                print raw entry names (don't treat e.g. control characters specially)

        -o     like -l, but do not list group information   不列出组信息

        -p, --indicator-style=slash
                append / indicator to directories  追加/在目录后面

        -q, --hide-control-chars
                print ? instead of nongraphic characters   打印？而不是不可打印的符号

        --show-control-chars
                show  nongraphic  characters as-is (the default, unless program is 'ls'
                and output is a terminal)

        -Q, --quote-name
                enclose entry names in double quotes 双引号包住列出的条目

        --quoting-style=WORD
                use quoting  style  WORD  for  entry  names:  literal,  locale,  shell,
                shell-always, c, escape

        -r, --reverse
                reverse order while sorting 反向排序

        -R, --recursive
                list subdirectories recursively 递归列出子目录

        -s, --size
                print the allocated size of each file, in blocks 打印分配的大小

        -S     sort by file size 排序文件大小

        --sort=WORD
                sort  by WORD instead of name: none (-U), size (-S), time (-t), version
                (-v), extension (-X)

        --time=WORD
                with -l, show time as WORD instead of default modification time:  atime
                or  access or use (-u) ctime or status (-c); also use specified time as
                sort key if --sort=time

        --time-style=STYLE
                with -l, show times using style STYLE: full-iso, long-iso, iso, locale,
                or  +FORMAT;  FORMAT  is  interpreted like in 'date'; if FORMAT is FOR‐
                MAT1<newline>FORMAT2, then FORMAT1 applies to non-recent files and FOR‐
                MAT2  to  recent files; if STYLE is prefixed with 'posix-', STYLE takes
                effect only outside the POSIX locale

        -t     sort by modification time, newest first 排序按照mtime

        -T, --tabsize=COLS
                assume tab stops at each COLS instead of 8

        -u     with -lt: sort by, and show, access time; with -l: show access time and
                sort by name; otherwise: sort by access time

        -U     do not sort; list entries in directory order 按照目录的顺序累出

        -v     natural sort of (version) numbers within text

        -w, --width=COLS
                assume screen width instead of current value 指定宽度

        -x     list entries by lines instead of by columns

        -X     sort alphabetically by entry extension 按照扩展排序

        -1     list one file per line  每行列出一个文件

        SELinux options:

        --lcontext
                Display  security context.   Enable -l. Lines will probably be too wide
                for most displays.

        -Z, --context
                Display security context so it fits on most  displays.   Displays  only
                mode, user, group, security context and file name.

        --scontext
                Display only security context and file name.

        --help display this help and exit

        --version
                output version information and exit
              

ls -l列出的信息说明

.. code-block:: bash

        [root@mail ~]# ls -l 
        total 16
        -rw-r--r--.  1 root root  154 Sep 25 19:34 adduserbat.sh
        -：文件类型
        rw-r--r--：权限
        .：这个位置有3个值，".","+","-"三个值。
        1： 文件被硬连接的次数
        root:文件的owner
        root:文件的group
        154:文件的大小
        Sep 25 19:34： 文件最近修改的时间
        adduserbat.sh： 文件名字

文件类型有一下几类

- \-            普通文件
- d             目录文件
- b             块设备文件
- c             字符设备文件
- s             socket文件
- p             管道文件
- l             连接文件

cat
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash


  NAME
        cat - concatenate files and print on the standard output

  SYNOPSIS
        cat [OPTION]... [FILE]...

  DESCRIPTION
        Concatenate FILE(s), or standard input, to standard output.

        -A, --show-all
                equivalent to -vET 显示所有

        -b, --number-nonblank
                number nonempty output lines, overrides -n 编号非空行不编号

        -e     equivalent to -vE 

        -E, --show-ends
                display $ at end of each line 每行结尾追加一个$

        -n, --number
                number all output lines 每行添加一个行号

        -s, --squeeze-blank
                suppress repeated empty output lines  压缩重复的空行

        -t     equivalent to -vT

        -T, --show-tabs
                display TAB characters as ^I

        -u     (ignored)


echo 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

  NAME
        echo - display a line of text 显示一行文本

  SYNOPSIS
        echo [SHORT-OPTION]... [STRING]...
        echo LONG-OPTION

  DESCRIPTION
        Echo the STRING(s) to standard output.

        -n     do not output the trailing newline 不显示自动换行

        -e     enable interpretation of backslash escapes 启动转义符

        -E     disable interpretation of backslash escapes (default) 关闭转义符

        --help display this help and exit

        --version
                output version information and exit

        If -e is in effect, the following sequences are recognized:

        \\     backslash  打印\

        \a     alert (BEL) 警钟声音

        \b     backspace 删除一个字符

        \c     produce no further output

        \e     escape 

        \f     form feed

        \n     new line 新行

        \r     carriage return 回车符

        \t     horizontal tab 制表符

        \v     vertical tab  水平制表符


echo 打印颜色符号

.. code-block:: bash

  [root@mail ~]# echo -e "\033[34mOk\033[0m"
  Ok(这个字体是带颜色的)

颜色控制

.. code-block:: bash

  \033[##m:控制颜色
  第一个#：控制字体的前景色
  第二个#：控制字体的背景色
  如果同时使用前景和背景色：\033[3#:4#m
  \033[0m：关闭字体功能

which 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

  [root@mail ~]# which ls
  alias ls='ls --color=auto'
    /usr/bin/ls
  [root@mail ~]# which ls --skip-alias
  /usr/bin/ls

whatis
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

  [root@mail ~]# whatis ls
  ls (1)               - list directory contents
  ls (1p)              - list directory contents

  #centos6:makewhat命令创建帮助手册和对应关键字的数据库
  #cnetos7:mandb