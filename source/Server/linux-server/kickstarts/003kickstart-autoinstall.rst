.. _kickstart-autoinstall:

======================================================================================================================================================
自动安装系统(kickstart+PXE)
======================================================================================================================================================

:Date: 2018-09

.. contents::


.. tip:: 前面的准备过程和 :ref:`kickstart-manulinstall` 一样




系统环境准备
======================================================================================================================================================

系统版本
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# cat /etc/redhat-release
    CentOS release 6.6 (Final)
    [root@cent6_cobbler_01 ~]# uname -r
    2.6.32-504.el6.x86_64
    [root@cent6_cobbler_01 ~]# cat /etc/sysconfig/network
    NETWORKING=yes
    HOSTNAME=cent6_cobbler_01

网络时间同步
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    如果时间没有和网络同步，yum安装会报错。
    
    参考:
        :ref:`linux-yuminstallerr-time`

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# date
    Thu Sep  6 21:07:25 CST 2018
    [root@cent6_cobbler_01 ~]# ntpdate pool.ntp.org
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

    [root@cent6_cobbler_01 ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    [root@cent6_cobbler_01 ~]# grep SELINUX /etc/selinux/config
    # SELINUX= can take one of these three values:
    SELINUX=disabled
    # SELINUXTYPE= can take one of these two values:
    SELINUXTYPE=targeted

**临时关闭：**
    下面配置是立即生效，但是系统重启后会失效。

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# getenforce
    Enforcing
    [root@cent6_cobbler_01 ~]# setenforce 0
    [root@cent6_cobbler_01 ~]# getenforce
    Permissive




关闭防火墙
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    防火墙一般都是关闭。如果不不关闭，也可以通过配置规则允许所有使用的端口被访问。

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# /etc/init.d/iptables stop 
    iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
    iptables: Flushing firewall rules:                         [  OK  ]
    iptables: Unloading modules:                               [  OK  ]

关闭防火墙开机自启动

.. code-block:: bash
    :linenos:
    
    [root@cent6_cobbler_01 ~]# chkconfig iptables off


系统准备命令集合
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    ntpdate pool.ntp.org
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    /etc/init.d/iptables stop 
    chkconfig iptables off

DHCP安装配置
======================================================================================================================================================

安装dhcp服务：

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# yum install dhcp -y


查看DHCP安装目录：

.. code-block:: bash
    :linenos:
    
    [root@cent6_cobbler_01 ~]# rpm -ql dhcp

DHCP配置

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# cat >>/etc/dhcp/dhcpd.conf<<EOF
    > subnet 192.168.6.0 netmask 255.255.255.0 {
    >         range 192.168.6.100 192.168.6.200;
    >         option subnet-mask 255.255.255.0;
    >         default-lease-time 21600;
    >         max-lease-time 43200;
    >         next-server 192.168.6.10;
    >         filename "/pxelinux.0";
    > }
    > EOF
    [root@cent6_cobbler_01 ~]# cat /etc/dhcp/dhcpd.conf
    #
    # DHCP Server Configuration file.
    #   see /usr/share/doc/dhcp*/dhcpd.conf.sample
    #   see 'man 5 dhcpd.conf'
    #
    subnet 192.168.6.0 netmask 255.255.255.0 {
            range 192.168.6.100 192.168.6.200;
            option subnet-mask 255.255.255.0;
            default-lease-time 21600;
            max-lease-time 43200;
            next-server 192.168.6.10;
            filename "/pxelinux.0";
    }

检查网卡信息：

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# ifconfig
    eth0      Link encap:Ethernet  HWaddr 00:0C:29:B3:93:42  
            inet addr:192.168.161.132  Bcast:192.168.161.255  Mask:255.255.255.0
            inet6 addr: fe80::20c:29ff:feb3:9342/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:1014 errors:0 dropped:0 overruns:0 frame:0
            TX packets:592 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000 
            RX bytes:108635 (106.0 KiB)  TX bytes:97793 (95.5 KiB)

    eth1      Link encap:Ethernet  HWaddr 00:0C:29:B3:93:4C  
            inet addr:192.168.6.10  Bcast:192.168.6.255  Mask:255.255.255.0
            inet6 addr: fe80::20c:29ff:feb3:934c/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:4 errors:0 dropped:0 overruns:0 frame:0
            TX packets:14 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000 
            RX bytes:316 (316.0 b)  TX bytes:916 (916.0 b)

    lo        Link encap:Local Loopback  
            inet addr:127.0.0.1  Mask:255.0.0.0
            inet6 addr: ::1/128 Scope:Host
            UP LOOPBACK RUNNING  MTU:65536  Metric:1
            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0 
            RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

修改默认网关：

.. attention::
    这一步根据实际情况。本例子，因为默认网关192.168.6.1不能访问外网，所以修改了默认网关。

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# route
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    192.168.6.0     *               255.255.255.0   U     0      0        0 eth1
    192.168.161.0   *               255.255.255.0   U     0      0        0 eth0
    link-local      *               255.255.0.0     U     1002   0        0 eth0
    link-local      *               255.255.0.0     U     1003   0        0 eth1
    default         192.168.6.1     0.0.0.0         UG    0      0        0 eth1

    [root@cent6_cobbler_01 ~]# route del default gw 192.168.6.1
    [root@cent6_cobbler_01 ~]# route add default gw 192.168.161.2

启动DHCP

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# /etc/init.d/dhcpd start
    Starting dhcpd:                                            [  OK  ]

    [root@cent6_cobbler_01 ~]# lsof -i :67
    COMMAND  PID  USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    dhcpd   1866 dhcpd    7u  IPv4  14762      0t0  UDP *:bootps 



TFTP安装配置
======================================================================================================================================================

tfpt安装：

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# yum install tftp-server -y

配置tftp：

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# cat -n /etc/xinetd.d/tftp
        1  # default: off
        2  # description: The tftp server serves files using the trivial file transfer \
        3  #       protocol.  The tftp protocol is often used to boot diskless \
        4  #       workstations, download configuration files to network-aware printers, \
        5  #       and to start the installation process for some operating systems.
        6  service tftp
        7  {
        8          socket_type             = dgram
        9          protocol                = udp
        10          wait                    = yes
        11          user                    = root
        12          server                  = /usr/sbin/in.tftpd
        13          server_args             = -s /var/lib/tftpboot
        14          disable                 = yes
        15          per_source              = 11
        16          cps                     = 100 2
        17          flags                   = IPv4
        18  }

    [root@cent6_cobbler_01 ~]# sed -i '14s/yes/no/' /etc/xinetd.d/tftp

    [root@cent6_cobbler_01 ~]# cat -n /etc/xinetd.d/tftp              
        1  # default: off
        2  # description: The tftp server serves files using the trivial file transfer \
        3  #       protocol.  The tftp protocol is often used to boot diskless \
        4  #       workstations, download configuration files to network-aware printers, \
        5  #       and to start the installation process for some operating systems.
        6  service tftp
        7  {
        8          socket_type             = dgram
        9          protocol                = udp
        10          wait                    = yes
        11          user                    = root
        12          server                  = /usr/sbin/in.tftpd
        13          server_args             = -s /var/lib/tftpboot
        14          disable                 = no
        15          per_source              = 11
        16          cps                     = 100 2
        17          flags                   = IPv4
        18  }

启动tftp服务：

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# /etc/init.d/xinetd start
    Starting xinetd:                                           [  OK  ]


    [root@cent6_cobbler_01 ~]# ss -tunlp|grep 69       
    udp    UNCONN     0      0                      *:68                    *:*      users:(("dhclient",3269,6))
    udp    UNCONN     0      0                      *:69                    *:*      users:(("xinetd",3449,5))



apache安装配置
======================================================================================================================================================

安装apache：

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# yum -y install httpd

添加ServerName，防止http提示域名和主机名映射的问题：

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# sed -i "277i ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf

启动apache服务：

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# /etc/init.d/httpd start
    Starting httpd:                                            [  OK  ]

查看http服务状态：

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# lsof -i :80
    COMMAND  PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    httpd   3553   root    4u  IPv6  18461      0t0  TCP *:http (LISTEN)
    httpd   3554 apache    4u  IPv6  18461      0t0  TCP *:http (LISTEN)
    httpd   3555 apache    4u  IPv6  18461      0t0  TCP *:http (LISTEN)
    httpd   3556 apache    4u  IPv6  18461      0t0  TCP *:http (LISTEN)
    httpd   3558 apache    4u  IPv6  18461      0t0  TCP *:http (LISTEN)
    httpd   3559 apache    4u  IPv6  18461      0t0  TCP *:http (LISTEN)
    httpd   3560 apache    4u  IPv6  18461      0t0  TCP *:http (LISTEN)
    httpd   3561 apache    4u  IPv6  18461      0t0  TCP *:http (LISTEN)
    httpd   3562 apache    4u  IPv6  18461      0t0  TCP *:http (LISTEN)

创建挂载系统的目录，建议用操作系统版本命名。这样方便以后安装其他版本系统：

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# mkdir /var/www/html/centos/6.6 -p

挂载并检查挂载情况：

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# mount /dev/cdrom /var/www/html/centos/6.6
    mount: block device /dev/sr0 is write-protected, mounting read-only
    [root@cent6_cobbler_01 ~]# ls /var/www/html/centos/6.6/
    CentOS_BuildTag  GPL                       RPM-GPG-KEY-CentOS-6           RPM-GPG-KEY-CentOS-Testing-6  isolinux
    EFI              Packages                  RPM-GPG-KEY-CentOS-Debug-6     TRANS.TBL                     repodata
    EULA             RELEASE-NOTES-en-US.html  RPM-GPG-KEY-CentOS-Security-6  images

测试http访问情况：

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# curl -s -o /dev/null -I -w "%{http_code}\n" http://192.168.6.10/centos/6.6/
    200



配置支持PXE的启动程序
======================================================================================================================================================

安装syslinux

.. code-block:: bash
    :linenos:
    
    [root@cent6_cobbler_01 ~]# yum -y install syslinux

syslinux是一个功能强大的引导加载程序，而且兼容各种介质。
SYSLINUX是一个小型的Linux操作系统，它的目的是简化首次安装Linux的时间，并建立修护或其它特殊用途的启动盘。

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
    [root@cent6_cobbler_01 ~]# cp -a /var/www/html/centos/6.6/isolinux/* /var/lib/tftpboot/
    [root@cent6_cobbler_01 ~]# ls /var/lib/tftpboot/
    TRANS.TBL  boot.msg   initrd.img    isolinux.cfg  pxelinux.0  vesamenu.c32
    boot.cat   grub.conf  isolinux.bin  memtest       splash.jpg  vmlinuz

    [root@cent6_cobbler_01 ~]# cp /var/www/html/centos/6.6/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default




创建ks.cfg文件
======================================================================================================================================================


我们一般普通安装系统的时候是一个交互过程。为了减少这个交互过程，kickstart就诞生了。

使用这种kickstart，只需事先定义好一个Kickstart自动应答配置文件ks.cfg（通常存放在安装服务器上），并让安装程序知道该配置文件的位置，在安装过程中安装程序就可以自己从该文件中读取安装配置，这样就避免了在安装过程中多次的人机交互，从而实现无人值守的自动化安装。


生成kickstart配置文件的三种方法：
    - 方法1：每安装好一台Centos机器，Centos安装程序都会创建一个kickstart配置文件，记录你的真实安装配置。如果你希望实现和某系统类似的安装，可以基于该系统的kickstart配置文件来生成你自己的kickstart配置文件。（生成的文件名字叫anaconda-ks.cfg位于/root/anaconda-ks.cfg）
    - 方法2：Centos提供了一个图形化的kickstart配置工具。在任何一个安装好的Linux系统上运行该工具，就可以很容易地创建你自己的kickstart配置文件。kickstart配置工具命令为redhat-config-kickstart（RHEL3）或system-config-kickstart（RHEL4，RHEL5）.网上有很多用CentOS桌面版生成ks文件的文章，如果有现成的系统就没什么可说。但没有现成的，也没有必要去用桌面版，命令行也很简单。
    - 方法3：阅读kickstart配置文件的手册。用任何一个文本编辑器都可以创建你自己的kickstart配置文件。

[root@cent6_cobbler_01 ~]# ll anaconda-ks.cfg
-rw-------. 1 root root 1040 Mar 30 17:41 anaconda-ks.cfg

官网文档 
    - CentOS5: http://www.centos.org/docs/5/html/Installation_Guide-en-US/s1-kickstart2-options.html 
    - CentOS6: https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/s1-kickstart2-options.html 

ks.cfg文件组成大致分为3段：
    - 命令段
    - 软件包段
    - 脚本段(可选)

.. hint::
    脚本段在生产环境用来做服务器系统安装后的初始优化。

================= =========================================================================================
关键字              含义
----------------- -----------------------------------------------------------------------------------------
install	            告知安装程序，这是一次全新安装，而不是升级upgrade。
----------------- -----------------------------------------------------------------------------------------
url --url=" "	    通过FTP或HTTP从远程服务器上的安装树中安装。
                    url --url="http://192.168.6.10/centos/6.6/"
                    url --url ftp://<username>:<password>@<server>/<dir>
----------------- -----------------------------------------------------------------------------------------
nfs	                从指定的NFS服务器安装。

                    ``nfs --server=nfsserver.example.com --dir=/tmp/install-tree``
----------------- -----------------------------------------------------------------------------------------
text	            使用文本模式安装。
----------------- -----------------------------------------------------------------------------------------
lang	            设置在安装过程中使用的语言以及系统的缺省语言。lang en_US.UTF-8
----------------- -----------------------------------------------------------------------------------------
keyboard	        设置系统键盘类型。keyboard us
----------------- -----------------------------------------------------------------------------------------
zerombr	            清除mbr引导信息。
----------------- -----------------------------------------------------------------------------------------
bootloader	        系统引导相关配置。

                    ``bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"``

                    --location=,指定引导记录被写入的位置.
                    有效的值如下:mbr(缺省),partition(在包含内核的分区的第一个扇区安装引导装载程序)
                    或none(不安装引导装载程序)。
                    --driveorder,指定在BIOS引导顺序中居首的驱动器。
                    --append=,指定内核参数.要指定多个参数,使用空格分隔它们。
----------------- -----------------------------------------------------------------------------------------
network	            为通过网络的kickstart安装以及所安装的系统配置联网信息。

                    ``network --bootproto=dhcp --device=eth0 --onboot=yes --noipv6 --hostname=CentOS6``
                    
                    --bootproto=[dhcp/bootp/static]中的一种，缺省值是dhcp。bootp和dhcp被认为是相同的。
                    
                    static方法要求在kickstart文件里输入所有的网络信息。

                    ``network --bootproto=static --ip=10.0.0.100 --netmask=255.255.255.0 
                    --gateway=10.0.0.2 --nameserver=10.0.0.2``

                    请注意所有配置信息都必须在一行上指定,不能使用反斜线来换行。
                    --ip=,要安装的机器的IP地址.
                    --gateway=,IP地址格式的默认网关.
                    --netmask=,安装的系统的子网掩码.
                    --hostname=,安装的系统的主机名.
                    --onboot=,是否在引导时启用该设备.
                    --noipv6=,禁用此设备的IPv6.
                    --nameserver=,配置dns解析.
----------------- -----------------------------------------------------------------------------------------
timezone	        设置系统时区。timezone --utc Asia/Shanghai
----------------- -----------------------------------------------------------------------------------------
authconfig	        系统认证信息。authconfig --enableshadow --passalgo=sha512

                    设置密码加密方式为sha512 启用shadow文件。
----------------- -----------------------------------------------------------------------------------------
rootpw	            root密码
----------------- -----------------------------------------------------------------------------------------
clearpart	        清空分区。clearpart --all --initlabel

                    --all 从系统中清除所有分区，--initlable 初始化磁盘标签
----------------- -----------------------------------------------------------------------------------------
part	            磁盘分区。

                    ``part /boot --fstype=ext4 --asprimary --size=200``

                    ``part swap --size=1024``
                    
                    ``part / --fstype=ext4 --grow --asprimary --size=200``
                    
                    --fstype=,为分区设置文件系统类型.有效的类型为ext2,ext3,swap和vfat。
                    --asprimary,强迫把分区分配为主分区,否则提示分区失败。
                    --size=,以MB为单位的分区最小值.在此处指定一个整数值,如500.不要在数字后面加MB。
                    --grow,告诉分区使用所有可用空间(若有),或使用设置的最大值。
                    负责协助配置redhat一些重要的信息。
----------------- -----------------------------------------------------------------------------------------
firstboot           ``firstboot --disable``
----------------- -----------------------------------------------------------------------------------------
selinux	            关闭selinux。 ``selinux --disabled``
----------------- -----------------------------------------------------------------------------------------
firewall	        关闭防火墙。 ``firewall --disabled``
----------------- -----------------------------------------------------------------------------------------
logging	            设置日志级别。 ``logging --level=info``
----------------- -----------------------------------------------------------------------------------------
reboot	            设定安装完成后重启,此选项必须存在，不然kickstart显示一条消息，
                    并等待用户按任意键后才重新引导，也可以选择halt关机。
================= =========================================================================================


配置root密码

**密码123，但是不显示**


.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# grub-crypt
    Password: 
    Retype password: 
    $6$GafRCAkqcz35Y62c$yqmxZeTgOsMWawSyJ/crWjx9N2zBQBUn1A6295uAhRLJqptzvX5pnU.vct6snauchxB8aUF486ojM6aICqemb0

配置ks文件

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# cat >>/var/www/html/centos/ks_config/centos-6.6-ks.cfg<<EOF
    > # Kickstart Configurator for CentOS 6.6 by cent6_cobbler_01
    > install
    > url --url="http://192.168.6.10/centos/6.6/"
    > text
    > lang en_US.UTF-8
    > keyboard us
    > zerombr
    > bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"
    > network --bootproto=dhcp --device=eth0 --onboot=yes --noipv6 --hostname=CentOS6
    > timezone --utc Asia/Shanghai
    > authconfig --enableshadow --passalgo=sha512
    > rootpw  --iscrypted $6$GafRCAkqcz35Y62c$yqmxZeTgOsMWawSyJ/crWjx9N2zBQBUn1A6295uAhRLJqptzvX5pnU.vct6snauchxB8aUF486ojM6aICqemb0
    > clearpart --all --initlabel
    > part /boot --fstype=ext4 --asprimary --size=200
    > part swap --size=1024
    > part / --fstype=ext4 --grow --asprimary --size=200
    > firstboot --disable
    > selinux --disabled
    > firewall --disabled
    > logging --level=info
    > reboot
    > %packages
    > @base
    > @compat-libraries
    > @debugging
    > @development
    > tree
    > nmap
    > sysstat
    > lrzsz
    > dos2unix
    > telnet
    > %post
    > wget -O /tmp/optimization.sh http://192.168.6.10/centos/ks_config/centos6_optimization.sh &>/dev/null
    > /bin/sh /tmp/optimization.sh
    > %end
    > EOF

编辑装机完成后运行的系统优化脚本：

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# vi >>/var/www/html/centos/ks_config/centos6_optimization.sh

把 :ref:`cent6_cobbler_01-kickstart-sys-optimization` 内容插入上面的文件中。




整合编辑default配置文件

.. code-block:: bash
    :linenos:

    [root@cent6_cobbler_01 ~]# cat >>/var/lib/tftpboot/pxelinux.cfg/default<<EOF
    > default ks
    > prompt 0
    > 
    > label ks
    >     kernel vmlinuz
    >     append initrd=initrd.img ks=http://192.168.6.10/centos/ks_config/centos-6.6-ks.cfg ksdevice=eth0
    > EOF

.. attention::
    - 上面文件中的超链接指定的文件需要和前面配置的http文件路径一致。
    - 参数 ``ksdevice`` 指定默认网卡，如果不指定，在服务器有多网卡时会弹出页面让选择网卡。一般无论有几个网卡都有eth0，所以选择eth0。


.. _cent6_cobbler_01-kickstart-sys-optimization:

开机优化脚本
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    #!/usr/bin/env bash
    PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
    export PATH
    #=================================================================#
    #   System Required:  CentOS 6+,                                  #
    #   Description: optimization CentOS6.X                           #
    #   Author: cent6_cobbler_01 <login_root@163.com>                         #
    #   Thanks: @XXX <XXX>                                            #
    #   Intro:                                                        #
    #=================================================================#

    Interface=eth0

    # add log to the log file
    function sh_log(){
        if [ $? -eq 0 ];then
            echo "$1 success" >>/tmp/optimization-`date +%F`.log
        else
            echo "$1 fail" >>/tmp/optimization-`date +%F`.log
        fi
    }

    # get the network info:ip mask gateway suffix
    function get_networkinfo(){
        Ip=`/sbin/ifconfig $Interface|awk -F '[ :]' '{if(NR==2) print $13}'`
        Suffix=`ifconfig $Interface|awk -F "[ .]+" 'NR==2 {print $6}'`
        Mask=`/sbin/ifconfig $Interface|awk -F '[ :]' '{if(NR==2) print $NF}'`
        Gateway=`/sbin/route|grep "^default.*$Interface$"|awk '{print $2}'`
    }

    # config network use static ip
    function config_network(){
        get_networkinfo
    cat >/etc/sysconfig/network-scripts/ifcfg-$Interface <<-END
    DEVICE=$Interface
    TYPE=Ethernet
    ONBOOT=yes
    NM_CONTROLLED=yes
    BOOTPROTO=none
    IPADDR=$Ip
    NETMASK=$Mask
    GATEWAY=$Gateway
    DEFROUTE=yes
    IPV4_FAILURE_FATAL=yes
    IPV6INIT=no
    END
    }

    # config max limit of open file
    function config_unlimit(){
        [ -f "/etc/security/limits.conf" ] && {
        echo '*  -  nofile  65535' >> /etc/security/limits.conf
        ulimit -HSn 65535 >/dev/null 2&1
        }
    }

    # config service start when sys start
    function config_base_services(){
        Services="crond|network|rsyslog|sshd|sysstat|ntpd"
        /sbin/chkconfig --list|grep "3:on"|grep -vE $Services|awk '{print "chkconfig " $1 " off"}'|/bin/bash >/dev/null 2&1
    }

    # config ssh service
    function config_ssh(){
        File_ssh=/etc/ssh/sshd_config
        cp $File_ssh $File_ssh.backup
        sed -i 's%#PermitRootLogin no%PermitRootLogin yes%' $File_ssh >/dev/null 2&1
        sed -i 's%#UseDNS yes%UseDNS no%' $File_ssh >/dev/null 2&1
        sed -i 's%GSSAPIAuthentication yes%GSSAPIAuthentication no%' $File_ssh >/dev/null 2&1

    }

    # config quick time when sys boot
    function config_boot_time(){
        Bootloader="/boot/grub/grub.conf"
        /bin/sed -i 's#rhgb quiet##' $Bootloader >/dev/null 2&1
        /bin/sed -i 's#timeout=5#timeout=1#' $Bootloader >/dev/null 2&1
    }

    # config sys time
    function config_systime(){
        Dateserver='pool.ntp.org'
        /usr/sbin/ntpdate $Dateserver >/dev/null 2&1
        echo "#time sysc by myhome at 2018-03-30" >>/var/spool/cron/root
        echo "*/5 * * * * /usr/sbin/ntpdate $Dateserver >/dev/null 2&1" >>/var/spool/cron/root
    }

    # the script's main function
    function main(){
        config_base_services
        sh_log "config_base_services:base service config"
        config_ssh
        sh_log "config_ssh:config ssh service"
        config_network
        sh_log "config_network:config network"
        config_systime
        sh_log "config_systime:config system time sync"
        config_unlimit
        sh_log "config_unlimit:config max open file"
        config_boot_time
        sh_log "config_boot_time:config boot time"
    }

    main


