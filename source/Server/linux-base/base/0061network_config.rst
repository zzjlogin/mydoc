.. _linux-network-config:

======================================================================================================================================================
Linux网络设置
======================================================================================================================================================

:Date: 2018-10-21

.. contents::



CentOS网络配置
======================================================================================================================================================


文件详解
------------------------------------------------------------------------------------------------------------------------------------------------------

参考redhat官方文档：
    https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/s1-networkscripts-interfaces


**以下是CentOS6的网卡配置及说明**


DEVICE=name
    （必填项）网卡物理设备名，和文件ifcfg-ethX里的ethX要一致,name一般是 ``eth0``

HWADDR=MAC-address
    网卡物理地址，格式 ``AA:BB:CC:DD:EE:FF``
    这个参数不能和参数 **MACADDR** 一起使用。
    这个值在文件 ``/etc/udev/rules.d/70-persistent-net.rules`` 也有设置。

    .. tip::
        这个网口配置信息如果和物理网卡的真实信息不一致会导致网卡不能启动。
        如果想手动指定mac地址，需要用参数 **MACADDR**
IPADDRn=address
    IPv4地址，设置静态IP时使用这个参数。其中n从0开始，例如 ``IPADDR0``
    但是我们日常设置，指设置 ``IPADDR`` 而不带数字。
IPV6ADDR=address
    - 设置IPv6地址，address值是：
        Address/Prefix-length
    - 这个参数设置需要先IPV6INIT开启状态。

IPV6ADDR_SECONDARIES=address
    设置多个IPv6地址，多个地址中间用空格分割，如果每个地址没有子网掩码，使用默认的64。
    这个参数设置需要先IPV6INIT开启状态。
IPV6INIT=answer
    是否启用IPv6地址。
        - yes(启用IPv6)
        - no(默认值，不启用IPv6)
IPV6_AUTOCONF=answer
    是否启用IPv6通过邻居发现自动配置。
        - yes(开启)
        - no(关闭)
    
    如果开启则用Neighbor Discovery (ND)的路由发现配置本地IPv6地址。

    参数 **IPV6FORWARDING** 会对本参数设置效果有影响，具体情况如下：
        - IPV6FORWARDING=yes则IPV6_AUTOCONF默认为no
        - IPV6FORWARDING=no则IPV6_AUTOCONF默认是yes，而且IPV6_ROUTER没有影响。
IPV6_MTU=value
    设置MTU值。
IPV6_PRIVACY=rfc3041
    默认是禁用RFC 3041支持，这个设置取决于是否启用了IPV6INIT选项
LINKDELAY=time
    在配置设备之前等待链接协商的秒数。默认值是5秒。
    
    用途：
        例如，通过增加这个值，可以克服由STP引起的链接协商中的延迟。

MACADDR=MAC-address
    设置网卡物理地址，例如 ``AA:BB:CC:DD:EE:FF``
    
    作用：
        手动设置物理网卡地址。
    
    不能和参数 **HWADDR** 一起用
MASTER=bond-interface
    指定端口绑定时的主设备端口。经常和指定备设备的 ``SLAVE`` 连用
SLAVE=answer
    是否通过绑定端口的MASTER指定的端口控制本端口。
        - yes(这个接口被MASTER指定的端口控制)
        - no(不是)
NETMASKn=mask
    子网掩码,n默认从0开始。一般设置参数都不设置数字。具体的mask例如：255.255.0.0
NETWORK=address
    这个指令不赞成使用，手动指定网络地址。
NM_CONTROLLED=answer
    是否通过 **NetworkManager** 管理网卡设备，具体值是：
        - yes(默认就是允许)
        - no(不允许)
    
    **NetworkManager** 是图形界面管理网卡的程序。
ONBOOT=answer
    系统启动时是否激活该设备。
        - yes(激活)
        - no(不激活)
PEERDNS=answer
    是否使用文件 ``/etc/resolv.conf`` 来定义DNS。
        - yes(是)
        - no(不用 ``/etc/resolv.conf`` 来定义DNS)

BOOTPROTO=protocol
    网卡使用的协议，最常见的三个参数如下：
        - static(静态IP)
        - none(不指定,设置固定ip的情况，这个也行，但是如果要设定多网口绑定bond的时候，必须设成none）
        - dhcp(动态获得IP相关信息）

BONDING_OPTS=parameters
    在多网卡绑定时的绑定网卡设置这个参数(绑定的后生成的虚拟网卡例如： ``/etc/sysconfig/network-scripts/ifcfg-bondN`` )

BROADCAST=address
    指定广播地址，官方不建议设置这个参数

DHCP_HOSTNAME=name
    其中name是发送到DHCP服务器的短主机名。只有当DHCP服务器要求客户机在接收IP地址之前指定主机名时，才使用此选项。
DHCPV6C=answer
    是否，使用DHCP获取IPv6地址参数：
        - yes(使用dhcp获取IPv6地址)
        - no(默认时no，不使用dhcp获取IPv6地址)
    
.. hint::
    根据RFC 4862文件，网卡会自动生成一个IPv6 link-local地址。

DHCPV6C_OPTIONS=answer
    启动通过dhcp获取IPv6以后的参数，具体值和含义：
        - \-P(启用IPv6前缀)
        - \-S(用dhcp获取无状态配置信息，不获取地址)
        - \-N(在参数 ``-T`` 和 ``-P`` 后面使用，重置到正常的操作)
        - \-D(当选择DUID(DHCP Unique Identifier)类型后，重置为默认值)

DNS{1,2}=address
    设置主/备DNS信息，一般都使用配置文件 ``/etc/resolv.conf`` 配置。
    如果参数： **PEERDNS** 设置为no，则需要在网卡设置DNS。
ETHTOOL_OPTS=options
    设置网卡的工作模式，选项是ethtool支持的任何特定于设备的选项。
    
    例如，如果你想强制100Mb，全双工:
        ETHTOOL_OPTS="autoneg off speed 100 duplex full"

.. tip::
    改变速度或双工设置需要禁用自动协商选项。

HOTPLUG=answer
    在多端口绑定时，这个参数控制是否支持热插拔。
        - yes(支持热插拔)
        - no(不支持热插拔)
SRCADDR=address
    发出的数据包指定源IP。
USERCTL=answer
    是否允许非root用户管理这个设备。
        - yes(允许)
        - no(不允许)


网卡配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. tip::
    以下配置，是简略配置。可以直接使用，省去了一些不必要的参数。防止后序还要继续调整。

**配置静态IP**

.. code-block:: bash
    :linenos:

    DEVICE=eth0
    TYPE=Ethernet
    ONBOOT=yes
    BOOTPROTO=static
    IPADDR=192.168.161.132
    NETMASK=255.255.255.0
    GATEWAY=192.168.161.2


**配置动态获取DHCP**

.. code-block:: bash
    :linenos:

    DEVICE=eth0
    TYPE=Ethernet
    ONBOOT=yes
    NM_CONTROLLED=yes
    BOOTPROTO=dhcp

配置网卡绑定
------------------------------------------------------------------------------------------------------------------------------------------------------


配置DNS地址
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@server ~]# cat /etc/resolv.conf
    ; generated by /sbin/dhclient-script
    search localdomain
    nameserver 192.168.161.2


手动添加路由信息
------------------------------------------------------------------------------------------------------------------------------------------------------

**方法1：**

.. attention::
    一般用这个方法即可

以下时网卡设备管理脚本 ``/etc/init.d/network`` 的焊好和具体内容：

.. code-block:: bash
    :linenos:

    133         # Add non interface-specific static-routes.
    134         if [ -f /etc/sysconfig/static-routes ]; then
    135            grep "^any" /etc/sysconfig/static-routes | while read ignore args ; do
    136               /sbin/route add -$args
    137            done
    138         fi

从上面提示的脚本135行可以判断。可以通过在系统 ``/etc/sysconfig/static-routes`` 添加对应信息，从而达到开机自动添加路由条目的效果。

从上面内容可以发现。添加的内容应该是用any来开头的而且是增加的路由条目的具体信息。

添加的信息应该是去掉any以后和 ``/sbin/route add -`` 应该能够成增加对应路由信息的命令。而且需要本地测试能添加才可以。


例如样例：

.. code-block:: bash
    :linenos:

    [root@server ~]# cat /etc/sysconfig/static-routes
    any net 192.168.3.0/24 gw 192.168.161.2
    any net 10.250.228.128 netmask 255.255.255.192 gw 192.168.161.2
    [root@server ~]# route
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    10.250.228.128  192.168.161.2   255.255.255.192 UG    0      0        0 eth0
    192.168.6.0     *               255.255.255.0   U     0      0        0 eth1
    192.168.161.0   *               255.255.255.0   U     0      0        0 eth0
    link-local      *               255.255.0.0     U     1002   0        0 eth0
    link-local      *               255.255.0.0     U     1003   0        0 eth1
    default         192.168.161.2   0.0.0.0         UG    0      0        0 eth0

    [root@server ~]# /sbin/route add -net 192.168.3.0/24 gw 192.168.161.2
    [root@server ~]# route
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    10.250.228.128  192.168.161.2   255.255.255.192 UG    0      0        0 eth0
    192.168.6.0     *               255.255.255.0   U     0      0        0 eth1
    192.168.161.0   *               255.255.255.0   U     0      0        0 eth0
    192.168.3.0     192.168.161.2   255.255.255.0   UG    0      0        0 eth0
    link-local      *               255.255.0.0     U     1002   0        0 eth0
    link-local      *               255.255.0.0     U     1003   0        0 eth1
    default         192.168.161.2   0.0.0.0         UG    0      0        0 eth0

.. attention::
    如果网关地址本地没有。则会添加失败，所以最好先手动测试能添加这个路由条目以后，再添加到 ``/etc/sysconfig/static-routes``


**方法2：**

.. attention::
    这个方法会导致开机挂载NFS失败，所以一般不用这种方法。

把对应的添加路由条目的命令追加到文件 ``/etc/rc.local``

**方法3：**
    在 ``/etc/sysconfig/network-script/`` 目录下添加路由文件。
        格式： ``route-interface``
    每个接口一个文件，如果没有就创建一个，只能添加针对该接口的路由，文件内容的格式：
        network/prefix via gateway dev intf

参考样例：

.. code-block:: bash
    :linenos:

    [root@server ~]# echo "10.0.0.0/8 via 192.168.161.2 dev eth0" >>/etc/sysconfig/network-scripts/route-eth0   
    [root@server ~]# cat /etc/sysconfig/network-scripts/route-eth0
    10.0.0.0/8 via 192.168.161.2 dev eth0
    [root@server ~]# route
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    192.168.6.0     *               255.255.255.0   U     0      0        0 eth1
    192.168.161.0   *               255.255.255.0   U     0      0        0 eth0
    link-local      *               255.255.0.0     U     1002   0        0 eth0
    link-local      *               255.255.0.0     U     1003   0        0 eth1
    default         192.168.161.2   0.0.0.0         UG    0      0        0 eth0
    [root@server ~]# /etc/init.d/network restart
    Shutting down interface eth0:                              [  OK  ]
    Shutting down interface eth1:                              [  OK  ]
    Shutting down loopback interface:                          [  OK  ]
    Bringing up loopback interface:                            [  OK  ]
    Bringing up interface eth0:  
    Determining IP information for eth0... done.
                                                            [  OK  ]
    Bringing up interface eth1:  Determining if ip address 192.168.6.10 is already in use for device eth1...
                                                            [  OK  ]
    [root@server ~]# route
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    192.168.6.0     *               255.255.255.0   U     0      0        0 eth1
    192.168.161.0   *               255.255.255.0   U     0      0        0 eth0
    link-local      *               255.255.0.0     U     1002   0        0 eth0
    link-local      *               255.255.0.0     U     1003   0        0 eth1
    10.0.0.0        192.168.161.2   255.0.0.0       UG    0      0        0 eth0
    default         192.168.161.2   0.0.0.0         UG    0      0        0 eth0

.. attention::
    有的人说在文件 ``/etc/sysconfig/network`` 中添加参数GATEWAY=gw_ip，这个只能控制网关地址。
    而且网关地址需要和本地系统的网卡信息匹配。否则也不会生效。如果多个网卡设置多个网关地址，只有一个生效。

开启 IP 转发
======================================================================================================================================================

临时

echo "1" >/proc/sys/net/ipv4/ip_forward

永久开启

sed -i 's#net.ipv4.ip_forward = 0#net.ipv4.ip_forward = 1#'/etc/sysctl.conf


