.. _dns-bind-install:

============================================
bind安装使用
============================================

:Date: 2018-09

.. contents::

安装环境
============================================

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
=================== ==============================================================

.. tip::
    - 系统是最小化安装。然后勾选了 ``Debugging Tools`` 和 ``Development tools``
    - bind-libs和bind-utils系统默认已经安装。

bind安装
============================================

.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# yum install bind -y



bind所有程序目录
============================================


查看bind安装目录
--------------------------------------------

.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# rpm -qa bind
    bind-9.8.2-0.68.rc1.el6_10.1.x86_64
    [root@dns_01 ~]# rpm -ql bind
    /etc/NetworkManager/dispatcher.d/13-named
    /etc/logrotate.d/named
    /etc/named
    /etc/named.conf
    /etc/named.iscdlv.key
    /etc/named.rfc1912.zones
    /etc/named.root.key
    /etc/portreserve/named
    /etc/rc.d/init.d/named
    /etc/rndc.conf
    /etc/rndc.key
    /etc/sysconfig/named
    /usr/lib64/bind
    /usr/sbin/arpaname
    /usr/sbin/ddns-confgen
    /usr/sbin/dnssec-dsfromkey
    /usr/sbin/dnssec-keyfromlabel
    /usr/sbin/dnssec-keygen
    /usr/sbin/dnssec-revoke
    /usr/sbin/dnssec-settime
    /usr/sbin/dnssec-signzone
    /usr/sbin/genrandom
    /usr/sbin/isc-hmac-fixup
    /usr/sbin/lwresd
    /usr/sbin/named
    /usr/sbin/named-checkconf
    /usr/sbin/named-checkzone
    /usr/sbin/named-compilezone
    /usr/sbin/named-journalprint
    /usr/sbin/nsec3hash
    /usr/sbin/rndc
    /usr/sbin/rndc-confgen
    /usr/share/doc/bind-9.8.2
    /usr/share/doc/bind-9.8.2/CHANGES
    /usr/share/doc/bind-9.8.2/COPYRIGHT
    /usr/share/doc/bind-9.8.2/Copyright
    /usr/share/doc/bind-9.8.2/README
    /usr/share/doc/bind-9.8.2/arm
    /usr/share/doc/bind-9.8.2/arm/Bv9ARM-book.xml
    /usr/share/doc/bind-9.8.2/arm/Bv9ARM.ch01.html
    /usr/share/doc/bind-9.8.2/arm/Bv9ARM.ch02.html
    /usr/share/doc/bind-9.8.2/arm/Bv9ARM.ch03.html
    /usr/share/doc/bind-9.8.2/arm/Bv9ARM.ch04.html
    /usr/share/doc/bind-9.8.2/arm/Bv9ARM.ch05.html
    /usr/share/doc/bind-9.8.2/arm/Bv9ARM.ch06.html
    /usr/share/doc/bind-9.8.2/arm/Bv9ARM.ch07.html
    /usr/share/doc/bind-9.8.2/arm/Bv9ARM.ch08.html
    /usr/share/doc/bind-9.8.2/arm/Bv9ARM.ch09.html
    /usr/share/doc/bind-9.8.2/arm/Bv9ARM.ch10.html
    /usr/share/doc/bind-9.8.2/arm/Bv9ARM.html
    /usr/share/doc/bind-9.8.2/arm/Bv9ARM.pdf
    /usr/share/doc/bind-9.8.2/arm/Makefile
    /usr/share/doc/bind-9.8.2/arm/Makefile.in
    /usr/share/doc/bind-9.8.2/arm/README-SGML
    /usr/share/doc/bind-9.8.2/arm/dnssec.xml
    /usr/share/doc/bind-9.8.2/arm/isc-logo.eps
    /usr/share/doc/bind-9.8.2/arm/isc-logo.pdf
    /usr/share/doc/bind-9.8.2/arm/latex-fixup.pl
    /usr/share/doc/bind-9.8.2/arm/libdns.xml
    /usr/share/doc/bind-9.8.2/arm/man.arpaname.html
    /usr/share/doc/bind-9.8.2/arm/man.ddns-confgen.html
    /usr/share/doc/bind-9.8.2/arm/man.dig.html
    /usr/share/doc/bind-9.8.2/arm/man.dnssec-dsfromkey.html
    /usr/share/doc/bind-9.8.2/arm/man.dnssec-keyfromlabel.html
    /usr/share/doc/bind-9.8.2/arm/man.dnssec-keygen.html
    /usr/share/doc/bind-9.8.2/arm/man.dnssec-revoke.html
    /usr/share/doc/bind-9.8.2/arm/man.dnssec-settime.html
    /usr/share/doc/bind-9.8.2/arm/man.dnssec-signzone.html
    /usr/share/doc/bind-9.8.2/arm/man.genrandom.html
    /usr/share/doc/bind-9.8.2/arm/man.host.html
    /usr/share/doc/bind-9.8.2/arm/man.isc-hmac-fixup.html
    /usr/share/doc/bind-9.8.2/arm/man.named-checkconf.html
    /usr/share/doc/bind-9.8.2/arm/man.named-checkzone.html
    /usr/share/doc/bind-9.8.2/arm/man.named-journalprint.html
    /usr/share/doc/bind-9.8.2/arm/man.named.html
    /usr/share/doc/bind-9.8.2/arm/man.nsec3hash.html
    /usr/share/doc/bind-9.8.2/arm/man.nsupdate.html
    /usr/share/doc/bind-9.8.2/arm/man.rndc-confgen.html
    /usr/share/doc/bind-9.8.2/arm/man.rndc.conf.html
    /usr/share/doc/bind-9.8.2/arm/man.rndc.html
    /usr/share/doc/bind-9.8.2/arm/managed-keys.xml
    /usr/share/doc/bind-9.8.2/arm/pkcs11.xml
    /usr/share/doc/bind-9.8.2/arm/releaseinfo.xml
    /usr/share/doc/bind-9.8.2/draft
    /usr/share/doc/bind-9.8.2/draft/draft-faltstrom-uri-06.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-6man-text-addr-representation-07.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-behave-address-format-07.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-behave-dns64-11.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsext-axfr-clarify-14.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsext-dns-tcp-requirements-03.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsext-dnssec-bis-updates-12.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsext-dnssec-registry-fixes-06.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsext-ecc-key-07.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsext-interop3597-02.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsext-rfc2671bis-edns0-05.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsext-rfc2672bis-dname-19.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsext-rfc3597-bis-02.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsext-tsig-md5-deprecated-03.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsop-bad-dns-res-05.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsop-dnssec-key-timing-02.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsop-dnssec-trust-history-01.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsop-inaddr-required-07.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsop-name-server-management-reqs-02.txt
    /usr/share/doc/bind-9.8.2/draft/draft-ietf-dnsop-respsize-06.txt
    /usr/share/doc/bind-9.8.2/draft/draft-kato-dnsop-local-zones-00.txt
    /usr/share/doc/bind-9.8.2/draft/draft-kerr-ixfr-only-01.txt
    /usr/share/doc/bind-9.8.2/draft/draft-mekking-dnsop-auto-cpsync-00.txt
    /usr/share/doc/bind-9.8.2/draft/draft-yao-dnsext-bname-04.txt
    /usr/share/doc/bind-9.8.2/draft/update
    /usr/share/doc/bind-9.8.2/misc
    /usr/share/doc/bind-9.8.2/misc/Makefile
    /usr/share/doc/bind-9.8.2/misc/Makefile.in
    /usr/share/doc/bind-9.8.2/misc/dnssec
    /usr/share/doc/bind-9.8.2/misc/format-options.pl
    /usr/share/doc/bind-9.8.2/misc/ipv6
    /usr/share/doc/bind-9.8.2/misc/migration
    /usr/share/doc/bind-9.8.2/misc/migration-4to9
    /usr/share/doc/bind-9.8.2/misc/options
    /usr/share/doc/bind-9.8.2/misc/rfc-compliance
    /usr/share/doc/bind-9.8.2/misc/roadmap
    /usr/share/doc/bind-9.8.2/misc/sdb
    /usr/share/doc/bind-9.8.2/misc/sort-options.pl
    /usr/share/doc/bind-9.8.2/named.conf.default
    /usr/share/doc/bind-9.8.2/rfc
    /usr/share/doc/bind-9.8.2/rfc/index.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1032.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1033.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1034.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1035.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1101.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1122.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1123.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1183.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1348.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1535.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1536.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1537.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1591.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1611.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1612.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1706.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1712.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1750.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1876.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1886.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1912.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1982.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1995.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc1996.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2052.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2104.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2119.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2133.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2136.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2137.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2163.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2168.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2181.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2230.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2308.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2317.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2373.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2374.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2375.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2418.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2535.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2536.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2537.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2538.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2539.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2540.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2541.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2553.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2671.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2672.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2673.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2782.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2825.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2826.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2845.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2874.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2915.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2929.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2930.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc2931.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3007.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3008.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3071.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3090.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3110.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3123.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3152.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3197.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3225.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3226.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3258.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3363.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3364.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3425.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3445.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3467.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3490.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3491.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3492.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3493.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3513.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3596.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3597.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3645.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3655.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3658.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3755.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3757.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3833.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3845.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc3901.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4025.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4033.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4034.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4035.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4074.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4159.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4193.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4255.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4294.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4339.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4343.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4367.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4398.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4408.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4431.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4470.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4471.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4472.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4509.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4634.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4635.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4641.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4648.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4697.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4701.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4892.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4955.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc4956.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc5001.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc5011.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc5155.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc5205.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc5452.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc5507.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc5625.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc5702.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc5933.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc6303.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc6844.txt.caa_rr.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc6844.txt.gz
    /usr/share/doc/bind-9.8.2/rfc/rfc952.txt.gz
    /usr/share/doc/bind-9.8.2/rfc1912.txt
    /usr/share/doc/bind-9.8.2/sample
    /usr/share/doc/bind-9.8.2/sample/etc
    /usr/share/doc/bind-9.8.2/sample/etc/named.conf
    /usr/share/doc/bind-9.8.2/sample/etc/named.rfc1912.zones
    /usr/share/doc/bind-9.8.2/sample/var
    /usr/share/doc/bind-9.8.2/sample/var/named
    /usr/share/doc/bind-9.8.2/sample/var/named/data
    /usr/share/doc/bind-9.8.2/sample/var/named/my.external.zone.db
    /usr/share/doc/bind-9.8.2/sample/var/named/my.internal.zone.db
    /usr/share/doc/bind-9.8.2/sample/var/named/named.ca
    /usr/share/doc/bind-9.8.2/sample/var/named/named.empty
    /usr/share/doc/bind-9.8.2/sample/var/named/named.localhost
    /usr/share/doc/bind-9.8.2/sample/var/named/named.loopback
    /usr/share/doc/bind-9.8.2/sample/var/named/slaves
    /usr/share/doc/bind-9.8.2/sample/var/named/slaves/my.ddns.internal.zone.db
    /usr/share/doc/bind-9.8.2/sample/var/named/slaves/my.slave.internal.zone.db
    /usr/share/man/man1/arpaname.1.gz
    /usr/share/man/man5/named.conf.5.gz
    /usr/share/man/man5/rndc.conf.5.gz
    /usr/share/man/man8/ddns-confgen.8.gz
    /usr/share/man/man8/dnssec-dsfromkey.8.gz
    /usr/share/man/man8/dnssec-keyfromlabel.8.gz
    /usr/share/man/man8/dnssec-keygen.8.gz
    /usr/share/man/man8/dnssec-revoke.8.gz
    /usr/share/man/man8/dnssec-settime.8.gz
    /usr/share/man/man8/dnssec-signzone.8.gz
    /usr/share/man/man8/genrandom.8.gz
    /usr/share/man/man8/isc-hmac-fixup.8.gz
    /usr/share/man/man8/lwresd.8.gz
    /usr/share/man/man8/named-checkconf.8.gz
    /usr/share/man/man8/named-checkzone.8.gz
    /usr/share/man/man8/named-compilezone.8.gz
    /usr/share/man/man8/named-journalprint.8.gz
    /usr/share/man/man8/named.8.gz
    /usr/share/man/man8/nsec3hash.8.gz
    /usr/share/man/man8/rndc-confgen.8.gz
    /usr/share/man/man8/rndc.8.gz
    /var/log/named.log
    /var/named
    /var/named/data
    /var/named/dynamic
    /var/named/named.ca
    /var/named/named.empty
    /var/named/named.localhost
    /var/named/named.loopback
    /var/named/slaves
    /var/run/named

bind主要目录说明
--------------------------------------------

bind配置文件目录
    /etc/

==============================  ==============================================
目录/文件                           说明
------------------------------  ----------------------------------------------
/etc/named                      存放子配置文件，默认是空目录
------------------------------  ----------------------------------------------    
/etc/named.conf                 主配置文件
------------------------------  ----------------------------------------------
/etc/named.iscdlv.key
------------------------------  ----------------------------------------------
/etc/named.rfc1912.zones
------------------------------  ----------------------------------------------
/etc/named.root.key
------------------------------  ----------------------------------------------
/etc/sysconfig/named
------------------------------  ----------------------------------------------
/usr/lib64/bind
------------------------------  ----------------------------------------------
/etc/portreserve/named
==============================  ==============================================

bind启动脚本
    /etc/rc.d/init.d/named

bind域名配置目录
    /var/named/

bind软件包提供的命令目录：
    /usr/sbin/

==============================  ==============================================
/usr/sbin/arpaname
------------------------------  ----------------------------------------------
/usr/sbin/named                     bind主程序
------------------------------  ----------------------------------------------
/usr/sbin/named-checkconf           检查bind配置文件命令
------------------------------  ----------------------------------------------
/usr/sbin/named-checkzone           检查配置的zone区域命令
------------------------------  ----------------------------------------------
/usr/sbin/named-compilezone
------------------------------  ----------------------------------------------
/usr/sbin/named-journalprint
==============================  ==============================================


bind相关模版和文档
    /usr/share/doc/bind-9.8.2/

bind相关的man帮助
    /usr/share/man/man5/named.conf.5.gz


bind配置
============================================

.. note::
    无论是正向解析的域名配置文件还是反向解析的配置文件，都需要包含进主配置域名文件。


bind主配置文件修改
--------------------------------------------

/etc/named.conf

/etc/named.rfc1912.zones

[root@dns_01 ~]# sed -i 's#listen-on port 53 { 127.0.0.1; };#// listen-on port 53 { 127.0.0.1; };#g' /etc/named.conf
[root@dns_01 ~]# sed -i 's#listen-on-v6 port 53 { ::1; };#// listen-on-v6 port 53 { ::1; };#g' /etc/named.conf

[root@dns_01 ~]# sed -i 's#dnssec-enable yes;#dnssec-enable no;#' /etc/named.conf
[root@dns_01 ~]# sed -i 's#dnssec-validation yes;#dnssec-validation no;#' /etc/named.conf




域名解析文件添加配置
--------------------------------------------

添加域名反向解析
--------------------------------------------

域名解析和反向解析文件包含进主配置
--------------------------------------------

[root@dns_01 ~]# echo 'zone "display.tk" IN {'>>/etc/named.rfc1912.zones
[root@dns_01 ~]# echo '        type master;'>>/etc/named.rfc1912.zones  
[root@dns_01 ~]# echo '        file "display.tk.zone";'>>/etc/named.rfc1912.zones
[root@dns_01 ~]# echo '}'>>/etc/named.rfc1912.zones 


检查域名解析文件和反向解析文件语法
--------------------------------------------





bind启动/开机自启动
============================================

启动bind：

.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# /etc/init.d/named start
    Generating /etc/rndc.key:                                  [  OK  ]
    Starting named:                                            [  OK  ]


.. code-block:: bash
    :linenos:

    [root@dns_01 ~]# chkconfig named on



