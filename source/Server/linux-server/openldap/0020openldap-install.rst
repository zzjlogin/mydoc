
.. _openldap-install:

======================================================================================================================================================
openldap安装配置(单主)
======================================================================================================================================================

:Date: 2018-09

.. contents::


服务器环境
======================================================================================================================================================

openldap服务器环境

=================== ==============================================================
系统版本                CentOS release 6.6 (Final)
------------------- --------------------------------------------------------------
主机名                  ldap_001
------------------- --------------------------------------------------------------
硬件环境                x86_64
------------------- --------------------------------------------------------------
网络配置                eth0(dhcp)：192.168.161.137
------------------- --------------------------------------------------------------
openldap软件            
=================== ==============================================================



安装准备
======================================================================================================================================================

网络时间同步
------------------------------------------------------------------------------------------------------------------------------------------------------

如果时间没有和网络同步，yum安装会报错。参考:
    :ref:`linux-yuminstallerr-time`

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# date
    Thu Sep  6 21:07:25 CST 2018
    [root@ldap_001 ~]# ntpdate pool.ntp.org
    28 Sep 00:53:38 ntpdate[1577]: step time server 5.103.139.163 offset 1827966.915121 sec



关闭selinux
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    如果不关闭selinux也没有配置selinux。则安装以后zabbix会启动失败。会发现zabbix网页可以访问，但是提示zabbix服务没有启动。

**永久关闭:**
    下面配置会让selinux的关闭重启系统后还是关闭状态。但是配置不会立即生效。

.. attention::
    通过 ``source /etc/selinux/config`` 也不能让修改的文件立即生效。所以需要下面的临时关闭的方式结合使用。

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    [root@ldap_001 ~]# grep SELINUX /etc/selinux/config
    # SELINUX= can take one of these three values:
    SELINUX=disabled
    # SELINUXTYPE= can take one of these two values:
    SELINUXTYPE=targeted

**临时关闭：**
    下面配置是立即生效，但是系统重启后会失效。

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# getenforce
    Enforcing
    [root@ldap_001 ~]# setenforce 0
    [root@ldap_001 ~]# getenforce
    Permissive




关闭防火墙
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    防火墙一般都是关闭。如果不不关闭，也可以通过配置规则允许所有使用的端口被访问。

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# /etc/init.d/iptables stop 
    iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
    iptables: Flushing firewall rules:                         [  OK  ]
    iptables: Unloading modules:                               [  OK  ]

关闭防火墙开机自启动

.. code-block:: bash
    :linenos:
    
    [root@ldap_001 ~]# chkconfig iptables off


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


openldap安装
======================================================================================================================================================


安装
------------------------------------------------------------------------------------------------------------------------------------------------------

官方编译安装资料(依赖包也有介绍)：
    http://www.openldap.org/doc/admin24/install.html


安装openldap依赖包：

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# yum update nss-softokn-freebl -y



安装openldap：

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# yum install openldap openldap* -y
    [root@ldap_001 ~]# yum -y install openldap openldap-servers openldap-clients openldap-devel compat-openldap

.. tip::
    compat-openldap这个包与主从关系

.. tip::
    如果报错，可以通过命令：
        ``yum install openldap openldap* --skip-broken -y``





检查安装：

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# rpm -qa openldap*
    openldap-2.4.40-16.el6.x86_64
    openldap-clients-2.4.40-16.el6.x86_64
    openldap-servers-2.4.40-16.el6.x86_64
    openldap-devel-2.4.40-16.el6.x86_64
    openldap-servers-sql-2.4.40-16.el6.x86_64

安装命令集合
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    yum update nss-softokn-freebl -y
    yum -y install openldap openldap-servers openldap-clients openldap-devel compat-openldap







openldap配置
======================================================================================================================================================


openldap的版本区别：
    2.3/2.4区别：http://www.openldap.org/doc/admin24/slapdconf2.html

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# cd /etc/openldap/
    [root@ldap_001 openldap]# pwd
    /etc/openldap
    [root@ldap_001 openldap]# ls
    certs  check_password.conf  ldap.conf  schema  slapd.d

使用openldap2.3的配置文件方式配置2.4：


    [root@ldap_001 openldap]# cp /usr/share/openldap-servers/slapd.conf.obsolete /etc/openldap/slapd.conf
    [root@ldap_001 openldap]# ls
    certs  check_password.conf  ldap.conf  schema  slapd.conf  slapd.d

openldap2.4配置文件应该是：

[root@ldap_001 openldap]# ls /etc/openldap/slapd.d/cn\=config
cn=schema       olcDatabase={0}config.ldif     olcDatabase={1}monitor.ldif
cn=schema.ldif  olcDatabase={-1}frontend.ldif  olcDatabase={2}bdb.ldif


配置ldap密码管理员用户名和密码：

.. code-block:: bash
    :linenos:

    [root@ldap_001 openldap]# slappasswd -s zzjlogin |sed -e "s#{SSHA}#rootpw\t{SSHA}#g"
    rootpw {SSHA}5m7kDrKUSFkSusbuo9gtwztk71TwK9VI
    [root@ldap_001 openldap]# slappasswd -s zzjlogin |sed -e "s#{SSHA}#rootpw\t{SSHA}#g" >>slapd.conf
    [root@ldap_001 openldap]# tail -1 slapd.conf
    rootpw {SSHA}iabLjB/VTzg4sm5hMBA+pJ5aZq0dAJgh

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# vi /etc/openldap/slapd.conf


修改下面几行：

.. code-block:: bash
    :linenos:

    114 database        bdb
    115 suffix          "dc=my-domain,dc=com"
    116 checkpoint      1024 15
    117 rootdn          "cn=Manager,dc=my-domain,dc=com"

改成：

.. code-block:: bash
    :linenos:

    database        bdb
    suffix          "dc=display,dc=tk"
    rootdn          "cn=admin,dc=display,dc=tk"

.. code-block:: bash
    :linenos:

    sed -i 's#suffix          "dc=my-domain,dc=com"#suffix          "dc=display,dc=tk"#g' /etc/openldap/slapd.conf
    sed -i 's#rootdn          "cn=Manager,dc=my-domain,dc=com"#rootdn          "cn=admin,dc=display,dc=tk"#g' /etc/openldap/slapd.conf


配置文件说名：
    - 配置文件中每个配置项的先后顺序尽量不变，修改后可能导致错误故障；
    - 空行和以 ``#`` 开始的行都会自动忽略
    - 每行的起始如果是空格则会认为是和上一行是同一行的内容。如果上一行是注释，则这一行也是注释。

追加内容到文件 ``/etc/openldap/slapd.conf``

.. code-block:: bash
    :linenos:

    # add start by zzjlogin 20181029
    loglevel        256
    cachesize   1000
    checkpoint  2048    10
    # add end by zzjlogin 20181029

.. code-block:: bash
    :linenos:

    echo "# add start by zzjlogin 20181029">>/etc/openldap/slapd.conf
    echo "loglevel        256">>/etc/openldap/slapd.conf
    echo "cachesize   1000">>/etc/openldap/slapd.conf
    echo "checkpoint  2048    10">>/etc/openldap/slapd.conf
    echo "# add end by zzjlogin 20181029">>/etc/openldap/slapd.conf

openldap日志级别设置选择参考：



权限控制配置文件 ``/etc/openldap/slapd.conf``

.. code-block:: bash
    :linenos:

     98 database config
     99 access to *
    100         by dn.exact="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage
    101         by * none
    102 
    103 # enable server status monitoring (cn=monitor)
    104 database monitor
    105 access to *
    106         by dn.exact="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read
    107         by dn.exact="cn=Manager,dc=my-domain,dc=com" read
    108         by * none

把上面内容可以去掉。

.. code-block:: bash
    :linenos:

    access to *
    access to *
        by self write
        by dn.subtree="ou=sysusers,dc=intra,dc=qq,dc=com" read
        by anonymous auth

    access to *
        by self write
        by dn.exact="uid=auth,ou=sysusers,dc=intra,dc=qq,dc=com" peername.regex=127\.0\.0\.1 write
        by dn.subtree="ou=sysusers,dc=intra,dc=qq,dc=com" read
        by anonymous auth

    access to *
        by self write
        by anonymous auth
        by * read

配置openldap的数据库配置

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# grep directory /etc/openldap/slapd.conf
    # Do not enable referrals until AFTER you have a working directory
    # The database directory MUST exist prior to running slapd AND 
    directory       /var/lib/ldap


    [root@ldap_001 ~]# cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/
    [root@ldap_001 ~]# ll /var/lib/ldap/
    total 4
    -rw-r--r-- 1 root root 845 Oct 22 00:49 DB_CONFIG.example
    [root@ldap_001 ~]# chown ldap.ldap -R /var/lib/ldap/*
    [root@ldap_001 ~]# chmod 700 /var/lib/ldap/DB_CONFIG.example
    [root@ldap_001 ~]# ll /var/lib/ldap/
    total 4
    -rwx------ 1 ldap ldap 845 Oct 22 00:49 DB_CONFIG.example




测试openldap：

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# slaptest -u
    config file testing succeeded


配置openldap的日志记录：

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# cp /etc/rsyslog.conf /etc/rsyslog.conf.`date +%F`
    [root@ldap_001 ~]# ll /etc/rsyslog.*
    -rw-r--r--. 1 root root 2875 Aug 15  2013 /etc/rsyslog.conf
    -rw-r--r--  1 root root 2875 Oct 22 00:27 /etc/rsyslog.conf.2018-10-22

    /etc/rsyslog.d:
    total 0
    [root@ldap_001 ~]# echo '#record ldaplog by zzjlogin 20181029'>>/etc/rsyslog.conf
    [root@ldap_001 ~]# echo 'local4.*                /var/log/ldap.log'>>/etc/rsyslog.conf
    [root@ldap_001 ~]# tail -1 /etc/rsyslog.conf
    local4.*                /var/log/ldap.log

    [root@ldap_001 ~]# /etc/init.d/rsyslog restart
    Shutting down system logger:                               [  OK  ]


openldap启动检查

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# /etc/init.d/slapd start
    Starting slapd:                                            [  OK  ]
    [root@ldap_001 ~]# ss -lntup|grep 389|column -t
    tcp  LISTEN  0  128  :::389  :::*  users:(("slapd",55575,8))
    tcp  LISTEN  0  128  *:389   *:*   users:(("slapd",55575,7))

未加密的是389，加密后是636

官方启动openldap方法：
    http://www.openldap.org/doc/admin24/runningslapd.html

openldap日志查看

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# tail /var/log/ldap.log
    Oct 22 00:53:20 ldap_001 slapd[55574]: @(#) $OpenLDAP: slapd 2.4.40 (Mar 22 2017 06:29:21) $#012#011mockbuild@c1bm.rdu2.centos.org:/builddir/build/BUILD/openldap-2.4.40/openldap-2.4.40/build-servers/servers/slapd


数据链接会出错，所以以下操作

.. code-block:: bash
    :linenos:

    [root@ldap_001 openldap]# rm -rf /etc/openldap/slapd.d/*

    [root@ldap_001 openldap]# slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d/

    [root@ldap_001 openldap]# chown -R ldap.ldap /etc/openldap/slapd.d/



数据测试：

.. code-block:: none
    :linenos:

    [root@ldap_001 openldap]# ldapsearch -LLL -W -x -H ldap://192.168.161.137 -D "cn=admin, dc=display, dc=tk" -b "dc=display, dc=tk""(uid=*)"
    Enter LDAP Password: 
    No such object (32)
 
.. code-block:: bash
    :linenos:

    [root@ldap_001 openldap]# ldapsearch -LLL -W -x -h 192.168.161.137 -D "cn=admin, dc=display, dc=tk" -b "dc=display, dc=tk""(uid=*)"         
    Enter LDAP Password: 
    No such object (32)

下面错误：

.. code-block:: none
    :linenos:

    [root@ldap_001 openldap]# ldapsearch -LLL -W -x -H ldap://display.tk -D "cn=admin, dc=display, dc=tk" -b "dc=display, dc=tk""(uid=*)"
    Enter LDAP Password: 
    ldap_sasl_bind(SIMPLE): Can't contact LDAP server (-1)


原因：
    ldap使用域名，域名对应的主机不是ldap服务器，可以用IP代替域名或者用-h参数指定ldapserver即可。
    也可以修改本地/etc/hosts文件中ldap域名和IP的映射关系。

openldap配置命令集合
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    cd /etc/openldap/
    cp /usr/share/openldap-servers/slapd.conf.obsolete /etc/openldap/slapd.conf
    sed  -i '98,108s/.*/#&/g' /etc/openldap/slapd.conf
    sed -i '108a\    by * read' /etc/openldap/slapd.conf
    sed -i '108a\    by anonymous auth' /etc/openldap/slapd.conf
    sed -i '108a\    by self write' /etc/openldap/slapd.conf
    sed -i '108a\access to *' /etc/openldap/slapd.conf
    slappasswd -s zzjlogin |sed -e "s#{SSHA}#rootpw\t{SSHA}#g" >>slapd.conf
    sed  -i 's#suffix\t\t"dc=my-domain,dc=com"#suffix          "dc=display,dc=tk"#g' /etc/openldap/slapd.conf
    sed -i 's#rootdn\t\t"cn=Manager,dc=my-domain,dc=com"#rootdn          "cn=admin,dc=display,dc=tk"#g' /etc/openldap/slapd.conf
    echo "# add start by zzjlogin 20181029">>/etc/openldap/slapd.conf
    echo "cachesize   1000">>/etc/openldap/slapd.conf
    echo "checkpoint  2048    10">>/etc/openldap/slapd.conf
    echo "# add end by zzjlogin 20181029">>/etc/openldap/slapd.conf
    cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/
    chown ldap.ldap -R /var/lib/ldap/*
    chmod 700 /var/lib/ldap/DB_CONFIG.example
    cp /etc/rsyslog.conf /etc/rsyslog.conf.`date +%F`
    echo '#record ldaplog by zzjlogin 20181029'>>/etc/rsyslog.conf
    echo 'local4.*                /var/log/ldap.log'>>/etc/rsyslog.conf
    /etc/init.d/rsyslog restart
    rm -rf /etc/openldap/slapd.d/*
    slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d/
    chown -R ldap.ldap /etc/openldap/slapd.d/
    chown ldap /var/lib/ldap/*
    /etc/init.d/slapd start

    ldapsearch -LLL -W -x -H ldap://192.168.1.142 -D "cn=admin, dc=display, dc=tk" -b "dc=display, dc=tk" "(uid=*)"


.. tip::
    ``ldapsearch`` 命令查询用户时， ``"(uid=*)"`` 前面需要有空格，否则查询不到数据。






openldap数据管理
------------------------------------------------------------------------------------------------------------------------------------------------------

BS结构:web服务器客户端方式：

lamp安装以及lamp链接openldap的插件安装：


.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# yum install httpd php php-ldap php-gd -y

    [root@ldap_001 ~]# rpm -qa httpd php php-ldap php-gd
    php-gd-5.3.3-49.el6.x86_64
    php-5.3.3-49.el6.x86_64
    php-ldap-5.3.3-49.el6.x86_64
    httpd-2.2.15-69.el6.centos.x86_64

安装：

.. code-block:: bash
    :linenos:

    [root@ldap_001 tools]# wget http://prdownloads.sourceforge.net/lam/ldap-account-manager-3.9.tar.gz

    [root@ldap_001 tools]# tar zxf ldap-account-manager-3.9.tar.gz
    [root@ldap_001 tools]# cd ldap-account-manager-3.9
    [root@ldap_001 ldap-account-manager-3.9]# 


    [root@ldap_001 config]# pwd
    /data/tools/ldap-account-manager-3.9/config
    [root@ldap_001 config]# cp config.cfg_sample config.cfg
    [root@ldap_001 config]# cp lam.conf_sample lam.conf
    [root@ldap_001 config]# ls
    config.cfg  config.cfg_sample  lam.conf  lam.conf_sample  language  pdf  profiles  selfService  shells

    [root@ldap_001 config]# vi lam.conf

    #admins: cn=Manager,dc=my-domain,dc=com
    admins: cn=admin,dc=display,dc=tk

    #types: suffix_user: ou=People,dc=my-domain,dc=com
    types: suffix_user: ou=People,dc=display,dc=tk

    #types: suffix_group: ou=group,dc=my-domain,dc=com
    types: suffix_group: ou=group,dc=display,dc=tk


    #types: suffix_host: ou=machines,dc=my-domain,dc=com
    types: suffix_host: ou=machines,dc=display,dc=tk

    #types: suffix_smbDomain: dc=my-domain,dc=com
    types: suffix_smbDomain: dc=display,dc=tk

.. code-block:: bash
    :linenos:



.. code-block:: bash
    :linenos:

    [root@ldap_001 config]# cd ../..

    [root@ldap_001 tools]# cp -r ldap-account-manager-3.9 /var/www/html/ldap
    [root@ldap_001 tools]# ls /var/www/html/
    ldap
    [root@ldap_001 tools]# ls /var/www/html/ldap/
    config     configure.ac  copyright  graphics  HISTORY     install.sh  locale       README  style      tmp
    configure  COPYING       docs       help      index.html  lib         Makefile.in  sess    templates  VERSION
    [root@ldap_001 tools]# chown apache.apache -R /var/www/html/ldap


    [root@ldap_001 tools]# /etc/init.d/httpd start

openldap服务端安装配置+dap-account-manager安装配置命令汇总(master)
======================================================================================================================================================

.. code-block:: bash
    :linenos:
    
    ntpdate pool.ntp.org
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    /etc/init.d/iptables stop 
    chkconfig iptables off

    yum update nss-softokn-freebl -y
    yum -y install openldap openldap-servers openldap-clients openldap-devel compat-openldap

    cd /etc/openldap/
    cp /usr/share/openldap-servers/slapd.conf.obsolete /etc/openldap/slapd.conf
    sed  -i '98,108s/.*/#&/g' /etc/openldap/slapd.conf
    sed -i '108a\    by * read' /etc/openldap/slapd.conf
    sed -i '108a\    by anonymous auth' /etc/openldap/slapd.conf
    sed -i '108a\    by self write' /etc/openldap/slapd.conf
    sed -i '108a\access to *' /etc/openldap/slapd.conf
    slappasswd -s zzjlogin |sed -e "s#{SSHA}#rootpw\t{SSHA}#g" >>slapd.conf
    sed  -i 's#suffix\t\t"dc=my-domain,dc=com"#suffix          "dc=display,dc=tk"#g' /etc/openldap/slapd.conf
    sed -i 's#rootdn\t\t"cn=Manager,dc=my-domain,dc=com"#rootdn          "cn=admin,dc=display,dc=tk"#g' /etc/openldap/slapd.conf
    echo "# add start by zzjlogin 20181029">>/etc/openldap/slapd.conf
    echo "cachesize   1000">>/etc/openldap/slapd.conf
    echo "checkpoint  2048    10">>/etc/openldap/slapd.conf
    echo "# add end by zzjlogin 20181029">>/etc/openldap/slapd.conf
    cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/
    chown ldap.ldap -R /var/lib/ldap/*
    chmod 700 /var/lib/ldap/DB_CONFIG.example
    cp /etc/rsyslog.conf /etc/rsyslog.conf.`date +%F`
    echo '#record ldaplog by zzjlogin 20181029'>>/etc/rsyslog.conf
    echo 'local4.*                /var/log/ldap.log'>>/etc/rsyslog.conf
    /etc/init.d/rsyslog restart
    rm -rf /etc/openldap/slapd.d/*
    slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d/
    chown -R ldap.ldap /etc/openldap/slapd.d/
    chown ldap /var/lib/ldap/*
    /etc/init.d/slapd start

    ldapsearch -LLL -w zzjlogin -x -H ldap://192.168.1.142 -D "cn=admin, dc=display, dc=tk" -b "dc=display, dc=tk" "(uid=*)"

    yum install httpd php php-ldap php-gd -y
    sed -i "277i ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf
    mkdir /data/tools -p
    cd /data/tools
    wget http://prdownloads.sourceforge.net/lam/ldap-account-manager-3.9.tar.gz
    tar zxf ldap-account-manager-3.9.tar.gz

    cd ldap-account-manager-3.9/config
    cp config.cfg_sample config.cfg
    cp lam.conf_sample lam.conf

    sed -i 's#admins: cn=Manager,dc=my-domain,dc=com#admins: cn=admin,dc=display,dc=tk#g' lam.conf
    sed -i 's#types: suffix_user: ou=People,dc=my-domain,dc=com#types: suffix_user: ou=People,dc=display,dc=tk#g' lam.conf
    sed -i 's#types: suffix_group: ou=group,dc=my-domain,dc=com#types: suffix_group: ou=group,dc=display,dc=tk#g' lam.conf
    sed -i 's#types: suffix_host: ou=machines,dc=my-domain,dc=com#types: suffix_host: ou=machines,dc=display,dc=tk#g' lam.conf
    sed -i 's#types: suffix_smbDomain: dc=my-domain,dc=com#types: suffix_smbDomain: dc=display,dc=tk#g' lam.conf
    cd ../..
    cp -r ldap-account-manager-3.9 /var/www/html/ldap
    chown apache.apache -R /var/www/html/ldap
    /etc/init.d/httpd start





openldap客户端安装配置
======================================================================================================================================================

.. code-block:: bash
    :linenos:
