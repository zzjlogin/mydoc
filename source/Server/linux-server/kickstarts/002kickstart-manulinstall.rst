.. _kickstart-manulinstall:

======================================================================================================================================================
手动安装系统(kickstart+PXE)
======================================================================================================================================================

:Date: 2018-09

.. contents::


系统环境准备
======================================================================================================================================================

系统版本
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# cat /etc/redhat-release
    CentOS release 6.6 (Final)
    [root@centos-node1 ~]# uname -r
    2.6.32-504.el6.x86_64
    [root@centos-node1 ~]# cat /etc/sysconfig/network
    NETWORKING=yes
    HOSTNAME=centos-node1

网络时间同步
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    如果时间没有和网络同步，yum安装会报错。
    
    参考:
        :ref:`linux-yuminstallerr-time`

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# date
    Thu Sep  6 21:07:25 CST 2018
    [root@centos-node1 ~]# ntpdate pool.ntp.org
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

    [root@centos-node1 ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    [root@centos-node1 ~]# grep SELINUX /etc/selinux/config
    # SELINUX= can take one of these three values:
    SELINUX=disabled
    # SELINUXTYPE= can take one of these two values:
    SELINUXTYPE=targeted

**临时关闭：**
    下面配置是立即生效，但是系统重启后会失效。

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# getenforce
    Enforcing
    [root@centos-node1 ~]# setenforce 0
    [root@centos-node1 ~]# getenforce
    Permissive




关闭防火墙
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    防火墙一般都是关闭。如果不不关闭，也可以通过配置规则允许所有使用的端口被访问。

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# /etc/init.d/iptables stop 
    iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
    iptables: Flushing firewall rules:                         [  OK  ]
    iptables: Unloading modules:                               [  OK  ]

关闭防火墙开机自启动

.. code-block:: bash
    :linenos:
    
    [root@centos-node1 ~]# chkconfig iptables off

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

    [root@centos-node1 ~]# yum install dhcp -y


查看DHCP安装目录：

.. code-block:: bash
    :linenos:
    
    [root@centos-node1 ~]# rpm -ql dhcp

DHCP配置

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# cat >>/etc/dhcp/dhcpd.conf<<EOF
    > subnet 192.168.6.0 netmask 255.255.255.0 {
    >         range 192.168.6.100 192.168.6.200;
    >         option subnet-mask 255.255.255.0;
    >         default-lease-time 21600;
    >         max-lease-time 43200;
    >         next-server 192.168.6.10;
    >         filename "/pxelinux.0";
    > }
    > EOF
    [root@centos-node1 ~]# cat /etc/dhcp/dhcpd.conf
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

    [root@centos-node1 ~]# ifconfig
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

    [root@centos-node1 ~]# route
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    192.168.6.0     *               255.255.255.0   U     0      0        0 eth1
    192.168.161.0   *               255.255.255.0   U     0      0        0 eth0
    link-local      *               255.255.0.0     U     1002   0        0 eth0
    link-local      *               255.255.0.0     U     1003   0        0 eth1
    default         192.168.6.1     0.0.0.0         UG    0      0        0 eth1

    [root@centos-node1 ~]# route del default gw 192.168.6.1
    [root@centos-node1 ~]# route add default gw 192.168.161.2

启动DHCP

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# /etc/init.d/dhcpd start
    Starting dhcpd:                                            [  OK  ]

    [root@centos-node1 ~]# lsof -i :67
    COMMAND  PID  USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    dhcpd   1866 dhcpd    7u  IPv4  14762      0t0  UDP *:bootps 



TFTP安装配置
======================================================================================================================================================

tfpt安装：

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# yum install tftp-server -y

配置tftp：

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# cat -n /etc/xinetd.d/tftp
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

    [root@centos-node1 ~]# sed -i '14s/yes/no/' /etc/xinetd.d/tftp

    [root@centos-node1 ~]# cat -n /etc/xinetd.d/tftp              
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

    [root@centos-node1 ~]# /etc/init.d/xinetd start
    Starting xinetd:                                           [  OK  ]


    [root@centos-node1 ~]# ss -tunlp|grep 69       
    udp    UNCONN     0      0                      *:68                    *:*      users:(("dhclient",3269,6))
    udp    UNCONN     0      0                      *:69                    *:*      users:(("xinetd",3449,5))



apache安装配置
======================================================================================================================================================

安装apache：

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# yum -y install httpd

添加ServerName，防止http提示域名和主机名映射的问题：

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# sed -i "277i ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf

启动apache服务：

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# /etc/init.d/httpd start
    Starting httpd:                                            [  OK  ]

查看http服务状态：

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# lsof -i :80
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

    [root@centos-node1 ~]# mkdir /var/www/html/centos/6.6 -p

挂载并检查挂载情况：

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# mount /dev/cdrom /var/www/html/centos/6.6
    mount: block device /dev/sr0 is write-protected, mounting read-only
    [root@centos-node1 ~]# ls /var/www/html/centos/6.6/
    CentOS_BuildTag  GPL                       RPM-GPG-KEY-CentOS-6           RPM-GPG-KEY-CentOS-Testing-6  isolinux
    EFI              Packages                  RPM-GPG-KEY-CentOS-Debug-6     TRANS.TBL                     repodata
    EULA             RELEASE-NOTES-en-US.html  RPM-GPG-KEY-CentOS-Security-6  images

测试http访问情况：

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# curl -s -o /dev/null -I -w "%{http_code}\n" http://192.168.6.10/centos/6.6/
    200



配置支持PXE的启动程序
======================================================================================================================================================

安装syslinux

.. code-block:: bash
    :linenos:
    
    [root@centos-node1 ~]# yum -y install syslinux

syslinux是一个功能强大的引导加载程序，而且兼容各种介质。
SYSLINUX是一个小型的Linux操作系统，它的目的是简化首次安装Linux的时间，并建立修护或其它特殊用途的启动盘。

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
    [root@centos-node1 ~]# cp -a /var/www/html/centos/6.6/isolinux/* /var/lib/tftpboot/
    [root@centos-node1 ~]# ls /var/lib/tftpboot/
    TRANS.TBL  boot.msg   initrd.img    isolinux.cfg  pxelinux.0  vesamenu.c32
    boot.cat   grub.conf  isolinux.bin  memtest       splash.jpg  vmlinuz

    [root@centos-node1 ~]# cp /var/www/html/centos/6.6/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default



新服务器通过PXE手动安装系统
======================================================================================================================================================

没有安装系统的服务器通过PXE安装系统步骤：
    - 服务器网线插在和上面配置的node1同一局域网的交换机上面，这个网口需要可以通过DHCP获取上面服务器分配的IP地址。
    - 开机，DELL服务器按F12通过PXE启动。
    - 图形界面如下下面两个图，第二个图形开始就是正常安装。后序安装步骤省略。可以用鼠标/键盘然后控制继续点击选择然后继续下一步一直到安装完成即可。
    - 注意安装过程，选择URL方式安装，然后具体的URL输入：http://192.168.6.10/centos/6.6/

.. image:: /Server/res/images/server/linux/kickstart/pxe001.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/kickstart/linux-install001.png
    :align: center
    :height: 450 px
    :width: 800 px




文件 ``/var/lib/tftpboot/pxelinux.cfg/default`` 注解
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: text
    :linenos:

    default vesamenu.c32  # 默认加载一个菜单
    #prompt 1             # 开启会显示命令行'boot: '提示符。prompt值为0时则不提示，将会直接启动'default'参数中指定的内容。
    timeout 600           # timeout时间是引导时等待用户手动选择的时间，设为1可直接引导，单位为1/10秒。
    display boot.msg
    # 菜单背景图片、标题、颜色。
    menu background splash.jpg
    menu title Welcome to CentOS 6.7!
    menu color border 0 #ffffffff #00000000
    menu color sel 7 #ffffffff #ff000000
    menu color title 0 #ffffffff #00000000
    menu color tabmsg 0 #ffffffff #00000000
    menu color unsel 0 #ffffffff #00000000
    menu color hotsel 0 #ff000000 #ffffffff
    menu color hotkey 7 #ffffffff #ff000000
    menu color scrollbar 0 #ffffffff #00000000
    # label指定在boot:提示符下输入的关键字，比如boot:linux[ENTER]，这个会启动label linux下标记的kernel和initrd.img文件。
    label linux       # 一个标签就是前面图片的一行选项。
    menu label ^Install or upgrade an existing system
    menu default
    kernel vmlinuz  # 指定要启动的内核。同样要注意路径，默认是/tftpboot目录。
    append initrd=initrd.img # 指定追加给内核的参数，initrd.img是一个最小的linux系统
    label vesa
    menu label Install system with ^basic video driver
    kernel vmlinuz
    append initrd=initrd.img nomodeset
    label rescue
    menu label ^Rescue installed system
    kernel vmlinuz
    append initrd=initrd.img rescue
    label local
    menu label Boot from ^local drive
    localboot 0xffff
    label memtest86
    menu label ^Memory test
    kernel memtest
    append -



配置PXE网络安装(非自动安装)命令集合
======================================================================================================================================================

.. note::
    - 下面挂载的镜像是CentOS7,所以目录名称有所改变。
    - 本实例是通过挂载光驱得到的系统文件目录，而且直接挂载到了工作目录。
    - 工作环境先导入镜像到系统，然后通过 ``mount -o loop /data/CentOS-7-x86_64-bin-DVD1.iso /mnt/`` 然后把/mnt目录下的文件复制到工作目录。

.. code-block:: text
    :linenos:

    chkconfig iptables off

    yum install tftp-server httpd dhcp syslinux -y

    >/etc/dhcp/dhcpd.conf 
    cat >>/etc/dhcp/dhcpd.conf <<EOF
            subnet 192.168.6.0 netmask 255.255.255.0 {
            range 192.168.6.100 192.168.6.200;
            option subnet-mask 255.255.255.0;
            default-lease-time 21600;
            max-lease-time 43200;
            next-server 192.168.6.10;
            filename "/pxelinux.0";
    }
    EOF

    sed -i '14s/yes/no/' /etc/xinetd.d/tftp
    sed -i "277i ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf
    /etc/init.d/dhcpd start
    /etc/init.d/xinetd start
    /etc/init.d/httpd start

    mkdir /var/www/html/centos/7 -p
    mount /dev/cdrom /var/www/html/centos/7

    curl -s -o /dev/null -I -w "%{http_code}\n" http://192.168.6.10/centos/7/
    cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
    cp -a /var/www/html/centos/7/isolinux/* /var/lib/tftpboot/

    mkdir /var/lib/tftpboot/pxelinux.cfg/
    cp /var/www/html/centos/7/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default





