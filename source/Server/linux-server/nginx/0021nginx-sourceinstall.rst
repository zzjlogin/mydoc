
.. _nginx-sourceinstall:

======================================================================================================================================================
nginx源码编译安装
======================================================================================================================================================



环境
======================================================================================================================================================


服务器系统环境：
    系统：
        CentOS6.6 64位
    内核：
        2.6.32
    主机名：
        zzjlogin
nginx软件：
    nginx-1.12.2

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# hostname
    zzjlogin
    [root@zzjlogin ~]# uname -a
    Linux zzjlogin 2.6.32-504.el6.x86_64 #1 SMP Wed Oct 15 04:27:16 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
    [root@zzjlogin ~]# uname -r
    2.6.32-504.el6.x86_64
    [root@zzjlogin ~]# cat /etc/redhat-release
    CentOS release 6.6 (Final)

    [root@zzjlogin ~]# cat /proc/version
    Linux version 2.6.32-504.el6.x86_64 (mockbuild@c6b9.bsys.dev.centos.org) (gcc version 4.4.7 20120313 (Red Hat 4.4.7-11) (GCC) ) #1 SMP Wed Oct 15 04:27:16 UTC 2014



nginx安装准备
======================================================================================================================================================


依赖软件包准备
------------------------------------------------------------------------------------------------------------------------------------------------------

需要提前安装pcre，这个软件对nginx的rewrite功能提供支持。

nginx默认会自动安装ssl模块，这个模块需要openssl软件支持。


安装：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# yum install pcre pcre-devel openssl openssl-devel -y


.. attention::
    一般都默认安装了 ``zlib`` ，如果没有安装也需要安装zlib。这可软件对nginx的Gzib模块提供支持。


防火墙关闭
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /etc/init.d/iptables status
    Table: filter
    Chain INPUT (policy ACCEPT)
    num  target     prot opt source               destination         
    1    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED 
    2    ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0           
    3    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           
    4    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW tcp dpt:22 
    5    REJECT     all  --  0.0.0.0/0            0.0.0.0/0           reject-with icmp-host-prohibited 

    Chain FORWARD (policy ACCEPT)
    num  target     prot opt source               destination         
    1    REJECT     all  --  0.0.0.0/0            0.0.0.0/0           reject-with icmp-host-prohibited 

    Chain OUTPUT (policy ACCEPT)
    num  target     prot opt source               destination         

    [root@zzjlogin ~]# /etc/init.d/iptables stop
    iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
    iptables: Flushing firewall rules:                         [  OK  ]
    iptables: Unloading modules:                               [  OK  ]
    [root@zzjlogin ~]# chkconfig iptables off

selinux关闭
------------------------------------------------------------------------------------------------------------------------------------------------------


1. 永久关闭:
    下面配置会让selinux的关闭重启系统后还是关闭状态。但是配置不会立即生效。

.. note::
    通过 ``source /etc/selinux/config`` 也不能让修改的文件立即生效。所以需要下面的临时关闭的方式结合使用。

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    [root@zzjlogin ~]# grep SELINUX /etc/selinux/config
    # SELINUX= can take one of these three values:
    SELINUX=disabled
    # SELINUXTYPE= can take one of these two values:
    SELINUXTYPE=targeted

2. 临时关闭：
    下面配置是立即生效，但是系统重启后会失效。

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# getenforce
    Enforcing
    [root@zzjlogin ~]# setenforce 0
    [root@zzjlogin ~]# getenforce
    Permissive



nginx源码编译安装
======================================================================================================================================================

nginx下载
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# mkdir /data/tools -p
    [root@zzjlogin ~]# cd /data/tools/
    [root@zzjlogin tools]# wget http://nginx.org/download/nginx-1.12.2.tar.gz



nginx校验
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: bash
    :linenos:

    [root@zzjlogin tools]# wget http://nginx.org/download/nginx-1.12.2.tar.gz.asc
    [root@zzjlogin tools]# ll
    total 964
    -rw-r--r--. 1 root root 981687 Oct 17  2017 nginx-1.12.2.tar.gz
    -rw-r--r--. 1 root root    455 Oct 17  2017 nginx-1.12.2.tar.gz.asc


    [root@zzjlogin tools]# wget http://nginx.org/keys/aalexeev.key

    [root@zzjlogin tools]# wget http://nginx.org/keys/is.key

    [root@zzjlogin tools]# wget http://nginx.org/keys/mdounin.key

    [root@zzjlogin tools]# wget http://nginx.org/keys/maxim.key

    [root@zzjlogin tools]# wget http://nginx.org/keys/sb.key


    [root@zzjlogin tools]# gpg --import *.key                  
    gpg: key F5806B4D: public key "Andrew Alexeev <andrew@nginx.com>" imported
    gpg: key A524C53E: public key "Igor Sysoev <igor@sysoev.ru>" imported
    gpg: key 2C172083: public key "Maxim Konovalov <maxim@FreeBSD.org>" imported
    gpg: key A1C052F8: public key "Maxim Dounin <mdounin@mdounin.ru>" imported
    gpg: key 7BD9BF62: "nginx signing key <signing-key@nginx.com>" not changed
    gpg: key 7ADB39A8: public key "Sergey Budnevitch <sb@waeme.net>" imported
    gpg: Total number processed: 6
    gpg:               imported: 5  (RSA: 3)
    gpg:              unchanged: 1
    gpg: no ultimately trusted keys found
    [root@zzjlogin tools]# gpg --verify nginx-1.12.2.tar.gz.asc nginx-1.12.2.tar.gz
    gpg: Signature made Tue Oct 17 21:18:21 2017 CST using RSA key ID A1C052F8
    gpg: Good signature from "Maxim Dounin <mdounin@mdounin.ru>"
    gpg: WARNING: This key is not certified with a trusted signature!
    gpg:          There is no indication that the signature belongs to the owner.
    Primary key fingerprint: B0F4 2533 73F8 F6F5 10D4  2178 520A 9993 A1C0 52F8


.. tip::
    上面 ``gpg: Good signature from "Maxim Dounin <mdounin@mdounin.ru>"`` 说明签名是这个用户的可信签名。

nginx编译安装
------------------------------------------------------------------------------------------------------------------------------------------------------

创建nginx所属用户nginx：


.. code-block:: bash
    :linenos:

    [root@zzjlogin tools]# useradd nginx -s /sbin/nologin -M


解压：


.. code-block:: bash
    :linenos:

    [root@zzjlogin tools]# tar xf nginx-1.12.2.tar.gz

进入目录，然后运行configure脚本：


.. code-block:: bash
    :linenos:

    [root@zzjlogin tools]# cd nginx-1.12.2           
    [root@zzjlogin nginx-1.12.2]# ./configure --prefix=/usr/local/nginx-1.12.2 --user=nginx --group=nginx --with-http_stub_status_module --with-http_ssl_module

.. attention::
    指定安装目录的编译安装方式，安装后所有nginx程序都在指定的目录下，为了方便后序升级所以一般会建立一个软连接 ``nginx`` 目录来指向 ``nginx-1.12.2``

    - nginx主程序目录：/usr/local/nginx/sbin/
    - nginx配置文件目录：/usr/local/nginx/conf/
    - nginx站点目录：/usr/local/nginx/html/
    - nginx日志目录：/usr/local/nginx/logs/

编译安装：


.. code-block:: bash
    :linenos:
    
    [root@zzjlogin nginx-1.12.2]# make && make install


创建软连接：


.. code-block:: bash
    :linenos:

    [root@zzjlogin nginx-1.12.2]# ln -s /usr/local/nginx-1.12.2 /usr/local/nginx


nginx开机/开机自启动
------------------------------------------------------------------------------------------------------------------------------------------------------



检查配置文件是否正确：


.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /usr/local/nginx/sbin/nginx -t
    nginx: the configuration file /usr/local/nginx-1.12.2/conf/nginx.conf syntax is ok
    nginx: configuration file /usr/local/nginx-1.12.2/conf/nginx.conf test is successful

检查nginx编译参数和加载的模块：


.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /usr/local/nginx/sbin/nginx -V
    nginx version: nginx/1.12.2
    built by gcc 4.4.7 20120313 (Red Hat 4.4.7-11) (GCC) 
    built with OpenSSL 1.0.1e-fips 11 Feb 2013
    TLS SNI support enabled
    configure arguments: --prefix=/usr/local/nginx-1.12.2 --user=nginx --group=nginx --with-http_stub_status_module --with-http_ssl_module

.. attention::
    本实例中安装目录是 ``/usr/local/nginx-1.12.2`` ，在实际工作环境，一般把所有业务应用单独创建目录来存放。例如创建/app，然后在这个目录下面安装所有应用。

    这样安装的优点是。方便梳理业务。巡检服务时也清晰。当然数据也需要单独的目录。

检查nginx软件版本：


.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /usr/local/nginx/sbin/nginx -v
    nginx version: nginx/1.12.2

启动nginx：


.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /usr/local/nginx/sbin/nginx


命令：

.. code-block:: bash
    :linenos:

    nginx -s signal

signal具体值：
    - stop：快速关闭nginx服务
    - quit：优雅退出关闭服务。会让所有访问用户都访问结束再关不nginx
    - reload：重载nginx配置文件
    - reopen：重新打开日志文件。

检查nginx监听端口：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# ss -lntup
    Netid State      Recv-Q Send-Q                          Local Address:Port                            Peer Address:Port 
    udp   UNCONN     0      0                                           *:68                                         *:*      users:(("dhclient",958,5))
    tcp   LISTEN     0      128                                        :::22                                        :::*      users:(("sshd",1197,4))
    tcp   LISTEN     0      128                                         *:22                                         *:*      users:(("sshd",1197,3))
    tcp   LISTEN     0      100                                       ::1:25                                        :::*      users:(("master",1301,13))
    tcp   LISTEN     0      100                                 127.0.0.1:25                                         *:*      users:(("master",1301,12))
    tcp   LISTEN     0      128                                         *:80                                         *:*      users:(("nginx",4109,6),("nginx",4110,6))

    [root@zzjlogin ~]# lsof -i :80
    COMMAND  PID  USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    nginx   4109  root    6u  IPv4  20007      0t0  TCP *:http (LISTEN)
    nginx   4110 nginx    6u  IPv4  20007      0t0  TCP *:http (LISTEN)


测试页面测试访问：


.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# curl 192.168.161.132



nginx编译参数
======================================================================================================================================================

查看nginx有哪些编译参数：

.. code-block:: bash
    :linenos:

    [root@zzjlogin nginx-1.12.2]# ./configure --help

参数详解参考：
    http://nginx.org/en/docs/configure.html


--help                                      print this message
--prefix=PATH                               set installation prefix
--sbin-path=PATH                            set nginx binary pathname
--modules-path=PATH                         set modules path
--conf-path=PATH                            set nginx.conf pathname
--error-log-path=PATH                       set error log pathname
--pid-path=PATH                             set nginx.pid pathname
--lock-path=PATH                            set nginx.lock pathname
--user=USER                                 set non-privileged user for worker processes
--group=GROUP                               set non-privileged group for worker processes
--build=NAME                                set build name
--builddir=DIR                              set build directory
--with-select_module                        enable select module
--without-select_module                     disable select module
--with-poll_module                          enable poll module
--without-poll_module                       disable poll module
--with-threads                              enable thread pool support
--with-file-aio                             enable file AIO support
--with-http_ssl_module                      enable ngx_http_ssl_module
--with-http_v2_module                       enable ngx_http_v2_module
--with-http_realip_module                   enable ngx_http_realip_module
--with-http_addition_module                 enable ngx_http_addition_module
--with-http_xslt_module                     enable ngx_http_xslt_module
--with-http_xslt_module=dynamic             enable dynamic ngx_http_xslt_module
--with-http_image_filter_module             enable ngx_http_image_filter_module
--with-http_image_filter_module=dynamic     enable dynamic ngx_http_image_filter_module
--with-http_geoip_module                    enable ngx_http_geoip_module
--with-http_geoip_module=dynamic            enable dynamic ngx_http_geoip_module
--with-http_sub_module                      enable ngx_http_sub_module
--with-http_dav_module                      enable ngx_http_dav_module
--with-http_flv_module                      enable ngx_http_flv_module
--with-http_mp4_module                      enable ngx_http_mp4_module
--with-http_gunzip_module                   enable ngx_http_gunzip_module
--with-http_gzip_static_module              enable ngx_http_gzip_static_module
--with-http_auth_request_module             enable ngx_http_auth_request_module
--with-http_random_index_module             enable ngx_http_random_index_module
--with-http_secure_link_module              enable ngx_http_secure_link_module
--with-http_degradation_module              enable ngx_http_degradation_module
--with-http_slice_module                    enable ngx_http_slice_module
--with-http_stub_status_module              enable ngx_http_stub_status_module
--without-http_charset_module               disable ngx_http_charset_module
--without-http_gzip_module                  disable ngx_http_gzip_module
--without-http_ssi_module                   disable ngx_http_ssi_module
--without-http_userid_module                disable ngx_http_userid_module
--without-http_access_module                disable ngx_http_access_module
--without-http_auth_basic_module            disable ngx_http_auth_basic_module
--without-http_autoindex_module             disable ngx_http_autoindex_module
--without-http_geo_module                   disable ngx_http_geo_module
--without-http_map_module                   disable ngx_http_map_module
--without-http_split_clients_module          disable ngx_http_split_clients_module
--without-http_referer_module               disable ngx_http_referer_module
--without-http_rewrite_module               disable ngx_http_rewrite_module
--without-http_proxy_module                 disable ngx_http_proxy_module
--without-http_fastcgi_module               disable ngx_http_fastcgi_module
--without-http_uwsgi_module                 disable ngx_http_uwsgi_module
--without-http_scgi_module                  disable ngx_http_scgi_module
--without-http_memcached_module             disable ngx_http_memcached_module
--without-http_limit_conn_module            disable ngx_http_limit_conn_module
--without-http_limit_req_module             disable ngx_http_limit_req_module
--without-http_empty_gif_module             disable ngx_http_empty_gif_module
--without-http_browser_module               disable ngx_http_browser_module
--without-http_upstream_hash_module         disable ngx_http_upstream_hash_module
--without-http_upstream_ip_hash_module      disable ngx_http_upstream_ip_hash_module
--without-http_upstream_least_conn_module   disable ngx_http_upstream_least_conn_module
--without-http_upstream_keepalive_module    disable ngx_http_upstream_keepalive_module
--without-http_upstream_zone_module         disable ngx_http_upstream_zone_module
--with-http_perl_module                     enable ngx_http_perl_module
--with-http_perl_module=dynamic             enable dynamic ngx_http_perl_module
--with-perl_modules_path=PATH               set Perl modules path
--with-perl=PATH                            set perl binary pathname
--http-log-path=PATH                        set http access log pathname
--http-client-body-temp-path=PATH           set path to store http client request body temporary files
--http-proxy-temp-path=PATH                 set path to store http proxy temporary files
--http-fastcgi-temp-path=PATH               set path to store http fastcgi temporary files
--http-uwsgi-temp-path=PATH                 set path to store http uwsgi temporary files
--http-scgi-temp-path=PATH                  set path to store http scgi temporary files
--without-http                              disable HTTP server
--without-http-cache                        disable HTTP cache
--with-mail                                 enable POP3/IMAP4/SMTP proxy module
--with-mail=dynamic                         enable dynamic POP3/IMAP4/SMTP proxy module
--with-mail_ssl_module                      enable ngx_mail_ssl_module
--without-mail_pop3_module                  disable ngx_mail_pop3_module
--without-mail_imap_module                  disable ngx_mail_imap_module
--without-mail_smtp_module                  disable ngx_mail_smtp_module
--with-stream                               enable TCP/UDP proxy module
--with-stream=dynamic                       enable dynamic TCP/UDP proxy module
--with-stream_ssl_module                    enable ngx_stream_ssl_module
--with-stream_realip_module                 enable ngx_stream_realip_module
--with-stream_geoip_module                  enable ngx_stream_geoip_module
--with-stream_geoip_module=dynamic          enable dynamic ngx_stream_geoip_module
--with-stream_ssl_preread_module            enable ngx_stream_ssl_preread_module
--without-stream_limit_conn_module          disable ngx_stream_limit_conn_module
--without-stream_access_module              disable ngx_stream_access_module
--without-stream_geo_module                 disable ngx_stream_geo_module
--without-stream_map_module                 disable ngx_stream_map_module
--without-stream_split_clients_module       disable ngx_stream_split_clients_module
--without-stream_return_module              disable ngx_stream_return_module
--without-stream_upstream_hash_module       disable ngx_stream_upstream_hash_module
--without-stream_upstream_least_conn_module disable ngx_stream_upstream_least_conn_module
--without-stream_upstream_zone_module       disable ngx_stream_upstream_zone_module
--with-google_perftools_module              enable ngx_google_perftools_module
--with-cpp_test_module                      enable ngx_cpp_test_module
--add-module=PATH                           enable external module
--add-dynamic-module=PATH                   enable dynamic external module
--with-compat                               dynamic modules compatibility
--with-cc=PATH                              set C compiler pathname
--with-cpp=PATH                             set C preprocessor pathname
--with-cc-opt=OPTIONS                       set additional C compiler options
--with-ld-opt=OPTIONS                       set additional linker options
--with-cpu-opt=CPU                          build for the specified CPU, valid values:
                                            pentium, pentiumpro, pentium3, pentium4,
                                            athlon, opteron, sparc32, sparc64, ppc64
--without-pcre                              disable PCRE library usage
--with-pcre                                 force PCRE library usage
--with-pcre=DIR                             set path to PCRE library sources
--with-pcre-opt=OPTIONS                     set additional build options for PCRE
--with-pcre-jit                             build PCRE with JIT compilation support
--with-zlib=DIR                             set path to zlib library sources
--with-zlib-opt=OPTIONS                     set additional build options for zlib
--with-zlib-asm=CPU                         use zlib assembler sources optimized
                                            for the specified CPU, valid values:
                                            pentium, pentiumpro
--with-libatomic                            force libatomic_ops library usage
--with-libatomic=DIR                        set path to libatomic_ops library sources
--with-openssl=DIR                          set path to OpenSSL library sources
--with-openssl-opt=OPTIONS                  set additional build options for OpenSSL
--with-debug                                enable debug logging

nginx编译优化安装参数
======================================================================================================================================================




