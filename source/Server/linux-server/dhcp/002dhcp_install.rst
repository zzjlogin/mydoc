.. _zzjlogin-linux-dhcp:

======================================================================================================================================================
DHCP服务搭建
======================================================================================================================================================

:Date: 2018-09

.. contents::


环境准备
======================================================================================================================================================

.. attention::
    dhcp在实际生活中很常见的一种服务。但是一般都是通过家用路由器(AP),或者企业内的三层交换机提供。
    所以一般的网络都不用配置dhcp服务器。但是如果是超大型网络。出于网络规划。会设计一个dhcp。
    但是这时候因为这种大型网络拓补结构都是多个网段或者多种网络类型。所以一般都需要DHCP中继。这会消耗一部分网络带宽。所以慎重应用。
    **常见工作应用：** 配置PXE自动化安装系统的时候会用到DHCP。

dhcp服务器环境
------------------------------------------------------------------------------------------------------------------------------------------------------

**系统环境：**

.. code-block:: bash
    :linenos:

    [root@dhcp_server01 ~]# uname -n
    dhcp_server01
    [root@dhcp_server01 ~]# uname -r
    2.6.32-504.el6.x86_64
    [root@dhcp_server01 ~]# uname -i
    x86_64
    [root@dhcp_server01 ~]# uname -o
    GNU/Linux
    [root@dhcp_server01 ~]# cat /etc/sysconfig/network
    NETWORKING=yes
    HOSTNAME=dhcp_server01

**网络环境：**

.. attention::
    DHCP服务器需要配置静态IP，而且需要配置网卡开机自启动

.. code-block:: bash
    :linenos:

    [root@dhcp_server01 ~]# ifconfig
    eth0      Link encap:Ethernet  HWaddr 00:0C:29:11:56:AC  
            inet addr:192.168.161.137  Bcast:192.168.161.255  Mask:255.255.255.0
            inet6 addr: fe80::20c:29ff:fe11:56ac/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:215868 errors:0 dropped:0 overruns:0 frame:0
            TX packets:29843 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000 
            RX bytes:272259368 (259.6 MiB)  TX bytes:2479551 (2.3 MiB)

    eth1      Link encap:Ethernet  HWaddr 00:0C:29:11:56:B6  
            inet addr:192.168.6.10  Bcast:192.168.6.255  Mask:255.255.255.0
            inet6 addr: fe80::20c:29ff:fe11:56b6/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:536902 errors:0 dropped:0 overruns:0 frame:0
            TX packets:3467335 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000 
            RX bytes:34209491 (32.6 MiB)  TX bytes:5161363668 (4.8 GiB)

    lo        Link encap:Local Loopback  
            inet addr:127.0.0.1  Mask:255.0.0.0
            inet6 addr: ::1/128 Scope:Host
            UP LOOPBACK RUNNING  MTU:65536  Metric:1
            RX packets:14 errors:0 dropped:0 overruns:0 frame:0
            TX packets:14 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0 
            RX bytes:1161 (1.1 KiB)  TX bytes:1161 (1.1 KiB)

其中DHCP服务器的eth0是通过dhcp获取的IP，可以方便管理使用。工作中一般就一个网卡即可，eth1是静态IP，这个网卡用来做DHCP的服务器端口。

工作中就只用这个静态IP的配置即可实现dhcp服务器部署。

.. code-block:: bash
    :linenos:

    [root@dhcp_server01 ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth1
    DEVICE=eth1
    #HWADDR=00:0C:29:11:56:B6
    TYPE=Ethernet
    #UUID=15ee2fe0-2e6e-4f6f-83a3-ef7fbe466508
    ONBOOT=yes
    NM_CONTROLLED=yes
    BOOTPROTO=static
    IPADDR=192.168.6.10
    NETMASK=255.255.255.0
    #GATEWAY=192.168.6.1



dhcp客户端环境
------------------------------------------------------------------------------------------------------------------------------------------------------


系统环境和dhcp服务器一致，此处dhcp客户端程序系统都默认自动集成安装，所以不用单独安装。

DHCP客户端的网卡也是使用两个网卡，方便实验使用。工作中只有一个网卡，网卡配置通过DHCP获取IP，则网卡启动后会自动通过
DHCP协议获取IP地址。

**客户端的网络配置信息：**



.. code-block:: bash
    :linenos:

    [root@dhcpclient ~]# uname -n
    dhcpclient
    [root@dhcpclient ~]# cat /etc/sysconfig/network
    NETWORKING=yes
    HOSTNAME=dhcpclient
    [root@dhcpclient ~]# ifconfig
    eth0      Link encap:Ethernet  HWaddr 00:0C:29:F0:8E:33  
            inet6 addr: fe80::20c:29ff:fef0:8e33/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:17 errors:0 dropped:0 overruns:0 frame:0
            TX packets:12 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000 
            RX bytes:1866 (1.8 KiB)  TX bytes:2520 (2.4 KiB)

    eth1      Link encap:Ethernet  HWaddr 00:0C:29:F0:8E:3D  
            inet addr:192.168.161.134  Bcast:192.168.161.255  Mask:255.255.255.0
            inet6 addr: fe80::20c:29ff:fef0:8e3d/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:691 errors:0 dropped:0 overruns:0 frame:0
            TX packets:298 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000 
            RX bytes:67924 (66.3 KiB)  TX bytes:53465 (52.2 KiB)

    lo        Link encap:Local Loopback  
            inet addr:127.0.0.1  Mask:255.0.0.0
            inet6 addr: ::1/128 Scope:Host
            UP LOOPBACK RUNNING  MTU:65536  Metric:1
            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0 
            RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

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


dhcp安装系统及软件信息
------------------------------------------------------------------------------------------------------------------------------------------------------


软件:
    dhcp-common-4.1.1-61.P1.el6.centos.x86_64
    dhcp-4.1.1-61.P1.el6.centos.x86_64

.. note::
    dhcp-common默认系统已经安装。所以只用安装dhcp软件包即可。


关闭vmware的dhcp功能
------------------------------------------------------------------------------------------------------------------------------------------------------

默认情况下vmware会提供dhcp功能，为了不影响我们后续的自己搭建dhcp功能，建议先关闭vmware的dhcp功能。

关闭vmwaredhcp功能具体步骤: 【菜单栏】->【编辑】->【虚拟网络编辑器】->【更改设置】,如下图：

.. image::/Server/res/images/tools/vmware/network/hostonly.png
    :align: center
    :height: 500 px
    :width: 800 px

设置虚拟机的网络方式具体步骤： 【虚拟机右键】->【虚拟机设置】->【网络适配器】，如下图： 

.. image::/Server/res/images/tools/vmware/network/dhcp-option.jpg
    :align: center
    :height: 500 px
    :width: 800 px


.. note:: 我这个主机是最小化安装的，环境都没有配置，下面有写环境配置相关的， 自行跳过。



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


配置yum源
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    yum方式安装DHCP，默认的yum源是国外的安装程序比较慢，一般会换成国内的 ``163`` ``ali`` ``sohu`` 等yum源。
    
.. tip::
    本实例安装是用的本地光驱挂在的系统镜像的中的软件包目录作为yum源。

主要步骤：
    - 备份系统自带的源配置文件
    - 新建cdrom的源配置文件，并配置
    - 挂载本地镜像
    - 清空yum缓存
    - 生成新的yum缓存
    - 可以正常使用这个新的yum源安装软件

.. code-block:: bash
    :linenos:

    [root@dhcp_server01 ~]# cd /etc/yum.repos.d/
    [root@dhcp_server01 yum.repos.d]# ls
    CentOS-Base.repo       CentOS-fasttrack.repo  CentOS-Vault.repo
    CentOS-Debuginfo.repo  CentOS-Media.repo
    [root@dhcp_server01 yum.repos.d]# mkdir bak
    [root@dhcp_server01 yum.repos.d]# mv *.repo bak/
    [root@dhcp_server01 yum.repos.d]# ls
    bak
    [root@dhcp_server01 yum.repos.d]# cat >>cdrom.repo<<EOF
    > [base]
    > name=base
    > baseurl=file:///mnt
    > gpgcheck=0
    > enabled=1
    > EOF
    [root@dhcp_server01 yum.repos.d]# cat cdrom.repo
    [base]
    name=base
    baseurl=file:///mnt
    gpgcheck=0
    enabled=1

挂载本地镜像：

.. code-block:: bash
    :linenos:

    [root@dhcp_server01 yum.repos.d]# mount /dev/cdrom /mnt
    mount: block device /dev/sr0 is write-protected, mounting read-only
    [root@dhcp_server01 yum.repos.d]# cd
    [root@dhcp_server01 ~]# ls /mnt/
    CentOS_BuildTag  EULA  images    Packages                  repodata              RPM-GPG-KEY-CentOS-Debug-6     RPM-GPG-KEY-CentOS-Testing-6
    EFI              GPL   isolinux  RELEASE-NOTES-en-US.html  RPM-GPG-KEY-CentOS-6  RPM-GPG-KEY-CentOS-Security-6  TRANS.TBL

清空缓存，生成yum缓存：

.. code-block:: bash
    :linenos:

    [root@dhcp_server01 yum.repos.d]# yum clean all
    Loaded plugins: fastestmirror, security
    Cleaning repos: base
    Cleaning up Everything
    Cleaning up list of fastest mirrors
    [root@dhcp_server01 yum.repos.d]# yum makecache


vim安装
------------------------------------------------------------------------------------------------------------------------------------------------------

根据自己需要选择是否安装vim。

.. note::
    默认的vi编辑器用起来有时候觉得不方便。所以一般都更新为vim。

.. code-block:: bash
    :linenos:

    [root@dhcp_server01 yum.repos.d]# yum install vim -y

dhcp的安装
======================================================================================================================================================

.. literalinclude:: /Server/res/demo/server/linux/dhcp/dhcp-install.sh
   :language: bash
   :linenos:

dhcp目录结构说明
======================================================================================================================================================

查看dhcp安装所关联的目录：

.. code-block:: bash
    :linenos:

    [root@dhcp_server01 ~]# rpm -ql dhcp
    /etc/dhcp
    /etc/dhcp/dhcpd.conf
    /etc/dhcp/dhcpd6.conf
    /etc/openldap/schema/dhcp.schema
    /etc/portreserve/dhcpd
    /etc/rc.d/init.d/dhcpd
    /etc/rc.d/init.d/dhcpd6
    /etc/rc.d/init.d/dhcrelay
    /etc/rc.d/init.d/dhcrelay6
    /etc/sysconfig/dhcpd
    /etc/sysconfig/dhcpd6
    /etc/sysconfig/dhcrelay
    /etc/sysconfig/dhcrelay6
    /usr/bin/omshell
    /usr/sbin/dhcpd
    /usr/sbin/dhcrelay
    /usr/share/doc/dhcp-4.1.1
    /usr/share/doc/dhcp-4.1.1/3.0b1-lease-convert
    /usr/share/doc/dhcp-4.1.1/IANA-arp-parameters
    /usr/share/doc/dhcp-4.1.1/README.ldap
    /usr/share/doc/dhcp-4.1.1/api+protocol
    /usr/share/doc/dhcp-4.1.1/dhclient-tz-exithook.sh
    /usr/share/doc/dhcp-4.1.1/dhcpd-conf-to-ldap
    /usr/share/doc/dhcp-4.1.1/dhcpd.conf.sample
    /usr/share/doc/dhcp-4.1.1/dhcpd6.conf.sample
    /usr/share/doc/dhcp-4.1.1/draft-ietf-dhc-ldap-schema-01.txt
    /usr/share/doc/dhcp-4.1.1/ms2isc
    /usr/share/doc/dhcp-4.1.1/ms2isc/Registry.perlmodule
    /usr/share/doc/dhcp-4.1.1/ms2isc/ms2isc.pl
    /usr/share/doc/dhcp-4.1.1/ms2isc/readme.txt
    /usr/share/doc/dhcp-4.1.1/sethostname.sh
    /usr/share/doc/dhcp-4.1.1/solaris.init
    /usr/share/man/man1/omshell.1.gz
    /usr/share/man/man5/dhcpd.conf.5.gz
    /usr/share/man/man5/dhcpd.leases.5.gz
    /usr/share/man/man8/dhcpd.8.gz
    /usr/share/man/man8/dhcrelay.8.gz
    /var/lib/dhcpd
    /var/lib/dhcpd/dhcpd.leases
    /var/lib/dhcpd/dhcpd6.leases


dhcp配置目录
    - ``/etc/dhcp``

===================================================================   ===========================================
    目录文件                                                            作用
-------------------------------------------------------------------   -------------------------------------------
/etc/dhcp/dhcpd.conf                                                    dhcp配置文件(ipv4)
-------------------------------------------------------------------   -------------------------------------------
/etc/dhcp/dhcpd6.conf                                                   dhcp的ipv6环境的配置文件
===================================================================   ===========================================

/etc/openldap/schema/dhcp.schema
-------------------------------------------------------------------   -------------------------------------------
/etc/portreserve/dhcpd
===================================================================   ===========================================

dhcp启动脚本目录 ``/etc/rc.d/init.d/``

===================================================================   ===========================================
    目录文件                                                            作用
-------------------------------------------------------------------   -------------------------------------------
/etc/rc.d/init.d/dhcpd                                                  dhcp启动脚本(ipv4)
-------------------------------------------------------------------   -------------------------------------------
/etc/rc.d/init.d/dhcpd6                                                 dhcp启动脚本(ipv6)
-------------------------------------------------------------------   -------------------------------------------
/etc/rc.d/init.d/dhcrelay                                               dhcp中继
-------------------------------------------------------------------   -------------------------------------------
/etc/rc.d/init.d/dhcrelay6
===================================================================   ===========================================


===================================================================   ===========================================
    目录文件                                                            作用
-------------------------------------------------------------------   -------------------------------------------
/etc/sysconfig/dhcpd
-------------------------------------------------------------------   -------------------------------------------
/etc/sysconfig/dhcpd6
-------------------------------------------------------------------   -------------------------------------------
/etc/sysconfig/dhcrelay
-------------------------------------------------------------------   -------------------------------------------
/etc/sysconfig/dhcrelay6
===================================================================   ===========================================


dhcp服务器软件包提供的命令
    - ``/usr/bin/``
    - ``/usr/sbin/``

===================================================================   ===========================================
    目录文件                                                            作用
-------------------------------------------------------------------   -------------------------------------------
/usr/bin/omshell
-------------------------------------------------------------------   -------------------------------------------
/usr/sbin/dhcpd
-------------------------------------------------------------------   -------------------------------------------
/usr/sbin/dhcrelay
===================================================================   ===========================================

dhcp文档目录(配置模版等文件)
    - ``/usr/share/doc/dhcp-4.1.1``

===================================================================   ===========================================
    目录文件                                                            作用
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/3.0b1-lease-convert
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/IANA-arp-parameters
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/README.ldap
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/api+protocol
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/dhclient-tz-exithook.sh
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/dhcpd-conf-to-ldap
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/dhcpd.conf.sample                             dhcp配置模版
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/dhcpd6.conf.sample                            dhcp在IPv6环境的配置模版
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/draft-ietf-dhc-ldap-schema-01.txt
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/ms2isc
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/ms2isc/Registry.perlmodule
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/ms2isc/ms2isc.pl
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/ms2isc/readme.txt
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/sethostname.sh
-------------------------------------------------------------------   -------------------------------------------
/usr/share/doc/dhcp-4.1.1/solaris.init
===================================================================   ===========================================

dhcp对应命令的所有帮助手册(man帮助)

===================================================================   ===========================================
    目录文件                                                            作用
-------------------------------------------------------------------   -------------------------------------------
/usr/share/man/man1/omshell.1.gz
-------------------------------------------------------------------   -------------------------------------------
/usr/share/man/man5/dhcpd.conf.5.gz
-------------------------------------------------------------------   -------------------------------------------
/usr/share/man/man5/dhcpd.leases.5.gz
-------------------------------------------------------------------   -------------------------------------------
/usr/share/man/man8/dhcpd.8.gz
-------------------------------------------------------------------   -------------------------------------------
/usr/share/man/man8/dhcrelay.8.gz
===================================================================   ===========================================

dhcp运行状态记录
    /var/lib/dhcpd

===================================================================   ===========================================
    目录文件                                                            作用
-------------------------------------------------------------------   -------------------------------------------
/var/lib/dhcpd/dhcpd.leases                                             dhcp分配的ip记录信息文件
-------------------------------------------------------------------   -------------------------------------------
/var/lib/dhcpd/dhcpd6.leases
===================================================================   ===========================================


dhcp默认配置
======================================================================================================================================================

默认配置如下:

.. code-block:: bash
    :linenos:

    [root@dhcp_server01 ~]# cd /etc/dhcp/
    [root@dhcp_server01 dhcp]# ls
    dhcpd6.conf  dhcpd.conf
    [root@dhcp_server01 dhcp]# cat dhcpd.conf
    #
    # DHCP Server Configuration file.
    #   see /usr/share/doc/dhcp*/dhcpd.conf.sample
    #   see 'man 5 dhcpd.conf'
    #

配置样例：

.. code-block:: bash
    :linenos:

    [root@dhcp_server01 dhcp]# cat /usr/share/doc/dhcp-4.1.1/dhcpd.conf.sample
    # dhcpd.conf
    #
    # Sample configuration file for ISC dhcpd
    #

    # option definitions common to all supported networks...
    option domain-name "example.org";
    option domain-name-servers ns1.example.org, ns2.example.org;

    default-lease-time 600;
    max-lease-time 7200;

    # Use this to enble / disable dynamic dns updates globally.
    #ddns-update-style none;

    # If this DHCP server is the official DHCP server for the local
    # network, the authoritative directive should be uncommented.
    #authoritative;

    # Use this to send dhcp log messages to a different log file (you also
    # have to hack syslog.conf to complete the redirection).
    log-facility local7;

    # No service will be given on this subnet, but declaring it helps the 
    # DHCP server to understand the network topology.

    subnet 10.152.187.0 netmask 255.255.255.0 {
    }

    # This is a very basic subnet declaration.

    subnet 10.254.239.0 netmask 255.255.255.224 {
    range 10.254.239.10 10.254.239.20;
    option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;
    }

    # This declaration allows BOOTP clients to get dynamic addresses,
    # which we don't really recommend.

    subnet 10.254.239.32 netmask 255.255.255.224 {
    range dynamic-bootp 10.254.239.40 10.254.239.60;
    option broadcast-address 10.254.239.31;
    option routers rtr-239-32-1.example.org;
    }

    # A slightly different configuration for an internal subnet.
    subnet 10.5.5.0 netmask 255.255.255.224 {
    range 10.5.5.26 10.5.5.30;
    option domain-name-servers ns1.internal.example.org;
    option domain-name "internal.example.org";
    option routers 10.5.5.1;
    option broadcast-address 10.5.5.31;
    default-lease-time 600;
    max-lease-time 7200;
    }

    # Hosts which require special configuration options can be listed in
    # host statements.   If no address is specified, the address will be
    # allocated dynamically (if possible), but the host-specific information
    # will still come from the host declaration.

    host passacaglia {
    hardware ethernet 0:0:c0:5d:bd:95;
    filename "vmunix.passacaglia";
    server-name "toccata.fugue.com";
    }

    # Fixed IP addresses can also be specified for hosts.   These addresses
    # should not also be listed as being available for dynamic assignment.
    # Hosts for which fixed IP addresses have been specified can boot using
    # BOOTP or DHCP.   Hosts for which no fixed address is specified can only
    # be booted with DHCP, unless there is an address range on the subnet
    # to which a BOOTP client is connected which has the dynamic-bootp flag
    # set.
    host fantasia {
    hardware ethernet 08:00:07:26:c0:a5;
    fixed-address fantasia.fugue.com;
    }

    # You can declare a class of clients and then do address allocation
    # based on that.   The example below shows a case where all clients
    # in a certain class get addresses on the 10.17.224/24 subnet, and all
    # other clients get addresses on the 10.0.29/24 subnet.

    class "foo" {
    match if substring (option vendor-class-identifier, 0, 4) = "SUNW";
    }

    shared-network 224-29 {
    subnet 10.17.224.0 netmask 255.255.255.0 {
        option routers rtr-224.example.org;
    }
    subnet 10.0.29.0 netmask 255.255.255.0 {
        option routers rtr-29.example.org;
    }
    pool {
        allow members of "foo";
        range 10.17.224.10 10.17.224.250;
    }
    pool {
        deny members of "foo";
        range 10.0.29.10 10.0.29.230;
    }
    }

dhcp简单配置
======================================================================================================================================================

参考上面样例配置简单配置一个地址池：
    - 网关地址：192.168.6.1
    - 地址池范围：192.168.6.20-200
    - dns地址：192.168.6.1/8.8.8.8
    - IP地址默认租期：1小时
    - IP地址最长租期：1天(24小时)

.. attention::
    地址范围不要把服务器地址包含进去。

在配置文件 ``/etc/dhcp/dhcpd.conf`` 文件中追加下面内容：

.. code-block:: none
    :linenos:

    subnet 192.168.6.0 netmask 255.255.255.0 {
        range 192.168.6.20 192.168.6.200;
        option domain-name-servers 192.168.6.1,8.8.8.8;
        option routers 192.168.6.1;
        default-lease-time 3600;
        max-lease-time 86400;
    }

dhcp启动和开机自启动
======================================================================================================================================================


dhcp启动
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: none
    :linenos:

    [root@dhcp_server01 ~]# /etc/init.d/dhcpd start
    Shutting down dhcpd:                                       [  OK  ]
    Starting dhcpd:                                            [  OK  ]

.. note::
    dhcp的日志默认时存放在 ``/var/log/message``
    如果dhcpd启动失败，可以从/var/log/message文件的后30行获取帮助信息。

dhcp开机自启动
------------------------------------------------------------------------------------------------------------------------------------------------------

方法1：

.. code-block:: none
    :linenos:

    [root@dhcp_server01 ~]# chkconfig dhcpd on

方法2：

.. code-block:: none
    :linenos:

    [root@dhcp_server01 ~]# echo '#dhcp server start by zzjlogin on 20180910'>>/etc/rc.local
    [root@dhcp_server01 ~]# echo '/etc/init.d/dhcpd start >/dev/null 2&1' >>/etc/rc.local
    [root@dhcp_server01 ~]# tail -2 /etc/rc.local
    #dhcp server start by zzjlogin on 20180910
    /etc/init.d/dhcpd start >/dev/null 2&1


检查dhcp服务
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: bash
    :linenos:

    [root@dhcp_server01 ~]# ss -lntup|grep 67|column -t
    udp  UNCONN  0  0  *:67  *:*  users:(("dhcpd",30599,7))


dhcpd的详细参数
------------------------------------------------------------------------------------------------------------------------------------------------------

关于dhcpd的详细配置，我们可以使用"man dhcpd.conf"命令快速获取帮助，我这里简单介绍下常用参数





dhcp的测试
======================================================================================================================================================

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
    DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 5 (xid=0x4471d59e)
    DHCPOFFER from 192.168.6.10
    DHCPREQUEST on eth0 to 255.255.255.255 port 67 (xid=0x4471d59e)
    DHCPACK from 192.168.6.10 (xid=0x4471d59e)
    bound to 192.168.6.20 -- renewal in 1462 seconds.
    DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 7 (xid=0xc9fff86)
    DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 12 (xid=0xc9fff86)
    DHCPOFFER from 192.168.161.254
    DHCPREQUEST on eth1 to 255.255.255.255 port 67 (xid=0xc9fff86)
    DHCPACK from 192.168.161.254 (xid=0xc9fff86)
    bound to 192.168.161.135 -- renewal in 717 seconds

此时查看eth0网卡信息：

.. code-block:: bash
    :linenos:

    [root@dhcpclient ~]# ifconfig eth0
    eth0      Link encap:Ethernet  HWaddr 00:0C:29:F0:8E:33  
            inet addr:192.168.6.20  Bcast:192.168.6.255  Mask:255.255.255.0
            inet6 addr: fe80::20c:29ff:fef0:8e33/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:85 errors:0 dropped:0 overruns:0 frame:0
            TX packets:16 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000 
            RX bytes:11061 (10.8 KiB)  TX bytes:3288 (3.2 KiB)

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




