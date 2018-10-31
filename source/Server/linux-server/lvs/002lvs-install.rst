.. _lvs-install:

=============================================
lvs安装
=============================================

:Date: 2018-10

.. contents::

.. _lvs-centos5:

CentOS5环境安装lvs
=============================================


.. _lvs-centos6:

CentOS6环境安装lvs
=============================================

lvs已经加进内核。只需要开启lvs并安装lvs管理工具即可。

ipvsadm安装准备
---------------------------------------------

检查ip_vs模块是否加载(lvs是否启动)
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
---------------------------------------------

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

编译报错：

.. code-block:: txt
    :linenos:

    libipvs.c:526: note: expected ‘struct nlattr *’ but argument is of type ‘struct nlattr *’
    libipvs.c: In function ‘ipvs_get_dests’:
    libipvs.c:809: error: ‘NLM_F_DUMP’ undeclared (first use in this function)
    libipvs.c:813: warning: assignment makes pointer from integer without a cast
    libipvs.c:829: error: too many arguments to function ‘ipvs_nl_send_message’
    libipvs.c: In function ‘ipvs_get_service’:
    libipvs.c:939: error: too many arguments to function ‘ipvs_nl_send_message’
    libipvs.c: In function ‘ipvs_timeout_parse_cb’:
    libipvs.c:972: warning: initialization makes pointer from integer without a cast
    libipvs.c:986: error: ‘NL_OK’ undeclared (first use in this function)
    libipvs.c: In function ‘ipvs_get_timeout’:
    libipvs.c:1005: error: too many arguments to function ‘ipvs_nl_send_message’
    libipvs.c: In function ‘ipvs_daemon_parse_cb’:
    libipvs.c:1023: warning: initialization makes pointer from integer without a cast
    libipvs.c:1048: warning: passing argument 2 of ‘strncpy’ makes pointer from integer without a cast
    /usr/include/string.h:131: note: expected ‘const char * __restrict _ _’ but argument is of type ‘int’
    libipvs.c:1051: error: ‘NL_OK’ undeclared (first use in this function)
    libipvs.c: In function ‘ipvs_get_daemon’:
    libipvs.c:1071: error: ‘NLM_F_DUMP’ undeclared (first use in this function)
    libipvs.c:1072: error: too many arguments to function ‘ipvs_nl_send_message’
    make[1]: *** [libipvs.o] Error 1
    make[1]: Leaving directory ``/home/tools/ipvsadm-1.26/libipvs'
    make: *** [libs] Error 2



由上面可以发现应该是lib库缺少


.. code-block:: bash
    :linenos:

    [root@lvs_01 ipvsadm-1.26]# yum install libnl* -y

编译发现错误

.. code-block:: txt
    :linenos:

    ipvsadm.c:661: error: ‘POPT_BADOPTION_NOALIAS’ undeclared (first use in this function)
    ipvsadm.c:669: warning: implicit declaration of function ‘poptStrerror’
    ipvsadm.c:670: warning: implicit declaration of function ‘poptFreeContext’
    ipvsadm.c:677: warning: implicit declaration of function ‘poptGetArg’
    ipvsadm.c:367: warning: unused variable ‘options_table’
    ipvsadm.c: In function ‘print_largenum’:
    ipvsadm.c:1383: warning: field width should have type ‘int’, but argument 2 has type ‘size_t’
    make: *** [ipvsadm.o] Error 1

.. code-block:: bash
    :linenos:

    [root@lvs_01 ipvsadm-1.26]# yum install popt* -y



.. code-block:: bash
    :linenos:

    [root@lvs_01 ipvsadm-1.26]# make install



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
---------------------------------------------

临时新增网卡并设置IP：

[root@lvs_01 ~]# ifconfig eth0:0 192.168.161.250 netmask 255.255.255.0 up
[root@lvs_01 ~]# ifconfig eth0:0
eth0:0    Link encap:Ethernet  HWaddr 00:0C:29:F0:8E:33  
          inet addr:192.168.161.250  Bcast:192.168.161.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

或者命令：
ifconfig eth0:0 192.168.161.250/24 up

可以添加主机路由，不添加也没有问题：

[root@lvs_01 ~]# route add -host 192.168.161.250 dev eth0

测试网卡正常：

[root@lvs_01 ~]# ping 192.168.161.250
PING 192.168.161.250 (192.168.161.250) 56(84) bytes of data.
64 bytes from 192.168.161.250: icmp_seq=1 ttl=64 time=0.230 ms
64 bytes from 192.168.161.250: icmp_seq=2 ttl=64 time=0.054 ms


绑定lo：
    一般可以把vip的虚拟网卡绑定lo回环网卡。并设置子网掩码32位。

抑制arp响应
---------------------------------------------

arp抑制dr模式需要配置。

[root@lvs_01 ~]# echo "1">/proc/sys/net/ipv4/conf/lo/arp_ignore
[root@lvs_01 ~]# echo "2">/proc/sys/net/ipv4/conf/lo/arp_announce
[root@lvs_01 ~]# echo "1">/proc/sys/net/ipv4/conf/all/arp_ignore
[root@lvs_01 ~]# echo "2">/proc/sys/net/ipv4/conf/all/arp_announce


ipvsadm常见操作
---------------------------------------------

增加vip

[root@lvs_01 ~]# ipvsadm -A -t 192.168.161.250:80 -s wrr
[root@lvs_01 ~]# ipvsadm -L -n
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  192.168.161.250:80 wrr

增加rip

[root@lvs_01 ~]# ipvsadm -a -t 192.168.161.250:80 -r 192.168.161.134 -g -w 1
[root@lvs_01 ~]# ipvsadm -L -n
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  192.168.161.250:80 wrr
  -> 192.168.161.134:80           Local   1      0          0 

删除rip

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

[root@lvs_01 ~]# ipvsadm -D -t 192.168.161.250:80 -s wrr


arping使用测试
---------------------------------------------

[root@lvs_01 ~]# arping -c 1 -I eth1 -s 192.168.161.250 192.168.161.1 
ARPING 192.168.161.1 from 192.168.161.250 eth1
Unicast reply from 192.168.161.1 [00:50:56:C0:00:08]  0.817ms
Sent 1 probes (1 broadcast(s))
Received 1 response(s)

arping -c 1 -I eth0 -s 192.168.161.250 192.168.161.1 >/dev/null 2>&1

检测lvs调度(用ipvsadm命令)
---------------------------------------------

两秒检测一次：

[root@lvs_01 ~]# watch ipvsadm -L -n

设置1秒监控一次：

[root@lvs_01 ~]# watch -n 1 ipvsadm -L -n

ipvsadm命令管理lvs
---------------------------------------------

ipvsadm命令参数详解：
    参考：http://zh.linuxvirtualserver.org/node/5

有两种命令选项格式，长的和短的，具有相同的意思。在实际使用时，两种都可
以。
-A --add-service
    在内核的虚拟服务器表中添加一条新的虚拟服务器记录。也就是增加一台新的虚拟服务器。
-E --edit-service
    编辑内核虚拟服务器表中的一条虚拟服务器记录。
-D --delete-service
    删除内核虚拟服务器表中的一条虚拟服务器记录。
-C --clear
    清除内核虚拟服务器表中的所有记录。
-R --restore
    恢复虚拟服务器规则
-S --save
    保存虚拟服务器规则，输出为-R 选项可读的格式
-a --add-server
    在内核虚拟服务器表的一条记录里添加一条新的真实服务器记录。也就是在一个虚拟服务器中增加一台新的真实服务器
-e --edit-server
    编辑一条虚拟服务器记录中的某条真实服务器记录
-d --delete-server
    删除一条虚拟服务器记录中的某条真实服务器记录
-L|-l --list
    显示内核虚拟服务器表
-Z --zero
    虚拟服务表计数器清零（清空当前的连接数量等）
--set tcp tcpfin udp
    设置连接超时值
--start-daemon
    启动同步守护进程。他后面可以是master 或backup，用来说明LVS Router 是master 或是backup。在这个功能上也可以采用keepalived 的VRRP 功能。
--stop-daemon
    停止同步守护进程
-h --help
    显示帮助信息

其他的选项:
-t --tcp-service service-address
    说明虚拟服务器提供的是tcp 的服务
        - [vip:port] or [real-server-ip:port]
-u --udp-service service-address
    说明虚拟服务器提供的是udp 的服务
        - [vip:port] or [real-server-ip:port]
-f --fwmark-service fwmark
    说明是经过iptables 标记过的服务类型。
-s --scheduler scheduler
    使用的调度算法，有这样几个选项
        - rr|wrr|lc|wlc|lblc|lblcr|dh|sh|sed|nq,
默认的调度算法是：
    wlc
-p --persistent [timeout]
    持久稳固的服务。这个选项的意思是来自同一个客户的多次请求，将被同一台真实的服务器处理。timeout 的默认值为300 秒。
-M --netmask netmask persistent granularity mask
-r --real-server server-address 
    真实的服务器[Real-Server:port]
-g --gatewaying
    指定LVS 的工作模式为直接路由模式（也是LVS 默认的模式）
-i --ipip
    指定LVS 的工作模式为隧道模式
-m --masquerading
    指定LVS 的工作模式为NAT 模式
-w --weight weight
    真实服务器的权值
--mcast-interface interface
    指定组播的同步接口
-c --connection
    显示LVS 目前的连接 如：ipvsadm -L -c
--timeout
    显示tcp tcpfin udp 的timeout 值 如：ipvsadm -L --timeout
--daemon
    显示同步守护进程状态
--stats
    显示统计信息
--rate
    显示速率信息
--sort
    对虚拟服务器和真实服务器排序输出
--numeric -n
    输出IP 地址和端口的数字形式








