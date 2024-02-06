.. _server-linux-zabbix-items:

======================================================================================================================================================
zabbix监控项(items)
======================================================================================================================================================

一般监控项
======================================================================================================================================================

监控项一般可以配置在模版、主机。或者发现时使用的监控内容。

网速监控
------------------------------------------------------------------------------------------------------------------------------------------------------

.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network001.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network002.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network003.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network004.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network005.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network006.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network007.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network008.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network009.png
    :align: center
    :height: 450 px
    :width: 800 px



总流量监控
------------------------------------------------------------------------------------------------------------------------------------------------------

如果统计每天的网络流量方法：
    1. 监控网卡总流量；
    #. 每天凌晨定时清空网卡流量统计；

    .. attention::
        清空网卡流量统计信息的方法：
            - yum install ethtool -y
            - ethtool -i eth0查网卡类型
            - 清空网卡流量统计信息：
                
                ifconfig eth0 down

                modprobe -r e1000
            
                modprobe e1000
            
                ifconfig eth0 up

zabbix客户端和服务器默认可以统计网卡接口的接收和发送数据和的信息。如果要分别统计接收和发送的数据，需要自定义key值来监控。

下面是监控网卡总流量信息配置：

下面不再详细介绍item创建过程。而是重点介绍流量接口监控创建过程。



.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network101.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network102.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network103.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network104.png
    :align: center
    :height: 350 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network105.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network106.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network107.png
    :align: center
    :height: 450 px
    :width: 800 px


自定义流量接收/发送数据监控
------------------------------------------------------------------------------------------------------------------------------------------------------

在zabbix客户端配置文件中添加：

.. code-block:: bash
    :linenos:

    UserParameter=network.statistic.in[*],/sbin/ifconfig $1 | awk -F '[ :]' '{if(NR==8) print $$13}'
    UserParameter=network.statistic.out[*],/sbin/ifconfig $1 | awk -F '[ :]' '{if(NR==8) print $$19}'

zabbix服务器创建item并相应的key是 ``network.statistic.out[eth1]`` 和 ``network.statistic.in[eth1]``

然后创建监控的图形展示即可。



.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network201.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network202.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network203.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network204.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network205.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network206.png
    :align: center
    :height: 450 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network207.png
    :align: center
    :height: 350 px
    :width: 800 px
    
.. image:: /Server/res/images/server/linux/zabbix-config/items/network/zabbix-network208.png
    :align: center
    :height: 450 px
    :width: 800 px




自定义监控内容
======================================================================================================================================================


zabbix-agent客户端配置文件

.. code-block:: bash
    :linenos:

    /etc/zabbix/zabbix_agentd.conf

.. code-block:: bash
    :linenos:

    vi /etc/zabbix/zabbix_agentd.conf



295行

.. code-block:: bash
    :linenos:

    UserParameter=

具体配置方法参考：

.. code-block:: bash
    :linenos:

    ### Option: UserParameter
    #       User-defined parameter to monitor. There can be several user-defined parameters.
    #       Format: UserParameter=<key>,<shell command>
    #       See 'zabbix_agentd' directory for examples.

举例：

方法1

.. code-block:: bash
    :linenos:

    UserParameter=net.ip[*],/sbin/ifconfig $1 | awk -F '[ :]' '{if(NR==2) print $$13}'

zabbix服务器测试获取客户端数据：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# zabbix_get -s 192.168.161.134 -k "net.ip[eth1]"
    192.168.161.134
    [root@zzjlogin ~]# zabbix_get -s 192.168.161.134 -k "net.ip[lo]"           
    127.0.0.1

.. note::
    zabbix_get命令需要安装zabbix-get软件包才能有这个测试命令。

方法2

.. code-block:: bash
    :linenos:

    UserParameter=memory.usage[*],/bin/cat /proc/meminfo | awk '/^$1:/{print $$2}'

.. attention::
    1. 命令路径要用绝对路径；
    #. 命令用命令自己的 ``$n`` 时需要用两个 ``$`` 符号。 一个 ``$`` 的参数是通过*传入的参数。

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# zabbix_get -s 192.168.161.134 -k "memory.usage[MemFree]"
    693216
    [root@zzjlogin ~]# zabbix_get -s 192.168.161.134 -k "memory.usage[MemTotal]"
    1004348




监控nginx
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    cat >>/etc/nginx/nginx.conf<<EOF
    ##status
    server{
        listen    80;
        #server_name    status.mysite.com;
        location  /  {
        stub_status    on;
        access_log    off;
        allow 192.168.161.0/24;
        allow 127.0.0.1;
        deny all;
        }
    }
    EOF

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /usr/bin/curl -s "http://192.168.161.134:80/status" |awk '/^Active/ {print $NF}' 
    2
    [root@zzjlogin ~]# /usr/bin/curl -s "http://192.168.161.134:80/status" |awk '/^Active/ {print $NF}'
    1

    [root@zzjlogin ~]# /usr/bin/curl -s "http://192.168.161.134:80/status" | grep "Reading"
    Reading: 0 Writing: 1 Waiting: 0 
    [root@zzjlogin ~]# /usr/bin/curl -s "http://192.168.161.134:80/status" | grep "Reading"|cut -d " " -f2
    0
    [root@zzjlogin ~]# /usr/bin/curl -s "http://192.168.161.134:80/status" | grep "Reading"|cut -d " " -f4
    1
    [root@zzjlogin ~]# /usr/bin/curl -s "http://192.168.161.134:80/status" | grep "Reading"|cut -d " " -f6
    0
    [root@zzjlogin ~]# /usr/bin/curl -s "http://192.168.161.134:80/status" | grep "Waiting"|cut -d " " -f6       
    0

    [root@zzjlogin ~]# /usr/bin/curl -s "http://192.168.161.134:80/status" | awk '/^[ \t]+[0-9]+[ \t]+[0-9]+[ \t]+[0-9]+/ {print $1}'    
    22
    [root@zzjlogin ~]# /usr/bin/curl -s "http://192.168.161.134:80/status" | awk '/^[ \t]+[0-9]+[ \t]+[0-9]+[ \t]+[0-9]+/ {print $2}'
    23
    [root@zzjlogin ~]# /usr/bin/curl -s "http://192.168.161.134:80/status" | awk '/^[ \t]+[0-9]+[ \t]+[0-9]+[ \t]+[0-9]+/ {print $3}'
    25


.. attention::
    ``/etc/zabbix/zabbix_agentd.d/`` 目录下的conf配置文件会自动以 ``UserParameter`` 方式包含在主配置文件中。

.. code-block:: bash
    :linenos:

    cat >>/etc/zabbix/zabbix_agentd.d/nginx_parameters.conf <<EOF

    UserParameter=Nginx.active[*],/usr/bin/curl -s "http://$1:$2/status" |awk '/^Active/ {print $$NF}'

    UserParameter=Nginx.reading[*],/usr/bin/curl -s "http://$1:$2/status" | grep "Reading"|cut -d " " -f2

    UserParameter=Nginx.writing[*],/usr/bin/curl -s "http://$1:$2/status" | grep "Writing"|cut -d " " -f4

    UserParameter=Nginx.waiting[*],/usr/bin/curl -s "http://$1:$2/status" | grep "Waiting"|cut -d " " -f6

    UserParameter=Nginx.accepted[*],/usr/bin/curl -s "http://$1:$2/status" | awk '/^[ \t]+[0-9]+[ \t]+[0-9]+[ \t]+[0-9]+/ {print $$1}'    

    UserParameter=Nginx.handled[*],/usr/bin/curl -s "http://$1:$2/status" | awk '/^[ \t]+[0-9]+[ \t]+[0-9]+[ \t]+[0-9]+/ {print $$2}'

    UserParameter=Nginx.requests[*],/usr/bin/curl -s "http://$1:$2/status" | awk '/^[ \t]+[0-9]+[ \t]+[0-9]+[ \t]+[0-9]+/ {print $$3}'

    EOF



