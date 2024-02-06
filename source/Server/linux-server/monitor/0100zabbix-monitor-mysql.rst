.. _server-linux-zabbix-monitor-app:

======================================================================================================================================================
zabbix监控MySQL服务
======================================================================================================================================================





zabbix监控MySQL服务(单实例)
======================================================================================================================================================

zabbix客户端配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    如果没有文件 ``/etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf``
    可以在目录/usr/share/doc/zabbix-agent-XXX/目录下查找。

备份zabbix客户端的默认mysql监控项配置文件：

.. code-block:: bash
    :linenos:
    
    cp /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf.`date "+%F"`

用vi编辑默认的配置文件

.. code-block:: bash
    :linenos:

    vi /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf

上面vi不推出，输入下面，然后替换：

.. code-block:: bash
    :linenos:

    :1,$ s#/var/lib/#/etc/#g

MySQL服务器授权监控使用的用户：

.. code-block:: bash
    :linenos:

    mysql -uroot -p

    use mysql;
    grant all privileges on zabbix.* to zabbix@localhost identified by 'password';
    grant all privileges on zabbix.* to zabbix@192.168.161.132 identified by 'password';
    flush privileges;
    exit

添加登陆的配置文件：

.. code-block:: bash
    :linenos:

    vi /etc/zabbix/.my.conf

上面配置文件内容如下：

.. code-block:: bash
    :linenos:

    [mysql]
    host=localhost
    user=zabbix
    password=password
    socket=/var/lib/mysql/mysql.sock
    [mysqladmin]
    host=localhost
    user=zabbix
    password=password
    socket=/var/lib/mysql/mysql.sock

zabbix服务器测试获取MySQL监控数据：

.. code-block:: bash
    :linenos:

    [root@localhost ~]# zabbix_get -s '192.168.161.134' -k 'mysql.status[Uptime]'
    1582


图形监控配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    zabbix监控服务器默认的MySQL监控项的更新周期是1小时，所以被监控服务器和MySQL模版关联以后需要等待一个小时后所有数据才可以完全同步。


.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-monitor-mysql001.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-monitor-mysql002.png
    :align: center
    :height: 450 px
    :width: 800 px



.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-monitor-mysql003.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-monitor-mysql004.png
    :align: center
    :height: 450 px
    :width: 800 px



.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-monitor-mysql005.png
    :align: center
    :height: 450 px
    :width: 800 px




zabbix监控MySQL服务(低级自动发现多实例)
======================================================================================================================================================




zabbix配置低级自动发现MySQL步骤：
    1. MySQL多实例服务器创建监控需要的脚本；
    #. MySQL多实例服务器配置MySQL监控项及参数，并用zabbix服务器使用 ``zabbix_get`` 命令测试
    #. zabbix服务器创建MySQL多实例监控的模版，并创建自动发现规则，然后创建自动发现规则对应的动作。
    #. 添加MySQL多实例服务器关联到上面创建的模版，查看zabbix监控是否自动添加了MySQL不同实例的监控。

MySQL服务器脚本配置(提取端口并输出json格式)
------------------------------------------------------------------------------------------------------------------------------------------------------

MySQL多实例安装参考：
    :ref:`mysql_multi_instance`

MySQL多实例服务器需要安装zabbix-agent客户端软件，安装参考：
    :ref:`server-linux-zabbix-clients`

提取MySQL服务端口并输出json格式的脚本：

.. code-block:: bash
    :linenos:

    [root@mysql_001 ~]# mkdir /etc/zabbix/scripts
    [root@mysql_001 ~]# vi /etc/zabbix/scripts/discovery_mysql.sh

脚本内容如下：

.. code-block:: bash
    :linenos:

    #!/bin/bash
    #mysql low-level discovery

    #res=`ss -lntup|awk -F "[ :\t]" '/mysqld/{print$5}'`
    res=`ss -lntup|grep mysqld|awk -F "[ :\t]+" '{print$6}'`
    port=($res)
    printf '{'
    printf '"data":['
    for key in ${!port[@]}
    do
        if [[ "${#port[@]}" -gt 1 && "${key}" -ne "$((${#port[@]}-1))" ]];then
            printf '{'
            printf "\"{#MYSQLPORT}\":\"${port[${key}]}\"},"
        else [[ "${key}" -eq "((${#port[@]}-1))" ]]
            printf '{'
            printf "\"{#MYSQLPORT}\":\"${port[${key}]}\"}"
        fi
    done
    printf ']'
    printf '}\n'


测试输出的格式是否符合json：

.. code-block:: bash
    :linenos:

    [root@mysql_001 ~]# /etc/init.d/zabbix-agent status
    zabbix_agentd (pid  46516) is running...
    [root@mysql_001 ~]# zabbix_agentd -p|grep discovery
    vfs.fs.discovery                              [s|{"data":[{"{#FSNAME}":"/","{#FSTYPE}":"rootfs"},{"{#FSNAME}":"/proc","{#FSTYPE}":"proc"},{"{#FSNAME}":"/sys","{#FSTYPE}":"sysfs"},{"{#FSNAME}":"/dev","{#FSTYPE}":"devtmpfs"},{"{#FSNAME}":"/dev/pts","{#FSTYPE}":"devpts"},{"{#FSNAME}":"/dev/shm","{#FSTYPE}":"tmpfs"},{"{#FSNAME}":"/","{#FSTYPE}":"ext4"},{"{#FSNAME}":"/proc/bus/usb","{#FSTYPE}":"usbfs"},{"{#FSNAME}":"/boot","{#FSTYPE}":"ext4"},{"{#FSNAME}":"/data","{#FSTYPE}":"ext4"},{"{#FSNAME}":"/proc/sys/fs/binfmt_misc","{#FSTYPE}":"binfmt_misc"}]}]
    net.if.discovery                              [s|{"data":[{"{#IFNAME}":"lo"},{"{#IFNAME}":"eth0"},{"{#IFNAME}":"eth1"}]}]
    system.cpu.discovery                          [m|ZBX_NOTSUPPORTED] [Collector is not started.]
    [root@mysql_001 ~]# 
    [root@mysql_001 ~]# sh discovery_mysql.sh 
    {"data":[{"{#MYSQLPORT}":"3306"},{"{#MYSQLPORT}":"3307"}]}
    [root@mysql_001 ~]# sh discovery_mysql.sh|python -m json.tool
    {
        "data": [
            {
                "{#MYSQLPORT}": "3306"
            }, 
            {
                "{#MYSQLPORT}": "3307"
            }
        ]
    }


MySQL服务器添加多实例监控项并测试
------------------------------------------------------------------------------------------------------------------------------------------------------

添加监控项：

.. code-block:: bash
    :linenos:

    [root@mysql_001 ~]# vim /etc/zabbix/zabbix_agentd.d/discovery_mysql.conf
    
    UserParameter=discovery_mysql,sh /etc/zabbix/scripts/discovery_mysql.sh

为提取端口的命令 ``ss`` 设置粘贴位，否则zabbix客户端的运行的用户是zabbix，没有执行 ``ss`` 命令的权限，会获取不到端口信息。

.. code-block:: bash
    :linenos:

    [root@mysql_001 zabbix]# chmod u+s `which ss`
    [root@mysql_001 zabbix]# ll `which ss`
    -rwsr-xr-x 1 root root 74840 May 29  2014 /usr/sbin/ss

测试获取信息：

.. code-block:: bash
    :linenos:

    [root@zabbix_001 ~]# zabbix_get -s 192.168.1.152 -k "discovery_mysql" 
    {"data":[{"{#MYSQLPORT}":"3306"},{"{#MYSQLPORT}":"3307"}]}

如果不设置ss命令的权限或者其他设置。直接测试获取数据会有下面展示：

.. code-block:: bash
    :linenos:

    [root@zabbix_001 ~]# zabbix_get -s 192.168.1.152 -k "discovery_mysql" 
    {"data":[]}


修改默认的MySQL的配置：

.. code-block:: bash
    :linenos:

    vi /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf 

    #UserParameter=mysql.status[*],echo "show global status where Variable_name='$2';" | HOME=/var/lib/zabbix mysql -uroot -p123 -h 127.0.0.1 -P $1 -N | awk '{print $$2}'
    UserParameter=mysql.status[*],echo "show global status where Variable_name='$2';" | HOME=/var/lib/zabbix mysql -uroot -h 127.0.0.1 -P $1 -N| awk '{print $$2}'

    [root@zabbix_001 ~]# zabbix_get -s 192.168.1.152 -k "mysql.status[3306,Slow_queries]"          
    0
    [root@zabbix_001 ~]# zabbix_get -s 192.168.1.152 -k "mysql.status[3307,Slow_queries]"  
    0

    [root@zabbix_001 ~]# zabbix_get -s 192.168.1.152 -k mysql.status[3306,Bytes_received]
    3898
    [root@zabbix_001 ~]# zabbix_get -s 192.168.1.152 -k mysql.status[3306,Bytes_received]
    4064


zabbix服务器低级自动发现模版配置
------------------------------------------------------------------------------------------------------------------------------------------------------

本示例只添加两个低级自动发现监控项：
    - Bytes_received
    - Bytes_sent

1. 根据zabbix默认的MySQL模版，克隆一个新的MySQL模版，然后名字改成多实例的即可。





.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery001.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery002.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery003.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery004.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery005.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery006.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery007.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery008.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery009.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery010.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery011.png
    :align: center
    :height: 350 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery012.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery013.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery014.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery015.png
    :align: center
    :height: 350 px
    :width: 800 px


添加被监控多实例MySQL测试
------------------------------------------------------------------------------------------------------------------------------------------------------

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery016.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery017.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery018.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery019.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery020.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery021.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/mysql/zabbix-lowlevel-decovery022.png
    :align: center
    :height: 350 px
    :width: 800 px









