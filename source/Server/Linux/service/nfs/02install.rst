

==============================================================
nfs安装配置
==============================================================

:Date: 2018-09

.. contents::







安装nfs工具
==============================================================

.. code-block:: bash
    :linenos:

    [root@centos-7 ~]$yum install nfs-utils

    [root@centos-7 ~]# rpm -ql nfs-utils |grep bin 

    [root@centos-7 ~]# rpm -ql nfs-utils |grep systemd


启动服务
==============================================================------

.. code-block:: bash
    :linenos:

    [root@centos-155 yum.repos.d]# rpcinfo
    program version netid     address                service    owner
        100000    4    tcp6      ::.0.111               portmapper superuser
        100000    3    tcp6      ::.0.111               portmapper superuser
        100000    4    udp6      ::.0.111               portmapper superuser
        100000    3    udp6      ::.0.111               portmapper superuser
        100000    4    tcp       0.0.0.0.0.111          portmapper superuser
        100000    3    tcp       0.0.0.0.0.111          portmapper superuser
        100000    2    tcp       0.0.0.0.0.111          portmapper superuser
        100000    4    udp       0.0.0.0.0.111          portmapper superuser
        100000    3    udp       0.0.0.0.0.111          portmapper superuser
        100000    2    udp       0.0.0.0.0.111          portmapper superuser
        100000    4    local     /var/run/rpcbind.sock  portmapper superuser
        100000    3    local     /var/run/rpcbind.sock  portmapper superuser

    [root@centos-155 yum.repos.d]# systemctl start nfs-server 
    [root@centos-155 yum.repos.d]# rpcinfo
    program version netid     address                service    owner
        100000    4    tcp6      ::.0.111               portmapper superuser
        100000    3    tcp6      ::.0.111               portmapper superuser
        100000    4    udp6      ::.0.111               portmapper superuser
        100000    3    udp6      ::.0.111               portmapper superuser
        100000    4    tcp       0.0.0.0.0.111          portmapper superuser
        100000    3    tcp       0.0.0.0.0.111          portmapper superuser
        100000    2    tcp       0.0.0.0.0.111          portmapper superuser
        100000    4    udp       0.0.0.0.0.111          portmapper superuser
        100000    3    udp       0.0.0.0.0.111          portmapper superuser
        100000    2    udp       0.0.0.0.0.111          portmapper superuser
        100000    4    local     /var/run/rpcbind.sock  portmapper superuser
        100000    3    local     /var/run/rpcbind.sock  portmapper superuser
        100024    1    udp       0.0.0.0.224.237        status     29
        100024    1    tcp       0.0.0.0.140.148        status     29
        100024    1    udp6      ::.146.29              status     29
        100024    1    tcp6      ::.188.103             status     29
        100005    1    udp       0.0.0.0.78.80          mountd     superuser
        100005    1    tcp       0.0.0.0.78.80          mountd     superuser
        100005    1    udp6      ::.78.80               mountd     superuser
        100005    1    tcp6      ::.78.80               mountd     superuser
        100005    2    udp       0.0.0.0.78.80          mountd     superuser
        100005    2    tcp       0.0.0.0.78.80          mountd     superuser
        100005    2    udp6      ::.78.80               mountd     superuser
        100005    2    tcp6      ::.78.80               mountd     superuser
        100005    3    udp       0.0.0.0.78.80          mountd     superuser
        100005    3    tcp       0.0.0.0.78.80          mountd     superuser
        100005    3    udp6      ::.78.80               mountd     superuser
        100005    3    tcp6      ::.78.80               mountd     superuser
        100003    3    tcp       0.0.0.0.8.1            nfs        superuser
        100003    4    tcp       0.0.0.0.8.1            nfs        superuser
        100227    3    tcp       0.0.0.0.8.1            nfs_acl    superuser
        100003    3    udp       0.0.0.0.8.1            nfs        superuser
        100003    4    udp       0.0.0.0.8.1            nfs        superuser
        100227    3    udp       0.0.0.0.8.1            nfs_acl    superuser
        100003    3    tcp6      ::.8.1                 nfs        superuser
        100003    4    tcp6      ::.8.1                 nfs        superuser
        100227    3    tcp6      ::.8.1                 nfs_acl    superuser
        100003    3    udp6      ::.8.1                 nfs        superuser
        100003    4    udp6      ::.8.1                 nfs        superuser
        100227    3    udp6      ::.8.1                 nfs_acl    superuser
        100021    1    udp       0.0.0.0.221.211        nlockmgr   superuser
        100021    3    udp       0.0.0.0.221.211        nlockmgr   superuser
        100021    4    udp       0.0.0.0.221.211        nlockmgr   superuser
        100021    1    tcp       0.0.0.0.128.74         nlockmgr   superuser
        100021    3    tcp       0.0.0.0.128.74         nlockmgr   superuser
        100021    4    tcp       0.0.0.0.128.74         nlockmgr   superuser
        100021    1    udp6      ::.194.142             nlockmgr   superuser
        100021    3    udp6      ::.194.142             nlockmgr   superuser
        100021    4    udp6      ::.194.142             nlockmgr   superuser
        100021    1    tcp6      ::.165.168             nlockmgr   superuser
        100021    3    tcp6      ::.165.168             nlockmgr   superuser
        100021    4    tcp6      ::.165.168             nlockmgr   superuser


共享目录
==============================================================----

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
==============================================================----------

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



