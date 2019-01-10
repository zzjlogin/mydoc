
.. _rsync-file2file:

======================================================================================================================================================
rsync同一主机不同目录的同步
======================================================================================================================================================


:Date: 2018-10

.. contents::

本地环境
======================================================================================================================================================

=================== ==============================================================
系统版本                CentOS release 6.6 (Final)
------------------- --------------------------------------------------------------
主机名                  rsync_bak_01
------------------- --------------------------------------------------------------
硬件环境                x86_64
------------------- --------------------------------------------------------------
网络配置                eth0(dhcp)：192.168.161.137
------------------- --------------------------------------------------------------
bind软件                rsync-3.0.6-12.el6.x86_64
=================== ==============================================================


rsync本地同步命令
======================================================================================================================================================

.. note::
    同步是源和目标目录都需要以 ``/`` 结尾。如果不以此结尾则会被rsync认为是同步这个目录及目录中的内容。
    
推送源文件到指定目录
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# ll
    total 40
    -rw-------. 1 root root  1139 Oct 20 22:40 anaconda-ks.cfg
    -rw-r--r--. 1 root root 21682 Oct 20 22:40 install.log
    -rw-r--r--. 1 root root  5890 Oct 20 22:39 install.log.syslog
    [root@rsync_bak_01 ~]# pwd
    /root
    [root@rsync_bak_01 ~]# ll /tmp/
    total 0
    -rw-------. 1 root root 0 Oct 20 22:34 yum.log
    [root@rsync_bak_01 ~]# rsync /root/anaconda-ks.cfg /tmp/
    [root@rsync_bak_01 ~]# ll /tmp/
    total 4
    -rw-------  1 root root 1139 Oct 29 03:42 anaconda-ks.cfg
    -rw-------. 1 root root    0 Oct 20 22:34 yum.log

推送源目录所有内容到指定目录
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# ll
    total 40
    -rw-------. 1 root root  1139 Oct 20 22:40 anaconda-ks.cfg
    -rw-r--r--. 1 root root 21682 Oct 20 22:40 install.log
    -rw-r--r--. 1 root root  5890 Oct 20 22:39 install.log.syslog
    [root@rsync_bak_01 ~]# ll /tmp/
    total 4
    -rw-------  1 root root 1139 Oct 29 03:42 anaconda-ks.cfg
    -rw-------. 1 root root    0 Oct 20 22:34 yum.log
    [root@rsync_bak_01 ~]# rsync -avz /root/ /tmp/
    sending incremental file list
    ./
    .bash_history
    .bash_logout
    .bash_profile
    .bashrc
    .cshrc
    .tcshrc
    anaconda-ks.cfg
    install.log
    install.log.syslog

    sent 9049 bytes  received 186 bytes  18470.00 bytes/sec
    total size is 33035  speedup is 3.58
    [root@rsync_bak_01 ~]# ll /tmp/
    total 36
    -rw-------  1 root root  1139 Oct 20 22:40 anaconda-ks.cfg
    -rw-r--r--  1 root root 21682 Oct 20 22:40 install.log
    -rw-r--r--  1 root root  5890 Oct 20 22:39 install.log.syslog
    -rw-------. 1 root root     0 Oct 20 22:34 yum.log
    [root@rsync_bak_01 ~]# ll /root/
    total 40
    -rw-------. 1 root root  1139 Oct 20 22:40 anaconda-ks.cfg
    -rw-r--r--. 1 root root 21682 Oct 20 22:40 install.log
    -rw-r--r--. 1 root root  5890 Oct 20 22:39 install.log.syslog

同步时如果源目录没有则删除目标目录对应内容
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# ll /data
    total 0
    [root@rsync_bak_01 ~]# ll /tmp/
    total 56
    drwxr-xr-x  2 root root  4096 Oct 29 03:47 a
    -rw-------  1 root root  1139 Oct 20 22:40 anaconda-ks.cfg
    drwxr-xr-x  2 root root  4096 Oct 29 03:47 b
    drwxr-xr-x  2 root root  4096 Oct 29 03:47 c
    drwxr-xr-x  2 root root  4096 Oct 29 03:47 d
    -rw-r--r--  1 root root 21682 Oct 20 22:40 install.log
    -rw-r--r--  1 root root  5890 Oct 20 22:39 install.log.syslog
    drwxr-xr-x  2 root root  4096 Oct 29 03:47 test
    -rw-------. 1 root root     0 Oct 20 22:34 yum.log
    [root@rsync_bak_01 ~]# rsync -r --delete /data/ /tmp/
    [root@rsync_bak_01 ~]# ll /tmp/
    total 0



