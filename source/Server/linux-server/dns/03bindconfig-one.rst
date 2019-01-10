.. _dns-bindconfig-one:

======================================================================================================================================================
bind单实例部署
======================================================================================================================================================



:Date: 2018-09

.. contents::


dns服务器环境
======================================================================================================================================================

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


.. note::
    bind安装过程此处略过，参考：
        :ref:`dns-bind-install`




bind配置
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


rndc配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. note::
    默认没有文件 ``/etc/rndc.key`` 也没有 ``/etc/rndc.conf``


.. code-block:: bash
    :linenos:

    [root@dns_01 etc]# pwd
    /etc
    [root@dns_01 etc]# rndc-confgen -a   
    wrote key file "/etc/rndc.key"
    [root@dns_01 etc]# cat rndc.key 
    key "rndc-key" {
            algorithm hmac-md5;
            secret "5gMwPoQw6iumSg9pSFOi4w==";
    };

生成 ``rndc.conf`` 并修改

.. code-block:: bash
    :linenos:

    [root@dns_01 etc]# rndc-confgen >rndc.conf
    [root@dns_01 etc]# cat rndc.conf
    # Start of rndc.conf
    key "rndc-key" {
            algorithm hmac-md5;
            secret "meQGrfOy+mPHOs/CoBDqyQ==";
    };

    options {
            default-key "rndc-key";
            default-server 127.0.0.1;
            default-port 953;
    };
    # End of rndc.conf

    # Use with the following in named.conf, adjusting the allow list as needed:
    # key "rndc-key" {
    #       algorithm hmac-md5;
    #       secret "meQGrfOy+mPHOs/CoBDqyQ==";
    # };
    # 
    # controls {
    #       inet 127.0.0.1 port 953
    #               allow { 127.0.0.1; } keys { "rndc-key"; };
    # };
    # End of named.conf




修改上面内容：

.. code-block:: bash
    :linenos:

    [root@dns_01 etc]# sed -i 's#secret "meQGrfOy+mPHOs/CoBDqyQ==";#secret "5gMwPoQw6iumSg9pSFOi4w==";#' /etc/rndc.conf
    [root@dns_01 etc]# grep 'secret "5gMwPoQw6iumSg9pSFOi4w==";' /etc/rndc.conf
            secret "5gMwPoQw6iumSg9pSFOi4w==";
    #       secret "5gMwPoQw6iumSg9pSFOi4w==";

bind主配置文件修改
------------------------------------------------------------------------------------------------------------------------------------------------------

配置准备：

.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# cd /etc/
    [root@dns_01 etc]# cp named.conf named.conf.`date +%F`
    [root@dns_01 etc]# ll named.conf*
    -rw-r----- 1 root named 979 Oct 20 15:57 named.conf
    -rw-r----- 1 root root  979 Oct 20 16:54 named.conf.2018-10-20
    [root@dns_01 etc]# >named.conf

配置 ``named.conf`` ：

.. tip::
    注意这个配置里面的 ``secret "5gMwPoQw6iumSg9pSFOi4w==";``
    就是上面生成的rndc.key里面的值。也是rndc.conf的值。

.. code-block:: bash
    :linenos:

    [root@dns_01 etc]# cat >>named.conf<<EOF
    > options {
    >     version "1.1.1";
    >     listen-on port 53 {any;};
    >     directory "/var/named/chroot/etc/";
    >     pid-file "/var/named/chroot/var/run/named/named.pid";
    >     allow-query { any; };
    >     dump-file "/var/named/chroot/var/log/binddump.db";
    >     statistics-file "/var/named/chroot/var/log/named_stats";
    >     zone-statistics yes;
    >     memstatistics-file "log/mem_stats";
    >     empty-zones-enable no;
    >     forwarders {
    >         219.146.0.130;
    >         8.8.8.8;
    >     };
    > };
    > 
    > key "rndc-key" {
    >     algorithm hmac-md5;
    >     secret "5gMwPoQw6iumSg9pSFOi4w==";
    > };
    > 
    > controls {
    >     inet 127.0.0.1 port 953
    >     allow { 127.0.0.1; } keys { "rndc-key"; };
    >  };
    > 
    > logging {
    >     channel warning {
    >         file "/var/named/chroot/var/log/dns_warning" versions 10 size 10m;
    >         severity warning;
    >         print-category yes;
    >         print-severity yes;
    >         print-time yes;
    >     };
    >     channel general_dns {
    >         file "/var/named/chroot/var/log/dns_log" versions 10 size 100m;
    >         severity info;
    >         print-category yes;
    >         print-severity yes;
    >         print-time yes;
    >     };
    >     category default {
    >         warning;
    >     };
    >     category queries {
    >         general_dns;
    >     };
    > };
    > 
    > include "/var/named/chroot/etc/view.conf";
    > EOF

上面配置内容：

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
        secret "5gMwPoQw6iumSg9pSFOi4w==";
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

    include "/var/named/chroot/etc/view.conf";


域名解析文件添加配置
------------------------------------------------------------------------------------------------------------------------------------------------------

根据前面named.conf配置文件说明是包含了文件 ``/var/named/chroot/etc/view.conf``
在这个view.conf文件中包含一个新的自己的域名：display.tk，并指定这个域名的配置文件。

.. code-block:: bash
    :linenos:

    [root@dns_01 etc]# cd /var/named/chroot/etc/
    [root@dns_01 etc]# ls
    localtime  named  pki
    [root@dns_01 etc]# cat >>view.conf <<EOF
    > view "View" {
    >     zone "display.tk" {
    >         type    master;
    >         file    "display.tk.zone";
    >         //allow-transfer {
    >         //    192.168.161.137;
    >         //};
    >         //notify  yes;
    >         //also-notify {
    >         //    192.168.161.137;
    >         //};
    >     };
    >     zone "192.168.161.in-addr.arpa" {
    >         type    master;
    >         file    "192.168.161.zone";
    >         //allow-transfer {
    >         //    192.168.161.137;
    >         //};
    >         //notify  yes;
    >         //also-notify {
    >         //    192.168.161.137;
    >         //};
    >     };
    > };
    > EOF

上面配置内容：

.. code-block:: text
    :linenos:

    view "View" {
        zone "display.tk" {
            type    master;
            file    "display.tk.zone";
            //allow-transfer {
            //    192.168.161.134;
            //};
            //notify  yes;
            //also-notify {
            //    192.168.161.134;
            //};
        };
        zone "192.168.161.in-addr.arpa" {
            type    master;
            file    "192.168.161.zone";
            //allow-transfer {
            //    192.168.161.134;
            //};
            //notify  yes;
            //also-notify {
            //    192.168.161.134;
            //};
        };
    };

添加一个display域名配置

.. code-block:: bash
    :linenos:

    [root@dns_01 etc]# vi /var/named/chroot/etc/display.tk.zone

文件中插入下面内容：

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


Serial
    只是一个序号，但这个序号可被用来作为slave与master更新的依据。举例来说，master序号为100但slave序号为90时，那么这个zonefile的资料就会被传送到slave来更新了。由于这个序号代表新旧资料，通常建议可以利用日期来设定。举例来说，上面的资料是在2006/10/20所写的第一次，所以用2006102001作为序号代表！(yyyymmddnn，nn代表这一天是第几次修改)
Refresh
    除了根据Serial来判断新旧之外，我们可以利用这个refresh(更新)命令slave多久进行一次主动更新；
Retry
    如果到了Refresh的时间，但是slave却无法连接到master时，那么在多久之后，slave会再次的主动尝试与主机连线；
Expire
    如果slave一直无法与master连接上，那么经过多久的时间之后，则命令slave不要再连接master了！也就是说，此时我们假设masterDNS可能遇到重大问题而无法上线，则等待系统管理员处理完毕后，再重新来到slaveDNS重新启动bind吧！
Minimun
    这个就有点象是TTL



添加域名反向解析
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@dns_01 etc]# vi 192.168.161.zone

插入下面内容

.. code-block:: text
    :linenos:

    $TTL 3600       ; 1 hour
    @                  IN SOA  op.display.tk. dns.display.tk. (
                                    2004       ; serial
                                    900        ; refresh (15 minutes)
                                    600        ; retry (10 minutes)
                                    86400      ; expire (1 day)
                                    3600       ; minimum (1 hour)
                                    )
                            NS      op.display.tk.
    134     IN      PTR     a.display.tk.

检查配置合法性
------------------------------------------------------------------------------------------------------------------------------------------------------

1. 检查 /etc/named.conf 语法是否有错误

.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# named-checkconf

2. 检查zone配置是否有语法错误

.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# named-checkzone display.tk. /var/named/chroot/etc/display.tk.zone 
    zone display.tk/IN: loaded serial 2000
    OK


测试上面配置
------------------------------------------------------------------------------------------------------------------------------------------------------

测试域名dns服务器的域名： ``op.display.tk``

.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# dig @192.168.161.137 op.display.tk

    ; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.68.rc1.el6_10.1 <<>> @192.168.161.137 op.display.tk
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 26072
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;op.display.tk.                 IN      A

    ;; ANSWER SECTION:
    op.display.tk.          3600    IN      A       1.2.3.4

    ;; AUTHORITY SECTION:
    display.tk.             3600    IN      NS      op.display.tk.

    ;; Query time: 1 msec
    ;; SERVER: 192.168.161.137#53(192.168.161.137)
    ;; WHEN: Sat Oct 27 22:36:54 2018
    ;; MSG SIZE  rcvd: 61


测试域名dns服务器反向解析IP： ``192.168.161.134``

.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# host -t PTR 192.168.161.134 192.168.161.137
    Using domain server:
    Name: 192.168.161.137
    Address: 192.168.161.137#53
    Aliases: 

    Host 134.161.168.192.in-addr.arpa. not found: 3(NXDOMAIN)

DNS做负载均衡
======================================================================================================================================================

负载均衡的原理就是一个域名，对应多个IP，此时用户访问这个域名是会轮询所有IP，每次返回一个。

缺点：
    DNS不能检测域名对应的IP是否存在，只能傻瓜式的直接返回这个IP。

实例：
    为域名display.tk后面的www服务添加两个对应的IP：
        192.168.161.134
        192.168.161.132
    配置过程：
        在上面配置的文件 ``/var/named/chroot/etc/display.tk.zone`` 追加两行。

.. code-block:: text
    :linenos:

    www                 A       192.168.161.134
    www                 A       192.168.161.132
    
此时配置文件 ``/var/named/chroot/etc/display.tk.zone`` 内容如下：

.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# cd /var/named/chroot/etc/
    [root@dns_01 etc]# cat display.tk.zone
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
    [root@dns_01 etc]# echo 'www                 A       192.168.161.134'>>display.tk.zone
    [root@dns_01 etc]# echo 'www                 A       192.168.161.132'>>display.tk.zone
    [root@dns_01 etc]# cat display.tk.zone
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
    www                 A       192.168.161.132

配置生效：

.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# rndc reload
    WARNING: key file (/etc/rndc.key) exists, but using default configuration file (/etc/rndc.conf)
    server reload successful



测试上面配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# host www.display.tk 192.168.161.137     
    Using domain server:
    Name: 192.168.161.137
    Address: 192.168.161.137#53
    Aliases: 

    www.display.tk has address 192.168.161.134
    www.display.tk has address 192.168.161.132

测试域名返回值：

.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# dig @192.168.161.137 www.display.tk

    ; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.68.rc1.el6_10.1 <<>> @192.168.161.137 www.display.tk
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 43925
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 1, ADDITIONAL: 1

    ;; QUESTION SECTION:
    ;www.display.tk.                        IN      A

    ;; ANSWER SECTION:
    www.display.tk.         3600    IN      A       192.168.161.132
    www.display.tk.         3600    IN      A       192.168.161.134

    ;; AUTHORITY SECTION:
    display.tk.             3600    IN      NS      op.display.tk.

    ;; ADDITIONAL SECTION:
    op.display.tk.          3600    IN      A       1.2.3.4

    ;; Query time: 1 msec
    ;; SERVER: 192.168.161.137#53(192.168.161.137)
    ;; WHEN: Sat Oct 27 23:13:16 2018
    ;; MSG SIZE  rcvd: 97

    [root@dns_01 ~]# dig @192.168.161.137 www.display.tk

    ; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.68.rc1.el6_10.1 <<>> @192.168.161.137 www.display.tk
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 22012
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 1, ADDITIONAL: 1

    ;; QUESTION SECTION:
    ;www.display.tk.                        IN      A

    ;; ANSWER SECTION:
    www.display.tk.         3600    IN      A       192.168.161.134
    www.display.tk.         3600    IN      A       192.168.161.132

    ;; AUTHORITY SECTION:
    display.tk.             3600    IN      NS      op.display.tk.

    ;; ADDITIONAL SECTION:
    op.display.tk.          3600    IN      A       1.2.3.4

    ;; Query time: 0 msec
    ;; SERVER: 192.168.161.137#53(192.168.161.137)
    ;; WHEN: Sat Oct 27 23:13:20 2018
    ;; MSG SIZE  rcvd: 97



智能DNS
======================================================================================================================================================


智能DNS会根据用户IP返回同一域名对应的不同IP。

- 根据用户IP分为两个组，每个组访问同一个 ``www.display.tk`` 返回不同的IP。
- 第一组的客户端IP是 ``192.168.161.132`` ，第二组的用户IP是 ``192.168.161.136`` 。
- 第一组用户访问 ``www.display.tk`` 返回IP是 ``192.168.161.134`` ，第二组用户返回的是 ``192.168.161.138``

**配置过程：**

1. 修改主配置文件 ``/var/named/chroot/etc/named.conf``

在主配置文件 ``/var/named/chroot/etc/named.conf`` 最后一行前一行添加下面内容：

.. code-block:: text
    :linenos:

    acl group1 {
        192.168.161.132;
    };

    acl group2 {
        192.168.161.136;
    };

2. 修改配置文件 ``/var/named/chroot/etc/view.conf``

.. note::
    假设goup1中的用户是河北用户，用hb代表，goup2中的用户是山东用户，用sd代表。

先空空这个文件内容：

.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# >/var/named/chroot/etc/view.conf

清空这个文件内容，然后添加下面内容：

.. code-block:: text
    :linenos:

    view "GROUP1" {
        match-clients { group1; };
        zone "display.tk" {
            type master;
            file "hb.display.tk.zone";
        };
    };

    view "GROUP2" {
        match-clients { group2; };
        zone "display.tk" {
            type master;
            file "sd.display.tk.zone";
        };
    };


上面这个配置说明要重新创建两个域名解析文件：
    - /var/named/chroot/etc/hb.display.tk.zone
    - /var/named/chroot/etc/sd.display.tk.zone

.. tip::
    这两个文件名称是上面 ``/var/named/chroot/etc/view.conf`` 中的 ``file`` 指定的。

3. 创建对应的解析文件并配置

创建文件 ``/var/named/chroot/etc/sd.display.tk.zone``

编辑并加入下面内容：

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

创建文件 ``/var/named/chroot/etc/hb.display.tk.zone``

编辑并加入下面内容：

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



测试上面配置
------------------------------------------------------------------------------------------------------------------------------------------------------

模拟河北客户端IP：192.168.161.132，测试：

.. code-block:: bash
    :linenos:

    [root@client_hb_01 ~]# ifconfig eth0|awk -F '[ :]+' '{if(NR==2) print $4}'
    192.168.161.132
    [root@client_hb_01 ~]# dig @192.168.161.137 WWW.display.tk

    ; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.30.rc1.el6 <<>> @192.168.161.137 WWW.display.tk
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 5133
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

    ;; QUESTION SECTION:
    ;WWW.display.tk.                        IN      A

    ;; ANSWER SECTION:
    WWW.display.tk.         3600    IN      A       192.168.161.138

    ;; AUTHORITY SECTION:
    display.tk.             3600    IN      NS      op.display.tk.

    ;; ADDITIONAL SECTION:
    op.display.tk.          3600    IN      A       1.2.3.4

    ;; Query time: 0 msec
    ;; SERVER: 192.168.161.137#53(192.168.161.137)
    ;; WHEN: Sun Oct 28 08:36:44 2018
    ;; MSG SIZE  rcvd: 81

模拟山东客户端IP：192.168.161.136，测试：

.. code-block:: bash
    :linenos:

    [root@client_sd_01 ~]# ifconfig eth0|awk -F '[ :]+' '{if(NR==2) print $4}'
    192.168.161.136
    [root@client_sd_01 ~]# dig @192.168.161.137 WWW.display.tk                

    ; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.30.rc1.el6 <<>> @192.168.161.137 WWW.display.tk
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 53250
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

    ;; QUESTION SECTION:
    ;WWW.display.tk.                        IN      A

    ;; ANSWER SECTION:
    WWW.display.tk.         3600    IN      A       192.168.161.134

    ;; AUTHORITY SECTION:
    display.tk.             3600    IN      NS      op.display.tk.

    ;; ADDITIONAL SECTION:
    op.display.tk.          3600    IN      A       1.2.3.4

    ;; Query time: 0 msec
    ;; SERVER: 192.168.161.137#53(192.168.161.137)
    ;; WHEN: Mon Oct 15 09:56:03 2018
    ;; MSG SIZE  rcvd: 81

named日志
======================================================================================================================================================

``/var/named/chroot/var/log/named_stats`` 日志默认没有，需要运行下面的命令才能生成这个日志文件。

.. code-block:: bash
    :linenos:

    rndc stats




