
.. _server_kafka_install:

======================================================================
Kafka集群搭建安装教程
======================================================================

系统及软件版本
======================================================================


操作系统:centos7.8
官网下载安装包 apache-zookeeper-3.6.3-bin.tar.gz
版本: 2.12–2.6.0

kafka下载地址：（目前使用版本：2.6.0）
http://kafka.apache.org/downloads



1 前提条件
	Kafka需要依赖zookeeper运行，需安装zookeeper
	Kafka安装包下载


ZooKeeper下载及安装
======================================================================


通过SFTP工具，上传至根目录节点下的/mnt/soft

2.2 zookeeper安装步骤

解压（切换到根目录下 /mnt/soft）

::
    
    tar -zxvf apache-zookeeper-3.6.3-bin.tar.gz –C /usr/local
    mv apache-zookeeper-3.6.3-bin zookeeper-3.6.3 

创建数据、日志文件夹

::

    cd zookeeper-3.6.3/
    mkdir data
    mkdir log


增加配置文件

::

    cd conf/
    cp zoo_sample.cfg zoo.cfg

修改配置

::

    vi zoo.cfg


添加配置

::

    dataDir=/usr/local/zookeeper-3.6.3/data
    dataLogDir=/usr/local/zookeeper-3.6.3/log
    admin.serverPort=12181
    admin.enableServer=true

启动

::

    /usr/local/ zookeeper-3.6.3/bin/zkServer.sh start

验证是否启动（查看启动状态）

::

    /usr/local/ zookeeper-3.6.3/bin/zkServer.sh status
    Zookeeper安装完成

注：平时启动时，进入zookeeper安装目录下得bin文件下，输入命令：./zkServer.sh start


Kafka下载及安装（单机版）
======================================================================



下载已编译好的：kafka_2.12-2.6.0.tgz
安装kafka

拷贝安装包到 /mnt/soft

解压

::

    tar -zxvf kafka_2.12-2.6.0.tgz –C /usr/local

创建数据、日志文件夹

::

    cd kafka_2.12-2.6.0/
    mkdir logs

修改配置

::

    cd config/
    vi server.properties

修改服务Id、日志路径

::

    broker.id=0
    log.dirs=/usr/local/kafka_2.12-2.7.0/logs

启动

::

    cd /usr/local/kafka_2.12-2.6.0/bin
    ./kafka-server-start.sh  ../config/server.properties &


注：启动需要几秒钟，在最后会显示如图：
 
zookeeper和Kafka集群版配置
======================================================================


zookeeper集群

创建myid文件（存放节点Id）

::

    cd /usr/local/apache-zookeeper-3.6.3/data
    echo 1 >myid（10.20.2.22执行）
    echo 2 >myid（10.20.2.23执行）
    echo 3 >myid（10.20.2.24执行）

修改配置

::

    cd /usr/local/apache-zookeeper-3.6.3/conf
    vi zoo.cfg

增加集群配置（每个文件都添加下面三条）

::

    server.1=10.20.2.22:2888:3888
    server.2=10.20.2.23:2888:3888
    server.3=10.20.2.24:2888:3888

三台机都配置好后，停止再启动

::

    /usr/local/apache-zookeeper-3.6.3/bin/zkServer.sh stop
    /usr/local/apache-zookeeper-3.6.3/bin/zkServer.sh start


kafka集群

配置broker.id要唯一，不能一样

::

    #（10.20.2.22 broker.id配置）
    broker.id=0
    #（10.20.2.23 broker.id配置）
    broker.id=1
    #（10.20.2.24broker.id配置）
    broker.id=2

打开监听端口

::

    ####################### Socket Server Settings #############################
    # The address the socket server listens on. It will get the value returned from 
    # java.net.InetAddress.getCanonicalHostName() if not configured.
    #   FORMAT:
    #     listeners = listener_name://host_name:port
    #   EXAMPLE:
    #     listeners = PLAINTEXT://your.host.name:9092
    listeners=PLAINTEXT://10.255.34.145:9092


修改zookeeper.connect


::
    
    ############################# Zookeeper #############################
    # Zookeeper connection string (see zookeeper docs for details).
    # This is a comma separated host:port pairs, each corresponding to a zk
    # server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
    # You can also append an optional chroot string to the urls to specify the
    # root directory for all kafkaznodes.
    zookeeper.connect=192.168.1.22:2181, 192.168.1.23:2181, 192.168.1.24:2181/kafka

这里配置的是zookeeper群集的IP和端口。

这里需要说明的是，默认Kafka会使用ZooKeeper默认的/路径，这样有关Kafka的ZooKeeper配置就会散落在根路径下面，如果你有其他的应用也在使用ZooKeeper集群，查看ZooKeeper中数据可能会不直观，所以强烈建议指定一个chroot路径，直接在 zookeeper.connect配置项中指定。
zookeeper.connect=10.255.34.78:2181,10.255.34.76:2181,10.255.34.74:2181/kafka


而且，需要手动在ZooKeeper中创建路径/kafka，使用如下命令连接到任意一台 ZooKeeper服务器：

::

    cd ~/zookeeper
    bin/zkCli.sh

然后输入：create /kafka

启动kafka

::

    bin/kafka-server-start.sh config/server.properties&








