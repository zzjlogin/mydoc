.. _zzjlogin-linux-dhcp:

==================================================================
DHCP服务搭建
==================================================================

:Date: 2018-09

.. contents::

环境准备
==================================================================

.. attention::
    dhcp在实际生活中很常见的一种服务。但是一般都是通过家用路由器(AP),或者企业内的三层交换机提供。
    所以一般的网络都不用配置dhcp服务器。但是如果是超大型网络。出于网络规划。会设计一个dhcp。
    但是这时候因为这种大型网络拓补结构都是多个网段或者多种网络类型。所以一般都需要DHCP中继。这会消耗一部分网络带宽。所以慎重应用。
    

dhcp安装系统及软件信息
-------------------------------------

系统:
    CentOS6.6
软件:
    dhcp-common-4.1.1-61.P1.el6.centos.x86_64
    dhcp-4.1.1-61.P1.el6.centos.x86_64

.. note::
    dhcp-common默认系统已经安装。所以只用安装dhcp软件包即可。


关闭vmware的dhcp功能
-------------------------------------

默认情况下vmware会提供dhcp功能，为了不影响我们后续的自己搭建dhcp功能，建议先关闭vmware的dhcp功能。

关闭vmwaredhcp功能具体步骤: 【菜单栏】->【编辑】->【虚拟网络编辑器】->【更改设置】,如下图：

.. image:: /images/tools/vmware/network/hostonly.png
    :align: center
    :height: 500 px
    :width: 800 px

设置虚拟机的网络方式具体步骤： 【虚拟机右键】->【虚拟机设置】->【网络适配器】，如下图： 

.. image:: /images/tools/vmware/network/dhcp-option.jpg
    :align: center
    :height: 500 px
    :width: 800 px


.. note:: 我这个主机是最小化安装的，环境都没有配置，下面有写环境配置相关的， 自行跳过。


环境准备
==================================================================

配置yum源、禁用selinux和防火墙
-----------------------------------------------------------

1. 查看网络配置

.. attention::
    DHCP服务器需要配置静态IP，而且需要配置网卡开机自启动

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# cd /etc/sysconfig/network-scripts/
    [root@zzjlogin network-scripts]# cat ifcfg-eth0
    DEVICE=eth0
    TYPE=Ethernet
    #UUID=f8bb8e43-06b1-461b-bcaa-8babe463c5e6
    ONBOOT=yes
    NM_CONTROLLED=yes
    BOOTPROTO=dhcp
    #HWADDR=00:0C:29:C2:EF:FB
    DEFROUTE=yes
    PEERDNS=yes
    PEERROUTES=yes
    IPV4_FAILURE_FATAL=yes
    IPV6INIT=no
    NAME="System eth0"

.. code-block:: bash
    :linenos:
    
    [root@zzjlogin network-scripts]# cat ifcfg-eth1
    DEVICE=eth1
    TYPE=Ethernet
    #UUID=f8bb8e43-06b1-461b-bcaa-8babe463c5e6
    ONBOOT=yes
    NM_CONTROLLED=yes
    #BOOTPROTO=dhcp
    BOOTPROTO=static
    IPADDR=192.168.46.6
    PREFIX=24
    GATEWAY=192.168.46.1
    #HWADDR=00:0C:29:C2:EF:FB
    DEFROUTE=yes
    PEERDNS=yes
    PEERROUTES=yes
    IPV4_FAILURE_FATAL=yes
    IPV6INIT=no
    #NAME="System eth0"


2. yum 配置

.. attention::
    yum方式安装DHCP，默认的yum源是国外的安装程序比较慢，一般会换成国内的 ``163`` ``ali`` ``sohu`` 等yum源。
    **注意** 本实例安装是用的本地光驱挂在的系统镜像的中的软件包目录作为yum源。

.. code-block:: bash
    :linenos:

    [root@zzjlogin network-scripts]# cd /etc/yum.repos.d/
    [root@zzjlogin yum.repos.d]# ls
    CentOS-Base.repo  CentOS-Debuginfo.repo  CentOS-fasttrack.repo  CentOS-Media.repo  CentOS-Vault.repo
    [root@zzjlogin yum.repos.d]# cd 
    [root@zzjlogin ~]# cd /etc/yum.repos.d/
    [root@zzjlogin yum.repos.d]# ls
    CentOS-Base.repo  CentOS-Debuginfo.repo  CentOS-fasttrack.repo  CentOS-Media.repo  CentOS-Vault.repo
    [root@zzjlogin yum.repos.d]# mkdir bak                   # 创建备份目录
    [root@zzjlogin yum.repos.d]# mv *.repo bak/              # 备份文件
    [root@zzjlogin yum.repos.d]# ls
    bak
    [root@zzjlogin yum.repos.d]# vim cdrom.repo              # 编辑cdrom.repo
    -bash: vim: command not found
    [root@zzjlogin yum.repos.d]# vi cdrom.repo               # 编辑cdrom.repo
    [root@zzjlogin yum.repos.d]# cat cdrom.repo              # 查看cdrom
    [base]
    name=base
    baseurl=file:///mnt/cdrom
    gpgcheck=0
    enable=1
    [root@zzjlogin yum.repos.d]# mkdir /mnt/cdrom            # 创建挂载点
    [root@zzjlogin yum.repos.d]# mount /dev/cdrom  /mnt/cdrom  # 挂载
    mount: block device /dev/sr0 is write-protected, mounting read-only
    [root@zzjlogin yum.repos.d]# yum clean all                 # 清空缓存
    [root@zzjlogin yum.repos.d]# yum makecache                 # 生成yum缓存

3. selinux和防火墙关闭

.. code-block:: bash
    :linenos:

    [root@zzjlogin yum.repos.d]# sed -i 's@SELINUX=enforcing@SELINUX=disabled@' /etc/sysconfig/selinux
    [root@zzjlogin yum.repos.d]# setenforce 0
    关闭防火墙
    [root@zzjlogin yum.repos.d]# service iptables stop
    关闭防火墙开机自启动                                                 
    [root@zzjlogin yum.repos.d]# chkconfig iptables off

4. vim安装

.. note::
    默认的vi编辑器用起来有时候觉得不方便。所以一般都更新为vim。

.. code-block:: bash
    :linenos:

    [root@zzjlogin yum.repos.d]# yum install vim -y            # 安装vim 

dhcp的安装
==================================================================

.. literalinclude:: /demo/server/linux/dhcp/dhcp-install.sh
   :language: bash
   :linenos:

dhcp的配置
==================================================================

具体配置如下:

.. code-block:: bash
    :linenos:

    [root@zzjlogin dhcp]# cd /etc/dhcp                         # 进入dhcp工作目录
    [root@zzjlogin dhcp]# cp /usr/share/doc/dhcp-4.1.1/dhcpd.conf.sample dhcpd.conf
    [root@zzjlogin dhcp]# cp dhcpd.conf dhcpd.conf.backup
    [root@zzjlogin dhcp]# vim dhcpd.conf                       # 编辑主配置文件
    [root@zzjlogin dhcp]# cat dhcpd.conf                       # 查看dhcp文件
    # dhcpd.conf
    #
    # Sample configuration file for ISC dhcpd
    #

    # option definitions common to all supported networks...
    option domain-name "linuxpanda.tech";
    option domain-name-servers ns1.linuxpanda.tech, ns2.linuxpanda.tech;

    default-lease-time 86400;
    max-lease-time 864000;

    # 这个地方配置动态ip范围
    subnet 192.168.46.0 netmask 255.255.255.0 {
    range dynamic-bootp 192.168.46.100 192.168.46.200 ;
    option routers 192.168.46.6 ;
    }

    # 这个地方配置静态的ip
    host boss {
    hardware ethernet 08:00:07:26:c0:a5;
    fixed-address 192.168.46.2 ;
    }

    [root@zzjlogin dhcp]# /etc/init.d/dhcpd restart
    Shutting down dhcpd:                                       [  OK  ]
    Starting dhcpd:                                            [  OK  ]

.. note:: 如果dhcpd启动失败，可以从/var/log/message文件的后30行获取帮助信息。

dhcpd的详细参数
-------------------------------------------------------------------------------

关于dhcpd的详细配置，我们可以使用"man dhcpd.conf"命令快速获取帮助，我这里简单介绍下常用参数


dhcp的主要文件
------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# rpm -ql dhcp                                # 查看dhcp server的主要文件
    /etc/dhcp                                                       # dhcp主配置目录
    /etc/dhcp/dhcpd.conf                                            # dhcpd的主配置文件
    /etc/rc.d/init.d/dhcpd                                          # dhcpd的init文件
    /usr/share/doc/dhcp-4.1.1/dhcpd.conf.sample                     # dhcp的样例配置文件
    /var/lib/dhcpd/dhcpd.leases                                     # dhcp分配的ip记录信息文件

    [root@zzjlogin ~]# rpm -ql dhclient                            # dhcp客户端的主要文件
    /sbin/dhclient                                                  # dhcp客户端软件
    /var/lib/dhclient                                               # dhcp获取的ip记录信息文件


dhcp的测试
==================================================================

在另外一个虚拟机里面测试

.. attention::
    这个客户端。dhclient是在dhcp客户端包含的调试命令。客户端需要也配置同一个hostonly网络。然后配置dhcp获取IP。具体信息参考下面配置和显示。


.. code-block:: bash
    :linenos:

    [root@dhcpclient ~]# dhclient -d
    Internet Systems Consortium DHCP Client 4.1.1-P1
    Copyright 2004-2010 Internet Systems Consortium.
    All rights reserved.
    For info, please visit https://www.isc.org/software/dhcp/

    Listening on LPF/eth1/00:0c:29:f0:8e:3d
    Sending on   LPF/eth1/00:0c:29:f0:8e:3d
    Listening on LPF/eth0/00:0c:29:f0:8e:33
    Sending on   LPF/eth0/00:0c:29:f0:8e:33
    Sending on   Socket/fallback
    DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 5 (xid=0x502cfdc6)
    DHCPOFFER from 192.168.46.6
    DHCPREQUEST on eth0 to 255.255.255.255 port 67 (xid=0x502cfdc6)
    DHCPACK from 192.168.46.6 (xid=0x502cfdc6)
    bound to 192.168.46.100 -- renewal in 43162 seconds.
    DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 6 (xid=0x1b3388ff)
    DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 15 (xid=0x1b3388ff)
    DHCPOFFER from 192.168.161.254
    DHCPREQUEST on eth1 to 255.255.255.255 port 67 (xid=0x1b3388ff)
    DHCPACK from 192.168.161.254 (xid=0x1b3388ff)
    bound to 192.168.161.135 -- renewal in 861 seconds.

    [root@dhcpclient ~]# ifconfig eth0
    eth0      Link encap:Ethernet  HWaddr 00:0C:29:F0:8E:33  
            inet addr:192.168.46.100  Bcast:192.168.46.255  Mask:255.255.255.0
            inet6 addr: fe80::20c:29ff:fef0:8e33/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:7 errors:0 dropped:0 overruns:0 frame:0
            TX packets:16 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000 
            RX bytes:1365 (1.3 KiB)  TX bytes:3288 (3.2 KiB)

    [root@dhcpclient ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth0
    DEVICE=eth0
    TYPE=Ethernet
    ONBOOT=yes
    NM_CONTROLLED=yes
    BOOTPROTO=dhcp
    #HWADDR=00:0C:29:C2:EF:FB
    DEFROUTE=yes
    PEERDNS=yes
    PEERROUTES=yes
    IPV4_FAILURE_FATAL=yes
    IPV6INIT=no
    NAME="System eth0"

从上面的测试中，我们可以看出来eth0这个hostonly网卡的ip绑定了192.168.46.100这个ip,是我们dhcp服务器range的第一个ip。




