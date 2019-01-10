
.. _nfs-install:

======================================================================================================================================================
nfs安装配置
======================================================================================================================================================

:Date: 2018-09

.. contents::


环境
======================================================================================================================================================

nfs服务器环境

=================== ==============================================================
系统版本                CentOS release 6.6 (Final)
------------------- --------------------------------------------------------------
主机名                  nfs_01
------------------- --------------------------------------------------------------
硬件环境                x86_64
------------------- --------------------------------------------------------------
网络配置                eth0(dhcp)：192.168.161.137
------------------- --------------------------------------------------------------
nfs软件                 - rpcbind-0.2.0-16.el6.x86_64
                        - nfs-utils-1.2.3-78.el6_10.1.x86_64
=================== ==============================================================


nfs客户端环境


=================== ==============================================================
系统版本                CentOS release 6.6 (Final)
------------------- --------------------------------------------------------------
主机名                  web_01
------------------- --------------------------------------------------------------
硬件环境                x86_64
------------------- --------------------------------------------------------------
网络配置                eth0(dhcp)：192.168.161.134
------------------- --------------------------------------------------------------
nfs软件                 - rpcbind-0.2.0-16.el6.x86_64
                        - nfs-utils-1.2.3-78.el6_10.1.x86_64
=================== ==============================================================


nfs软件：
    1. nfs-utils
    #. portmap
        这是CentOS5.8程序
    #. rpcbind
        这是CentOS6的程序




安装nfs软件包
======================================================================================================================================================

网络时间同步
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    如果时间没有和网络同步，yum安装会报错。
    
    参考:
        :ref:`linux-yuminstallerr-time`

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# date
    Thu Sep  6 21:07:25 CST 2018
    [root@nfs_01 ~]# ntpdate pool.ntp.org
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

    [root@nfs_01 ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    [root@nfs_01 ~]# grep SELINUX /etc/selinux/config
    # SELINUX= can take one of these three values:
    SELINUX=disabled
    # SELINUXTYPE= can take one of these two values:
    SELINUXTYPE=targeted

**临时关闭：**
    下面配置是立即生效，但是系统重启后会失效。

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# getenforce
    Enforcing
    [root@nfs_01 ~]# setenforce 0
    [root@nfs_01 ~]# getenforce
    Permissive




关闭防火墙
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    防火墙一般都是关闭。如果不不关闭，也可以通过配置规则允许所有使用的端口被访问。

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# /etc/init.d/iptables stop 
    iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
    iptables: Flushing firewall rules:                         [  OK  ]
    iptables: Unloading modules:                               [  OK  ]

关闭防火墙开机自启动

.. code-block:: bash
    :linenos:
    
    [root@nfs_01 ~]# chkconfig iptables off


系统准备命令集合
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    ntpdate pool.ntp.org
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    /etc/init.d/iptables stop 
    chkconfig iptables off

nfs安装
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# yum install nfs-utils rpcbind -y
    [root@Server ~]# rpm -qa nfs-utils rpcbind            
    rpcbind-0.2.0-16.el6.x86_64
    nfs-utils-1.2.3-78.el6.x86_64



.. tip::
    yum安装nfs也可以通过软件包组安装，通过 ``yum grouplist``查看nfs的软件包组。
    然后通过命令 ``yum groupinstall "NFS file server"``

nfs依赖包：
    - libgssglue-0.1-11.el6.x86_64
    - libtirpc-0.2.1-15.el6.x86_64
    - python-argparse-1.2.1-2.1.el6.noarch
    - libevent-1.4.13-4.el6.x86_64
    - keyutils-1.4-5.el6.x86_64
    - nfs-utils-lib-1.1.5-13.el6.x86_64


nfs服务器端配置
======================================================================================================================================================


创建nfs共享目录
------------------------------------------------------------------------------------------------------------------------------------------------------

创建专门的nfs服务目录： ``/data/``

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# ll -d /data/
    drwxr-xr-x. 2 root root 4096 Oct 28 23:46 /data/

nfs设置共享目录
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# cat /etc/exports
    [root@nfs_01 ~]# echo '#create nfs share file by zzjlogin on 20181020'>>/etc/exports
    [root@nfs_01 ~]# echo '/data  192.168.161.137/32(rw,sync)'>>/etc/exports
    [root@nfs_01 ~]# cat /etc/exports
    #create nfs share file by zzjlogin on 20181020
    /data  192.168.161.134/32(rw,sync)

设置nfs本地的 ``/data/`` 目录设置允许客户端IP为192.168.161.137的主机写和读操作。并且写操作实时同步到本地。

nfs共享目录权限修改
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# chown -R nfsnobody /data/

.. note::
    上面的nfs共享目录共享设置 ``/etc/exports`` 没有设置客户端访问目录时使用的权限。默认是使用所有来宾用户都
    压缩成nfsnobody这个nfs自带的用户。所以如果要使所有来宾用户具有写权限，需要改这个目录的属主。

.. tip::
    - 一般不会设置这个目录权限777，这样权限过大。
    - 如果发现有的客户端还是不能访问，需要看客户端是否有这个用户。
    - 还有就是客户端这个用户的id和nfs服务器的这个用户的id是否一致。


启动服务
======================================================================================================================================================

nfs启动
------------------------------------------------------------------------------------------------------------------------------------------------------

启动nfs步骤：
    1. 启动rpc服务；
    2. 启动nfs服务。


.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# /etc/init.d/rpcbind start
    Starting rpcbind:                                          [  OK  ]
    [root@nfs_01 ~]# /etc/init.d/nfs start
    Starting NFS services:                                     [  OK  ]
    Starting NFS quotas:                                       [  OK  ]
    Starting NFS mountd:                                       [  OK  ]
    Starting NFS daemon:                                       [  OK  ]
    Starting RPC idmapd:                                       [  OK  ]




nfs开机自启动
------------------------------------------------------------------------------------------------------------------------------------------------------

1. 方法1

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# chkconfig rpcbind on
    [root@nfs_01 ~]# chkconfig nfs on

2. 方法2

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# echo '/etc/init.d/rpcbind start'>> /etc/rc.local^C
    [root@nfs_01 ~]# echo '#add start rpcbind by zzjlogin on 20181010'>>/etc/rc.local
    [root@nfs_01 ~]# echo '/etc/init.d/rpcbind start'>> /etc/rc.local
    [root@nfs_01 ~]# echo '#add start nfs by zzjlogin on 20181010'>>/etc/rc.local       
    [root@nfs_01 ~]# echo '/etc/init.d/nfs start'>> /etc/rc.local



nfs重启
------------------------------------------------------------------------------------------------------------------------------------------------------

nfs重启的方法：
    - 用reload参数重启，这样降低数据丢失的风险。一般建议这样重启
    - 用restart参数重启。这样做比较暴力。一般现在工作中都尽量不这样用。
    - 如果特殊情况发现重启不生效，stop也不生效。可以用kill/killall/pkill来杀掉对应的程序。

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# /etc/init.d/nfs reload



检查nfs服务端口
------------------------------------------------------------------------------------------------------------------------------------------------------

1. nfs监听2049检查

nfs主程序启动前：

.. code-block:: bash
    :linenos:
    
    [root@nfs_01 ~]# ss -lntup|grep 2049

nfs主程序启动后：

.. code-block:: bash
    :linenos:
    
    [root@nfs_01 ~]# ss -lntup|grep 2049
    udp    UNCONN     0      0                      *:2049                  *:*     
    udp    UNCONN     0      0                     :::2049                 :::*     
    tcp    LISTEN     0      64                    :::2049                 :::*     
    tcp    LISTEN     0      64                     *:2049                  *:* 


2. 启动rpcbind并检查监听服务的端口

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# ss -lntup|grep rpc|column -t
    udp  UNCONN  0  0    *:992     *:*   users:(("rpcbind",2089,7))
    udp  UNCONN  0  0    *:43878   *:*   users:(("rpc.mountd",2126,7))
    udp  UNCONN  0  0    *:875     *:*   users:(("rpc.rquotad",2121,3))
    udp  UNCONN  0  0    *:42220   *:*   users:(("rpc.mountd",2126,15))
    udp  UNCONN  0  0    *:111     *:*   users:(("rpcbind",2089,6))
    udp  UNCONN  0  0    *:45733   *:*   users:(("rpc.mountd",2126,11))
    udp  UNCONN  0  0    :::38873  :::*  users:(("rpc.mountd",2126,17))
    udp  UNCONN  0  0    :::992    :::*  users:(("rpcbind",2089,10))
    udp  UNCONN  0  0    :::111    :::*  users:(("rpcbind",2089,9))
    udp  UNCONN  0  0    :::50299  :::*  users:(("rpc.mountd",2126,13))
    udp  UNCONN  0  0    :::49689  :::*  users:(("rpc.mountd",2126,9))
    tcp  LISTEN  0  128  *:43953   *:*   users:(("rpc.mountd",2126,12))
    tcp  LISTEN  0  128  *:52148   *:*   users:(("rpc.mountd",2126,16))
    tcp  LISTEN  0  128  :::57949  :::*  users:(("rpc.mountd",2126,10))
    tcp  LISTEN  0  128  :::48580  :::*  users:(("rpc.mountd",2126,14))
    tcp  LISTEN  0  128  :::54886  :::*  users:(("rpc.mountd",2126,18))
    tcp  LISTEN  0  128  *:48744   *:*   users:(("rpc.mountd",2126,8))
    tcp  LISTEN  0  128  *:875     *:*   users:(("rpc.rquotad",2121,4))
    tcp  LISTEN  0  128  :::111    :::*  users:(("rpcbind",2089,11))
    tcp  LISTEN  0  128  *:111     *:*   users:(("rpcbind",2089,8))

服务说明：
    rpc.rquotad
        nfs磁盘配额管理的进程。
    rpc.mountd
        nfs挂载的时候权限管理校验的进程
    rpcbind
        rpc服务进行
    rpc.statd
        检查nfs文件一致性的进程

.. tip::
    上面进程名具体说明。可以用man来查找帮助。例如： ``man rpc.statd``

检查nfs服务具体参数
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# cat /var/lib/nfs/etab
    /data   192.168.161.134/32(rw,sync,wdelay,hide,nocrossmnt,secure,root_squash,no_all_squash,no_subtree_check,secure_locks,acl,anonuid=65534,anongid=65534,sec=sys,rw,root_squash,no_all_squash)

    [root@nfs_01 ~]# exportfs -v|column -t
    /data  192.168.161.134/32(rw,wdelay,root_squash,no_subtree_check,sec=sys,rw,root_squash,no_all_squash)

检查rpcbind服务
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# rpcinfo -p localhost
    program vers proto   port  service
        100000    4   tcp    111  portmapper
        100000    3   tcp    111  portmapper
        100000    2   tcp    111  portmapper
        100000    4   udp    111  portmapper
        100000    3   udp    111  portmapper
        100000    2   udp    111  portmapper
        100011    1   udp    875  rquotad
        100011    2   udp    875  rquotad
        100011    1   tcp    875  rquotad
        100011    2   tcp    875  rquotad
        100005    1   udp  43410  mountd
        100005    1   tcp  41588  mountd
        100005    2   udp  44023  mountd
        100005    2   tcp  50878  mountd
        100005    3   udp  39297  mountd
        100005    3   tcp  36742  mountd
        100003    2   tcp   2049  nfs
        100003    3   tcp   2049  nfs
        100003    4   tcp   2049  nfs
        100227    2   tcp   2049  nfs_acl
        100227    3   tcp   2049  nfs_acl
        100003    2   udp   2049  nfs
        100003    3   udp   2049  nfs
        100003    4   udp   2049  nfs
        100227    2   udp   2049  nfs_acl
        100227    3   udp   2049  nfs_acl
        100021    1   udp  48318  nlockmgr
        100021    3   udp  48318  nlockmgr
        100021    4   udp  48318  nlockmgr
        100021    1   tcp  36929  nlockmgr
        100021    3   tcp  36929  nlockmgr
        100021    4   tcp  36929  nlockmgr


nfs客户端安装配置
======================================================================================================================================================

nfs客户端安装
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# yum install rpcbind -y

挂载参数配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. tip::
    - fstab配置可以参考： :ref:`fstab-syntax`
    - fstab配置导致的故障及修复可以参考： :ref:`fstab-error`


创建本地挂载目录：

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# mkdir /var/data
    [root@web_01 ~]# ll /var/data/ -d
    drwxr-xr-x. 2 root root 4096 Sep  9 23:36 /var/data/

配置开机挂载：

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# echo '192.168.161.137:/data   /var/data                nfs     rw,hard,intr    0 0'>>/etc/fstab
    [root@web_01 ~]# tail /etc/fstab
    # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
    #
    UUID=aeb38bc0-d01d-4a52-9c87-0c4b775e1103 /                       ext4    defaults        1 1
    UUID=1657cb5a-6975-43ba-96e7-cb8f5647debe /boot                   ext4    defaults        1 2
    UUID=73bf9782-7462-4d25-8ad4-d88f51d8d955 swap                    swap    defaults        0 0
    tmpfs                   /dev/shm                tmpfs   defaults        0 0
    devpts                  /dev/pts                devpts  gid=5,mode=620  0 0
    sysfs                   /sys                    sysfs   defaults        0 0
    proc                    /proc                   proc    defaults        0 0
    192.168.161.137:/data   /var/data                nfs     rw,hard,intr    0 0


开机自动挂载
------------------------------------------------------------------------------------------------------------------------------------------------------

上面一步配置了 ``/etc/fstab`` 这个配置文件会开机自动挂载里面的挂载项。但是要注意以下问题：

1. 要先考虑客户端到nfs服务器端的网络延迟。
    - 这个文件的加载情况不同版本的系统有差异。如果挂载失败可能是这个文件加载的在网络启动之前前，所以挂载肯定失败。
    - 网络延迟如果较大是否影响挂载成功率。
    - 挂载项最后两列都必须是0，防止因为挂载失败导致系统不能启动。

2. 如果配置了这个文件还是挂载失败，可以考虑用mount命令挂载的方式然后配置到开机自启动脚本中： ``/etc/rc.local``

3. 对nfs挂载情况最好做一个监控。


挂载测试
------------------------------------------------------------------------------------------------------------------------------------------------------

挂载测试步骤：
    - 用showmount测试nfs服务器共享目录是否可以检查到。如果检查不到，检查服务器端防火墙和nfs服务状态。
    - 创建nfs客户端本地的挂载点
    - 配置客户端挂载信息
    - 挂载，然后查看挂载信息

.. tip::
    也可用mount直接测试是否可以挂载。mount挂载命令： ``mount -t nfs 192.168.161.137:/data /mnt/``

查看是否可以检测到nfs服务器挂载信息：

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# showmount -e 192.168.161.137
    Export list for 192.168.161.137:
    /data 192.168.161.134/32

挂载之前查看挂载信息：

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# mount
    /dev/sda3 on / type ext4 (rw)
    proc on /proc type proc (rw)
    sysfs on /sys type sysfs (rw)
    devpts on /dev/pts type devpts (rw,gid=5,mode=620)
    tmpfs on /dev/shm type tmpfs (rw,rootcontext="system_u:object_r:tmpfs_t:s0")
    /dev/sda1 on /boot type ext4 (rw)
    none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)

挂载上面配置的 ``/etc/fstab`` 配置中所有挂载信息

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# mount -a

挂载后查看挂载信息

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# mount
    /dev/sda3 on / type ext4 (rw)
    proc on /proc type proc (rw)
    sysfs on /sys type sysfs (rw)
    devpts on /dev/pts type devpts (rw,gid=5,mode=620)
    tmpfs on /dev/shm type tmpfs (rw,rootcontext="system_u:object_r:tmpfs_t:s0")
    /dev/sda1 on /boot type ext4 (rw)
    none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
    192.168.161.137:/data on /var/data type nfs (rw,hard,intr,vers=4,addr=192.168.161.137,clientaddr=192.168.161.134)

读写测试
------------------------------------------------------------------------------------------------------------------------------------------------------

操作之前检查：
    - nfs服务器端目录内容
    - nfs客户端这个挂载目录的内容

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# ll /data/
    total 0

    [root@web_01 ~]# ll /var/data/
    total 0


写入文件测试：
    - 客户端写入后nfs服务器和客户端检查
    - nfs服务器端写入后客户端和nfs服务器端检查

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# touch /var/data/test_wr_client.sh
    [root@web_01 ~]# ll /var/data/
    total 0
    -rw-r--r--. 1 nfsnobody nfsnobody 0 Oct 29  2018 test_wr_client.sh

    [root@nfs_01 ~]# ll /data/
    total 0
    -rw-r--r-- 1 nfsnobody nfsnobody 0 Oct 29 01:14 test_wr_client.sh

.. code-block:: bash
    :linenos:

    [root@nfs_01 ~]# touch /data/test_wr_server.sh
    [root@nfs_01 ~]# ll /data/
    total 0
    -rw-r--r-- 1 nfsnobody nfsnobody 0 Oct 29 01:14 test_wr_client.sh
    -rw-r--r-- 1 root      root      0 Oct 29 01:15 test_wr_server.sh
    [root@web_01 ~]# ll /var/data/
    total 0
    -rw-r--r--. 1 nfsnobody nfsnobody 0 Oct 29  2018 test_wr_client.sh
    -rw-r--r--. 1 root      root      0 Oct 29  2018 test_wr_server.sh

删除文件：

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# rm -rf /var/data/test_wr_client.sh
    [root@web_01 ~]# rm -rf /var/data/test_wr_server.sh
    [root@web_01 ~]# ll /var/data/
    total 0
    [root@nfs_01 ~]# ll /data/
    total 0




nfs客户端优化配置
======================================================================================================================================================


1. CentOS5.8 x86_64优化命令：

.. code-block:: bash
    :linenos:

    mount -t nfs -o noatime,nodiratime,nosuid,noexec,nodev,rw,bg,soft,rsize=32768,wsize=32768 192.168.1.100:/data/ /mnt

2. CentOS6.5 x86_64优化命令：

.. code-block:: bash
    :linenos:

    mount -t nfs -o noatime,nodiratime,nosuid,noexec,nodev,rw,bg,hard,intr,rsize=131072,wsize=131072 192.168.1.100:/data/ /mnt


