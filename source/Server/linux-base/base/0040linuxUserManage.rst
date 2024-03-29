.. _zzjlogin-usermanage:

======================================================================================================================================================
linux用户和组管理
======================================================================================================================================================

:Date: 2018-09-02

.. contents::

用户分类

- 系统用户:
    1-499(centos6),1-999(centos7)
- 登陆用户：
    500+（centos6）,1000+(centos7)

.. hint:: 用户ID为0的账号是系统管理员。默认root的用户ID是0


.. tip::
    系统增加一个用户，默认的变化是:
        - ``/etc/passwd`` 文件中追加一行用户信息
        - ``/etc/shadow`` 文件中追加创建用户的密码信息
        - ``/etc/group`` 文件中追加一行用户组信息
        - ``/etc/gshadow`` 文件中追加一行用户组密码信息

        - 默认会在/home/目录下创建一个和用户名相同的文件目录
        - 会把目录/etc/skel/下的三个文件( ``.bash_logout`` 、 ``.bash_profile`` 、 ``.bashrc`` )复制到创建用户的家目录。



主要配置文件分析
======================================================================================================================================================

/etc/passwd
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: text
    :linenos:

    name:password:uid:gid:geocos:homedir:shell

.. code-block:: bash
    :linenos:

    [root@centos6 ~]# head -1 /etc/passwd
    root:x:0:0:root:/root:/bin/bash

.. attention::
    - 如果/etc/passwd文件用冒号分割的第二列为空，则这个用户没有设置密码。可以通过这样手动设置，来设置用户登录不用密码。(和免密钥登录不一样)
        1. 第一个字段root是用户名为root
        #. 第二个x，是root用户登录需要密码。
        #. root的用户id是0。
        #. root的组ID，(一个用户可以有多个组，这是主组ID)。
        #. /root是用户root的家目录。默认普通用户在/home/username，这个username是对应的用户名。
        #. /bin/bash是用户登录系统时使用的shell类型。


/etc/group
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: text
    :linenos:

    groupname:password:gid:userlist

.. code-block:: bash
    :linenos:

    [root@centos6 ~]# head -1 /etc/group
    root:x:0:

/etc/shadow
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: text
    :linenos:

    name:password: date of last password change : minimum password age : maximum password age : password warning period: password warning period: password inactivity period

.. code-block:: bash

    [root@zzjlogin ~]# tail -n 1 /etc/shadow
    zzjlogin:$6$Ja8cr1kv$.B64B7jS2ypx5ZHKVkgaxWJU/sAtp5AGJzt2YOFWlfzv9KKoyOv9DhzRzH76I./1wLH4zSi/vcSR7X0/sNi7x0:17639:0:99999:7:::

.. attention::

    创建的新用户，默认有效期为10年。提前7天提醒用户修改密码。

    其中shadow中存放的密码密文格式如下：$id$salt$encrypted

    其中id是指使用的哈希算法：

    可取如下值：
    
    ======== ================================================
        ID   Method
    ======== ================================================
        1    MD5
    -------- ------------------------------------------------
        2a   Blowfish (not in mainline glibc; added in some
             Linux distributions)
    -------- ------------------------------------------------
        5    SHA-256 (since glibc 2.7)
    -------- ------------------------------------------------
        6    SHA-512 (since glibc 2.7)
    ======== ================================================

    salt：是使用上面hash算法对密码进行hash的一个干扰值。

    encrypted: 这个值即 密码的hash, 但不是直接的hash("passwd")，而是hash("passwd＋salt")后，再经过编码。

- 用户名
- 加密密码
- 上次修改的密码
- 最小使用时间
- 最大使用时间
- 密码警告时间
- 密码禁用期
- 账户过期日期
- 保留字段

用户管理命令
======================================================================================================================================================

useradd
------------------------------------------------------------------------------------------------------------------------------------------------------

新建/增加一个用户

-u              指定用户id
-g              基本组
-G              附加组
-c              注释信息
-s              shell类型
-d              用户的家目录
-r              系统用户

groupadd
------------------------------------------------------------------------------------------------------------------------------------------------------

增加/新建一个组

-g              组id
-r              系统用户

id

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# id
    uid=0(root) gid=0(root) groups=0(root) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
    [root@centos6 ~]# id -u 
    0
    [root@centos6 ~]# id -g
    0
    [root@centos6 ~]# id -G
    0
    [root@centos6 ~]# id -un
    root

su 
------------------------------------------------------------------------------------------------------------------------------------------------------

- su username: 非登录切换，不会读取目标用户的配置文件
- su -username:登陆切换，会读取目标用户配置文件，完全切换

.. attention::
    用户切换一般都用 ``su -`` ，这样是为了把环境变量也切换到对应的用户的环境变量。

usermod
------------------------------------------------------------------------------------------------------------------------------------------------------

修改用户的基本信息

-g              主组        
-G              附加组
-u              用户名
-s              shell
-c              注释
-d              家目录
-l              新的登陆名
-L              锁定
-U              解锁
-e              指定过期日期
-f              指定非活动期限

passwd
------------------------------------------------------------------------------------------------------------------------------------------------------

为指定用户修改/创建密码(默认为当前登录用户)

-l              锁定用户
-u              解锁
-n              最短期限
-x              最大期限
-w              警告期限
-i              非活动期限
--stdin         接受终端输入

userdel
------------------------------------------------------------------------------------------------------------------------------------------------------

删除用户

-r          删除用户家目录

groupdel
------------------------------------------------------------------------------------------------------------------------------------------------------

删除用户组

groupmod
------------------------------------------------------------------------------------------------------------------------------------------------------

修改用户组信息

-n              新名字
-g              新的id

gpasswd
------------------------------------------------------------------------------------------------------------------------------------------------------

修改/新增用户组密码

-a              添加到指定的组
-d              从指定组删除
-A              设置用户列表

newgrp
------------------------------------------------------------------------------------------------------------------------------------------------------

用户临时切换基本组

chage
------------------------------------------------------------------------------------------------------------------------------------------------------

-d              修改用户最近一次修改时间
-I              修改用户的非活动期限
-E              过期日期

sudo
------------------------------------------------------------------------------------------------------------------------------------------------------

-l              查看用户可以执行的sudo
-k              清除下的令牌时间戳
-u              以指定用户运行命令

配置文件是/etc/sudoers

账号 登陆这来源主机名=可切换的身份） 命令

注意事项

- ALL大写
- 命令使用全路径
- 组使用%
- 别名 User_Alias User1 = magedu,centos,test



用户权限管理
======================================================================================================================================================

默认Linux系统新增一个用户，这个新增用户的用户权限是普通用户。

普通用户的用户权限一般都比较小。运行命令一般需要sudo来运行，但是此时这些命令需要已经配置允许这些用户运行才可以。
所以不是所有命令都是sudo可以运行。只有在配置文件中配置允许sudo来运行的命令才可以通过sodu运行。

.. hint:: sodu运行命令，提示输入密码，这个密码是普通用户自己的密码(不是root密码)


.. attention:: 如果把普通用户的用户id修改为0，则这个普通用户也是超级管理员。但是一般很少有这样做的。


/etc/sudoers配置
------------------------------------------------------------------------------------------------------------------------------------------------------


root用户编辑/etc/sudoers文件,添加要分配的普通用户记录,其中有这么一行记录：root ALL=(ALL) ALL,在这行后面添加：Sam ALL=(ALL) ALL







