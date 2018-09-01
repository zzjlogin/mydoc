LINUX上bash的基础特性(二)
====================================================

命令别名
--------------------------------------------------------------

alias cdnet="cd /etc/sysconfig/network-scripts"

针对用户的别名： "~/.bashrc"

针对系统的别名："/etc/bashrc"

重读配置文件:source /path/to/config.file

unalias:撤销别名

glob通配
------------------------------------------------------

- \* 代表任意长度的任意字符
- ？： 表示任意单个字符
- []:匹配指定范围的任意的单个字符
- [^]:取反
- [alnum]:所有字母和数字
- [:alpha:]：字母
- [:digit:]:数字
- [:lower:]:小写字母
- [:upper:]:大写字母
- [:punct:]:标点符号
- [:space:]:空白字符，不是仅仅空格

bash快捷键盘
-----------------------------------------------------

- ctrl+L:
- ctrl+a:
- ctrl+e:
- ctrl+u:
- ctrl+k:

bash i/o重定向
-------------------------------------------------------

- >
- >>:
- 2>
- 2>>
- > a.txt 2 > &1
- >>a.txt 2>> &1

tr 

.. code-block:: bash

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
---------------------------------------------------

wc
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-l              行数
-c              字符数量
-w              单词个数

cut
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-d              分割符号
-f              提取

sort
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-f              忽略大小写
-k              指定字段排序
-t              分割
-n              数字排序
-u              去重连续的重复
-r              逆序

uniq
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-c              显示重复的次数
-d              只显示重复的行
-u              只显示不重复的行




