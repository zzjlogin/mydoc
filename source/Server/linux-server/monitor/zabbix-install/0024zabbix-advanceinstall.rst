.. _server-linux-zabbix-advanceinstall:

======================================================================================================================================================
zabbix 分布式安装
======================================================================================================================================================

zabbix server的模式：
    - server：即zabbix服务器，如果是分布式部署的时候可以被叫做master
    - nodes：这种模式在zabbix2.x以及之前的版本有，在zaibbix3.X及以后版本都被proxy取代。没有nodes了。
    - proxy：及监控代理模式，可以有效减轻zabbix server的压力(主要是io压力)

参考：
    proxy支持的各种功能：https://www.zabbix.com/documentation/3.4/zh/manual/distributed_monitoring/proxies
    nodes支持的各种功能：https://www.zabbix.com/documentation/2.0/manual/distributed_monitoring/nodes

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

    [root@proxy ~]# hostname
    proxy
    [root@proxy ~]# uname -a
    Linux proxy 2.6.32-504.el6.x86_64 #1 SMP Wed Oct 15 04:27:16 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
    [root@proxy ~]# uname -r
    2.6.32-504.el6.x86_64
    [root@proxy ~]# cat /etc/redhat-release
    CentOS release 6.6 (Final)

    [root@proxy ~]# cat /proc/version
    Linux version 2.6.32-504.el6.x86_64 (mockbuild@c6b9.bsys.dev.centos.org) (gcc version 4.4.7 20120313 (Red Hat 4.4.7-11) (GCC) ) #1 SMP Wed Oct 15 04:27:16 UTC 2014

zabbix软件：
    zabbix版本：3.4.14

.. code-block:: bash
    :linenos:

    [root@proxy ~]# rpm -qa zabbix*
    zabbix-server-mysql-3.4.14-1.el6.x86_64
    zabbix-release-3.4-1.el6.noarch
    zabbix-web-3.4.14-1.el6.noarch
    zabbix-agent-3.4.14-1.el6.x86_64
    zabbix-web-mysql-3.4.14-1.el6.noarch

代理服务环境：
    和服务器系统以及软件完全一致

    软件环境是：
        - zabbix-proxy-mysql-3.4.14-1.el6.x86_64
        - zabbix-release-3.4-1.el6.noarch
        - zabbix-agent-3.4.14-1.el6.x86_64
        - proxy的MySQL也是用本地的yum安装的mysql-server




主服务器安装(zabbix server/master)
======================================================================================================================================================

参考：
    - :ref:`server-linux-zabbix-rpminstall`
    - :ref:`server-linux-zabbix-sourceinstall`


代理服务器安装(zabbix proxy)
======================================================================================================================================================

监控代理的部署，一般是在一个服务区域子网可以配置一台监控代理服务器。


.. attention::
    - 触发器计算（Calculating triggers）不支持
    - 处理事件（Processing events）不支持
    - 发送报警（Sending alerts）不支持
    - 远程命令（Remote commands）不支持

.. note::
    zabbix proxy 数据库必须和 server 分开,否则数据会被破坏。

代理服务安装配置
------------------------------------------------------------------------------------------------------------------------------------------------------

网络时间同步
......................................................................................................................................................

.. attention::
    如果时间没有和网络同步，yum安装会报错。
    
    参考:
        :ref:`linux-yuminstallerr-time`

.. code-block:: bash
    :linenos:

    [root@proxy ~]# date
    Thu Sep  6 21:07:25 CST 2018
    [root@proxy ~]# ntpdate pool.ntp.org
    28 Sep 00:53:38 ntpdate[1577]: step time server 5.103.139.163 offset 1827966.915121 sec


关闭selinux
......................................................................................................................................................

.. attention::
    如果不关闭selinux也没有配置selinux。则安装以后zabbix会启动失败。会发现zabbix网页可以访问，但是提示zabbix服务没有启动。

**永久关闭:**
    下面配置会让selinux的关闭重启系统后还是关闭状态。但是配置不会立即生效。

.. attention::
    通过 ``source /etc/selinux/config`` 也不能让修改的文件立即生效。所以需要下面的临时关闭的方式结合使用。

.. code-block:: bash
    :linenos:

    [root@proxy ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    [root@proxy ~]# grep SELINUX /etc/selinux/config
    # SELINUX= can take one of these three values:
    SELINUX=disabled
    # SELINUXTYPE= can take one of these two values:
    SELINUXTYPE=targeted

**临时关闭：**
    下面配置是立即生效，但是系统重启后会失效。

.. code-block:: bash
    :linenos:

    [root@proxy ~]# getenforce
    Enforcing
    [root@proxy ~]# setenforce 0
    [root@proxy ~]# getenforce
    Permissive




关闭防火墙
......................................................................................................................................................

.. attention::
    防火墙一般都是关闭。如果不不关闭，也可以通过配置规则允许所有使用的端口被访问。

.. code-block:: bash
    :linenos:

    [root@proxy ~]# /etc/init.d/iptables stop 
    iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
    iptables: Flushing firewall rules:                         [  OK  ]
    iptables: Unloading modules:                               [  OK  ]

安装zabbix官方源
......................................................................................................................................................

.. code-block:: bash
    :linenos:

    [root@proxy ~]# rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
    Retrieving http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
    Preparing...                ########################################### [100%]
        1:zabbix-release         ########################################### [100%]

安装zabbix-proxy、zabbix-agent
......................................................................................................................................................

.. code-block:: bash
    :linenos:

    [root@proxy ~]# yum install zabbix-proxy-mysql
    [root@proxy ~]# yum install zabbix-agent

配置zabbix-proxy的MySQL数据库初始化
......................................................................................................................................................

.. code-block:: bash
    :linenos:
    
    [root@proxy ~]# yum install mysql-server

    [root@proxy ~]# /etc/init.d/mysqld start


登陆数据库，清理空账号信息，创建zabbix数据库，并创建授权访问数据库的用户：

.. attention::
    如果把zabbix-server的数据库文件导入到proxy的数据库中，proxy会不能启动，日志会提示数据库不可以用zabbix server的数据库。

.. code-block:: bash
    :linenos:

    [root@proxy ~]# mysql -uroot -p
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
    |      | proxy     |
    | root | proxy     |
    +------+-----------+
    5 rows in set (0.00 sec)

    mysql> drop user ""@"localhost";
    Query OK, 0 rows affected (0.00 sec)

    mysql> drop user ""@"proxy";
    Query OK, 0 rows affected (0.00 sec)

    mysql> drop user "root"@"proxy";
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


    [root@proxy ~]# cd /usr/share/doc/zabbix-proxy-mysql-3.4.14/
    [root@proxy zabbix-proxy-mysql-3.4.14]# ls
    AUTHORS  ChangeLog  COPYING  NEWS  README  schema.sql.gz
    [root@proxy zabbix-proxy-mysql-3.4.14]# zcat schema.sql.gz | mysql -uroot -p123 zabbix


配置zabbix-proxy配置文件修改
......................................................................................................................................................

.. note::
    本例中没有修改proxy默认的名称,默认名称是：Zabbix proxy,如果有多个proxy，需要名称标准化。
    这个配置参数在文件 ``/etc/zabbix/zabbix_proxy.conf`` 中的参数Hostname指定。配置这个参数的方法
    和zabbix-agent的配置客户端主机名方法相同。

.. code-block:: bash
    :linenos:

    [root@proxy ~]# sed -i 's#Server=127.0.0.1#Server=192.168.161.132#g' /etc/zabbix/zabbix_proxy.conf
    [root@proxy ~]# sed -i 's/DBName=zabbix_proxy/DBName=zabbix/g' /etc/zabbix/zabbix_proxy.conf
    [root@proxy ~]# sed -i 's/# DBPassword=/DBPassword=password/g' /etc/zabbix/zabbix_proxy.conf
    [root@proxy ~]# sed -i 's/# ConfigFrequency=3600/ConfigFrequency=10/g' /etc/zabbix/zabbix_proxy.conf


如果需要自定义proxy向server同步配置的时间间隔可以修改以下参数：
    - 默认时1小时同步一次。即服务器配置后最长时间是1小时后proxy才可以同步到这个修改。
    - /etc/zabbix/zabbix_proxy.conf文件中的ConfigFrequency=3600修改为指定的多少秒即可。(本例中是10秒)

.. tip::
    默认proxy会自动把本地的数据打包发送给server，默认时1秒钟发送一次，可以修改配置文件/etc/zabbix/zabbix_proxy.conf
    中的参数 ``DataSenderFrequency``

zabbix_proxy配置命令集合
......................................................................................................................................................


.. code-block:: bash
    :linenos:

    ntpdate pool.ntp.org
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    getenforce
    /etc/init.d/iptables stop
    yum install mysql-devel mysql-server -y

    rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
    yum install zabbix-proxy-mysql zabbix-agent -y

    /etc/init.d/mysqld start
    /usr/bin/mysqladmin -u root password '123'
    mysql -uroot -p

    use mysql;
    drop user ""@"localhost";
    drop user ""@"proxy";
    drop user "root"@"proxy";
    update user set password=password("123") where user="root" and host="127.0.0.1";
    create database zabbix;
    grant all privileges on zabbix.* to zabbix@localhost identified by 'password';
    grant all privileges on zabbix.* to zabbix@192.168.161.136 identified by 'password';
    flush privileges;
    exit

    cd /usr/share/doc/zabbix-proxy-mysql-3.4.14/
    zcat schema.sql.gz | mysql -uroot -p123 zabbix


    sed -i 's#Server=127.0.0.1#Server=192.168.161.132#g' /etc/zabbix/zabbix_proxy.conf
    sed -i 's/DBName=zabbix_proxy/DBName=zabbix/g' /etc/zabbix/zabbix_proxy.conf
    sed -i 's/# DBPassword=/DBPassword=password/g' /etc/zabbix/zabbix_proxy.conf
    sed -i 's/# ConfigFrequency=3600/ConfigFrequency=10/g' /etc/zabbix/zabbix_proxy.conf

    /etc/init.d/zabbix_proxy start

    ss -lntu | grep 10051

    chkconfig zabbix_proxy on



zabbix-agent服务配置
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

配置zabbix主服务器和proxy关联
======================================================================================================================================================


zabbix添加proxy
------------------------------------------------------------------------------------------------------------------------------------------------------

在zabbix服务器添加proxy主要在zabbix的web界面添加。具体过程如下：



.. image:: /Server/res/images/server/linux/zabbix-install/advance/zabbix-advance001.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-install/advance/zabbix-advance002.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-install/advance/zabbix-advance003.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-install/advance/zabbix-advance004.png
    :align: center
    :height: 400 px
    :width: 800 px


zabbix添加使用proxy监控的host
------------------------------------------------------------------------------------------------------------------------------------------------------


.. image:: /Server/res/images/server/linux/zabbix-install/advance/zabbix-advance101.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-install/advance/zabbix-advance102.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-install/advance/zabbix-advance103.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-install/advance/zabbix-advance104.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-install/advance/zabbix-advance105.png
    :align: center
    :height: 400 px
    :width: 800 px

