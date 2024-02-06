
.. _server-linux-zabbix-rpminstall:

======================================================================================================================================================
zabbix rpm安装
======================================================================================================================================================

环境
======================================================================================================================================================

服务器系统环境：
    系统：
        CentOS6.6 64位
    内核：
        2.6.32
    主机名：
        zzjlogin


.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# hostname
    zzjlogin
    [root@zzjlogin ~]# uname -a
    Linux zzjlogin 2.6.32-504.el6.x86_64 #1 SMP Wed Oct 15 04:27:16 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
    [root@zzjlogin ~]# uname -r
    2.6.32-504.el6.x86_64
    [root@zzjlogin ~]# cat /etc/redhat-release
    CentOS release 6.6 (Final)

    [root@zzjlogin ~]# cat /proc/version
    Linux version 2.6.32-504.el6.x86_64 (mockbuild@c6b9.bsys.dev.centos.org) (gcc version 4.4.7 20120313 (Red Hat 4.4.7-11) (GCC) ) #1 SMP Wed Oct 15 04:27:16 UTC 2014

zabbix软件：
    zabbix版本：3.4.14

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# rpm -qa zabbix*
    zabbix-server-mysql-3.4.14-1.el6.x86_64
    zabbix-release-3.4-1.el6.noarch
    zabbix-web-3.4.14-1.el6.noarch
    zabbix-agent-3.4.14-1.el6.x86_64
    zabbix-web-mysql-3.4.14-1.el6.noarch


客户端：



zabbix安装前准备
======================================================================================================================================================

官方4.0LST rpm安装方法：
    https://www.zabbix.com/documentation/4.0/zh/manual/installation/install_from_packages/rhel_centos

zabbix安装参考:
    - zabbix3.4官方文档：https://www.zabbix.com/documentation/3.4/zh/start
    - zabbix官方下载地址：https://www.zabbix.com/download

需要使用的链接:
    - http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/
    - http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/
    - https://sourceforge.net/projects/zabbix/files/

需要的软件包：
    yum的方式安装rpm软件包，yum会自动解决软件包依赖问题。但是httpd服务软件和mysql数据库软件需要手动先安装。
    
网络时间同步
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    如果时间没有和网络同步，yum安装会报错。
    
    参考:
        :ref:`linux-yuminstallerr-time`

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# date
    Thu Sep  6 21:07:25 CST 2018
    [root@zzjlogin ~]# ntpdate pool.ntp.org
    28 Sep 00:53:38 ntpdate[1577]: step time server 5.103.139.163 offset 1827966.915121 sec


关闭selinux
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    如果不关闭selinux也没有配置selinux。则安装以后zabbix会启动失败。会发现zabbix网页可以访问，但是提示zabbix服务没有启动。

**永久关闭:**
    下面配置会让selinux的关闭重启系统后还是关闭状态。但是配置不会立即生效。

.. attention::
    通过 ``source /etc/selinux/config`` 也不能让修改的文件立即生效。所以需要下面的临时关闭的方式结合使用。

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    [root@zzjlogin ~]# grep SELINUX /etc/selinux/config
    # SELINUX= can take one of these three values:
    SELINUX=disabled
    # SELINUXTYPE= can take one of these two values:
    SELINUXTYPE=targeted

**临时关闭：**
    下面配置是立即生效，但是系统重启后会失效。

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# getenforce
    Enforcing
    [root@zzjlogin ~]# setenforce 0
    [root@zzjlogin ~]# getenforce
    Permissive




关闭防火墙
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    防火墙一般都是关闭。如果不不关闭，也可以通过配置规则允许所有使用的端口被访问。

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /etc/init.d/iptables stop 
    iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
    iptables: Flushing firewall rules:                         [  OK  ]
    iptables: Unloading modules:                               [  OK  ]

关闭防火墙开机自启动

.. code-block:: bash
    :linenos:
    
    [root@zzjlogin ~]# chkconfig iptables off


系统准备命令集合
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    ntpdate pool.ntp.org
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    /etc/init.d/iptables stop 
    chkconfig iptables off

.. attention::
    时间同步最好加入到定时任务。这样保证以后时间如果有错误的时候会自动更正。
    	- ``echo "#time sysc by myhome at 2018-03-30" >>/var/spool/cron/root``
        - ``echo "*/5 * * * * /usr/sbin/ntpdate pool.ntp.org >/dev/null 2&1" >>/var/spool/cron/root``


LAMP安装
------------------------------------------------------------------------------------------------------------------------------------------------------

安装apache、php组件以及MySQL：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
    [root@zzjlogin ~]# yum install php56w php56w-gd php56w-mysql php56w-bcmath php56w-bcmath php56w-mbstring php56w-xml php56w-ldap -y

    [root@zzjlogin ~]# yum install mysql-devel mysql-server -y


检查安装结果：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# rpm -qa mysql*
    mysql-5.1.73-8.el6_8.x86_64
    mysql-libs-5.1.73-8.el6_8.x86_64
    mysql-devel-5.1.73-8.el6_8.x86_64
    mysql-server-5.1.73-8.el6_8.x86_64
    [root@zzjlogin ~]# rpm -qa php httpd
    httpd-2.2.15-69.el6.centos.x86_64
    [root@zzjlogin ~]# rpm -qa php*
    php56w-5.6.38-1.w6.x86_64
    php56w-bcmath-5.6.38-1.w6.x86_64
    php56w-cli-5.6.38-1.w6.x86_64
    php56w-gd-5.6.38-1.w6.x86_64
    php56w-mysql-5.6.38-1.w6.x86_64
    php56w-ldap-5.6.38-1.w6.x86_64
    php56w-pdo-5.6.38-1.w6.x86_64
    php56w-xml-5.6.38-1.w6.x86_64
    php56w-mbstring-5.6.38-1.w6.x86_64
    php56w-common-5.6.38-1.w6.x86_64

配置PHP
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    如果没有配置php下面信息。在配置完所有设置后。启动zabbix服务器，进行网页设置的时候会提示错误。提示页面会提示下面这些选项需要配置。


配置php配置文件：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# sed -i 's#;date.timezone =#date.timezone = Asia/Shanghai#g' /etc/php.ini
    [root@zzjlogin ~]# sed -i 's#post_max_size = 8M#post_max_size = 32M#g' /etc/php.ini
    [root@zzjlogin ~]# sed -i 's#max_execution_time = 30#max_execution_time = 300#g' /etc/php.ini
    [root@zzjlogin ~]# sed -i 's#max_input_time = 60#max_input_time = 300#g' /etc/php.ini
    [root@zzjlogin ~]# sed -i 's#;always_populate_raw_post_data = -1#always_populate_raw_post_data = -1#g' /etc/php.ini


zabbix安装配置
======================================================================================================================================================


安装zabbix
------------------------------------------------------------------------------------------------------------------------------------------------------

1. 安装zabbix官方源：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
    Retrieving http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
    Preparing...                ########################################### [100%]
        1:zabbix-release         ########################################### [100%]

2. 安装zabbix软件包：

.. attention::
    zabbix服务器也需要被监控，所以服务器端也安装zabbix客户端。

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent -y


3. 把zabbix前端显示的页面放在apache网站目录：

.. code-block:: bash
    :linenos:

    [root@zzjlogin zabbix]# cd /usr/share/zabbix
    [root@zzjlogin zabbix]# pwd
    /usr/share/zabbix
    [root@zzjlogin zabbix]# cp -ra * /var/www/html/




配置数据库
------------------------------------------------------------------------------------------------------------------------------------------------------

1. mysql数据库启动创建密码


启动数据库，并配置密码:


.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /etc/init.d/mysqld start

    [root@zzjlogin ~]# /usr/bin/mysqladmin -u root password '123'



2. 登陆数据库，清理空账号信息，创建zabbix数据库，并创建授权访问数据库的用户：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# mysql -uroot -p
    Enter password: 
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 3
    Server version: 5.1.73 Source distribution

    Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights reserved.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql> use mysql;
    Reading table information for completion of table and column names
    You can turn off this feature to get a quicker startup with -A

    Database changed
    mysql> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    | test               |
    +--------------------+
    3 rows in set (0.00 sec)

    mysql> select user,host from user;
    +------+-----------+
    | user | host      |
    +------+-----------+
    | root | 127.0.0.1 |
    |      | localhost |
    | root | localhost |
    |      | zzjlogin  |
    | root | zzjlogin  |
    +------+-----------+
    5 rows in set (0.00 sec)

    mysql> drop user ""@"localhost";
    Query OK, 0 rows affected (0.00 sec)

    mysql> drop user ""@"zzjlogin";
    Query OK, 0 rows affected (0.00 sec)

    mysql> drop user "root"@"zzjlogin";
    Query OK, 0 rows affected (0.00 sec)

    mysql> select user,host from user;
    +------+-----------+
    | user | host      |
    +------+-----------+
    | root | 127.0.0.1 |
    | root | localhost |
    +------+-----------+
    2 rows in set (0.00 sec)

    mysql> select user,host,password from user;
    +------+-----------+-------------------------------------------+
    | user | host      | password                                  |
    +------+-----------+-------------------------------------------+
    | root | localhost | *23AE809DDACAF96AF0FD78ED04B6A265E05AA257 |
    | root | 127.0.0.1 |                                           |
    +------+-----------+-------------------------------------------+
    2 rows in set (0.00 sec)

    mysql> update user set password=password("123") where user="root" and host="127.0.0.1";
    Query OK, 1 row affected (0.01 sec)
    Rows matched: 1  Changed: 1  Warnings: 0

    mysql> select user,host,password from user;                                            
    +------+-----------+-------------------------------------------+
    | user | host      | password                                  |
    +------+-----------+-------------------------------------------+
    | root | localhost | *23AE809DDACAF96AF0FD78ED04B6A265E05AA257 |
    | root | 127.0.0.1 | *23AE809DDACAF96AF0FD78ED04B6A265E05AA257 |
    +------+-----------+-------------------------------------------+
    2 rows in set (0.00 sec)

    mysql> create database zabbix;
    Query OK, 1 row affected (0.00 sec)

    mysql> show databases;            
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    | test               |
    | zabbix             |
    +--------------------+
    4 rows in set (0.00 sec)

    mysql> grant all privileges on zabbix.* to zabbix@localhost identified by 'password';
    Query OK, 0 rows affected (0.00 sec)

    mysql> exit
    Bye




.. tip::
    - mysql数据库授权zabbix用户的时候的访问IP ``localhost`` 是本地主机。此时只能通过localhost来登陆，不能通过127.0.0.1登陆，也不能通过系统IP登陆。
    - 如果mysql授权访问用户通过IP访问需要授权方式是:grant all privileges on zabbix.* to zabbix@192.168.161.132 identified by 'password';

.. attention::
    这些表信息是zabbix已经提供的，直接导入即可，如果不导入数据库，是不能访问zabbix的。


3. zabbix数据库文件导入MySQL数据库：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# cd /usr/share/doc/zabbix-server-mysql-3.4.14/
    [root@zzjlogin zabbix-server-mysql-3.4.14]# ls
    AUTHORS  ChangeLog  COPYING  create.sql.gz  NEWS  README
    [root@zzjlogin zabbix-server-mysql-3.4.14]# zcat create.sql.gz | mysql -uroot -p123 zabbix



4. 修改zabbix服务器配置信息:

.. code-block:: bash
    :linenos:

    [root@zzjlogin zabbix-3.4.13]# vim /etc/zabbix/zabbix_server.conf

    DBHost=localhost  数据库ip地址
    DBName=zabbix
    DBUser=zabbix
    DBPassword=password
    ListenIP=192.168.161.132        #zabbix server ip地址

    

5. zabbix服务器启动

zabbix服务器启动需要先启动MySQL和httpd(apache/nginx)

启动mysql数据库:

.. code-block:: bash
    :linenos:

    [root@zzjlogin zabbix-3.4.13]# /etc/init.d/mysqld start

启动httpd服务:

.. code-block:: bash
    :linenos:

    [root@zzjlogin zabbix-3.4.13]# /etc/init.d/httpd start

启动zabbix服务器的zabbix客户端:

.. code-block:: bash
    :linenos:

    [root@zzjlogin zabbix-server-mysql-3.4.14]# /etc/init.d/zabbix-agent start
    Starting Zabbix agent:                                     [  OK  ]

启动zabbix服务器的zabix服务端软件：

.. code-block:: bash
    :linenos:

    [root@zzjlogin zabbix-server-mysql-3.4.14]# /etc/init.d/zabbix-server start
    Starting Zabbix server:                                    [  OK  ]




6. 查看服务器是否启动

.. code-block:: bash
    :linenos:

    [root@zzjlogin zabbix-server-mysql-3.4.14]# ss -lntu
    Netid State      Recv-Q Send-Q                          Local Address:Port                            Peer Address:Port 
    udp   UNCONN     0      0                                           *:68                                         *:*     
    tcp   LISTEN     0      128                                        :::22                                        :::*     
    tcp   LISTEN     0      128                                         *:22                                         *:*     
    tcp   LISTEN     0      100                                       ::1:25                                        :::*     
    tcp   LISTEN     0      100                                 127.0.0.1:25                                         *:*     
    tcp   LISTEN     0      128                                        :::10050                                     :::*     
    tcp   LISTEN     0      128                                         *:10050                                      *:*     
    tcp   LISTEN     0      128                           192.168.161.132:10051                                      *:*     
    tcp   LISTEN     0      50                                          *:3306                                       *:*     
    tcp   LISTEN     0      128                                        :::80                                        :::*     
    [root@zzjlogin zabbix-server-mysql-3.4.14]# 

至此zabbix可以访问。然后通过浏览器输入zabbix服务器IP地址，然后通过网页配置zabbix即可。


开机自启动
------------------------------------------------------------------------------------------------------------------------------------------------------

方法1：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# chkconfig httpd on
    [root@zzjlogin ~]# chkconfig mysqld on
    [root@zzjlogin ~]# chkconfig zabbix-agent on
    [root@zzjlogin ~]# chkconfig zabbix-server on

方法2：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# echo "/etc/init.d/mysqld start" >>/etc/rc.local
    [root@zzjlogin ~]# echo "/etc/init.d/httpd start" >>/etc/rc.local
    [root@zzjlogin ~]# echo "/etc/init.d/zabbix-agent start" >>/etc/rc.local
    [root@zzjlogin ~]# echo "/etc/init.d/zabbix-server start" >>/etc/rc.local


zabbix服务器安装配置命令集合
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: bash
    :linenos:

    ntpdate pool.ntp.org
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    getenforce
    /etc/init.d/iptables stop
    chkconfig iptables off
    rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
    yum install php56w php56w-gd php56w-mysql php56w-bcmath php56w-bcmath php56w-mbstring php56w-xml php56w-ldap -y
    yum install mysql-devel mysql-server -y

    sed -i 's#;date.timezone =#date.timezone = Asia/Shanghai#g' /etc/php.ini
    sed -i 's#post_max_size = 8M#post_max_size = 32M#g' /etc/php.ini
    sed -i 's#max_execution_time = 30#max_execution_time = 300#g' /etc/php.ini
    sed -i 's#max_input_time = 60#max_input_time = 300#g' /etc/php.ini
    sed -i 's#;always_populate_raw_post_data = -1#always_populate_raw_post_data = -1#g' /etc/php.ini

    yum install zabbix-get -y
    rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
    yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent -y
    cd /usr/share/zabbix
    cp -ra * /var/www/html/
    
    /etc/init.d/mysqld start
    /usr/bin/mysqladmin -u root password '123'
    mysql -uroot -p

    use mysql;
    drop user ""@"localhost";
    drop user ""@"zzjlogin";
    drop user "root"@"zzjlogin";
    use mysql;
    update user set password=password("123") where user="root" and host="127.0.0.1";
    create database zabbix;
    grant all privileges on zabbix.* to zabbix@localhost identified by 'password';
    grant all privileges on zabbix.* to zabbix@192.168.161.132 identified by 'password';
    flush privileges;
    exit
    cd /usr/share/doc/zabbix-server-mysql-*
    zcat create.sql.gz | mysql -uroot -p123 zabbix

    sed -i 's/# DBHost=localhost/DBHost=192.168.161.132/g' /etc/zabbix/zabbix_server.conf
    sed -i 's/# DBPassword=/DBPassword=password/g' /etc/zabbix/zabbix_server.conf
    sed -i 's/# ListenIP=127.0.0.1/# ListenIP=192.168.161.132/g' /etc/zabbix/zabbix_server.conf
    
    
    
    sed -i "277i ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf

    /etc/init.d/mysqld start
    /etc/init.d/httpd start
    /etc/init.d/zabbix-agent start
    /etc/init.d/zabbix-server start

    echo "/etc/init.d/mysqld start" >>/etc/rc.local
    echo "/etc/init.d/httpd start" >>/etc/rc.local
    echo "/etc/init.d/zabbix-agent start" >>/etc/rc.local
    echo "/etc/init.d/zabbix-server start" >>/etc/rc.local


图形安装配置
======================================================================================================================================================


.. image:: /Server/res/images/server/linux/zabbix-install/zabbix001.png
    :align: center
    :height: 400 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-install/zabbix002.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-install/zabbix003.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-install/zabbix004.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-install/zabbix005.png
    :align: center
    :height: 400 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-install/zabbix006.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-install/zabbix007.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-install/zabbix008.png
    :align: center
    :height: 400 px
    :width: 800 px



监控服务器自己
======================================================================================================================================================


.. image:: /Server/res/images/server/linux/zabbix-config/zabbix-config001.png
    :align: center
    :height: 450 px
    :width: 800 px




zabbix客户端安装配置
======================================================================================================================================================


客户端环境：
    - 系统： 和服务器端一致(可以不一致)
    - 客户端软件: 


.. code-block:: bash
    :linenos:

    [root@client ~]# rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
    Retrieving https://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
    Preparing...                ########################################### [100%]
    1:zabbix-release         ########################################### [100%]

    [root@client ~]# yum install zabbix-agent -y
    Loaded plugins: fastestmirror, security
    Setting up Install Process
    Loading mirror speeds from cached hostfile
    * base: mirror.bit.edu.cn
    * extras: mirror.bit.edu.cn
    * updates: mirrors.tuna.tsinghua.edu.cn
    Resolving Dependencies
    --> Running transaction check
    ---> Package zabbix-agent.x86_64 0:3.4.14-1.el6 will be installed
    --> Finished Dependency Resolution

    Dependencies Resolved

    =========================================================================================================================
    Package                        Arch                     Version                          Repository                Size
    =========================================================================================================================
    Installing:
    zabbix-agent                   x86_64                   3.4.14-1.el6                     zabbix                   362 k

    Transaction Summary
    =========================================================================================================================
    Install       1 Package(s)

    Total size: 362 k
    Installed size: 1.4 M
    Downloading Packages:
    warning: rpmts_HdrFromFdno: Header V4 RSA/SHA512 Signature, key ID a14fe591: NOKEY
    Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
    Importing GPG key 0xA14FE591:
    Userid : Zabbix LLC <packager@zabbix.com>
    Package: zabbix-release-3.4-1.el6.noarch (installed)
    From   : /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
    Running rpm_check_debug
    Running Transaction Test
    Transaction Test Succeeded
    Running Transaction
    Warning: RPMDB altered outside of yum.
    Installing : zabbix-agent-3.4.14-1.el6.x86_64                                                                      1/1 
    Verifying  : zabbix-agent-3.4.14-1.el6.x86_64                                                                      1/1 

    Installed:
    zabbix-agent.x86_64 0:3.4.14-1.el6                                                                                     

    Complete!

客户端配置：

.. code-block:: bash
    :linenos:

    [root@client ~]# cp -a /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.`date '+%F'`
    [root@client ~]# sed -ir 's#^Server=127.0.0.1#Server=192.168.161.132#g' /etc/zabbix/zabbix_agentd.conf
    [root@client ~]# grep "Server=192.168.161.132" /etc/zabbix/zabbix_agentd.conf
    Server=192.168.161.132

.. attention::
    如果配置客户端主动向zabbix服务器注册需要添加： ``sed -ir 's#^ServerActive=127.0.0.1#ServerActive=192.168.161.132#g' /etc/zabbix/zabbix_agentd.conf``
    zabbix服务器也需要添加对应的action。
    
启动客户端：

.. code-block:: bash
    :linenos:

    [root@client ~]# /etc/init.d/zabbix-agent start
    Starting Zabbix agent:                                     [  OK  ]

开机自启动zabbix客户端：

方法1：

.. code-block:: bash
    :linenos:

    [root@client ~]# chkconfig zabbix-agent on

方法2：


.. code-block:: bash
    :linenos:

    [root@client ~]# echo '############################' >>/etc/rc.local
    [root@client ~]# echo '#add by zzj at 20180930' >>/etc/rc.local
    [root@client ~]# echo '/etc/init.d/zabbix-agent start' >>/etc/rc.local

zabbix客户端安装配置命令集合
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: bash
    :linenos:

    rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
    yum install zabbix-agent -y
    cp -a /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.`date '+%F'`

    sed -ir 's#^Server=127.0.0.1#Server=192.168.161.132#g' /etc/zabbix/zabbix_agentd.conf
    grep "Server=192.168.161.132" /etc/zabbix/zabbix_agentd.conf

    /etc/init.d/zabbix-agent start
    echo '############################' >>/etc/rc.local
    echo '#add by zzj at 20180930' >>/etc/rc.local
    echo '/etc/init.d/zabbix-agent start' >>/etc/rc.local



