

==============================================================
nfs安装配置
==============================================================

:Date: 2018-09

.. contents::


环境
==============================================================

系统：
    CentOS6.7 64位

nfs软件：
    - 服务端软件：
        1. nfs-utils
        #. portmap
        #. rpcbind
    - 客户端软件：
        1. rpcbind

.. code-block:: bash
    :linenos:

    [root@Server ~]# hostname
    Server
    [root@Server ~]# uname -a
    Linux Server 2.6.32-573.el6.x86_64 #1 SMP Thu Jul 23 15:44:03 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
    [root@Server ~]# uname -r
    2.6.32-573.el6.x86_64
    [root@Server ~]# cat /proc/version
    Linux version 2.6.32-573.el6.x86_64 (mockbuild@c6b9.bsys.dev.centos.org) (gcc version 4.4.7 20120313 (Red Hat 4.4.7-16) (GCC) ) #1 SMP Thu Jul 23 15:44:03 UTC 2015



安装nfs软件包
==============================================================

.. code-block:: bash
    :linenos:

    [root@Server ~]# yum install nfs-utils portmap rpcbind -y

    [root@Server ~]# rpm -qa nfs-utils portmap rpcbind            
    rpcbind-0.2.0-16.el6.x86_64
    nfs-utils-1.2.3-78.el6.x86_64

.. tip::
    yum安装nfs也可以通过软件包组安装，通过 ``yum grouplist``查看nfs的软件包组。
    然后通过命令 ``yum groupinstall "NFS file server"``


启动服务
==============================================================


查看启动服务前的监听服务：

.. code-block:: bash
    :linenos:

    [root@Server ~]# ss -lntu
    Netid  State      Recv-Q Send-Q     Local Address:Port       Peer Address:Port 
    udp    UNCONN     0      0                      *:68                    *:*     
    tcp    LISTEN     0      128                   :::22                   :::*     
    tcp    LISTEN     0      128                    *:22                    *:*     

启动rpcbind并检查监听服务的端口：

.. code-block:: bash
    :linenos:

    [root@Server ~]# /etc/init.d/rpcbind start
    Starting rpcbind:                                          [  OK  ]
    [root@Server ~]# ss -lntu
    Netid  State      Recv-Q Send-Q     Local Address:Port       Peer Address:Port 
    udp    UNCONN     0      0                      *:68                    *:*     
    udp    UNCONN     0      0                      *:736                   *:*     
    udp    UNCONN     0      0                      *:111                   *:*     
    udp    UNCONN     0      0                     :::736                  :::*     
    udp    UNCONN     0      0                     :::111                  :::*     
    tcp    LISTEN     0      128                   :::111                  :::*     
    tcp    LISTEN     0      128                    *:111                   *:*     
    tcp    LISTEN     0      128                   :::22                   :::*     
    tcp    LISTEN     0      128                    *:22                    *:*     


检查rpcbind服务：

.. code-block:: bash
    :linenos:

    [root@Server ~]# rpcinfo -p localhost

启动nfs服务并检查监听端口：

.. code-block:: bash
    :linenos:

    [root@Server ~]# /etc/init.d/nfs start    
    Starting NFS services:                                     [  OK  ]
    Starting NFS quotas:                                       [  OK  ]
    Starting NFS mountd:                                       [  OK  ]
    Starting NFS daemon:                                       [  OK  ]
    Starting RPC idmapd:                                       [  OK  ]
    [root@Server ~]# ss -lntu             
    Netid  State      Recv-Q Send-Q     Local Address:Port       Peer Address:Port 
    udp    UNCONN     0      0                      *:41984                 *:*     
    udp    UNCONN     0      0                      *:2049                  *:*     
    udp    UNCONN     0      0                      *:40119                 *:*     
    udp    UNCONN     0      0                      *:68                    *:*     
    udp    UNCONN     0      0                      *:44244                 *:*     
    udp    UNCONN     0      0                      *:736                   *:*     
    udp    UNCONN     0      0                      *:58723                 *:*     
    udp    UNCONN     0      0                      *:875                   *:*     
    udp    UNCONN     0      0                      *:111                   *:*     
    udp    UNCONN     0      0                     :::2049                 :::*     
    udp    UNCONN     0      0                     :::60162                :::*     
    udp    UNCONN     0      0                     :::51599                :::*     
    udp    UNCONN     0      0                     :::736                  :::*     
    udp    UNCONN     0      0                     :::42223                :::*     
    udp    UNCONN     0      0                     :::111                  :::*     
    udp    UNCONN     0      0                     :::58097                :::*     
    tcp    LISTEN     0      128                   :::35069                :::*     
    tcp    LISTEN     0      64                     *:35041                 *:*     
    tcp    LISTEN     0      64                    :::2049                 :::*     
    tcp    LISTEN     0      64                     *:2049                  *:*     
    tcp    LISTEN     0      128                   :::54628                :::*     
    tcp    LISTEN     0      128                   :::50507                :::*     
    tcp    LISTEN     0      128                    *:875                   *:*     
    tcp    LISTEN     0      128                    *:54478                 *:*     
    tcp    LISTEN     0      128                   :::111                  :::*     
    tcp    LISTEN     0      128                    *:111                   *:*     
    tcp    LISTEN     0      128                    *:52817                 *:*     
    tcp    LISTEN     0      128                    *:55346                 *:*     
    tcp    LISTEN     0      128                   :::22                   :::*     
    tcp    LISTEN     0      128                    *:22                    *:*     
    tcp    LISTEN     0      64                    :::44444                :::*     


nfs服务端配置
==============================================================

nfs服务开机自启动
-------------------------------------------------------------

方法1：

.. code-block:: bash
    :linenos:

    [root@Server ~]# chkconfig nfs on
    [root@Server ~]# chkconfig rpcbind on

方法2：

.. code-block:: bash
    :linenos:

    [root@Server ~]# echo "#######################">>/etc/rc.local
    [root@Server ~]# echo "#add by zzj">>/etc/rc.local            
    [root@Server ~]# echo "#func: start nfs service">>/etc/rc.local 
    [root@Server ~]# echo "/etc/init.d/rpcbind start">>/etc/rc.local
    [root@Server ~]# echo "/etc/init.d/nfs start">>/etc/rc.local    
    [root@Server ~]# tail /etc/rc.local
    # This script will be executed *after* all the other init scripts.
    # You can put your own initialization stuff in here if you don't
    # want to do the full Sys V style init stuff.

    touch /var/lock/subsys/local
    #######################
    #add by zzj
    #func: start nfs service
    /etc/init.d/rpcbind start
    /etc/init.d/nfs start

nfs配置共享目录
-------------------------------------------------------------



共享目录
==============================================================

.. code-block:: bash
    :linenos:

    [root@centos-155 yum.repos.d]# mkdir /data/nfs1
    [root@centos-155 yum.repos.d]# mkdir /data/nfs2
    [root@centos-155 yum.repos.d]# vim /etc/exports
    [root@centos-155 yum.repos.d]# cat /etc/exports
    /data/nfs1 *(rw)
    /data/nfs2 *(rw) 
    [root@centos-155 yum.repos.d]# exportfs -r
    [root@centos-155 yum.repos.d]# cat /etc/export
    cat: /etc/export: No such file or directory

    [root@centos-155 yum.repos.d]# exportfs -v 
    /data/nfs1    	<world>(rw,sync,wdelay,hide,no_subtree_check,sec=sys,secure,root_squash,no_all_squash)
    /data/nfs2    	<world>(rw,sync,wdelay,hide,no_subtree_check,sec=sys,secure,root_squash,no_all_squash)

挂载
==============================================================

.. code-block:: bash
    :linenos:

    [root@centos-152 ~]# showmount -e 192.168.46.155
    Export list for 192.168.46.155:
    /data/nfs2 *
    /data/nfs1 *
    [root@centos-152 ~]# mkdir /mnt/nfs1 
    [root@centos-152 ~]# mkdir /mnt/nfs2
    [root@centos-152 ~]# mount 192.168.46.155:/data/nfs1 /mnt/nfs1
    [root@centos-152 ~]# mount 192.168.46.155:/data/nfs2 /mnt/nfs2

配置文件选项
==============================================================----------

配置nfs服务器共享的本地文件目录：

.. code-block:: bash
    :linenos:

    [root@Server ~]# echo "# share file for xxx by zzjlogin at 20180901" >>/etc/exports
    [root@Server ~]# echo "/data 192.168.0.0/16(rw,sync)" >>/etc/exports
    [root@Server ~]# tail /etc/exports
    # share file for xxx by zzjlogin at 20180901
    /data 192.168.0.0/16(rw,sync)

.. attention::
    nfs服务器共享目录需要在本地有这个目录才可以。否则会共享失败。

重启nfs服务：

.. code-block:: bash
    :linenos:

    [root@Server ~]# /etc/init.d/nfs reload

本地检查共享是否正常：

.. code-block:: bash
    :linenos:

    [root@Server ~]# /etc/init.d/nfs reload
    [root@Server ~]# showmount -e localhost
    Export list for localhost:
    /data 192.168.0.0/16

到此时服务端的配置基本完成。此时可以看客户端是否正常查看到nfs：


自动挂载
==============================================================----------

自动挂载分为2种， 相对路径法和绝对路径法。


相对路径法
   
.. code-block:: bash
    :linenos:

    [root@centos-152 ~]# vim /etc/auto.master
    # 添加一行
    /test          auto.test
    [root@centos-152 ~]# vim /etc/auto.test
    [root@centos-152 ~]# cat /etc/auto.test
    nfs1       -fstype=nfs,vers=3,rw 192.168.46.155:/data/nfs1
    [root@centos-152 ~]# systemctl restart autofs
    [root@centos-152 ~]# ll /test/nfs1
    total 0

绝对路径法



.. code-block:: bash
    :linenos:

    [root@centos-152 ~]# vim /etc/auto.master
    /-         /etc/auto.test2
    [root@centos-152 ~]# vim /etc/auto.test2
    [root@centos-152 ~]# cat /etc/auto.test2
    /data/nfs2      -fstype=nfs,vers=3,rw 192.168.46.155:/data/nfs2
    [root@centos-152 ~]# systemctl restart autofs 
    [root@centos-152 ~]# ll /data/nfs2
    total 0

.. tip:: 添加一行 ``/-         /etc/auto.test2``

nfs实现伪根挂载
==============================================================----------

1. 创建分散的文件夹和文件

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# mkdir /test1/test1 -pv 
    [root@centos-155 ~]# mkdir /test2/test2 -pv 
    [root@centos-155 ~]# mkdir /test3/test3 -pv 

    [root@centos-155 nfsroot]# touch /test1/test1/test1
    [root@centos-155 nfsroot]# touch /test2/test2/test2
    [root@centos-155 nfsroot]# touch /test3/test3/test3

2. 整合到一块

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# mkdir /nfsroot
    [root@centos-155 ~]# cd /nfsroot/
    [root@centos-155 nfsroot]# mkdir test1 test2 test3
    [root@centos-155 nfsroot]# mount /test1/test1 test1 -B
    [root@centos-155 nfsroot]# mount /test2/test2 test2 -B
    [root@centos-155 nfsroot]# mount /test3/test3 test3 -B

3. 导出配置

.. code-block:: bash
    :linenos:

    [root@centos-155 nfsroot]# vim /etc/exports
    [root@centos-155 nfsroot]# cat /etc/exports
    /nfsroot    *(fsid=0,ro,crossmnt)

    /test1/test1 *(ro)
    /test2/test2 *(rw)
    /test3/test3 *(rw)

4. 导出

.. code-block:: bash
    :linenos:

    [root@centos-155 nfsroot]# exportfs -r
    [root@centos-155 nfsroot]# exportfs -v 
    /nfsroot      	<world>(ro,sync,wdelay,hide,crossmnt,no_subtree_check,fsid=0,sec=sys,secure,root_squash,no_all_squash)
    /test1/test1  	<world>(ro,sync,wdelay,hide,no_subtree_check,sec=sys,secure,root_squash,no_all_squash)
    /test2/test2  	<world>(rw,sync,wdelay,hide,no_subtree_check,sec=sys,secure,root_squash,no_all_squash)
    /test3/test3  	<world>(rw,sync,wdelay,hide,no_subtree_check,sec=sys,secure,root_squash,no_all_squash)

5. 另外一个机器测试

.. code-block:: bash
    :linenos:

    [root@centos-152 ~]# mount 192.168.46.155:/ /mnt/nfsroot
    [root@centos-152 ~]# tree /mnt/nfsroot
    /mnt/nfsroot
    ├── test1
    │   └── test1
    ├── test2
    │   └── test2
    └── test3
        └── test3

    3 directories, 3 files

.. note:: 我们使用默认挂载过来使用了nfsnobody的用户的，可以考虑使用setfacl来添加nfsnobody的权限。



