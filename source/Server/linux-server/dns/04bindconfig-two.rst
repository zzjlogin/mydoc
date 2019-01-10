.. _dns-bindconfig-two:

======================================================================================================================================================
bind主从配置
======================================================================================================================================================

:Date: 2018-09

.. contents::



主bind配置
======================================================================================================================================================

主bind配置参考 :ref:`dns-bindconfig-one`
完全一致。

主DNS系统环境：

=================== ==============================================================
系统版本                CentOS release 6.6 (Final)
------------------- --------------------------------------------------------------
主机名                  dns_01
------------------- --------------------------------------------------------------
硬件环境                x86_64
------------------- --------------------------------------------------------------
网络配置                eth0(dhcp)：192.168.161.137
------------------- --------------------------------------------------------------
bind软件                - bind-libs-9.8.2-0.68.rc1.el6_10.1.x86_64
                        - bind-utils-9.8.2-0.68.rc1.el6_10.1.x86_64
                        - bind-9.8.2-0.68.rc1.el6_10.1.x86_64
                        - bind-chroot-9.8.2-0.68.rc1.el6_10.1.x86_64
                        - bind-devel-9.8.2-0.68.rc1.el6_10.1.x86_64
=================== ==============================================================




从bind配置
======================================================================================================================================================


=================== ==============================================================
系统版本                CentOS release 6.6 (Final)
------------------- --------------------------------------------------------------
主机名                  dns_02
------------------- --------------------------------------------------------------
硬件环境                x86_64
------------------- --------------------------------------------------------------
网络配置                eth0(dhcp)：192.168.161.134
------------------- --------------------------------------------------------------
bind软件                - bind-libs-9.8.2-0.68.rc1.el6_10.1.x86_64
                        - bind-utils-9.8.2-0.68.rc1.el6_10.1.x86_64
                        - bind-9.8.2-0.68.rc1.el6_10.1.x86_64
                        - bind-chroot-9.8.2-0.68.rc1.el6_10.1.x86_64
                        - bind-devel-9.8.2-0.68.rc1.el6_10.1.x86_64
=================== ==============================================================

.. attention::
    主bind配置过程的 ``/var/named/chroot/etc/view.conf`` 中的注释行(配置前面带 ``//`` )删除前面的注释符。


备bind配置
======================================================================================================================================================

.. note::
    无论是正向解析的域名配置文件还是反向解析的配置文件，都需要包含进主配置域名文件。

bind配置过程包括以下几步骤：
    1. rndc配置，用来远程管理bind；
    #. bind主配置文件 ``/etc/named.conf`` 配置；
    #. 一般会用主配置文件包含子配置文件的方式来分解配置复杂度对配置分层管理。这样易于配置管理维护，且降低配置复杂度；
    #. 权威域名解析文件配置；
    #. 在权威域名解析文件中添加对应的解析记录；
    #. 添加反向解析记录文件并添加反向解析记录。




bind安装后检查
------------------------------------------------------------------------------------------------------------------------------------------------------

安装：
    参考： :ref:`dns-bind-install`


安装完以后检查：


.. code-block:: bash
    :linenos:

    [root@dns_02 ~]# yum install bind bind-devel -y
    [root@dns_02 ~]# rpm -qa bind*
    bind-libs-9.8.2-0.68.rc1.el6_10.1.x86_64
    bind-devel-9.8.2-0.68.rc1.el6_10.1.x86_64
    bind-utils-9.8.2-0.68.rc1.el6_10.1.x86_64
    bind-chroot-9.8.2-0.68.rc1.el6_10.1.x86_64
    bind-9.8.2-0.68.rc1.el6_10.1.x86_64
    [root@dns_02 ~]# chkconfig|grep named
    named           0:off   1:off   2:on    3:on    4:on    5:on    6:off
    [root@dns_02 ~]# /etc/init.d/iptables status
    iptables: Firewall is not running.

备bind服务器rndc配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. note::
    默认没有文件 ``/etc/rndc.key`` 也没有 ``/etc/rndc.conf``


.. code-block:: bash
    :linenos:

    [root@dns_02 etc]# pwd
    /etc
    [root@dns_02 etc]# rndc-confgen >>rndc.conf
    [root@dns_02 etc]# grep secret rndc.conf
            secret "TbfqkuoVT/rt2sCxi1/2TQ==";
    #       secret "TbfqkuoVT/rt2sCxi1/2TQ==";

备bind主配置文件修改
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

[root@dns_02 etc]# cp named.conf named.conf`date +%F`
[root@dns_02 etc]# ll named.conf*
-rw-r-----. 1 root named 984 Nov 20  2015 named.conf
-rw-r-----  1 root root  984 Sep  9 22:49 named.conf2018-10-28

清空配置文件 ``named.conf`` 然后把下面插入这个配置文件：

.. code-block:: text
    :linenos:

    options {
        version "1.1.1";
        listen-on port 53 {any;};
        directory "/var/named/chroot/etc/";
        pid-file "/var/named/chroot/var/run/named/named.pid";
        allow-query { any; };
        dump-file "/var/named/chroot/var/log/binddump.db";
        statistics-file "/var/named/chroot/var/log/named_stats";
        zone-statistics yes;
        memstatistics-file "log/mem_stats";
        empty-zones-enable no;
        forwarders {
            219.146.0.130;
            8.8.8.8;
        };
    };

    key "rndc-key" {
        algorithm hmac-md5;
        secret "TbfqkuoVT/rt2sCxi1/2TQ==";
    };

    controls {
        inet 127.0.0.1 port 953
        allow { 127.0.0.1; } keys { "rndc-key"; };
    };

    logging {
        channel warning {
            file "/var/named/chroot/var/log/dns_warning" versions 10 size 10m;
            severity warning;
            print-category yes;
            print-severity yes;
            print-time yes;
        };
        channel general_dns {
            file "/var/named/chroot/var/log/dns_log" versions 10 size 100m;
            severity info;
            print-category yes;
            print-severity yes;
            print-time yes;
        };
        category default {
            warning;
        };
        category queries {
            general_dns;
        };
    };

    acl group1 {
        192.168.161.132;
    };

    acl group2 {
        192.168.161.136;
    };
    acl group1 {
        192.168.161.132;
    };

    acl group2 {
        192.168.161.136;
    };

    include "/var/named/chroot/etc/view.conf";



备bind包含的view配置文件配置
------------------------------------------------------------------------------------------------------------------------------------------------------

新建配置文件 ``/var/named/chroot/etc/view.conf`` 然后配置内容如下：

.. code-block:: text
    :linenos:

    view "GROUP1" {
        match-clients { group1; };
        zone "display.tk" {
            type    slave;
            masters {192.168.161.137; };
            file "slave.hb.display.tk.zone";
        };
    };

    view "GROUP2" {
        match-clients { group2; };
        zone "display.tk" {
            type    slave;
            masters {192.168.161.137; };
            file "slave.sd.display.tk.zone";
        };
    };



备bind域名配置文件修改
------------------------------------------------------------------------------------------------------------------------------------------------------

[root@dns_02 etc]# pwd
/var/named/chroot/etc

[root@dns_02 etc]# vi slave.sd.display.tk.zone


.. code-block:: text
    :linenos:

    $ORIGIN .
    $TTL 3600       ; 1 hour
    display.tk                  IN SOA  op.display.tk. dns.display.tk. (
                                    2000       ; serial
                                    900        ; refresh (15 minutes)
                                    600        ; retry (10 minutes)
                                    86400      ; expire (1 day)
                                    3600       ; minimum (1 hour)
                                    )
                            NS      op.display.tk.
    $ORIGIN display.tk.
    shanks              A       1.2.3.4
    op                  A       1.2.3.4
    www                 A       192.168.161.134


[root@dns_02 etc]# vi slave.hb.display.tk.zone

.. code-block:: text
    :linenos:

    $ORIGIN .
    $TTL 3600       ; 1 hour
    display.tk                  IN SOA  op.display.tk. dns.display.tk. (
                                    2000       ; serial
                                    900        ; refresh (15 minutes)
                                    600        ; retry (10 minutes)
                                    86400      ; expire (1 day)
                                    3600       ; minimum (1 hour)
                                    )
                            NS      op.display.tk.
    $ORIGIN display.tk.
    shanks              A       1.2.3.4
    op                  A       1.2.3.4
    www                 A       192.168.161.138








测试
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: bash
    :linenos:

    [root@client_sd_01 ~]# ifconfig eth0|awk -F '[ :]+' '{if(NR==2) print $4}'
    192.168.161.136
    [root@client_sd_01 ~]# dig @192.168.161.134 WWW.display.tk

    ; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.30.rc1.el6 <<>> @192.168.161.134 WWW.display.tk
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 42608
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

    ;; QUESTION SECTION:
    ;WWW.display.tk.                        IN      A

    ;; ANSWER SECTION:
    WWW.display.tk.         3600    IN      A       192.168.161.134

    ;; AUTHORITY SECTION:
    display.tk.             3600    IN      NS      op.display.tk.

    ;; ADDITIONAL SECTION:
    op.display.tk.          3600    IN      A       1.2.3.4

    ;; Query time: 1 msec
    ;; SERVER: 192.168.161.134#53(192.168.161.134)
    ;; WHEN: Mon Oct 15 13:10:05 2018
    ;; MSG SIZE  rcvd: 81

.. code-block:: bash
    :linenos:

    [root@client_hb_01 ~]# ifconfig eth0|awk -F '[ :]+' '{if(NR==2) print $4}'
    192.168.161.132
    [root@client_hb_01 ~]# dig @192.168.161.134 WWW.display.tk                

    ; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.30.rc1.el6 <<>> @192.168.161.134 WWW.display.tk
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 56745
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

    ;; QUESTION SECTION:
    ;WWW.display.tk.                        IN      A

    ;; ANSWER SECTION:
    WWW.display.tk.         3600    IN      A       192.168.161.138

    ;; AUTHORITY SECTION:
    display.tk.             3600    IN      NS      op.display.tk.

    ;; ADDITIONAL SECTION:
    op.display.tk.          3600    IN      A       1.2.3.4

    ;; Query time: 1 msec
    ;; SERVER: 192.168.161.134#53(192.168.161.134)
    ;; WHEN: Sun Oct 28 11:49:29 2018
    ;; MSG SIZE  rcvd: 81


named日志
======================================================================================================================================================

``/var/named/chroot/var/log/named_stats`` 日志默认没有，需要运行下面的命令才能生成这个日志文件。

.. code-block:: bash
    :linenos:

    rndc stats


