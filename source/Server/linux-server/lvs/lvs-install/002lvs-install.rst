.. _lvs-install-common:

======================================================================================================================================================
lvs安装
======================================================================================================================================================

:Date: 2018-10

.. contents::

.. _lvs-centos5:

CentOS5环境安装lvs
======================================================================================================================================================


.. _lvs-centos6:

CentOS6环境安装lvs
======================================================================================================================================================

lvs已经加进内核。只需要开启lvs并安装lvs管理工具即可。

ipvsadm安装准备
------------------------------------------------------------------------------------------------------------------------------------------------------

检查ip_vs模块是否加载(lvs是否启动)

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# lsmod|grep ip_vs

创建软连接 ``/usr/src/linux``

.. note::
    - 如果没有目录 ``/usr/src/kernels/2.6.32-504.el6.x86_64/`` 可以安装 ``kernel-devel``
    - 如果有 ``kernels有`` 多个 ``2.6.XX`` 则可以用 ``uname -r`` 然后就知道软连接的目的目录。

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# ln -s /usr/src/kernels/2.6.32-504.el6.x86_64/ /usr/src/linux
    [root@lvs_01 ~]# ll /usr/src/linux
    lrwxrwxrwx. 1 root root 39 Sep  9 22:06 /usr/src/linux -> /usr/src/kernels/2.6.32-504.el6.x86_64/

.. note::
    如果没有创建软连接 ``/usr/src/linux``  ，编译安装ipvsadm时需要指定内核目录。

lvs管理工具安装(ipvsadm)
------------------------------------------------------------------------------------------------------------------------------------------------------

CentOS6安装版本：
    ipvsadm-1.26.tar.gz

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# mkdir /home/tools
    [root@lvs_01 ~]# cd /home/tools/
    [root@lvs_01 tools]# wget http://www.linuxvirtualserver.org/software/kernel-2.6/ipvsadm-1.26.tar.gz

.. code-block:: bash
    :linenos:

    [root@lvs_01 tools]# tar zxf ipvsadm-1.26.tar.gz
    [root@lvs_01 tools]# cd ipvsadm-1.26
    [root@lvs_01 ipvsadm-1.26]# make
    [root@lvs_01 ipvsadm-1.26]# make install


.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# lsmod|grep ip_vs        
    [root@lvs_01 ~]# /sbin/ipvsadm
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    [root@lvs_01 ~]# lsmod|grep ip_vs
    ip_vs                 125694  0 
    libcrc32c               1246  1 ip_vs
    ipv6                  334932  270 ip_vs,ip6t_REJECT,nf_conntrack_ipv6,nf_defrag_ipv6




网卡配置
------------------------------------------------------------------------------------------------------------------------------------------------------

临时新增网卡并设置IP：

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# ifconfig eth0:0 192.168.161.250 netmask 255.255.255.0 up
    [root@lvs_01 ~]# ifconfig eth0:0
    eth0:0    Link encap:Ethernet  HWaddr 00:0C:29:F0:8E:33  
            inet addr:192.168.161.250  Bcast:192.168.161.255  Mask:255.255.255.0
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

或者命令：

.. code-block:: bash
    :linenos:

    ifconfig eth0:0 192.168.161.250/24 up

可以添加主机路由，不添加也没有问题：

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# route add -host 192.168.161.250 dev eth0

测试网卡正常：

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# ping 192.168.161.250
    PING 192.168.161.250 (192.168.161.250) 56(84) bytes of data.
    64 bytes from 192.168.161.250: icmp_seq=1 ttl=64 time=0.230 ms
    64 bytes from 192.168.161.250: icmp_seq=2 ttl=64 time=0.054 ms


绑定lo：
    一般可以把vip的虚拟网卡绑定lo回环网卡。并设置子网掩码32位。

抑制arp响应
------------------------------------------------------------------------------------------------------------------------------------------------------

arp抑制dr模式需要配置。

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# echo "1">/proc/sys/net/ipv4/conf/lo/arp_ignore
    [root@lvs_01 ~]# echo "2">/proc/sys/net/ipv4/conf/lo/arp_announce
    [root@lvs_01 ~]# echo "1">/proc/sys/net/ipv4/conf/all/arp_ignore
    [root@lvs_01 ~]# echo "2">/proc/sys/net/ipv4/conf/all/arp_announce


ipvsadm常见操作
------------------------------------------------------------------------------------------------------------------------------------------------------

增加vip

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# ipvsadm -A -t 192.168.161.250:80 -s wrr
    [root@lvs_01 ~]# ipvsadm -L -n
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    TCP  192.168.161.250:80 wrr

增加rip

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# ipvsadm -a -t 192.168.161.250:80 -r 192.168.161.134 -g -w 1
    [root@lvs_01 ~]# ipvsadm -L -n
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    TCP  192.168.161.250:80 wrr
    -> 192.168.161.134:80           Local   1      0          0 

删除rip

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# ipvsadm -L -n
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    TCP  192.168.161.250:80 wrr
    -> 192.168.161.134:80           Local   1      0          0         
    [root@lvs_01 ~]# ipvsadm -d -t 192.168.161.250:80 -r 192.168.161.134 
    [root@lvs_01 ~]# ipvsadm -L -n
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    TCP  192.168.161.250:80 wrr

删除vip

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# ipvsadm -D -t 192.168.161.250:80 -s wrr


arping使用测试
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# arping -c 1 -I eth1 -s 192.168.161.250 192.168.161.1 
    ARPING 192.168.161.1 from 192.168.161.250 eth1
    Unicast reply from 192.168.161.1 [00:50:56:C0:00:08]  0.817ms
    Sent 1 probes (1 broadcast(s))
    Received 1 response(s)

    arping -c 1 -I eth0 -s 192.168.161.250 192.168.161.1 >/dev/null 2>&1

检测lvs调度(用ipvsadm命令)
------------------------------------------------------------------------------------------------------------------------------------------------------

命令相关参数详细：
    :ref:`ipvsadm-cmd`

两秒检测一次：

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# watch ipvsadm -L -n

设置1秒监控一次：

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# watch -n 1 ipvsadm -L -n









