.. _ab-cmd:

======================================================================================================================================================
ab
======================================================================================================================================================

:Date: 2018-08-29

.. contents::


.. _ab-format:

命令格式
======================================================================================================================================================

命令格式:
    ab [options] [http[s]://]hostname[:port]/path

.. _ab-user:

所属用户
======================================================================================================================================================

命令路径:
    /usr/bin/ab

需要权限:
    普通用户权限即可执行

.. _ab-guid:

使用指导
======================================================================================================================================================

作用：
    ab命令是Apache的Web服务器的性能测试工具，它可以测试安装Web服务器每秒种处理的HTTP请求。

ab命令是软件包 ``httpd-tools`` 提供的工具。

.. tip::
    查看方法：
        ``yum provides */ab``

.. _ab-args:

参数
======================================================================================================================================================

**参数及参数作用：**

\-n requests
    - 用于指定压力测试总共的执行次数。如果没有指定这个参数默认是请求1次。
    - 示例：

.. code-block:: bash
    :linenos:

    [user@centos6 ~]$ ab http://www.baidu.com/index.html      
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking www.baidu.com (be patient).....done


    Server Software:        BWS/1.1--------------------提供服务的软件
    Server Hostname:        www.baidu.com--------------主机名
    Server Port:            80-------------------------端口

    Document Path:          /index.html----------------压力测试的页面
    Document Length:        118719 bytes---------------页面大小

    Concurrency Level:      1--------------------------并发，这个默认是1
    Time taken for tests:   0.107 seconds--------------测试耗时
    Complete requests:      1--------------------------完成的请求次数
    Failed requests:        0--------------------------请求失败次数
    Write errors:           0--------------------------写错误的次数
    Total transferred:      119670 bytes---------------共传输的字节数
    HTML transferred:       118719 bytes---------------传输html页面字符串，应该等于页面大小乘以请求的次数
    Requests per second:    9.34 [#/sec] (mean)--------每秒请求次数
    Time per request:       107.099 [ms] (mean)--------每次请求耗时
    Time per request:       107.099 [ms] (mean, across all concurrent requests)
    Transfer rate:          1091.19 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:       17   17   0.0     17      17
    Processing:    90   90   0.0     90      90
    Waiting:       18   18   0.0     18      18
    Total:        107  107   0.0    107     107

    [user@centos6 ~]$ ab -n 10 http://www.baidu.com/index.html
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking www.baidu.com (be patient).....done


    Server Software:        BWS/1.1
    Server Hostname:        www.baidu.com
    Server Port:            80

    Document Path:          /index.html
    Document Length:        118227 bytes

    Concurrency Level:      1
    Time taken for tests:   1.107 seconds
    Complete requests:      10
    Failed requests:        9
    (Connect: 0, Receive: 0, Length: 9, Exceptions: 0)
    Write errors:           0
    Total transferred:      1194133 bytes
    HTML transferred:       1184545 bytes
    Requests per second:    9.03 [#/sec] (mean)
    Time per request:       110.693 [ms] (mean)
    Time per request:       110.693 [ms] (mean, across all concurrent requests)
    Transfer rate:          1053.50 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:       16   18   1.6     17      22
    Processing:    73   93   9.9     91     105
    Waiting:       18   18   0.6     19      19
    Total:         95  110   8.9    109     122
    WARNING: The median and mean for the waiting time are not within a normal deviation
            These results are probably not that reliable.

    Percentage of the requests served within a certain time (ms)
    50%    109
    66%    109
    75%    121
    80%    122
    90%    122
    95%    122
    98%    122
    99%    122
    100%    122 (longest request)

\-c concurrency
    - 用于指定压力测试的并发数。默认并发是1。
    - 示例：

.. code-block:: bash
    :linenos:

    [user@centos6 ~]$ ab -n 100 https://zzjlogin.github.io/index.html  
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking zzjlogin.github.io (be patient).....done


    Server Software:        GitHub.com
    Server Hostname:        zzjlogin.github.io
    Server Port:            443
    SSL/TLS Protocol:       TLSv1/SSLv3,ECDHE-RSA-AES128-GCM-SHA256,2048,128

    Document Path:          /index.html
    Document Length:        65452 bytes

    Concurrency Level:      1-------------------------并发为1
    Time taken for tests:   139.671 seconds-----------默认并发是1，所以100次请求耗时较长
    Complete requests:      100
    Failed requests:        0
    Write errors:           0
    Total transferred:      6611663 bytes
    HTML transferred:       6545200 bytes
    Requests per second:    0.72 [#/sec] (mean)-------并发为1，所以每秒请求数也比较小
    Time per request:       1396.714 [ms] (mean)
    Time per request:       1396.714 [ms] (mean, across all concurrent requests)
    Transfer rate:          46.23 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:      608  690  33.4    693     749
    Processing:   596  706  78.2    693    1063
    Waiting:      200  229  11.9    230     257
    Total:       1205 1396  93.0   1391    1785

    Percentage of the requests served within a certain time (ms)
    50%   1391
    66%   1416
    75%   1429
    80%   1440
    90%   1478
    95%   1572
    98%   1750
    99%   1785
    100%   1785 (longest request)

    [user@centos6 ~]$ ab -n 100 -c20 https://zzjlogin.github.io/index.html
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking zzjlogin.github.io (be patient).....done


    Server Software:        GitHub.com
    Server Hostname:        zzjlogin.github.io
    Server Port:            443
    SSL/TLS Protocol:       TLSv1/SSLv3,ECDHE-RSA-AES128-GCM-SHA256,2048,128

    Document Path:          /index.html
    Document Length:        65452 bytes

    Concurrency Level:      20-----------------------并发是参数设置的20
    Time taken for tests:   8.678 seconds------------总耗时，并发为20，所以耗时更短
    Complete requests:      100
    Failed requests:        0
    Write errors:           0
    Total transferred:      6611703 bytes------------共传输的数据
    HTML transferred:       6545200 bytes------------html总传输的页面大小，和并发为1时相同
    Requests per second:    11.52 [#/sec] (mean)-----因为并发为20，所以比并发为1时每秒请求次数更多了。
    Time per request:       1735.534 [ms] (mean)
    Time per request:       86.777 [ms] (mean, across all concurrent requests)
    Transfer rate:          744.06 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:      716  751  24.9    747     811
    Processing:   711  746  53.6    735    1001
    Waiting:      236  245   4.0    245     254
    Total:       1437 1497  60.0   1487    1756

    Percentage of the requests served within a certain time (ms)
    50%   1487
    66%   1494
    75%   1502
    80%   1529
    90%   1553
    95%   1680
    98%   1725
    99%   1756
    100%   1756 (longest request)



\-t timelimit
    - 等待响应的最大时间(单位：秒)。默认情况下没有时间限制
    - 示例：

.. code-block:: bash
    :linenos:

    [user@centos6 ~]$ ab -n 100 -t 1 https://zzjlogin.github.io/index.html
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking zzjlogin.github.io (be patient)
    Finished 1 requests


    Server Software:        GitHub.com
    Server Hostname:        zzjlogin.github.io
    Server Port:            443
    SSL/TLS Protocol:       TLSv1/SSLv3,ECDHE-RSA-AES128-GCM-SHA256,2048,128

    Document Path:          /index.html
    Document Length:        65452 bytes

    Concurrency Level:      1
    Time taken for tests:   1.727 seconds
    Complete requests:      1--------------------------设置等待时间1秒，发现请求100次，成功请求只有1次
    Failed requests:        0
    Write errors:           0
    Total transferred:      66117 bytes
    HTML transferred:       65452 bytes
    Requests per second:    0.58 [#/sec] (mean)
    Time per request:       1727.304 [ms] (mean)
    Time per request:       1727.304 [ms] (mean, across all concurrent requests)
    Transfer rate:          37.38 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:      801  801   0.0    801     801
    Processing:   926  926   0.0    926     926
    Waiting:      414  414   0.0    414     414
    Total:       1726 1726   0.0   1726    1726

    [user@centos6 ~]$ ab -n 100 -t 1 http://192.168.1.1/webpages/login.html
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking 192.168.1.1 (be patient)
    Finished 81 requests


    Server Software:        
    Server Hostname:        192.168.1.1
    Server Port:            80

    Document Path:          /webpages/login.html
    Document Length:        73974 bytes

    Concurrency Level:      1
    Time taken for tests:   1.004 seconds
    Complete requests:      81-----------------------局域网测试，请求100次，设置超时时间1秒，最后成功81次
    Failed requests:        0
    Write errors:           0
    Total transferred:      6007851 bytes
    HTML transferred:       5991894 bytes
    Requests per second:    80.65 [#/sec] (mean)
    Time per request:       12.399 [ms] (mean)
    Time per request:       12.399 [ms] (mean, across all concurrent requests)
    Transfer rate:          5841.67 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        1    1   0.1      1       1
    Processing:    10   11   0.7     11      15
    Waiting:        1    1   0.5      1       5
    Total:         11   12   0.7     12      16

    Percentage of the requests served within a certain time (ms)
    50%     12
    66%     12
    75%     13
    80%     13
    90%     13
    95%     14
    98%     14
    99%     16
    100%     16 (longest request)


\-b windowsize
    - TCP发送/接收的缓冲大小(单位：字节,bytes)。
    - 示例：

.. code-block:: bash
    :linenos:

    [user@centos6 ~]$ ab -n 10 -b 100 https://zzjlogin.github.io/index.html
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking zzjlogin.github.io (be patient).....done


    Server Software:        GitHub.com
    Server Hostname:        zzjlogin.github.io
    Server Port:            443
    SSL/TLS Protocol:       TLSv1/SSLv3,ECDHE-RSA-AES128-GCM-SHA256,2048,128

    Document Path:          /index.html
    Document Length:        65452 bytes--------------测试页面比设置的值大，这个测试大几倍

    Concurrency Level:      1
    Time taken for tests:   119.578 seconds----------因为请求的只能接收100bytes，所以每个页面需要分多次传，所以耗时更长。
    Complete requests:      10
    Failed requests:        0
    Write errors:           0
    Total transferred:      661170 bytes
    HTML transferred:       654520 bytes
    Requests per second:    0.08 [#/sec] (mean)
    Time per request:       11957.845 [ms] (mean)
    Time per request:       11957.845 [ms] (mean, across all concurrent requests)
    Transfer rate:          5.40 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:     1081 1210 105.9   1205    1484
    Processing: 10441 10747 242.3  10785   11174
    Waiting:      431  470  24.7    480     506
    Total:      11554 11957 243.3  11951   12407

    Percentage of the requests served within a certain time (ms)
    50%  11951
    66%  11978
    75%  12127
    80%  12213
    90%  12407
    95%  12407
    98%  12407
    99%  12407
    100%  12407 (longest request)
    [user@centos6 ~]$ ab -n 10 -b 10000 https://zzjlogin.github.io/index.html
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking zzjlogin.github.io (be patient).....done


    Server Software:        GitHub.com
    Server Hostname:        zzjlogin.github.io
    Server Port:            443
    SSL/TLS Protocol:       TLSv1/SSLv3,ECDHE-RSA-AES128-GCM-SHA256,2048,128

    Document Path:          /index.html
    Document Length:        65452 bytes

    Concurrency Level:      1
    Time taken for tests:   22.891 seconds------------这个设置的缓存接收范围比较大，所以耗时较短
    Complete requests:      10
    Failed requests:        0
    Write errors:           0
    Total transferred:      661170 bytes
    HTML transferred:       654520 bytes
    Requests per second:    0.44 [#/sec] (mean)
    Time per request:       2289.149 [ms] (mean)
    Time per request:       2289.149 [ms] (mean, across all concurrent requests)
    Transfer rate:          28.21 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:      673  748  36.2    764     783
    Processing:  1447 1541  97.2   1530    1767
    Waiting:      227  245  11.3    246     262
    Total:       2130 2288 119.7   2290    2539

    Percentage of the requests served within a certain time (ms)
    50%   2290
    66%   2298
    75%   2307
    80%   2418
    90%   2539
    95%   2539
    98%   2539
    99%   2539
    100%   2539 (longest request)


\-p postfile
    - 发送POST请求时需要上传的文件，此外还必须设置-T参数。
    - 示例：

.. code-block:: bash
    :linenos:


\-u putfile
    - 发送PUT请求时需要上传的文件，此外还必须设置-T参数。
    - 示例：

.. code-block:: bash
    :linenos:

\-T content-type
    - 用于设置Content-Type请求头信息，例如：application/x-www-form-urlencoded，默认值为text/plain。
    - 示例：

.. code-block:: bash
    :linenos:

\-v verbosity
    - 指定打印帮助信息的冗余级别。默认是1
    - 4是打印头信息，3是打印相应状态码(例如200、404)，2是打印警告和通知信息
    - 示例：

.. code-block:: bash
    :linenos:

    [user@centos6 ~]$ ab -v 3 https://zzjlogin.github.io/index.html
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking zzjlogin.github.io (be patient)...INFO: POST header == 
    ---
    GET /index.html HTTP/1.0
    Host: zzjlogin.github.io
    User-Agent: ApacheBench/2.3
    Accept: */*

    省略下面输出内容


\-w
    - 以HTML表格形式打印结果。默认表宽两列，背景为白色。
    - 示例：

.. code-block:: bash
    :linenos:

    [user@centos6 ~]$ ab -w https://zzjlogin.github.io/index.html   
    <p>
    This is ApacheBench, Version 2.3 <i>&lt;$Revision: 655654 $&gt;</i><br>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/<br>
    Licensed to The Apache Software Foundation, http://www.apache.org/<br>
    </p>

\-i
    - 使用HEAD请求代替GET请求。
    - 示例：

.. code-block:: bash
    :linenos:

    [user@centos6 ~]$ ab -i https://zzjlogin.github.io/index.html
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking zzjlogin.github.io (be patient).....done


    Server Software:        GitHub.com
    Server Hostname:        zzjlogin.github.io
    Server Port:            443
    SSL/TLS Protocol:       TLSv1/SSLv3,ECDHE-RSA-AES128-GCM-SHA256,2048,128

    Document Path:          /index.html
    Document Length:        0 bytes

    Concurrency Level:      1
    Time taken for tests:   0.956 seconds
    Complete requests:      1
    Failed requests:        0
    Write errors:           0
    Total transferred:      665 bytes
    HTML transferred:       0 bytes
    Requests per second:    1.05 [#/sec] (mean)
    Time per request:       956.310 [ms] (mean)
    Time per request:       956.310 [ms] (mean, across all concurrent requests)
    Transfer rate:          0.68 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:      722  722   0.0    722     722
    Processing:   235  235   0.0    235     235
    Waiting:      234  234   0.0    234     234
    Total:        956  956   0.0    956     956

\-x <table>-attributes
    - 插入字符串作为table标签的属性。-y插入字符串作为tr标签的属性。
    - 示例：

.. code-block:: bash
    :linenos:

    [user@centos6 ~]$ ab -w https://zzjlogin.github.io/index.html          
    <p>
    This is ApacheBench, Version 2.3 <i>&lt;$Revision: 655654 $&gt;</i><br>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/<br>
    Licensed to The Apache Software Foundation, http://www.apache.org/<br>
    </p>
    <p>
    ..done


    <table >
    下面内容略

    [user@centos6 ~]$ ab -x test https://zzjlogin.github.io/index.html
    <p>
    This is ApacheBench, Version 2.3 <i>&lt;$Revision: 655654 $&gt;</i><br>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/<br>
    Licensed to The Apache Software Foundation, http://www.apache.org/<br>
    </p>
    <p>
    ..done


    <table test>
    下面内容略

\-y attributes
    - 插入字符串作为tr标签的属性。
    - 示例：

.. code-block:: bash
    :linenos:


\-z attributes
    - 插入字符串作为td标签的属性。
    - 示例：

.. code-block:: bash
    :linenos:


\-C attributes
    - 添加cookie信息，例如："Apache=1234"(可以重复该参数选项以添加多个)。
    - cookie格式：name=value，这种名称和值成对出现。
    - 示例：

.. code-block:: bash
    :linenos:


\-H attributes
    - 添加任意的请求头，请求头将会添加在现有的多个请求头之后(可以重复该参数选项以添加多个)。
    - 值时冒号分割的键值对，例如： ``Accept-Encoding: gzip`` 或者 ``Accept-Encoding: zip/zop;8bit`` 
    - 示例：

.. code-block:: bash
    :linenos:


\-A auth-username:password
    - 添加一个基本的网络认证信息，用户名和密码之间用英文冒号隔开。
    - 示例：


\-P proxy-auth-username:password
    - 添加一个基本的代理认证信息，用户名和密码之间用英文冒号隔开。
    - 示例：

.. code-block:: bash
    :linenos:


\-X proxy:port
    - 指定使用的代理服务器和端口号，例如:"126.10.10.3:88"。
    - 示例：

.. code-block:: bash
    :linenos:


\-V
    - 打印版本号并退出。
    - 示例：

.. code-block:: bash
    :linenos:


\-k
    - 使用HTTP的KeepAlive特性。
    - 示例：

.. code-block:: bash
    :linenos:


\-d
    - 不显示百分比。
    - 示例：

.. code-block:: bash
    :linenos:


\-S
    - 不显示预估和警告信息。
    - 示例：

.. code-block:: bash
    :linenos:


\-g filename
    - 输出结果信息到gnuplot格式的文件中。
    - 示例：

.. code-block:: bash
    :linenos:


\-e filename
    - 输出结果信息到CSV格式的文件中。
    - 示例：

.. code-block:: bash
    :linenos:


\-r
    - 指定接收到错误信息时不退出程序。

\-h
    - 显示用法信息，其实就是ab -help。

\-Z ciphersuite
    - 指定加密组件，可以参考openssl

\-f protocol
    - 使用指定的SSL/TLS 协议(SSL2, SSL3, TLS1, or ALL)


.. _ab-instance:

参考实例
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# ab -c 1000 -n 1000 http://www.baidu.com/index.html   
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking www.baidu.com (be patient)
    Completed 100 requests
    Completed 200 requests
    Completed 300 requests
    apr_socket_recv: Connection refused (111)
    Total of 309 requests completed


.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# ab -n 1000 -c 1000 http://192.168.161.132/index.html
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking 192.168.161.132 (be patient)
    Completed 100 requests
    Completed 200 requests
    Completed 300 requests
    Completed 400 requests
    Completed 500 requests
    Completed 600 requests
    Completed 700 requests
    Completed 800 requests
    Completed 900 requests
    Completed 1000 requests
    Finished 1000 requests


    Server Software:        nginx/1.14.0
    Server Hostname:        192.168.161.132
    Server Port:            80

    Document Path:          /index.html
    Document Length:        612 bytes

    Concurrency Level:      1000
    Time taken for tests:   0.072 seconds
    Complete requests:      1000
    Failed requests:        0
    Write errors:           0
    Total transferred:      845000 bytes
    HTML transferred:       612000 bytes
    Requests per second:    13810.63 [#/sec] (mean)
    Time per request:       72.408 [ms] (mean)
    Time per request:       0.072 [ms] (mean, across all concurrent requests)
    Transfer rate:          11396.47 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0   24   2.4     24      29
    Processing:    16   20   2.7     20      27
    Waiting:        0   17   4.8     18      27
    Total:         25   44   1.6     44      47

    Percentage of the requests served within a certain time (ms)
    50%     44
    66%     44
    75%     45
    80%     46
    90%     46
    95%     47
    98%     47
    99%     47
    100%     47 (longest request)


.. _ab-relevant:

相关命令
======================================================================================================================================================












