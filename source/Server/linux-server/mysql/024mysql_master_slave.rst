.. _mysql_master_slave:

======================================================================================================================================================
MySQL主从同步
======================================================================================================================================================

:Date: 2018-11

.. contents::


MySQL主从(单主单从)
======================================================================================================================================================

MySQL自带主从复制方案。可以通过配置文件my.cnf来配置，然后再通过sql语句配置即可实现主从备份。

主从数据备份的方式：
    - MySQL主从备份分为传统的复制记录产生变化的sql语句的基于语句的复制(statement-based replication)
    - 基于行的复制(row-based replication，在5.1版本提供)这种复制将每一次改动记为二进制日志的一行。

数据备份方式各自的缺点：
    - 基于语句的复制缺点：无法保证所有语句都正确复制。
    - 基于行的复制：相比基于语句的复制不仅更加方便，而且有时候速度更快。
MySQL配置主从同步原理：
    主服务器(主实例，逻辑的主服务器)有一个活动的二进制日志和唯一的服务器ID，二进制日志保存了master上所有的改变，slave服务器获取master的二进制日志变化然后重新执行这些变化即可实现主从同步。在主从服务器之间应该各自有唯一的server_id，

具体实现步骤：
    1. 修改Master配置文件开启二进制日志(log-bin),并设置server-id
    #. Master数据库登陆查看master状态，并授权slave的IP的访问权限
    #. 修改Slave配置文件，开启日志中继功能(relay-log),并设置server-id，这个id和Master不能相同
    #. Slave配置指定Master信息，一般包括4部分信息：主机名、端口号、Master上拥有REPLICATION SLAVE权限的用户账号、该用户的密码。
    #. 查看主从数据库状态，创建数据测试同步情况。
    
    第一步：
        Master修改my.cnf开启log-bin功能并设置主从之间唯一的server-id(范围：1-2^32，可以用IP表示)，然后Master进程需要重启这些新增配置才能生效。

.. code-block:: none
    :linenos:

    [mysqld]
    log-bin = /data/3306/mysql-bin
    server-id = 1

停止数据库
    多实例停数据库方法：

.. code-block:: bash
    :linenos:

    /app/mysql/bin/mysqladmin -uroot -p3306 -S /data/3306/mysql.sock shutdown

一般方法：

.. code-block:: bash
    :linenos:

    /etc/init.d/mysqld stop
    
终极方法：

.. code-block:: bash
    :linenos:

    pkill mysql
    killall mysql

启动数据库
    多实例启动：

.. code-block:: bash
    :linenos:

    mysqld_safe --defaults-file=/data/3306/my.cnf 2>&1 >/dev/null &
    
一般方法：

.. code-block:: bash
    :linenos:

    /etc/init.d/mysqld start

第二步：
        Master创建用来让slave获取Master二进制日志的用户及密码。
            登录Master数据库执行下面SQL语句：

.. code-block:: none
    :linenos:

    GRANT REPLICATION SLAVE ON *.* TO 'sync'@'192.168.10.%' identified by 'syncpasswd';
    flush privileges;
    select user,host,password from mysql.user;
    select user,host,password from mysql.user where user='sync';
    show master status\G
    *************************** 1. row ***************************
                    File: mysql-bin.000001
                Position: 408
            Binlog_Do_DB: 
        Binlog_Ignore_DB: 
    Executed_Gtid_Set: 
    1 row in set (0.00 sec)
    
            
第三步：
    Slave修改my.cnf开启relay-log功能，并配置和Master不同的server-id。修改后重启生效。

.. code-block:: none
    :linenos:

    [mysqld]
    relay-log = /data/3307/relay-bin
    server-id = 2
            
        
第四步：
Slave配置指定Master信息，一般包括4部分信息：主机名、端口号、Master上拥有REPLICATION SLAVE权限的用户账号、该用户的密码。
以上添加方式是Slave上面执行SQL语句。
具体语句：

.. code-block:: none
    :linenos:

    CHANGE MASTER TO
    MASTER_HOST='192.168.10.210',  
    MASTER_PORT=3306,
    MASTER_USER='sync',
    MASTER_PASSWORD='syncpasswd',
    MASTER_LOG_FILE='mysql-bin.000001',
    MASTER_LOG_POS=408;

上面命令实际原理是把数据写入：/data/3307/data/master.info文件
可以通过cat查看这个文件的内容。
第五步：



启动slave

.. code-block:: bash
    :linenos:

    start slave;

停止slave

.. code-block:: bash
    :linenos:

    stop slave;


slave配置重置：

.. code-block:: bash
    :linenos:

    reset slave;
    reset slave all;

查看主从各种信息：
Master数据各种信息查看：
查看Master是否开启
    show variables like 'log_bin';
        +---------------+-------+
        | Variable_name | Value |
        +---------------+-------+
        | log_bin       | ON    |
        +---------------+-------+
        1 row in set (0.00 sec)


说明：ON是开启binlog功能

查看Master状态：

.. code-block:: bash
    :linenos:

    show master status\G;
    *************************** 1. row ***************************
                    File: mysql-bin.000001
                Position: 120
            Binlog_Do_DB: 
        Binlog_Ignore_DB: 
    Executed_Gtid_Set: 
    1 row in set (0.00 sec)
    说明：
        120：二进制日志偏移量。这个在配置slave的时候需要用到，如果有更改数据的sql执行这个值会变化，在配置slave时需要查看最新的这个偏移量。
        mysql-bin.000001：二进制文件名称，在配置slave时需要用到这个名称。
    
查看master的server-id：

.. code-block:: bash
    :linenos:
    
    show variables like 'server_id';
        +---------------+-------+
        | Variable_name | Value |
        +---------------+-------+
        | server_id     | 6     |
        +---------------+-------+
        1 row in set (0.00 sec)

查看Master二进制文件内容：

.. code-block:: none
    :linenos:

    show binlog events in 'mysql-bin.000001'\G

查看自动解锁时长

.. code-block:: bash
    :linenos:

    show variables like '%timeout%';
        +-----------------------------+----------+
        | Variable_name               | Value    |
        +-----------------------------+----------+
        | connect_timeout             | 10       |
        | delayed_insert_timeout      | 300      |
        | innodb_flush_log_at_timeout | 1        |
        | innodb_lock_wait_timeout    | 120      |
        | innodb_rollback_on_timeout  | OFF      |
        | interactive_timeout         | 28800    |
        | lock_wait_timeout           | 31536000 |
        | net_read_timeout            | 30       |
        | net_write_timeout           | 60       |
        | rpl_stop_slave_timeout      | 31536000 |
        | slave_net_timeout           | 3600     |
        | wait_timeout                | 28800    |
        +-----------------------------+----------+
        12 rows in set (0.00 sec)
    
Slave相关查看：
查看slave状态

.. code-block:: bash
    :linenos:

    show slave status\G
            
        
问题排查：
    如果Master和Slave分别配置了log-bin和relay-log都配置为空，则一旦服务器主机名，将会因为无法找到中继日志索引文件而认为中继日志文件为空。




MySQL主从(单主双从)
======================================================================================================================================================


MySQL双主配置
======================================================================================================================================================



