.. _dns-bindconfig-others:

======================================================================================================================================================
bind其他配置方式
======================================================================================================================================================

:Date: 2018-09

.. contents::


bind压力测试
======================================================================================================================================================

bind源码包，然后编译安装生成压力测试工具 ``queryperf``

编译生成压力测试工具：

.. code-block:: bash
    :linenos:

    [root@dns_02 etc]# mkdir /data/tools -p
    [root@dns_02 etc]# cd /data/tools/
    [root@dns_02 tools]# wget http://ftp.isc.org/isc/bind9/9.8.2/bind-9.8.2.tar.gz

    [root@dns_02 tools]# tar zxf bind-9.8.2.tar.gz
    [root@dns_02 tools]# cd bind-9.8.2
    [root@dns_02 tools]# cd bind-9.8.2/contrib/queryperf/
    [root@dns_02 queryperf]# ./configure

    [root@dns_02 queryperf]# make && make install

创建压力测试文件，压力测试：

.. code-block:: bash
    :linenos:

    [root@dns_02 queryperf]# echo 'www.display.tk A'>>test.txt
    [root@dns_02 queryperf]# for((i=1; i<=100; i++)); do echo 'www.display.tk A'>>test.txt; done;

    [root@dns_02 queryperf]# ./queryperf -d test.txt 192.168.161.137

    DNS Query Performance Testing Tool
    Version: $Id: queryperf.c,v 1.12 2007/09/05 07:36:04 marka Exp $

    [Status] Processing input data
    [Status] Sending queries (beginning with 127.0.0.1)
    [Status] Testing complete

    Statistics:

    Parse input file:     once
    Ended due to:         reaching end of file

    Queries sent:         101 queries
    Queries completed:    101 queries
    Queries lost:         0 queries
    Queries delayed(?):   0 queries

    RTT max:              0.000793 sec
    RTT min:              0.000004 sec
    RTT average:          0.000274 sec
    RTT std deviation:    0.000202 sec
    RTT out of range:     0 queries

    Percentage completed: 100.00%
    Percentage lost:        0.00%

    Started at:           Sun Oct 28 03:36:55 2018
    Finished at:          Sun Oct 28 03:36:55 2018
    Ran for:              0.003064 seconds

    Queries per second:   32963.446475 qps


压力测试注意事项：
    1. 在多个客户端测试bind服务器，防止一个主机的偶然影响。
    #. 测试中调整测试的数量。(例如：100、1000、5000、10000)
    #. 测试中把bind的域名要尽量都测试。(单个域名、混合各个域名)


nslookup测试

.. code-block:: bash
    :linenos:

    [root@zzjlogin named]# nslookup      # nslookup测试，这个工具和windows环境的使用是一样的。
    > server localhost
    Default server: localhost
    Address: ::1#53
    Default server: localhost
    Address: 127.0.0.1#53
    > www.display.tk
    Server:		localhost
    Address:	::1#53

    Name:	www.display.tk
    Address: 192.168.46.7
    > exit

    