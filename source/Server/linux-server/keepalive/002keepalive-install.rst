.. _keepalive-install:

======================================================================================================================================================
keepalive安装
======================================================================================================================================================

:Date: 2018-09

.. contents::



keepalive安装准备
======================================================================================================================================================

创建软连接 ``/usr/src/linux``

.. note::
    - 如果没有目录 ``/usr/src/kernels/2.6.32-504.el6.x86_64/`` 可以安装 ``kernel-devel``
    - 如果有 ``kernels有`` 多个 ``2.6.XX`` 则可以用 ``uname -r`` 然后就知道软连接的目的目录。

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# ln -s /usr/src/kernels/2.6.32-504.el6.x86_64/ /usr/src/linux
    [root@lvs_01 ~]# ll /usr/src/linux
    lrwxrwxrwx. 1 root root 39 Sep  9 22:06 /usr/src/linux -> /usr/src/kernels/2.6.32-504.el6.x86_64/

keepalive源码包下载：

.. code-block:: bash
    :linenos:

    [root@lvs_01 tools]# pwd
    /home/tools
    [root@lvs_01 tools]# wget http://www.keepalived.org/software/keepalived-1.1.19.tar.gz


加压安装：

.. code-block:: bash
    :linenos:

    [root@lvs_01 tools]# tar zxf keepalived-1.1.19.tar.gz
    [root@lvs_01 tools]# yum install openssl openssl-devel -y
    [root@lvs_01 tools]# cd keepalived-1.1.19
    [root@lvs_01 keepalived-1.1.19]# ./configure
    [root@lvs_01 keepalived-1.1.19]# make
    [root@lvs_01 keepalived-1.1.19]# make install





编译安装后的keepalive相关文件目录转移：

.. code-block:: bash
    :linenos:

    [root@lvs_01 keepalived-1.1.19]# cp /usr/local/etc/rc.d/init.d/keepalived /etc/init.d/
    [root@lvs_01 keepalived-1.1.19]# cp /usr/local/etc/sysconfig/keepalived /etc/sysconfig/
    [root@lvs_01 keepalived-1.1.19]# mkdir /etc/keepalived -p
    [root@lvs_01 keepalived-1.1.19]# cp /usr/local/etc/keepalived/keepalived.conf /etc/keepalived
    [root@lvs_01 keepalived-1.1.19]# cp /usr/local/sbin/keepalived /usr/sbin/

keepalive启动及检查

.. code-block:: bash
    :linenos:

    [root@lvs_01 keepalived-1.1.19]# /etc/init.d/keepalived start
    Starting keepalived:                                       [  OK  ]
    [root@lvs_01 keepalived-1.1.19]# ps -ef|grep keep
    root       4611      1  0 23:55 ?        00:00:00 keepalived -D
    root       4613   4611  0 23:55 ?        00:00:00 keepalived -D
    root       4614   4611  0 23:55 ?        00:00:00 keepalived -D
    root       4616   1671  0 23:55 pts/2    00:00:00 grep keep

keepalive单实例配置

.. attention::
    keepalive只可以配置20个实例。

单实例主备的keepalive配置：

主lvs：

.. code-block:: text
    :linenos:

    ! Configuration File for keepalived

    global_defs {
    notification_email {
        login_root@163.com
    }
    notification_email_from Alexandre.Cassen@firewall.loc
    smtp_server 127.0.0.1
    smtp_connect_timeout 30
    router_id LVS_7
    }

    vrrp_instance VI_1 {
        state MASTER
        interface eth0
        virtual_router_id 55
        priority 150
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.161.250
        }
    }

备lvs

.. code-block:: text
    :linenos:

    ! Configuration File for keepalived

    global_defs {
    notification_email {
        login_root@163.com
    }
    notification_email_from Alexandre.Cassen@firewall.loc
    smtp_server 127.0.0.1
    smtp_connect_timeout 30
    router_id LVS_2
    }

    vrrp_instance VI_1 {
        state BACKUP
        interface eth0
        virtual_router_id 55
        priority 100
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.161.250
        }
    }


keepalive日志配置
======================================================================================================================================================


keepalive日志默认写入/var/log/message中

可以配置指定文件接收：

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# vi /etc/sysconfig/keepalived

最后一行内容替换为：

.. code-block:: text
    :linenos:

    KEEPALIVED_OPTIONS="-D -d -S 0"


CentOS5是配置 ``/etc/syslog.conf``

CentOS6配置 ``/etc/rsyslog.conf``

.. code-block:: bash
    :linenos:

    [root@lvs_01 ~]# vi /etc/rsyslog.conf

添加下面内容

.. code-block:: text
    :linenos:

    #save keepalived log to keepalive.log
    local0.*                                                /var/log/keepalive.log

重启rsyslog和keepalive检查日志：

.. code-block:: bash
    :linenos:


    [root@lvs_01 ~]# /etc/init.d/rsyslog restart
    Shutting down system logger:                               [  OK  ]
    Starting system logger:                                    [  OK  ]
    [root@lvs_01 ~]# tail /var/log/keepalive.log 
    [root@lvs_01 ~]# /etc/init.d/keepalived restart
    Stopping keepalived:                                       [  OK  ]
    Starting keepalived:                                       [  OK  ]
    [root@lvs_01 ~]# tail /var/log/keepalive.log   
    Sep 10 00:34:09 lvs_01 Keepalived_healthcheckers: Initializing ipvs 2.6
    Sep 10 00:34:09 lvs_01 Keepalived_healthcheckers: Netlink reflector reports IP 192.168.161.250 added
    Sep 10 00:34:09 lvs_01 Keepalived_healthcheckers: Netlink reflector reports IP 192.168.161.134 added
    Sep 10 00:34:09 lvs_01 Keepalived_healthcheckers: Registering Kernel netlink reflector
    Sep 10 00:34:09 lvs_01 Keepalived_healthcheckers: Registering Kernel netlink command channel
    Sep 10 00:34:09 lvs_01 Keepalived_vrrp: Netlink reflector reports IP 192.168.161.134 added
    Sep 10 00:34:09 lvs_01 Keepalived_vrrp: Registering Kernel netlink reflector
    Sep 10 00:34:09 lvs_01 Keepalived_vrrp: Registering Kernel netlink command channel
    Sep 10 00:34:09 lvs_01 Keepalived_vrrp: Registering gratutious ARP shared channel
    Sep 10 00:34:09 lvs_01 Keepalived_vrrp: Initializing ipvs 2.6

























