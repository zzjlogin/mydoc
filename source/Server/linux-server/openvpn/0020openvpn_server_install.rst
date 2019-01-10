.. _openvpn-server-install:

======================================================================================================================================================
OpenVPN服务器安装配置
======================================================================================================================================================

:Date: 2018-09

.. contents::


服务器环境
======================================================================================================================================================

OpenVPN服务器环境

=================== ==============================================================
系统版本                CentOS release 6.6 (Final)
------------------- --------------------------------------------------------------
主机名                  OpenVPN_001
------------------- --------------------------------------------------------------
硬件环境                x86_64
------------------- --------------------------------------------------------------
网络配置                eth0(dhcp)：192.168.1.140
------------------- --------------------------------------------------------------
OpenVPN软件            
=================== ==============================================================



安装准备
======================================================================================================================================================

网络时间同步
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    如果时间没有和网络同步，yum安装会报错。
    
    参考:
        :ref:`linux-yuminstallerr-time`

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 ~]# date
    Thu Sep  6 21:07:25 CST 2018
    [root@OpenVPN_001 ~]# ntpdate pool.ntp.org
    28 Sep 00:53:38 ntpdate[1577]: step time server 5.103.139.163 offset 1827966.915121 sec



关闭selinux
------------------------------------------------------------------------------------------------------------------------------------------------------


**永久关闭:**
    下面配置会让selinux的关闭重启系统后还是关闭状态。但是配置不会立即生效。

.. attention::
    通过 ``source /etc/selinux/config`` 也不能让修改的文件立即生效。所以需要下面的临时关闭的方式结合使用。

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    [root@OpenVPN_001 ~]# grep SELINUX /etc/selinux/config
    # SELINUX= can take one of these three values:
    SELINUX=disabled
    # SELINUXTYPE= can take one of these two values:
    SELINUXTYPE=targeted

**临时关闭：**
    下面配置是立即生效，但是系统重启后会失效。

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 ~]# getenforce
    Enforcing
    [root@OpenVPN_001 ~]# setenforce 0
    [root@OpenVPN_001 ~]# getenforce
    Permissive




关闭防火墙
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    防火墙一般都是关闭。如果不不关闭，也可以通过配置规则允许所有使用的端口被访问。

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 ~]# /etc/init.d/iptables stop 
    iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
    iptables: Flushing firewall rules:                         [  OK  ]
    iptables: Unloading modules:                               [  OK  ]

关闭防火墙开机自启动

.. code-block:: bash
    :linenos:
    
    [root@OpenVPN_001 ~]# chkconfig iptables off


系统准备命令集合
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    ntpdate pool.ntp.org
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    /etc/init.d/iptables stop 
    chkconfig iptables off

.. attention::
    时间同步最好加入到定时任务。这样保证以后时间如果有错误的时候会自动更正。
    	- ``echo "#time sysc by myhome at 2018-03-30" >>/var/spool/cron/root``
        - ``echo "*/5 * * * * /usr/sbin/ntpdate pool.ntp.org >/dev/null 2&1" >>/var/spool/cron/root``


OpenVPN安装(编译安装)
======================================================================================================================================================


OpenVPN依赖包安装
------------------------------------------------------------------------------------------------------------------------------------------------------

OpenVPN依赖包官方说明：
    https://openvpn.net/community-resources/how-to/#install

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 ~]# yum install openssl lzo pam openssl-devel lzo-devel pam-devel -y



安装
------------------------------------------------------------------------------------------------------------------------------------------------------

.. note::
    - OpenVPN官方提示2.2.x版本软件还集成 ``easy`` 脚本，如果2.3.x及以后版本，则需要自己下载单独的脚本了。
    - 官方参考：https://openvpn.net/community-resources/how-to/#pki  

下载
    1. 官方下载地址：http://build.openvpn.net/downloads/releases/openvpn-2.2.2.tar.gz
    2. github源码下载地址：https://github.com/OpenVPN/openvpn/archive/v2.2.2.tar.gz
.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 ~]# mkdir /data/tools -p
    [root@OpenVPN_001 ~]# cd /data/tools/
    [root@OpenVPN_001 tools]# wget http://build.openvpn.net/downloads/releases/openvpn-2.2.2.tar.gz


解压并运行 ``configure`` ：

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 tools]# ls
    openvpn-2.2.2.tar.gz
    [root@OpenVPN_001 tools]# ll
    total 892
    -rw-r--r--. 1 root root 911158 Nov 15  2018 openvpn-2.2.2.tar.gz
    [root@OpenVPN_001 tools]# tar zxf openvpn-2.2.2.tar.gz
    [root@OpenVPN_001 tools]# ll
    total 896
    drwxrwxr-x. 16  500  500   4096 Dec 14  2011 openvpn-2.2.2
    -rw-r--r--.  1 root root 911158 Nov 15  2018 openvpn-2.2.2.tar.gz
    [root@OpenVPN_001 tools]# cd openvpn-2.2.2
    [root@OpenVPN_001 openvpn-2.2.2]# ./configure --prefix=/usr/local/openvpn-2.2.2
    checking build system type... x86_64-unknown-linux-gnu
    checking host system type... x86_64-unknown-linux-gnu
    checking for a BSD-compatible install... /usr/bin/install -c
    checking whether build environment is sane... yes
    checking for a thread-safe mkdir -p... /bin/mkdir -p
    checking for gawk... gawk
    checking whether make sets $(MAKE)... yes
    checking for ifconfig... /sbin/ifconfig
    略
    config.status: creating install-win32/Makefile
    config.status: creating install-win32/settings
    config.status: creating config.h
    config.status: executing depfiles commands

编译安装：

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 openvpn-2.2.2]# make && make install

创建软连接
------------------------------------------------------------------------------------------------------------------------------------------------------

这样做的目的：
    方便以后OpenVPN升级。编译新版本后。直接把软连接改一下即可。

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 openvpn-2.2.2]# ln -s /usr/local/openvpn-2.2.2/ /usr/local/openvpn
    [root@OpenVPN_001 openvpn-2.2.2]# ll /usr/local/openvpn
    lrwxrwxrwx. 1 root root 25 Nov  4 06:02 /usr/local/openvpn -> /usr/local/openvpn-2.2.2/

OpenVPN需要的各种证书配置(ca/dh)
======================================================================================================================================================

ca证书创建
------------------------------------------------------------------------------------------------------------------------------------------------------

备份vars配置：

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 openvpn-2.2.2]# cd /data/tools/openvpn-2.2.2/easy-rsa/2.0/
    [root@OpenVPN_001 2.0]# pwd
    /data/tools/openvpn-2.2.2/easy-rsa/2.0
    [root@OpenVPN_001 2.0]# cp vars vars.ori.`date +%F`
    [root@OpenVPN_001 2.0]# ll vars*
    -rwxrwxr-x. 1  500  500 1841 Nov 25  2011 vars
    -rwxr-xr-x. 1 root root 1841 Nov  4 06:12 vars.ori.2018-11-04

查看vars中的配置内容：

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# grep -Ev '^#|^$' vars
    export EASY_RSA="`pwd`"
    export OPENSSL="openssl"
    export PKCS11TOOL="pkcs11-tool"
    export GREP="grep"
    export KEY_CONFIG=`$EASY_RSA/whichopensslcnf $EASY_RSA`
    export KEY_DIR="$EASY_RSA/keys"
    echo NOTE: If you run ./clean-all, I will be doing a rm -rf on $KEY_DIR
    export PKCS11_MODULE_PATH="dummy"
    export PKCS11_PIN="dummy"
    export KEY_SIZE=1024
    export CA_EXPIRE=3650
    export KEY_EXPIRE=3650
    export KEY_COUNTRY="US"
    export KEY_PROVINCE="CA"
    export KEY_CITY="SanFrancisco"
    export KEY_ORG="Fort-Funston"
    export KEY_EMAIL="me@myhost.mydomain"
    export KEY_EMAIL=mail@host.domain
    export KEY_CN=changeme
    export KEY_NAME=changeme
    export KEY_OU=changeme
    export PKCS11_MODULE_PATH=changeme
    export PKCS11_PIN=1234


清除配置并修改配置：

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# grep -Ev '^#|^$' vars.ori.`date +%F`>vars

    [root@OpenVPN_001 2.0]# sed -i 's#export KEY_COUNTRY="US"#export KEY_COUNTRY="CN"#g' vars
    [root@OpenVPN_001 2.0]# sed -i 's#export KEY_PROVINCE="CA"#export KEY_PROVINCE="SD"#g' vars
    [root@OpenVPN_001 2.0]# sed -i 's#export KEY_CITY="SanFrancisco"#export KEY_CITY="QD"#g' vars
    [root@OpenVPN_001 2.0]# sed -i 's#export KEY_ORG="Fort-Funston"#export KEY_ORG="zzjlogin"#g' vars
    [root@OpenVPN_001 2.0]# sed -i 's#export KEY_EMAIL="me@myhost.mydomain"#export KEY_EMAIL="admin@display.tk"#g' vars
    [root@OpenVPN_001 2.0]# sed -i 's#export KEY_EMAIL=mail@host.domain#export KEY_EMAIL=admin@display.tk#g' vars
    [root@OpenVPN_001 2.0]# sed -i 's#export KEY_CN=changeme#export KEY_CN=CN#g' vars
    [root@OpenVPN_001 2.0]# sed -i 's#export KEY_NAME=changeme#export KEY_NAME=zzjlogin#g' vars
    [root@OpenVPN_001 2.0]# sed -i 's#export KEY_OU=changeme#export KEY_OU=zzjlogin#g' vars

让配置vars生效，并清除现在可能存在的key：

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# source vars
    NOTE: If you run ./clean-all, I will be doing a rm -rf on /data/tools/openvpn-2.2.2/easy-rsa/2.0/keys
    [root@OpenVPN_001 2.0]# ./clean-all
    [root@OpenVPN_001 2.0]# ll keys/
    total 4
    -rw-r--r--. 1 root root 0 Nov  4 06:27 index.txt
    -rw-r--r--. 1 root root 3 Nov  4 06:27 serial

创建CA证书：

.. code-block:: none
    :linenos:

    [root@OpenVPN_001 2.0]# ./build-ca
    Generating a 1024 bit RSA private key
    ....++++++
    .++++++
    writing new private key to 'ca.key'
    -----
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [CN]:
    State or Province Name (full name) [SD]:
    Locality Name (eg, city) [QD]:
    Organization Name (eg, company) [zzjlogin]:
    Organizational Unit Name (eg, section) [zzjlogin]:
    Common Name (eg, your name or your server's hostname) [CN]:
    Name [zzjlogin]:
    Email Address [admin@display.tk]:
    [root@OpenVPN_001 2.0]# ll keys/  
    total 12
    -rw-r--r--. 1 root root 1302 Nov  4 06:29 ca.crt
    -rw-------. 1 root root  916 Nov  4 06:29 ca.key
    -rw-r--r--. 1 root root    0 Nov  4 06:27 index.txt
    -rw-r--r--. 1 root root    3 Nov  4 06:27 serial


生成服务端密钥文件
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# ./build-key-server openvpn_server
    Generating a 1024 bit RSA private key
    ........................................++++++
    ....................................++++++
    writing new private key to 'openvpn_server.key'
    -----
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [CN]:
    State or Province Name (full name) [SD]:
    Locality Name (eg, city) [QD]:
    Organization Name (eg, company) [zzjlogin]:
    Organizational Unit Name (eg, section) [zzjlogin]:
    Common Name (eg, your name or your server's hostname) [openvpn_server]:
    Name [zzjlogin]:
    Email Address [admin@display.tk]:

    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:
    An optional company name []:
    Using configuration from /data/tools/openvpn-2.2.2/easy-rsa/2.0/openssl-1.0.0.cnf
    Check that the request matches the signature
    Signature ok
    The Subject's Distinguished Name is as follows
    countryName           :PRINTABLE:'CN'
    stateOrProvinceName   :PRINTABLE:'SD'
    localityName          :PRINTABLE:'QD'
    organizationName      :PRINTABLE:'zzjlogin'
    organizationalUnitName:PRINTABLE:'zzjlogin'
    commonName            :T61STRING:'openvpn_server'
    name                  :PRINTABLE:'zzjlogin'
    emailAddress          :IA5STRING:'admin@display.tk'
    Certificate is to be certified until Oct 31 22:33:14 2028 GMT (3650 days)
    Sign the certificate? [y/n]:y


    1 out of 1 certificate requests certified, commit? [y/n]y
    Write out database with 1 new entries
    Data Base Updated


.. tip::
    上面整个过程，只输入两个 ``y`` 。没有设置密码。


.. code-block:: bash
    :linenos:


    [root@OpenVPN_001 2.0]# ll keys/          
    total 40
    -rw-r--r--. 1 root root 4009 Nov  4 06:33 01.pem
    -rw-r--r--. 1 root root 1302 Nov  4 06:29 ca.crt
    -rw-------. 1 root root  916 Nov  4 06:29 ca.key
    -rw-r--r--. 1 root root  130 Nov  4 06:33 index.txt
    -rw-r--r--. 1 root root   21 Nov  4 06:33 index.txt.attr
    -rw-r--r--. 1 root root    0 Nov  4 06:27 index.txt.old
    -rw-r--r--. 1 root root 4009 Nov  4 06:33 openvpn_server.crt
    -rw-r--r--. 1 root root  720 Nov  4 06:33 openvpn_server.csr
    -rw-------. 1 root root  916 Nov  4 06:33 openvpn_server.key
    -rw-r--r--. 1 root root    3 Nov  4 06:33 serial
    -rw-r--r--. 1 root root    3 Nov  4 06:27 serial.old



生成密钥交换时的密钥协议文件(dh文件)
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# ./build-dh
    Generating DH parameters, 1024 bit long safe prime, generator 2
    This is going to take a long time
    ............................................................
    ......................+.....................+...............
    ...........+....+...........................................
    ............................................................
    ....................................................+.......
    ...............................................+............
    .....+......................................................
    ...........+.............................................+..
    ..+....++*++*++*
    [root@OpenVPN_001 2.0]# ll keys/  
    total 44
    -rw-r--r--. 1 root root 4009 Nov  4 06:33 01.pem
    -rw-r--r--. 1 root root 1302 Nov  4 06:29 ca.crt
    -rw-------. 1 root root  916 Nov  4 06:29 ca.key
    -rw-r--r--. 1 root root  245 Nov  4 06:38 dh1024.pem
    -rw-r--r--. 1 root root  130 Nov  4 06:33 index.txt
    -rw-r--r--. 1 root root   21 Nov  4 06:33 index.txt.attr
    -rw-r--r--. 1 root root    0 Nov  4 06:27 index.txt.old
    -rw-r--r--. 1 root root 4009 Nov  4 06:33 openvpn_server.crt
    -rw-r--r--. 1 root root  720 Nov  4 06:33 openvpn_server.csr
    -rw-------. 1 root root  916 Nov  4 06:33 openvpn_server.key
    -rw-r--r--. 1 root root    3 Nov  4 06:33 serial
    -rw-r--r--. 1 root root    3 Nov  4 06:27 serial.old


生成防止DDOS攻击相关配置文件
------------------------------------------------------------------------------------------------------------------------------------------------------

防止DDOS、UDP port flooding攻击。

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# /usr/local/openvpn/sbin/openvpn --genkey --secret keys/ta.key
    [root@OpenVPN_001 2.0]# ll keys/ta.key
    -rw-------. 1 root root 636 Nov  4 06:42 keys/ta.key





.. code-block:: bash
    :linenos:

    sed -i 's#export KEY_COUNTRY="US"#export KEY_COUNTRY="CN"#g' vars
    sed -i 's#export KEY_PROVINCE="CA"#export KEY_PROVINCE="SD"#g' vars
    sed -i 's#export KEY_CITY="SanFrancisco"#export KEY_CITY="QD"#g' vars
    sed -i 's#export KEY_ORG="Fort-Funston"#export KEY_ORG="zzjlogin"#g' vars
    sed -i 's#export KEY_EMAIL="me@myhost.mydomain"#export KEY_EMAIL="admin@display.tk"#g' vars
    sed -i 's#export KEY_EMAIL=mail@host.domain#export KEY_EMAIL=admin@display.tk#g' vars
    sed -i 's#export KEY_CN=changeme#export KEY_CN=CN#g' vars
    sed -i 's#export KEY_NAME=changeme#export KEY_NAME=zzjlogin#g' vars
    sed -i 's#export KEY_OU=changeme#export KEY_OU=zzjlogin#g' vars



OpenVPN配置
======================================================================================================================================================

以下文件路径转移以及配置文件初始化都是需要的：

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# mkdir /etc/openvpn
    [root@OpenVPN_001 2.0]# pwd
    /data/tools/openvpn-2.2.2/easy-rsa/2.0
    [root@OpenVPN_001 2.0]# cp -ap keys /etc/openvpn/
    [root@OpenVPN_001 2.0]# cd /data/tools/openvpn-2.2.2/sample-config-files
    [root@OpenVPN_001 sample-config-files]# cp server.conf /etc/openvpn/
    [root@OpenVPN_001 sample-config-files]# mkdir /etc/openvpn/clients
    [root@OpenVPN_001 sample-config-files]# cp client.conf /etc/openvpn/clients/

    [root@OpenVPN_001 sample-config-files]# cd /etc/openvpn/
    [root@OpenVPN_001 openvpn]# ls
    clients  keys  server.conf
    [root@OpenVPN_001 openvpn]# cp server.conf server.conf.ori`date +%F`
    [root@OpenVPN_001 openvpn]# ls
    clients  keys  server.conf  server.conf.ori2018-11-04

    [root@OpenVPN_001 openvpn]# grep -vE '^;|^$|^#' server.conf
    port 1194
    proto udp
    dev tun
    ca ca.crt
    cert server.crt
    key server.key  # This file should be kept secret
    dh dh1024.pem
    server 10.8.0.0 255.255.255.0
    ifconfig-pool-persist ipp.txt
    keepalive 10 120
    comp-lzo
    persist-key
    persist-tun
    status openvpn-status.log
    verb 3




一般配置
------------------------------------------------------------------------------------------------------------------------------------------------------

一般配置功能：
    - 可以通过VPN链接VPN服务器；
    - 可以设置让VPN客户端之间网络相互连通；
    - 实现VPN客户端和VPN服务器以及VPN其他客户端之间加密传输；
    - 可以通过连接VPN，把所有VPN设置(push的子网网段)的子网都通过VPN链路访问。




.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 openvpn]# vi /etc/openvpn/server.conf

    local 192.168.1.140
    port 52115
    proto udp
    dev tun
    ca /etc/openvpn/keys/ca.crt
    cert /etc/openvpn/keys/server.crt
    key /etc/openvpn/keys/server.key  # This file should be kept secret
    dh /etc/openvpn/keys/dh1024.pem
    tls-auth /etc/openvpn/keys/ta.key 0
    server 10.8.0.0 255.255.255.0
    push "192.168.19.0 255.255.255.0"
    ifconfig-pool-persist ipp.txt
    keepalive 10 120
    comp-lzo
    persist-key
    persist-tun
    verb 3
    client-to-client
    duplicate-cn
    status openvpn-status.log
    log /var/log/openvpn.log



代理翻墙配置
------------------------------------------------------------------------------------------------------------------------------------------------------

代理翻墙配置作用：
    - 让所有本地访问互联网的流量都通过VPN，经过VPN中转访问互联网。
    - 参考：https://openvpn.net/community-resources/how-to/#redirect

一般配置文件中的配置需要添加下面配置内容：

.. code-block:: bash
    :linenos:

    push "redirect-gateway def1 bypass-dhcp bypass-dns"
    #push "redirect-gateway local def1"
    push "dhcp-option DNS 8.8.8.8"
    push "dhcp-option DNS 10.8.0.1"

添加路由：

.. code-block:: bash
    :linenos:

    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

NAT方式VPN配置
------------------------------------------------------------------------------------------------------------------------------------------------------




OpenVPN服务器添加客户端
======================================================================================================================================================

转移easy2.0脚本
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 easy-rsa]# pwd
    /data/tools/openvpn-2.2.2/easy-rsa

    [root@OpenVPN_001 easy-rsa]# cp -ap 2.0 /etc/openvpn/
    [root@OpenVPN_001 easy-rsa]# cd /etc/openvpn/2.0/
    [root@OpenVPN_001 2.0]# ls
    build-ca          build-key-server  list-crl           README
    build-dh          build-req         Makefile           revoke-full
    build-inter       build-req-pass    openssl-0.9.6.cnf  sign-req
    build-key         clean-all         openssl-0.9.8.cnf  vars
    build-key-pass    inherit-inter     openssl-1.0.0.cnf  vars.ori.2018-11-04
    build-key-pkcs12  keys              pkitool            whichopensslcnf

让新目录下的vars文件生效
------------------------------------------------------------------------------------------------------------------------------------------------------

.. note::
    每次创建用户时，文件 ``vars`` 都需要用命令 ``source`` 让其重新生效。并且注意不要运行 ``./clean-all`` 否则会清空之前的证书和密钥文件。

.. code-block:: bash
    :linenos:
    
    [root@OpenVPN_001 2.0]# source vars

创建用户
------------------------------------------------------------------------------------------------------------------------------------------------------

用户名：
    user001
登陆认证：
    - 需要证书和密钥
    - 不需要密码

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# ./build-key user001
    Generating a 1024 bit RSA private key
    ...........................................................++++++
    ...................................++++++
    writing new private key to 'user001.key'
    -----
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [CN]:
    State or Province Name (full name) [SD]:
    Locality Name (eg, city) [QD]:
    Organization Name (eg, company) [zzjlogin]:
    Organizational Unit Name (eg, section) [zzjlogin]:
    Common Name (eg, your name or your server's hostname) [user001]:
    Name [zzjlogin]:
    Email Address [admin@display.tk]:

    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:
    An optional company name []:
    Using configuration from /data/tools/openvpn-2.2.2/easy-rsa/2.0/openssl-1.0.0.cnf
    Check that the request matches the signature
    Signature ok
    The Subject's Distinguished Name is as follows
    countryName           :PRINTABLE:'CN'
    stateOrProvinceName   :PRINTABLE:'SD'
    localityName          :PRINTABLE:'QD'
    organizationName      :PRINTABLE:'zzjlogin'
    organizationalUnitName:PRINTABLE:'zzjlogin'
    commonName            :PRINTABLE:'user001'
    name                  :PRINTABLE:'zzjlogin'
    emailAddress          :IA5STRING:'admin@display.tk'
    Certificate is to be certified until Nov  1 00:29:14 2028 GMT (3650 days)
    Sign the certificate? [y/n]:y


    1 out of 1 certificate requests certified, commit? [y/n]y
    Write out database with 1 new entries
    Data Base Updated

查看创建用户以后keys目录文件变化：

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# ll -t keys/
    total 72
    -rw-r--r--. 1 root root 3872 Nov 15 19:17 02.pem
    -rw-r--r--. 1 root root  253 Nov 15 19:17 index.txt
    -rw-r--r--. 1 root root   21 Nov 15 19:17 index.txt.attr
    -rw-r--r--. 1 root root    3 Nov 15 19:17 serial
    -rw-r--r--. 1 root root 3872 Nov 15 19:17 user001.crt
    -rw-r--r--. 1 root root  712 Nov 15 19:17 user001.csr
    -rw-------. 1 root root  916 Nov 15 19:17 user001.key
    -rw-------. 1 root root  636 Nov  4 06:42 ta.key
    -rw-r--r--. 1 root root  245 Nov  4 06:38 dh1024.pem
    -rw-r--r--. 1 root root 4009 Nov  4 06:33 01.pem
    -rw-r--r--. 1 root root   21 Nov  4 06:33 index.txt.attr.old
    -rw-r--r--. 1 root root  130 Nov  4 06:33 index.txt.old
    -rw-r--r--. 1 root root 4009 Nov  4 06:33 openvpn_server.crt
    -rw-r--r--. 1 root root    3 Nov  4 06:33 serial.old
    -rw-r--r--. 1 root root  720 Nov  4 06:33 openvpn_server.csr
    -rw-------. 1 root root  916 Nov  4 06:33 openvpn_server.key
    -rw-r--r--. 1 root root 1302 Nov  4 06:29 ca.crt
    -rw-------. 1 root root  916 Nov  4 06:29 ca.key


创建同时需要证书和密码的用户
------------------------------------------------------------------------------------------------------------------------------------------------------

用户名：
    user101
认证方式：
    - 证书密钥+密码


.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# ./build-key-pass user101            
    Generating a 1024 bit RSA private key
    ..........................................++++++
    ............++++++
    writing new private key to 'user101.key'
    Enter PEM pass phrase:
    Verifying - Enter PEM pass phrase:
    -----
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [CN]:
    State or Province Name (full name) [SD]:
    Locality Name (eg, city) [QD]:
    Organization Name (eg, company) [zzjlogin]:
    Organizational Unit Name (eg, section) [zzjlogin]:
    Common Name (eg, your name or your server's hostname) [user101]:
    Name [zzjlogin]:
    Email Address [admin@display.tk]:

    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:
    An optional company name []:
    Using configuration from /etc/openvpn/2.0/openssl-1.0.0.cnf
    Check that the request matches the signature
    Signature ok
    The Subject's Distinguished Name is as follows
    countryName           :PRINTABLE:'CN'
    stateOrProvinceName   :PRINTABLE:'SD'
    localityName          :PRINTABLE:'QD'
    organizationName      :PRINTABLE:'zzjlogin'
    organizationalUnitName:PRINTABLE:'zzjlogin'
    commonName            :PRINTABLE:'user101'
    name                  :PRINTABLE:'zzjlogin'
    emailAddress          :IA5STRING:'admin@display.tk'
    Certificate is to be certified until Nov 12 11:35:19 2028 GMT (3650 days)
    Sign the certificate? [y/n]:y


    1 out of 1 certificate requests certified, commit? [y/n]y
    Write out database with 1 new entries
    Data Base Updated
    [root@OpenVPN_001 2.0]# ll keys/                            
    total 88
    -rw-r--r--. 1 root root 4009 Nov  4 06:33 01.pem
    -rw-r--r--. 1 root root 3872 Nov 15 19:17 02.pem
    -rw-r--r--. 1 root root 3872 Nov 15 19:35 03.pem
    -rw-r--r--. 1 root root 1302 Nov  4 06:29 ca.crt
    -rw-------. 1 root root  916 Nov  4 06:29 ca.key
    -rw-r--r--. 1 root root  245 Nov  4 06:38 dh1024.pem
    -rw-r--r--. 1 root root  376 Nov 15 19:35 index.txt
    -rw-r--r--. 1 root root   21 Nov 15 19:35 index.txt.attr
    -rw-r--r--. 1 root root   21 Nov 15 19:17 index.txt.attr.old
    -rw-r--r--. 1 root root  253 Nov 15 19:17 index.txt.old
    -rw-r--r--. 1 root root 4009 Nov  4 06:33 openvpn_server.crt
    -rw-r--r--. 1 root root  720 Nov  4 06:33 openvpn_server.csr
    -rw-------. 1 root root  916 Nov  4 06:33 openvpn_server.key
    -rw-r--r--. 1 root root    3 Nov 15 19:35 serial
    -rw-r--r--. 1 root root    3 Nov 15 19:17 serial.old
    -rw-------. 1 root root  636 Nov  4 06:42 ta.key
    -rw-r--r--. 1 root root 3872 Nov 15 19:17 user001.crt
    -rw-r--r--. 1 root root  712 Nov 15 19:17 user001.csr
    -rw-------. 1 root root  916 Nov 15 19:17 user001.key
    -rw-r--r--. 1 root root 3872 Nov 15 19:35 user101.crt
    -rw-r--r--. 1 root root  712 Nov 15 19:35 user101.csr
    -rw-------. 1 root root 1041 Nov 15 19:35 user101.key

OpenVPN服务器客户端用户注销和恢复
======================================================================================================================================================

参考：
    - https://openvpn.net/community-resources/how-to/#revoke
    - https://openvpn.net/community-resources/revoking-certificates/

.. note::
    - openvpn2.0.9吊销用户需要修改吊销脚本所在路径的openssl*.conf文件最后7行，需要注销掉这几行。否则吊销用户会报错。2.2.2版本没有这个问题。
    - 吊销用户证书以后服务端需要重启才能生效。

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# pwd
    /etc/openvpn/2.0
    [root@OpenVPN_001 2.0]# ls
    build-ca     build-key         build-key-server  clean-all      list-crl           openssl-0.9.8.cnf  README       vars
    build-dh     build-key-pass    build-req         inherit-inter  Makefile           openssl-1.0.0.cnf  revoke-full  vars.ori.2018-11-04
    build-inter  build-key-pkcs12  build-req-pass    keys           openssl-0.9.6.cnf  pkitool            sign-req     whichopensslcnf
    [root@OpenVPN_001 2.0]# tail -7 openssl-1.0.0.cnf

    [ pkcs11_section ]
    engine_id = pkcs11
    dynamic_path = /usr/lib/engines/engine_pkcs11.so
    MODULE_PATH = $ENV::PKCS11_MODULE_PATH
    PIN = $ENV::PKCS11_PIN
    init = 0


.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# source vars              
    NOTE: If you run ./clean-all, I will be doing a rm -rf on /etc/openvpn/2.0/keys
    [root@OpenVPN_001 2.0]# cat keys/index.txt
    V       281031223314Z           01      unknown /C=CN/ST=SD/L=QD/O=zzjlogin/OU=zzjlogin/CN=openvpn_server/name=zzjlogin/emailAddress=admin@display.tk
    V       281112111717Z           02      unknown /C=CN/ST=SD/L=QD/O=zzjlogin/OU=zzjlogin/CN=user001/name=zzjlogin/emailAddress=admin@display.tk
    V       281112113519Z           03      unknown /C=CN/ST=SD/L=QD/O=zzjlogin/OU=zzjlogin/CN=user101/name=zzjlogin/emailAddress=admin@display.tk
    V       281112123710Z           04      unknown /C=CN/ST=SD/L=QD/O=zzjlogin/OU=zzjlogin/CN=user002/name=zzjlogin/emailAddress=admin@display.tk
    [root@OpenVPN_001 2.0]# cat keys/index.txt.attr  
    unique_subject = yes
    [root@OpenVPN_001 2.0]# ./revoke-full user002
    Using configuration from /etc/openvpn/2.0/openssl-1.0.0.cnf
    Revoking Certificate 04.
    Data Base Updated
    Using configuration from /etc/openvpn/2.0/openssl-1.0.0.cnf
    user002.crt: C = CN, ST = SD, L = QD, O = zzjlogin, OU = zzjlogin, CN = user002, name = zzjlogin, emailAddress = admin@display.tk
    error 8 at 0 depth lookup:CRL signature failure
    140421920585544:error:0D0C50A1:asn1 encoding routines:ASN1_item_verify:unknown message digest algorithm:a_verify.c:217:
    [root@OpenVPN_001 2.0]# cat keys/index.txt
    V       281031223314Z           01      unknown /C=CN/ST=SD/L=QD/O=zzjlogin/OU=zzjlogin/CN=openvpn_server/name=zzjlogin/emailAddress=admin@display.tk
    V       281112111717Z           02      unknown /C=CN/ST=SD/L=QD/O=zzjlogin/OU=zzjlogin/CN=user001/name=zzjlogin/emailAddress=admin@display.tk
    V       281112113519Z           03      unknown /C=CN/ST=SD/L=QD/O=zzjlogin/OU=zzjlogin/CN=user101/name=zzjlogin/emailAddress=admin@display.tk
    R       281112123710Z   181115123756Z   04      unknown /C=CN/ST=SD/L=QD/O=zzjlogin/OU=zzjlogin/CN=user002/name=zzjlogin/emailAddress=admin@display.tk

    [root@OpenVPN_001 2.0]# cp -ap keys/crl.pem /etc/openvpn/keys/


``/etc/openvpn/server.conf`` 文件中添加下面配置

.. code-block:: bash
    :linenos:

    crl-verify keys/crl.pem




OpenVPN启动
======================================================================================================================================================

编译安装默认启动方式
------------------------------------------------------------------------------------------------------------------------------------------------------


添加chkconfig
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# cp /data/tools/openvpn-2.2.2/sample-scripts/openvpn.init /etc/init.d/openvpn
    [root@OpenVPN_001 2.0]# chmod 755 /etc/init.d/openvpn
    [root@OpenVPN_001 2.0]# ll /etc/init.d/openvpn
    -rwxr-xr-x. 1 root root 5481 Nov 15 19:51 /etc/init.d/openvpn

.. note::
    如果 ``/etc/openvpn/`` 目录下有多个 ``.conf`` 文件，则需要修改/etc/init.d/openvpn这个脚本的148行
    改成 ``for c in `/bin/ls server.conf 2>/dev/null`; do`` 。或者把除了openvpn服务端配置文件以外其他的 ``.conf`` 文件转移到其他目录。





设置OpenVPN开机自启动
------------------------------------------------------------------------------------------------------------------------------------------------------








