.. _lvs-nat-install:

======================================================================================================================================================
lvs-nat安装配置
======================================================================================================================================================

:Date: 2018-10

.. contents::



环境
======================================================================================================================================================


服务器列表
    默认硬件、系统版本全部相同，只是主机名不同和网络配置不同

=================== ==============================================================
**主机名**                **IP**
------------------- --------------------------------------------------------------
lvs_vip_01                 192.168.1.166
------------------- --------------------------------------------------------------
lvs_rip_web01              192.168.1.187
------------------- --------------------------------------------------------------
lvs_rip_web02              192.168.1.163
=================== ==============================================================


=================== ==============================================================
系统版本                CentOS release 6.6 (Final)
------------------- --------------------------------------------------------------
硬件环境                x86_64
------------------- --------------------------------------------------------------
lvsadm                  ipvsadm-1.26
=================== ==============================================================



安装配置
======================================================================================================================================================

nat模式官方资料
    http://www.linuxvirtualserver.org/zh/lvs3.html#3

配置说明
------------------------------------------------------------------------------------------------------------------------------------------------------

本lvs实例是基于NAT的实例配置。且调度算法使用rr(官方叫做轮叫，本人习惯叫做轮询算法。权重使用默认都是1)



lvs_vip_01安装配置过程
------------------------------------------------------------------------------------------------------------------------------------------------------

安装配置过程：

.. code-block:: none
    :linenos:

    [root@lvs_vip_01 ~]# mkdir /home/tools -p
    [root@lvs_vip_01 ~]# ll /home
    total 4
    drwxr-xr-x. 2 root root 4096 Nov  2 02:51 tools
    [root@lvs_vip_01 ~]# lsmod|grep ip_vs
    [root@lvs_vip_01 ~]# cd /home/tools
    [root@lvs_vip_01 tools]# pwd
    /home/tools
    [root@lvs_vip_01 tools]# ls
    [root@lvs_vip_01 tools]# wget http://www.linuxvirtualserver.org/software/kernel-2.6/ipvsadm-1.26.tar.gz
    --2018-11-02 02:55:23--  http://www.linuxvirtualserver.org/software/kernel-2.6/ipvsadm-1.26.tar.gz
    Resolving www.linuxvirtualserver.org... 173.255.202.51, 2600:3c00::f03c:91ff:fe96:fcc2
    Connecting to www.linuxvirtualserver.org|173.255.202.51|:80... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 41700 (41K) [application/x-gzip]
    Saving to: “ipvsadm-1.26.tar.gz”

    100%[===================================================================================================================================>] 41,700       194K/s   in 0.2s    

    2018-11-02 02:55:25 (194 KB/s) - “ipvsadm-1.26.tar.gz” saved [41700/41700]

    [root@lvs_vip_01 tools]# ls
    ipvsadm-1.26.tar.gz
    [root@lvs_vip_01 tools]# rpm -qa libnl* popt*
    popt-1.13-7.el6.x86_64
    libnl-1.1.4-2.el6.x86_64

    [root@lvs_vip_01 tools]# 
    [root@lvs_vip_01 tools]# yum install libnl* popt* -y
    Loaded plugins: fastestmirror, security
    Setting up Install Process
    Determining fastest mirrors
    * base: ftp.sjtu.edu.cn
    * extras: mirrors.tuna.tsinghua.edu.cn
    * updates: mirrors.tuna.tsinghua.edu.cn
    base                                                                                                                                                  | 3.7 kB     00:00     
    base/primary_db                                                                                                                                       | 4.7 MB     00:00     
    extras                                                                                                                                                | 3.4 kB     00:00     
    extras/primary_db                                                                                                                                     |  26 kB     00:00     
    updates                                                                                                                                               | 3.4 kB     00:00     
    updates/primary_db                                                                                                                                    | 1.9 MB     00:00     
    Package libnl-1.1.4-2.el6.x86_64 already installed and latest version
    Package popt-1.13-7.el6.x86_64 already installed and latest version
    Resolving Dependencies
    --> Running transaction check
    ---> Package libnl-devel.x86_64 0:1.1.4-2.el6 will be installed
    ---> Package libnl3.x86_64 0:3.2.21-8.el6 will be installed
    ---> Package libnl3-cli.x86_64 0:3.2.21-8.el6 will be installed
    ---> Package libnl3-devel.x86_64 0:3.2.21-8.el6 will be installed
    ---> Package libnl3-doc.x86_64 0:3.2.21-8.el6 will be installed
    ---> Package popt-devel.x86_64 0:1.13-7.el6 will be installed
    ---> Package popt-static.x86_64 0:1.13-7.el6 will be installed
    --> Finished Dependency Resolution

    Dependencies Resolved

    =============================================================================================================================================================================
    Package                                      Arch                                   Version                                      Repository                            Size
    =============================================================================================================================================================================
    Installing:
    libnl-devel                                  x86_64                                 1.1.4-2.el6                                  base                                 707 k
    libnl3                                       x86_64                                 3.2.21-8.el6                                 base                                 183 k
    libnl3-cli                                   x86_64                                 3.2.21-8.el6                                 base                                  58 k
    libnl3-devel                                 x86_64                                 3.2.21-8.el6                                 base                                  56 k
    libnl3-doc                                   x86_64                                 3.2.21-8.el6                                 base                                  10 M
    popt-devel                                   x86_64                                 1.13-7.el6                                   base                                  21 k
    popt-static                                  x86_64                                 1.13-7.el6                                   base                                  21 k

    Transaction Summary
    =============================================================================================================================================================================
    Install       7 Package(s)

    Total download size: 11 M
    Installed size: 30 M
    Downloading Packages:
    (1/7): libnl-devel-1.1.4-2.el6.x86_64.rpm                                                                                                             | 707 kB     00:00     
    (2/7): libnl3-3.2.21-8.el6.x86_64.rpm                                                                                                                 | 183 kB     00:00     
    (3/7): libnl3-cli-3.2.21-8.el6.x86_64.rpm                                                                                                             |  58 kB     00:00     
    (4/7): libnl3-devel-3.2.21-8.el6.x86_64.rpm                                                                                                           |  56 kB     00:00     
    (5/7): libnl3-doc-3.2.21-8.el6.x86_64.rpm                                                                                                             |  10 MB     00:02     
    (6/7): popt-devel-1.13-7.el6.x86_64.rpm                                                                                                               |  21 kB     00:00     
    (7/7): popt-static-1.13-7.el6.x86_64.rpm                                                                                                              |  21 kB     00:00     
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Total                                                                                                                                        3.6 MB/s |  11 MB     00:03     
    Running rpm_check_debug
    Running Transaction Test
    Transaction Test Succeeded
    Running Transaction
    Installing : libnl3-3.2.21-8.el6.x86_64                                                                                                                                1/7 
    Installing : libnl3-cli-3.2.21-8.el6.x86_64                                                                                                                            2/7 
    Installing : popt-devel-1.13-7.el6.x86_64                                                                                                                              3/7 
    Installing : popt-static-1.13-7.el6.x86_64                                                                                                                             4/7 
    Installing : libnl3-devel-3.2.21-8.el6.x86_64                                                                                                                          5/7 
    Installing : libnl3-doc-3.2.21-8.el6.x86_64                                                                                                                            6/7 
    Installing : libnl-devel-1.1.4-2.el6.x86_64                                                                                                                            7/7 
    Verifying  : libnl3-devel-3.2.21-8.el6.x86_64                                                                                                                          1/7 
    Verifying  : libnl-devel-1.1.4-2.el6.x86_64                                                                                                                            2/7 
    Verifying  : popt-static-1.13-7.el6.x86_64                                                                                                                             3/7 
    Verifying  : popt-devel-1.13-7.el6.x86_64                                                                                                                              4/7 
    Verifying  : libnl3-cli-3.2.21-8.el6.x86_64                                                                                                                            5/7 
    Verifying  : libnl3-3.2.21-8.el6.x86_64                                                                                                                                6/7 
    Verifying  : libnl3-doc-3.2.21-8.el6.x86_64                                                                                                                            7/7 

    Installed:
    libnl-devel.x86_64 0:1.1.4-2.el6  libnl3.x86_64 0:3.2.21-8.el6     libnl3-cli.x86_64 0:3.2.21-8.el6  libnl3-devel.x86_64 0:3.2.21-8.el6  libnl3-doc.x86_64 0:3.2.21-8.el6 
    popt-devel.x86_64 0:1.13-7.el6    popt-static.x86_64 0:1.13-7.el6 

    Complete!
    [root@lvs_vip_01 tools]# rpm -qa libnl* popt*
    libnl3-3.2.21-8.el6.x86_64
    libnl3-devel-3.2.21-8.el6.x86_64
    popt-1.13-7.el6.x86_64
    libnl-1.1.4-2.el6.x86_64
    libnl3-cli-3.2.21-8.el6.x86_64
    popt-static-1.13-7.el6.x86_64
    libnl3-doc-3.2.21-8.el6.x86_64
    popt-devel-1.13-7.el6.x86_64
    libnl-devel-1.1.4-2.el6.x86_64
    [root@lvs_vip_01 tools]# ls
    ipvsadm-1.26.tar.gz
    [root@lvs_vip_01 tools]# tar -xf ipvsadm-1.26.tar.gz
    [root@lvs_vip_01 tools]# ls
    ipvsadm-1.26  ipvsadm-1.26.tar.gz
    [root@lvs_vip_01 tools]# cd ipvsadm-1.26
    [root@lvs_vip_01 ipvsadm-1.26]# ls
    config_stream.c  contrib  dynamic_array.c  ipvsadm.8  ipvsadm-restore    ipvsadm-save    ipvsadm.sh    ipvsadm.spec.in  Makefile             README      VERSION
    config_stream.h  debian   dynamic_array.h  ipvsadm.c  ipvsadm-restore.8  ipvsadm-save.8  ipvsadm.spec  libipvs          PERSISTENCE_ENGINES  SCHEDULERS
    [root@lvs_vip_01 ipvsadm-1.26]# make
    make -C libipvs
    make[1]: Entering directory `/home/tools/ipvsadm-1.26/libipvs'`
    gcc -Wall -Wunused -Wstrict-prototypes -g -fPIC -DLIBIPVS_USE_NL  -DHAVE_NET_IP_VS_H -c -o libipvs.o libipvs.c
    gcc -Wall -Wunused -Wstrict-prototypes -g -fPIC -DLIBIPVS_USE_NL  -DHAVE_NET_IP_VS_H -c -o ip_vs_nl_policy.o ip_vs_nl_policy.c
    ar rv libipvs.a libipvs.o ip_vs_nl_policy.o
    ar: creating libipvs.a
    a - libipvs.o
    a - ip_vs_nl_policy.o
    gcc -shared -Wl,-soname,libipvs.so -o libipvs.so libipvs.o ip_vs_nl_policy.o
    make[1]: Leaving directory `/home/tools/ipvsadm-1.26/libipvs'`
    gcc -Wall -Wunused -Wstrict-prototypes -g  -DVERSION=\"1.26\" -DSCHEDULERS=\""rr|wrr|lc|wlc|lblc|lblcr|dh|sh|sed|nq"\" -DPE_LIST=\""sip"\" -DHAVE_POPT -DHAVE_NET_IP_VS_H -c -o ipvsadm.o ipvsadm.c
    ipvsadm.c: In function ‘print_largenum’:
    ipvsadm.c:1383: warning: field width should have type ‘int’, but argument 2 has type ‘size_t’
    gcc -Wall -Wunused -Wstrict-prototypes -g  -DVERSION=\"1.26\" -DSCHEDULERS=\""rr|wrr|lc|wlc|lblc|lblcr|dh|sh|sed|nq"\" -DPE_LIST=\""sip"\" -DHAVE_POPT -DHAVE_NET_IP_VS_H -c -o config_stream.o config_stream.c
    gcc -Wall -Wunused -Wstrict-prototypes -g  -DVERSION=\"1.26\" -DSCHEDULERS=\""rr|wrr|lc|wlc|lblc|lblcr|dh|sh|sed|nq"\" -DPE_LIST=\""sip"\" -DHAVE_POPT -DHAVE_NET_IP_VS_H -c -o dynamic_array.o dynamic_array.c
    gcc -Wall -Wunused -Wstrict-prototypes -g -o ipvsadm ipvsadm.o config_stream.o dynamic_array.o libipvs/libipvs.a -lpopt -lnl
    [root@lvs_vip_01 ipvsadm-1.26]# echo $?
    0
    [root@lvs_vip_01 ipvsadm-1.26]# make install
    make -C libipvs
    make[1]: Entering directory `/home/tools/ipvsadm-1.26/libipvs'`
    make[1]: Nothing to be done for `all'.`
    make[1]: Leaving directory `/home/tools/ipvsadm-1.26/libipvs'`
    if [ ! -d /sbin ]; then mkdir -p /sbin; fi
    install -m 0755 ipvsadm /sbin
    install -m 0755 ipvsadm-save /sbin
    install -m 0755 ipvsadm-restore /sbin
    [ -d /usr/man/man8 ] || mkdir -p /usr/man/man8
    install -m 0644 ipvsadm.8 /usr/man/man8
    install -m 0644 ipvsadm-save.8 /usr/man/man8
    install -m 0644 ipvsadm-restore.8 /usr/man/man8
    [ -d /etc/rc.d/init.d ] || mkdir -p /etc/rc.d/init.d
    install -m 0755 ipvsadm.sh /etc/rc.d/init.d/ipvsadm
    [root@lvs_vip_01 ipvsadm-1.26]# 
    [root@lvs_vip_01 ipvsadm-1.26]# 
    [root@lvs_vip_01 ipvsadm-1.26]# lsmod|grep ip_vs
    [root@lvs_vip_01 ipvsadm-1.26]# /sbin/ipvsadm
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    [root@lvs_vip_01 ipvsadm-1.26]# 
    [root@lvs_vip_01 ipvsadm-1.26]# lsmod|grep ip_vs
    ip_vs                 125694  0 
    libcrc32c               1246  1 ip_vs
    ipv6                  334932  270 ip_vs,ip6t_REJECT,nf_conntrack_ipv6,nf_defrag_ipv6
    [root@lvs_vip_01 ipvsadm-1.26]# 
    [root@lvs_vip_01 ipvsadm-1.26]# ifconfig eth0:0 192.168.1.250/24
    [root@lvs_vip_01 ipvsadm-1.26]# ifconfig
    eth0      Link encap:Ethernet  HWaddr 00:0C:29:12:76:B6  
            inet addr:192.168.1.166  Bcast:192.168.161.255  Mask:255.255.255.0
            inet6 addr: fe80::20c:29ff:fe12:76b6/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:14142 errors:0 dropped:0 overruns:0 frame:0
            TX packets:6611 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000 
            RX bytes:19317256 (18.4 MiB)  TX bytes:501456 (489.7 KiB)

    eth0:0    Link encap:Ethernet  HWaddr 00:0C:29:12:76:B6  
            inet addr:192.168.1.250  Bcast:192.168.161.255  Mask:255.255.255.0
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

    lo        Link encap:Local Loopback  
            inet addr:127.0.0.1  Mask:255.0.0.0
            inet6 addr: ::1/128 Scope:Host
            UP LOOPBACK RUNNING  MTU:65536  Metric:1
            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0 
            RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

    [root@lvs_vip_01 ipvsadm-1.26]# ping 192.168.1.250
    PING 192.168.1.250 (192.168.1.250) 56(84) bytes of data.
    64 bytes from 192.168.1.250: icmp_seq=1 ttl=64 time=0.024 ms
    ^C
    --- 192.168.1.250 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 935ms
    rtt min/avg/max/mdev = 0.024/0.024/0.024/0.000 ms
    
    [root@lvs_vip_01 ~]# ipvsadm -L -n
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    [root@lvs_vip_01 ~]# ipvsadm -A -t 192.168.1.250:80 -s rr                
    [root@lvs_vip_01 ~]# ipvsadm -a -t 192.168.1.250:80 -r 192.168.1.187 -m
    [root@lvs_vip_01 ~]# ipvsadm -a -t 192.168.1.250:80 -r 192.168.1.163 -m
    [root@lvs_vip_01 ~]# ipvsadm -L -n
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    TCP  192.168.1.250:80 rr
    -> 192.168.1.187:80           Masq    1      0          0         
    -> 192.168.1.163:80           Masq    1      0          0         
    
    [root@lvs_vip_01 ipvsadm-1.26]#     ntpdate pool.ntp.org
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
        setenforce 0
        /etc/init.d/iptables stop 
        chkconfig iptables off
    2 Nov 03:18:06 ntpdate[1837]: 87.120.166.8 rate limit response from server.
    2 Nov 03:18:06 ntpdate[1837]: 37.247.53.178 rate limit response from server.
    1 Nov 19:18:06 ntpdate[1837]: step time server 87.120.166.8 offset -28800.986290 sec
    [root@lvs_vip_01 ipvsadm-1.26]#     sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    [root@lvs_vip_01 ipvsadm-1.26]#     setenforce 0
    [root@lvs_vip_01 ipvsadm-1.26]#     /etc/init.d/iptables stop 
    iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
    iptables: Flushing firewall rules:                         [  OK  ]
    iptables: Unloading modules:                               [  OK  ]
    [root@lvs_vip_01 ipvsadm-1.26]#     chkconfig iptables off

.. attention::
    有的资料说要开启路由转发。但是我测试没有开启路由转发也可以成功。如果需要开启路由转发，命令：
        




lvs_rip_web01安装配置过程
------------------------------------------------------------------------------------------------------------------------------------------------------

安装配置过程：

.. code-block:: bash
    :linenos:

    [root@lvs_rip_web01 ~]# mkdir /home/tools -p
    [root@lvs_rip_web01 ~]# ll /home
    total 4
    drwxr-xr-x. 2 root root 4096 Nov  2 02:51 tools
    [root@lvs_rip_web01 ~]# lsmod|grep ip_vs
    [root@lvs_rip_web01 ~]# echo '1'>/proc/sys/net/ipv4/ip_forward
    [root@lvs_rip_web01 ~]# cd /home/tools
    [root@lvs_rip_web01 tools]# pwd
    /home/tools
    [root@lvs_rip_web01 tools]# ls
    [root@lvs_rip_web01 tools]# wget http://www.linuxvirtualserver.org/software/kernel-2.6/ipvsadm-1.26.tar.gz
    --2018-11-02 02:55:23--  http://www.linuxvirtualserver.org/software/kernel-2.6/ipvsadm-1.26.tar.gz
    Resolving www.linuxvirtualserver.org... 173.255.202.51, 2600:3c00::f03c:91ff:fe96:fcc2
    Connecting to www.linuxvirtualserver.org|173.255.202.51|:80... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 41700 (41K) [application/x-gzip]
    Saving to: “ipvsadm-1.26.tar.gz”

    100%[===================================================================================================================================>] 41,700       193K/s   in 0.2s    

    2018-11-02 02:55:25 (193 KB/s) - “ipvsadm-1.26.tar.gz” saved [41700/41700]

    [root@lvs_rip_web01 tools]# ls
    ipvsadm-1.26.tar.gz
    [root@lvs_rip_web01 tools]# rpm -qa libnl* popt*
    popt-1.13-7.el6.x86_64
    libnl-1.1.4-2.el6.x86_64

    [root@lvs_rip_web01 tools]# 
    [root@lvs_rip_web01 tools]# yum install libnl* popt* -y
    Loaded plugins: fastestmirror, security
    Setting up Install Process
    Determining fastest mirrors
    * base: mirrors.njupt.edu.cn
    * extras: mirrors.njupt.edu.cn
    * updates: ftp.sjtu.edu.cn
    base                                                                                                                                                  | 3.7 kB     00:00     
    http://mirrors.njupt.edu.cn/centos/6.10/os/x86_64/repodata/1aa8754bde2f3921d67cca4bb70d9f587fb858a24cc3d1f66d3315292a89fc20-primary.sqlite.bz2: [Errno 14] PYCURL ERROR 7 - "couldn't connect to host"
    Trying other mirror.
    base/primary_db                                                                                                                                       | 4.7 MB     00:00     
    extras                                                                                                                                                | 3.4 kB     00:00     
    http://mirrors.njupt.edu.cn/centos/6.10/extras/x86_64/repodata/0eb1b6b805b166a5f14cd3ad42db731169281d059ffbcdb1ebc157c0e4f675cf-primary.sqlite.bz2: [Errno 14] PYCURL ERROR 7 - "couldn't connect to host"
    Trying other mirror.
    extras/primary_db                                                                                                                                     |  26 kB     00:00     
    updates                                                                                                                                               | 3.4 kB     00:00     
    updates/primary_db                                                                                                                                    | 1.9 MB     00:00     
    Package libnl-1.1.4-2.el6.x86_64 already installed and latest version
    Package popt-1.13-7.el6.x86_64 already installed and latest version
    Resolving Dependencies
    --> Running transaction check
    ---> Package libnl-devel.x86_64 0:1.1.4-2.el6 will be installed
    ---> Package libnl3.x86_64 0:3.2.21-8.el6 will be installed
    ---> Package libnl3-cli.x86_64 0:3.2.21-8.el6 will be installed
    ---> Package libnl3-devel.x86_64 0:3.2.21-8.el6 will be installed
    ---> Package libnl3-doc.x86_64 0:3.2.21-8.el6 will be installed
    ---> Package popt-devel.x86_64 0:1.13-7.el6 will be installed
    ---> Package popt-static.x86_64 0:1.13-7.el6 will be installed
    --> Finished Dependency Resolution

    Dependencies Resolved

    =============================================================================================================================================================================
    Package                                      Arch                                   Version                                      Repository                            Size
    =============================================================================================================================================================================
    Installing:
    libnl-devel                                  x86_64                                 1.1.4-2.el6                                  base                                 707 k
    libnl3                                       x86_64                                 3.2.21-8.el6                                 base                                 183 k
    libnl3-cli                                   x86_64                                 3.2.21-8.el6                                 base                                  58 k
    libnl3-devel                                 x86_64                                 3.2.21-8.el6                                 base                                  56 k
    libnl3-doc                                   x86_64                                 3.2.21-8.el6                                 base                                  10 M
    popt-devel                                   x86_64                                 1.13-7.el6                                   base                                  21 k
    popt-static                                  x86_64                                 1.13-7.el6                                   base                                  21 k

    Transaction Summary
    =============================================================================================================================================================================
    Install       7 Package(s)

    Total download size: 11 M
    Installed size: 30 M
    Downloading Packages:
    (1/7): libnl-devel-1.1.4-2.el6.x86_64.rpm                                                                                                             | 707 kB     00:00     
    (2/7): libnl3-3.2.21-8.el6.x86_64.rpm                                                                                                                 | 183 kB     00:00     
    (3/7): libnl3-cli-3.2.21-8.el6.x86_64.rpm                                                                                                             |  58 kB     00:00     
    (4/7): libnl3-devel-3.2.21-8.el6.x86_64.rpm                                                                                                           |  56 kB     00:00     
    (5/7): libnl3-doc-3.2.21-8.el6.x86_64.rpm                                                                                                             |  10 MB     00:02     
    (6/7): popt-devel-1.13-7.el6.x86_64.rpm                                                                                                               |  21 kB     00:00     
    (7/7): popt-static-1.13-7.el6.x86_64.rpm                                                                                                              |  21 kB     00:00     
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Total                                                                                                                                        4.0 MB/s |  11 MB     00:02     
    Running rpm_check_debug
    Running Transaction Test
    Transaction Test Succeeded
    Running Transaction
    Installing : libnl3-3.2.21-8.el6.x86_64                                                                                                                                1/7 
    Installing : libnl3-cli-3.2.21-8.el6.x86_64                                                                                                                            2/7 
    Installing : popt-devel-1.13-7.el6.x86_64                                                                                                                              3/7 
    Installing : popt-static-1.13-7.el6.x86_64                                                                                                                             4/7 
    Installing : libnl3-devel-3.2.21-8.el6.x86_64                                                                                                                          5/7 
    Installing : libnl3-doc-3.2.21-8.el6.x86_64                                                                                                                            6/7 
    Installing : libnl-devel-1.1.4-2.el6.x86_64                                                                                                                            7/7 
    Verifying  : libnl3-devel-3.2.21-8.el6.x86_64                                                                                                                          1/7 
    Verifying  : libnl-devel-1.1.4-2.el6.x86_64                                                                                                                            2/7 
    Verifying  : popt-static-1.13-7.el6.x86_64                                                                                                                             3/7 
    Verifying  : popt-devel-1.13-7.el6.x86_64                                                                                                                              4/7 
    Verifying  : libnl3-cli-3.2.21-8.el6.x86_64                                                                                                                            5/7 
    Verifying  : libnl3-3.2.21-8.el6.x86_64                                                                                                                                6/7 
    Verifying  : libnl3-doc-3.2.21-8.el6.x86_64                                                                                                                            7/7 

    Installed:
    libnl-devel.x86_64 0:1.1.4-2.el6  libnl3.x86_64 0:3.2.21-8.el6     libnl3-cli.x86_64 0:3.2.21-8.el6  libnl3-devel.x86_64 0:3.2.21-8.el6  libnl3-doc.x86_64 0:3.2.21-8.el6 
    popt-devel.x86_64 0:1.13-7.el6    popt-static.x86_64 0:1.13-7.el6 

    Complete!
    [root@lvs_rip_web01 tools]# rpm -qa libnl* popt*
    libnl3-3.2.21-8.el6.x86_64
    libnl3-devel-3.2.21-8.el6.x86_64
    popt-1.13-7.el6.x86_64
    libnl-1.1.4-2.el6.x86_64
    libnl3-cli-3.2.21-8.el6.x86_64
    popt-static-1.13-7.el6.x86_64
    libnl3-doc-3.2.21-8.el6.x86_64
    popt-devel-1.13-7.el6.x86_64
    libnl-devel-1.1.4-2.el6.x86_64
    [root@lvs_rip_web01 tools]# ls
    ipvsadm-1.26.tar.gz
    [root@lvs_rip_web01 tools]# tar -xf ipvsadm-1.26.tar.gz
    [root@lvs_rip_web01 tools]# ls
    ipvsadm-1.26  ipvsadm-1.26.tar.gz
    [root@lvs_rip_web01 tools]# cd ipvsadm-1.26
    [root@lvs_rip_web01 ipvsadm-1.26]# ls
    config_stream.c  contrib  dynamic_array.c  ipvsadm.8  ipvsadm-restore    ipvsadm-save    ipvsadm.sh    ipvsadm.spec.in  Makefile             README      VERSION
    config_stream.h  debian   dynamic_array.h  ipvsadm.c  ipvsadm-restore.8  ipvsadm-save.8  ipvsadm.spec  libipvs          PERSISTENCE_ENGINES  SCHEDULERS
    [root@lvs_rip_web01 ipvsadm-1.26]# make
    make -C libipvs
    make[1]: Entering directory `/home/tools/ipvsadm-1.26/libipvs'`
    gcc -Wall -Wunused -Wstrict-prototypes -g -fPIC -DLIBIPVS_USE_NL  -DHAVE_NET_IP_VS_H -c -o libipvs.o libipvs.c
    gcc -Wall -Wunused -Wstrict-prototypes -g -fPIC -DLIBIPVS_USE_NL  -DHAVE_NET_IP_VS_H -c -o ip_vs_nl_policy.o ip_vs_nl_policy.c
    ar rv libipvs.a libipvs.o ip_vs_nl_policy.o
    ar: creating libipvs.a
    a - libipvs.o
    a - ip_vs_nl_policy.o
    gcc -shared -Wl,-soname,libipvs.so -o libipvs.so libipvs.o ip_vs_nl_policy.o
    make[1]: Leaving directory `/home/tools/ipvsadm-1.26/libipvs'`
    gcc -Wall -Wunused -Wstrict-prototypes -g  -DVERSION=\"1.26\" -DSCHEDULERS=\""rr|wrr|lc|wlc|lblc|lblcr|dh|sh|sed|nq"\" -DPE_LIST=\""sip"\" -DHAVE_POPT -DHAVE_NET_IP_VS_H -c -o ipvsadm.o ipvsadm.c
    ipvsadm.c: In function ‘print_largenum’:
    ipvsadm.c:1383: warning: field width should have type ‘int’, but argument 2 has type ‘size_t’
    gcc -Wall -Wunused -Wstrict-prototypes -g  -DVERSION=\"1.26\" -DSCHEDULERS=\""rr|wrr|lc|wlc|lblc|lblcr|dh|sh|sed|nq"\" -DPE_LIST=\""sip"\" -DHAVE_POPT -DHAVE_NET_IP_VS_H -c -o config_stream.o config_stream.c
    gcc -Wall -Wunused -Wstrict-prototypes -g  -DVERSION=\"1.26\" -DSCHEDULERS=\""rr|wrr|lc|wlc|lblc|lblcr|dh|sh|sed|nq"\" -DPE_LIST=\""sip"\" -DHAVE_POPT -DHAVE_NET_IP_VS_H -c -o dynamic_array.o dynamic_array.c
    gcc -Wall -Wunused -Wstrict-prototypes -g -o ipvsadm ipvsadm.o config_stream.o dynamic_array.o libipvs/libipvs.a -lpopt -lnl
    [root@lvs_rip_web01 ipvsadm-1.26]# echo $?
    0
    [root@lvs_rip_web01 ipvsadm-1.26]# make install
    make -C libipvs
    make[1]: Entering directory `/home/tools/ipvsadm-1.26/libipvs'`
    make[1]: Nothing to be done for `all'.`
    make[1]: Leaving directory `/home/tools/ipvsadm-1.26/libipvs'`
    if [ ! -d /sbin ]; then mkdir -p /sbin; fi
    install -m 0755 ipvsadm /sbin
    install -m 0755 ipvsadm-save /sbin
    install -m 0755 ipvsadm-restore /sbin
    [ -d /usr/man/man8 ] || mkdir -p /usr/man/man8
    install -m 0644 ipvsadm.8 /usr/man/man8
    install -m 0644 ipvsadm-save.8 /usr/man/man8
    install -m 0644 ipvsadm-restore.8 /usr/man/man8
    [ -d /etc/rc.d/init.d ] || mkdir -p /etc/rc.d/init.d
    install -m 0755 ipvsadm.sh /etc/rc.d/init.d/ipvsadm
    [root@lvs_rip_web01 ipvsadm-1.26]# 
    [root@lvs_rip_web01 ipvsadm-1.26]# 
    [root@lvs_rip_web01 ipvsadm-1.26]# lsmod|grep ip_vs
    [root@lvs_rip_web01 ipvsadm-1.26]# /sbin/ipvsadm
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    [root@lvs_rip_web01 ipvsadm-1.26]# 
    [root@lvs_rip_web01 ipvsadm-1.26]# lsmod|grep ip_vs
    ip_vs                 125694  0 
    libcrc32c               1246  1 ip_vs
    ipv6                  334932  270 ip_vs,ip6t_REJECT,nf_conntrack_ipv6,nf_defrag_ipv6
    [root@lvs_rip_web01 ipvsadm-1.26]# route
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    192.168.1.0     *               255.255.255.0   U     0      0        0 eth0
    link-local      *               255.255.0.0     U     1002   0        0 eth0
    default         192.168.1.1     0.0.0.0         UG    0      0        0 eth0
    [root@lvs_rip_web01 ipvsadm-1.26]# route add default gw 192.168.1.166   
    [root@lvs_rip_web01 ipvsadm-1.26]# route del default gw 192.168.1.1
    [root@lvs_rip_web01 ipvsadm-1.26]# route
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    192.168.1.0     *               255.255.255.0   U     0      0        0 eth0
    link-local      *               255.255.0.0     U     1002   0        0 eth0
    default         192.168.1.166   0.0.0.0         UG    0      0        0 eth0
    [root@lvs_rip_web01 ipvsadm-1.26]# ipvsadm -L -n
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    [root@lvs_rip_web01 ipvsadm-1.26]# ifconfig lo:0 192.168.1.250/32
    [root@lvs_rip_web01 ipvsadm-1.26]# 
    [root@lvs_rip_web01 ipvsadm-1.26]# yum install httpd -y
    Loaded plugins: fastestmirror, security
    Setting up Install Process
    Loading mirror speeds from cached hostfile
    * base: mirrors.njupt.edu.cn
    * extras: mirrors.njupt.edu.cn
    * updates: ftp.sjtu.edu.cn
    Resolving Dependencies
    --> Running transaction check
    ---> Package httpd.x86_64 0:2.2.15-69.el6.centos will be installed
    --> Processing Dependency: httpd-tools = 2.2.15-69.el6.centos for package: httpd-2.2.15-69.el6.centos.x86_64
    --> Processing Dependency: apr-util-ldap for package: httpd-2.2.15-69.el6.centos.x86_64
    --> Running transaction check
    ---> Package apr-util-ldap.x86_64 0:1.3.9-3.el6_0.1 will be installed
    ---> Package httpd-tools.x86_64 0:2.2.15-69.el6.centos will be installed
    --> Finished Dependency Resolution

    Dependencies Resolved

    ================================================================================================================================================
    Package                             Arch                         Version                                      Repository                  Size
    ================================================================================================================================================
    Installing:
    httpd                               x86_64                       2.2.15-69.el6.centos                         base                       836 k
    Installing for dependencies:
    apr-util-ldap                       x86_64                       1.3.9-3.el6_0.1                              base                        15 k
    httpd-tools                         x86_64                       2.2.15-69.el6.centos                         base                        81 k

    Transaction Summary
    ================================================================================================================================================
    Install       3 Package(s)

    Total download size: 932 k
    Installed size: 3.2 M
    Downloading Packages:
    (1/3): apr-util-ldap-1.3.9-3.el6_0.1.x86_64.rpm                                                                          |  15 kB     00:00     
    http://mirrors.njupt.edu.cn/centos/6.10/os/x86_64/Packages/httpd-2.2.15-69.el6.centos.x86_64.rpm: [Errno 14] PYCURL ERROR 7 - "couldn't connect to host"
    Trying other mirror.
    (2/3): httpd-2.2.15-69.el6.centos.x86_64.rpm                                                                             | 836 kB     00:00     
    (3/3): httpd-tools-2.2.15-69.el6.centos.x86_64.rpm                                                                       |  81 kB     00:00     
    ------------------------------------------------------------------------------------------------------------------------------------------------
    Total                                                                                                            43 kB/s | 932 kB     00:21     
    Running rpm_check_debug
    Running Transaction Test
    Transaction Test Succeeded
    Running Transaction
    Installing : apr-util-ldap-1.3.9-3.el6_0.1.x86_64                                                                                         1/3 
    Installing : httpd-tools-2.2.15-69.el6.centos.x86_64                                                                                      2/3 
    Installing : httpd-2.2.15-69.el6.centos.x86_64                                                                                            3/3 
    Verifying  : httpd-tools-2.2.15-69.el6.centos.x86_64                                                                                      1/3 
    Verifying  : httpd-2.2.15-69.el6.centos.x86_64                                                                                            2/3 
    Verifying  : apr-util-ldap-1.3.9-3.el6_0.1.x86_64                                                                                         3/3 

    Installed:
    httpd.x86_64 0:2.2.15-69.el6.centos                                                                                                           

    Dependency Installed:
    apr-util-ldap.x86_64 0:1.3.9-3.el6_0.1                                httpd-tools.x86_64 0:2.2.15-69.el6.centos                               

    Complete!
    [root@lvs_rip_web01 ipvsadm-1.26]#     ntpdate pool.ntp.org
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
        setenforce 0
        /etc/init.d/iptables stop 
        chkconfig iptables off
    1 Nov 19:18:07 ntpdate[1732]: step time server 87.120.166.8 offset -28800.933704 sec
    [root@lvs_rip_web01 ipvsadm-1.26]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    [root@lvs_rip_web01 ipvsadm-1.26]# setenforce 0
    [root@lvs_rip_web01 ipvsadm-1.26]# /etc/init.d/iptables stop 
    iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
    iptables: Flushing firewall rules:                         [  OK  ]
    iptables: Unloading modules:                               [  OK  ]
    [root@lvs_rip_web01 ipvsadm-1.26]# chkconfig iptables off
    [root@lvs_rip_web01 ipvsadm-1.26]# sed -i "277i ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf
    [root@lvs_rip_web01 ipvsadm-1.26]# /etc/init.d/httpd start
    Starting httpd:                                            [  OK  ]
    [root@lvs_rip_web01 ipvsadm-1.26]# ll /var/www/html/
    total 0
    [root@lvs_rip_web01 ipvsadm-1.26]# echo '192.168.1.187    this lvs is working'>>/var/www/html/index.html



lvs_rip_web02安装配置过程
------------------------------------------------------------------------------------------------------------------------------------------------------


安装配置过程：

.. code-block:: none
    :linenos:

    [root@lvs_rip_web02 ~]# mkdir /home/tools -p
    [root@lvs_rip_web02 ~]# ll /home
    total 4
    drwxr-xr-x. 2 root root 4096 Nov  2 02:51 tools
    [root@lvs_rip_web02 ~]# lsmod|grep ip_vs
    [root@lvs_rip_web02 ~]# echo '1'>/proc/sys/net/ipv4/ip_forward
    [root@lvs_rip_web02 ~]# cd /home/tools
    [root@lvs_rip_web02 tools]# pwd
    /home/tools
    [root@lvs_rip_web02 tools]# ls
    [root@lvs_rip_web02 tools]# wget http://www.linuxvirtualserver.org/software/kernel-2.6/ipvsadm-1.26.tar.gz
    --2018-11-02 02:55:23--  http://www.linuxvirtualserver.org/software/kernel-2.6/ipvsadm-1.26.tar.gz
    Resolving www.linuxvirtualserver.org... 173.255.202.51, 2600:3c00::f03c:91ff:fe96:fcc2
    Connecting to www.linuxvirtualserver.org|173.255.202.51|:80... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 41700 (41K) [application/x-gzip]
    Saving to: “ipvsadm-1.26.tar.gz”

    100%[===================================================================================================================================>] 41,700       189K/s   in 0.2s    

    2018-11-02 02:55:25 (189 KB/s) - “ipvsadm-1.26.tar.gz” saved [41700/41700]

    [root@lvs_rip_web02 tools]# ls
    ipvsadm-1.26.tar.gz
    [root@lvs_rip_web02 tools]# rpm -qa libnl* popt*
    popt-1.13-7.el6.x86_64
    libnl-1.1.4-2.el6.x86_64

    [root@lvs_rip_web02 tools]# 
    [root@lvs_rip_web02 tools]# yum install libnl* popt* -y
    Loaded plugins: fastestmirror, security
    Setting up Install Process
    Determining fastest mirrors
    * base: mirrors.huaweicloud.com
    * extras: mirrors.huaweicloud.com
    * updates: mirrors.huaweicloud.com
    base                                                                                                                                                  | 3.7 kB     00:00     
    base/primary_db                                                                                                                                       | 4.7 MB     00:00     
    extras                                                                                                                                                | 3.4 kB     00:00     
    extras/primary_db                                                                                                                                     |  26 kB     00:00     
    updates                                                                                                                                               | 3.4 kB     00:00     
    updates/primary_db                                                                                                                                    | 1.9 MB     00:00     
    Package libnl-1.1.4-2.el6.x86_64 already installed and latest version
    Package popt-1.13-7.el6.x86_64 already installed and latest version
    Resolving Dependencies
    --> Running transaction check
    ---> Package libnl-devel.x86_64 0:1.1.4-2.el6 will be installed
    ---> Package libnl3.x86_64 0:3.2.21-8.el6 will be installed
    ---> Package libnl3-cli.x86_64 0:3.2.21-8.el6 will be installed
    ---> Package libnl3-devel.x86_64 0:3.2.21-8.el6 will be installed
    ---> Package libnl3-doc.x86_64 0:3.2.21-8.el6 will be installed
    ---> Package popt-devel.x86_64 0:1.13-7.el6 will be installed
    ---> Package popt-static.x86_64 0:1.13-7.el6 will be installed
    --> Finished Dependency Resolution

    Dependencies Resolved

    =============================================================================================================================================================================
    Package                                      Arch                                   Version                                      Repository                            Size
    =============================================================================================================================================================================
    Installing:
    libnl-devel                                  x86_64                                 1.1.4-2.el6                                  base                                 707 k
    libnl3                                       x86_64                                 3.2.21-8.el6                                 base                                 183 k
    libnl3-cli                                   x86_64                                 3.2.21-8.el6                                 base                                  58 k
    libnl3-devel                                 x86_64                                 3.2.21-8.el6                                 base                                  56 k
    libnl3-doc                                   x86_64                                 3.2.21-8.el6                                 base                                  10 M
    popt-devel                                   x86_64                                 1.13-7.el6                                   base                                  21 k
    popt-static                                  x86_64                                 1.13-7.el6                                   base                                  21 k

    Transaction Summary
    =============================================================================================================================================================================
    Install       7 Package(s)

    Total download size: 11 M
    Installed size: 30 M
    Downloading Packages:
    (1/7): libnl-devel-1.1.4-2.el6.x86_64.rpm                                                                                                             | 707 kB     00:00     
    (2/7): libnl3-3.2.21-8.el6.x86_64.rpm                                                                                                                 | 183 kB     00:00     
    (3/7): libnl3-cli-3.2.21-8.el6.x86_64.rpm                                                                                                             |  58 kB     00:00     
    (4/7): libnl3-devel-3.2.21-8.el6.x86_64.rpm                                                                                                           |  56 kB     00:00     
    (5/7): libnl3-doc-3.2.21-8.el6.x86_64.rpm                                                                                                             |  10 MB     00:02     
    (6/7): popt-devel-1.13-7.el6.x86_64.rpm                                                                                                               |  21 kB     00:00     
    (7/7): popt-static-1.13-7.el6.x86_64.rpm                                                                                                              |  21 kB     00:00     
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Total                                                                                                                                        3.7 MB/s |  11 MB     00:02     
    Running rpm_check_debug
    Running Transaction Test
    Transaction Test Succeeded
    Running Transaction
    Installing : libnl3-3.2.21-8.el6.x86_64                                                                                                                                1/7 
    Installing : libnl3-cli-3.2.21-8.el6.x86_64                                                                                                                            2/7 
    Installing : popt-devel-1.13-7.el6.x86_64                                                                                                                              3/7 
    Installing : popt-static-1.13-7.el6.x86_64                                                                                                                             4/7 
    Installing : libnl3-devel-3.2.21-8.el6.x86_64                                                                                                                          5/7 
    Installing : libnl3-doc-3.2.21-8.el6.x86_64                                                                                                                            6/7 
    Installing : libnl-devel-1.1.4-2.el6.x86_64                                                                                                                            7/7 
    Verifying  : libnl3-devel-3.2.21-8.el6.x86_64                                                                                                                          1/7 
    Verifying  : libnl-devel-1.1.4-2.el6.x86_64                                                                                                                            2/7 
    Verifying  : popt-static-1.13-7.el6.x86_64                                                                                                                             3/7 
    Verifying  : popt-devel-1.13-7.el6.x86_64                                                                                                                              4/7 
    Verifying  : libnl3-cli-3.2.21-8.el6.x86_64                                                                                                                            5/7 
    Verifying  : libnl3-3.2.21-8.el6.x86_64                                                                                                                                6/7 
    Verifying  : libnl3-doc-3.2.21-8.el6.x86_64                                                                                                                            7/7 

    Installed:
    libnl-devel.x86_64 0:1.1.4-2.el6  libnl3.x86_64 0:3.2.21-8.el6     libnl3-cli.x86_64 0:3.2.21-8.el6  libnl3-devel.x86_64 0:3.2.21-8.el6  libnl3-doc.x86_64 0:3.2.21-8.el6 
    popt-devel.x86_64 0:1.13-7.el6    popt-static.x86_64 0:1.13-7.el6 

    Complete!
    [root@lvs_rip_web02 tools]# rpm -qa libnl* popt*
    libnl3-3.2.21-8.el6.x86_64
    libnl3-devel-3.2.21-8.el6.x86_64
    popt-1.13-7.el6.x86_64
    libnl-1.1.4-2.el6.x86_64
    libnl3-cli-3.2.21-8.el6.x86_64
    popt-static-1.13-7.el6.x86_64
    libnl3-doc-3.2.21-8.el6.x86_64
    popt-devel-1.13-7.el6.x86_64
    libnl-devel-1.1.4-2.el6.x86_64
    [root@lvs_rip_web02 tools]# ls
    ipvsadm-1.26.tar.gz
    [root@lvs_rip_web02 tools]# tar -xf ipvsadm-1.26.tar.gz
    [root@lvs_rip_web02 tools]# ls
    ipvsadm-1.26  ipvsadm-1.26.tar.gz
    [root@lvs_rip_web02 tools]# cd ipvsadm-1.26
    [root@lvs_rip_web02 ipvsadm-1.26]# ls
    config_stream.c  contrib  dynamic_array.c  ipvsadm.8  ipvsadm-restore    ipvsadm-save    ipvsadm.sh    ipvsadm.spec.in  Makefile             README      VERSION
    config_stream.h  debian   dynamic_array.h  ipvsadm.c  ipvsadm-restore.8  ipvsadm-save.8  ipvsadm.spec  libipvs          PERSISTENCE_ENGINES  SCHEDULERS
    [root@lvs_rip_web02 ipvsadm-1.26]# make
    make -C libipvs
    make[1]: Entering directory `/home/tools/ipvsadm-1.26/libipvs'`
    gcc -Wall -Wunused -Wstrict-prototypes -g -fPIC -DLIBIPVS_USE_NL  -DHAVE_NET_IP_VS_H -c -o libipvs.o libipvs.c
    gcc -Wall -Wunused -Wstrict-prototypes -g -fPIC -DLIBIPVS_USE_NL  -DHAVE_NET_IP_VS_H -c -o ip_vs_nl_policy.o ip_vs_nl_policy.c
    ar rv libipvs.a libipvs.o ip_vs_nl_policy.o
    ar: creating libipvs.a
    a - libipvs.o
    a - ip_vs_nl_policy.o
    gcc -shared -Wl,-soname,libipvs.so -o libipvs.so libipvs.o ip_vs_nl_policy.o
    make[1]: Leaving directory `/home/tools/ipvsadm-1.26/libipvs'`
    gcc -Wall -Wunused -Wstrict-prototypes -g  -DVERSION=\"1.26\" -DSCHEDULERS=\""rr|wrr|lc|wlc|lblc|lblcr|dh|sh|sed|nq"\" -DPE_LIST=\""sip"\" -DHAVE_POPT -DHAVE_NET_IP_VS_H -c -o ipvsadm.o ipvsadm.c
    ipvsadm.c: In function ‘print_largenum’:
    ipvsadm.c:1383: warning: field width should have type ‘int’, but argument 2 has type ‘size_t’
    gcc -Wall -Wunused -Wstrict-prototypes -g  -DVERSION=\"1.26\" -DSCHEDULERS=\""rr|wrr|lc|wlc|lblc|lblcr|dh|sh|sed|nq"\" -DPE_LIST=\""sip"\" -DHAVE_POPT -DHAVE_NET_IP_VS_H -c -o config_stream.o config_stream.c
    gcc -Wall -Wunused -Wstrict-prototypes -g  -DVERSION=\"1.26\" -DSCHEDULERS=\""rr|wrr|lc|wlc|lblc|lblcr|dh|sh|sed|nq"\" -DPE_LIST=\""sip"\" -DHAVE_POPT -DHAVE_NET_IP_VS_H -c -o dynamic_array.o dynamic_array.c
    gcc -Wall -Wunused -Wstrict-prototypes -g -o ipvsadm ipvsadm.o config_stream.o dynamic_array.o libipvs/libipvs.a -lpopt -lnl
    [root@lvs_rip_web02 ipvsadm-1.26]# echo $?
    0
    [root@lvs_rip_web02 ipvsadm-1.26]# make install
    make -C libipvs
    make[1]: Entering directory `/home/tools/ipvsadm-1.26/libipvs'`
    make[1]: Nothing to be done for `all'.`
    make[1]: Leaving directory `/home/tools/ipvsadm-1.26/libipvs'`
    if [ ! -d /sbin ]; then mkdir -p /sbin; fi
    install -m 0755 ipvsadm /sbin
    install -m 0755 ipvsadm-save /sbin
    install -m 0755 ipvsadm-restore /sbin
    [ -d /usr/man/man8 ] || mkdir -p /usr/man/man8
    install -m 0644 ipvsadm.8 /usr/man/man8
    install -m 0644 ipvsadm-save.8 /usr/man/man8
    install -m 0644 ipvsadm-restore.8 /usr/man/man8
    [ -d /etc/rc.d/init.d ] || mkdir -p /etc/rc.d/init.d
    install -m 0755 ipvsadm.sh /etc/rc.d/init.d/ipvsadm
    [root@lvs_rip_web02 ipvsadm-1.26]# 
    [root@lvs_rip_web02 ipvsadm-1.26]# 
    [root@lvs_rip_web02 ipvsadm-1.26]# lsmod|grep ip_vs
    [root@lvs_rip_web02 ipvsadm-1.26]# /sbin/ipvsadm
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    [root@lvs_rip_web02 ipvsadm-1.26]# 
    [root@lvs_rip_web02 ipvsadm-1.26]# lsmod|grep ip_vs
    ip_vs                 125694  0 
    libcrc32c               1246  1 ip_vs
    ipv6                  334932  270 ip_vs,ip6t_REJECT,nf_conntrack_ipv6,nf_defrag_ipv6
    [root@lvs_rip_web02 ipvsadm-1.26]# route
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    192.168.1.0     *               255.255.255.0   U     0      0        0 eth0
    link-local      *               255.255.0.0     U     1002   0        0 eth0
    default         192.168.1.1     0.0.0.0         UG    0      0        0 eth0
    [root@lvs_rip_web02 ipvsadm-1.26]# route add default gw 192.168.1.166    
    [root@lvs_rip_web02 ipvsadm-1.26]# route del default gw 192.168.1.1
    [root@lvs_rip_web02 ipvsadm-1.26]# route
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    192.168.1.0     *               255.255.255.0   U     0      0        0 eth0
    link-local      *               255.255.0.0     U     1002   0        0 eth0
    default         192.168.1.166   0.0.0.0         UG    0      0        0 eth0
    [root@lvs_rip_web02 ipvsadm-1.26]# ipvsadm -L -n
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    [root@lvs_rip_web02 ipvsadm-1.26]# ifconfig lo:0 192.168.1.250/32
    [root@lvs_rip_web02 ipvsadm-1.26]# 
    [root@lvs_rip_web02 ipvsadm-1.26]# yum install httpd -y
    Loaded plugins: fastestmirror, security
    Setting up Install Process
    Loading mirror speeds from cached hostfile
    * base: mirrors.huaweicloud.com
    * extras: mirrors.huaweicloud.com
    * updates: mirrors.huaweicloud.com
    Resolving Dependencies
    --> Running transaction check
    ---> Package httpd.x86_64 0:2.2.15-69.el6.centos will be installed
    --> Processing Dependency: httpd-tools = 2.2.15-69.el6.centos for package: httpd-2.2.15-69.el6.centos.x86_64
    --> Processing Dependency: apr-util-ldap for package: httpd-2.2.15-69.el6.centos.x86_64
    --> Running transaction check
    ---> Package apr-util-ldap.x86_64 0:1.3.9-3.el6_0.1 will be installed
    ---> Package httpd-tools.x86_64 0:2.2.15-69.el6.centos will be installed
    --> Finished Dependency Resolution

    Dependencies Resolved

    ================================================================================================================================================
    Package                             Arch                         Version                                      Repository                  Size
    ================================================================================================================================================
    Installing:
    httpd                               x86_64                       2.2.15-69.el6.centos                         base                       836 k
    Installing for dependencies:
    apr-util-ldap                       x86_64                       1.3.9-3.el6_0.1                              base                        15 k
    httpd-tools                         x86_64                       2.2.15-69.el6.centos                         base                        81 k

    Transaction Summary
    ================================================================================================================================================
    Install       3 Package(s)

    Total download size: 932 k
    Installed size: 3.2 M
    Downloading Packages:
    (1/3): apr-util-ldap-1.3.9-3.el6_0.1.x86_64.rpm                                                                          |  15 kB     00:00     
    (2/3): httpd-2.2.15-69.el6.centos.x86_64.rpm                                                                             | 836 kB     00:00     
    (3/3): httpd-tools-2.2.15-69.el6.centos.x86_64.rpm                                                                       |  81 kB     00:00     
    ------------------------------------------------------------------------------------------------------------------------------------------------
    Total                                                                                                           2.6 MB/s | 932 kB     00:00     
    Running rpm_check_debug
    Running Transaction Test
    Transaction Test Succeeded
    Running Transaction
    Installing : apr-util-ldap-1.3.9-3.el6_0.1.x86_64                                                                                         1/3 
    Installing : httpd-tools-2.2.15-69.el6.centos.x86_64                                                                                      2/3 
    Installing : httpd-2.2.15-69.el6.centos.x86_64                                                                                            3/3 
    Verifying  : httpd-tools-2.2.15-69.el6.centos.x86_64                                                                                      1/3 
    Verifying  : httpd-2.2.15-69.el6.centos.x86_64                                                                                            2/3 
    Verifying  : apr-util-ldap-1.3.9-3.el6_0.1.x86_64                                                                                         3/3 

    Installed:
    httpd.x86_64 0:2.2.15-69.el6.centos                                                                                                           

    Dependency Installed:
    apr-util-ldap.x86_64 0:1.3.9-3.el6_0.1                                httpd-tools.x86_64 0:2.2.15-69.el6.centos                               

    Complete!
    [root@lvs_rip_web02 ipvsadm-1.26]#     ntpdate pool.ntp.org
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
        setenforce 0
        /etc/init.d/iptables stop 
        chkconfig iptables off
    1 Nov 19:18:08 ntpdate[1629]: step time server 87.120.166.8 offset -28800.981356 sec
    [root@lvs_rip_web02 ipvsadm-1.26]#     sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    [root@lvs_rip_web02 ipvsadm-1.26]#     setenforce 0
    [root@lvs_rip_web02 ipvsadm-1.26]#     /etc/init.d/iptables stop 
    iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
    iptables: Flushing firewall rules:                         [  OK  ]
    iptables: Unloading modules:                               [  OK  ]
    [root@lvs_rip_web02 ipvsadm-1.26]#     chkconfig iptables off
    [root@lvs_rip_web02 ipvsadm-1.26]# sed -i "277i ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf
    [root@lvs_rip_web02 ipvsadm-1.26]# /etc/init.d/httpd start
    Starting httpd:                                            [  OK  ]
    [root@lvs_rip_web02 ipvsadm-1.26]# ll /var/www/html/
    total 0
    [root@lvs_rip_web02 ipvsadm-1.26]# echo '192.168.1.163    this lvs is working'>>/var/www/html/index.html 





测试
======================================================================================================================================================

lvs_vip_01本地测试
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@lvs_vip_01 ipvsadm-1.26]# curl http://192.168.1.163     
    192.168.1.163    this lvs is working
    [root@lvs_vip_01 ipvsadm-1.26]# curl http://192.168.1.187
    192.168.1.187    this lvs is working


lvs_rip_web01本地测试
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@lvs_rip_web01 ipvsadm-1.26]# curl http://192.168.1.187
    192.168.1.187    this lvs is working

lvs_rip_web02本地测试
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@lvs_rip_web02 ipvsadm-1.26]# curl http://192.168.1.163
    192.168.1.163    this lvs is working


抓包分析
------------------------------------------------------------------------------------------------------------------------------------------------------

1. 以下三台服务器都运行相应的命令
    - lvs_vip_01
        tcpdump -i eth0:0 dst port 80
    - lvs_rip_web01
        tcpdump -i eth0 src host 192.168.161.137 or dst host 192.168.161.137
    - lvs_rip_web02
        tcpdump -i eth0 src host 192.168.161.137 or dst host 192.168.161.137
2. 从本地另一个IP为： ``192.168.161.137`` 访问，即运行命令： ``curl http://192.168.1.250``

3. 查看监控的抓包信息：



开机自启动
======================================================================================================================================================


需要编写脚本校验然后开启。也可以结合keepalive做。






















