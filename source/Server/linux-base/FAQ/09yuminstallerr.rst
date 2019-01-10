.. _server-linux-faq-yuminstallerr:

======================================================================================================================================================
yum安装报错及解决办法
======================================================================================================================================================



yum安装https的在线软件包报错
======================================================================================================================================================

**错误现象：**

.. code-block:: none
    :linenos:

    [root@zzjlogin ~]# rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
    Retrieving https://mirror.webtatic.com/yum/el6/latest.rpm
    curl: (60) Peer certificate cannot be authenticated with known CA certificates
    More details here: http://curl.haxx.se/docs/sslcerts.html

    curl performs SSL certificate verification by default, using a "bundle"
    of Certificate Authority (CA) public keys (CA certs). If the default
    bundle file isn't adequate, you can specify an alternate file
    using the --cacert option.
    If this HTTPS server uses a certificate signed by a CA represented in
    the bundle, the certificate verification probably failed due to a
    problem with the certificate (it might be expired, or the name might
    not match the domain name in the URL).
    If you'd like to turn off curl's verification of the certificate, use
    the -k (or --insecure) option.
    error: skipping https://mirror.webtatic.com/yum/el6/latest.rpm - transfer failed


**原因：**
    上面显示内容提示https需要证书，所以可以用http代替https。


**解决：**

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm 
    Retrieving http://mirror.webtatic.com/yum/el6/latest.rpm
    warning: /var/tmp/rpm-tmp.ZS63LO: Header V4 DSA/SHA1 Signature, key ID cf4c4ff9: NOKEY
        Preparing...                ########################################### [100%]
        1:webtatic-release       ########################################### [100%]

.. _linux-yuminstallerr-time:

14: Peer cert cannot be verified or peer cert invalid
======================================================================================================================================================

**错误现象：**

[root@zzjlogin ~]# yum install php56w -y
已加载插件：fastestmirror, security
设置安装进程
Determining fastest mirrors
Could not retrieve mirrorlist https://mirror.webtatic.com/yum/el6/x86_64/mirrorlist error was
14: Peer cert cannot be verified or peer cert invalid
错误：Cannot find a valid baseurl for repo: webtatic



**原因：**
    系统时间和当前时间不一致导致的不能安装。


**解决：**

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# date
    2018年 09月 06日 星期四 21:07:01 CST
    [root@zzjlogin ~]# ntpdate pool.ntp.org
    6 Sep 21:07:10 ntpdate[1583]: 80.65.85.94 rate limit response from server.
    27 Sep 13:37:16 ntpdate[1583]: step time server 85.199.214.98 offset 1787405.299392 sec
    [root@zzjlogin ~]# date
    2018年 09月 27日 星期四 13:37:18 CST
    [root@zzjlogin ~]# yum install php56w -y
    已加载插件：fastestmirror, security
    设置安装进程
    Determining fastest mirrors
    * base: mirrors.tuna.tsinghua.edu.cn
    * extras: mirrors.tuna.tsinghua.edu.cn
    * updates: mirrors.tuna.tsinghua.edu.cn
    * webtatic: sp.repo.webtatic.com
    base                                                                                                                                                  | 3.7 kB     00:00     
    extras                                                                                                                                                | 3.4 kB     00:00     
    extras/primary_db                                                                                                                                     |  26 kB     00:00     
    updates                                                                                                                                               | 3.4 kB     00:00     
    updates/primary_db                                                                                                                                    | 1.2 MB     00:00     
    webtatic                                                                                                                                              | 3.6 kB     00:00     
    webtatic/primary_db                                                                                                                                   | 443 kB     00:00     
    解决依赖关系
    --> 执行事务检查
    ---> Package php56w.x86_64 0:5.6.38-1.w6 will be 安装
    --> 处理依赖关系 php56w-common(x86-64) = 5.6.38-1.w6，它被软件包 php56w-5.6.38-1.w6.x86_64 需要
    --> 处理依赖关系 php56w-cli(x86-64) = 5.6.38-1.w6，它被软件包 php56w-5.6.38-1.w6.x86_64 需要
    --> 处理依赖关系 php56w-cli = 5.6.38-1.w6，它被软件包 php56w-5.6.38-1.w6.x86_64 需要
    --> 处理依赖关系 httpd-mmn = 20051115，它被软件包 php56w-5.6.38-1.w6.x86_64 需要
    --> 处理依赖关系 httpd，它被软件包 php56w-5.6.38-1.w6.x86_64 需要
    --> 执行事务检查
    ---> Package httpd.x86_64 0:2.2.15-69.el6.centos will be 安装
    --> 处理依赖关系 httpd-tools = 2.2.15-69.el6.centos，它被软件包 httpd-2.2.15-69.el6.centos.x86_64 需要
    --> 处理依赖关系 apr-util-ldap，它被软件包 httpd-2.2.15-69.el6.centos.x86_64 需要
    ---> Package php56w-cli.x86_64 0:5.6.38-1.w6 will be 安装
    ---> Package php56w-common.x86_64 0:5.6.38-1.w6 will be 安装
    --> 执行事务检查
    ---> Package apr-util-ldap.x86_64 0:1.3.9-3.el6_0.1 will be 安装
    ---> Package httpd-tools.x86_64 0:2.2.15-69.el6.centos will be 安装
    --> 完成依赖关系计算

    依赖关系解决

    =============================================================================================================================================================================
    软件包                                    架构                               版本                                                仓库                                  大小
    =============================================================================================================================================================================
    正在安装:
    php56w                                    x86_64                             5.6.38-1.w6                                         webtatic                             2.7 M
    为依赖而安装:
    apr-util-ldap                             x86_64                             1.3.9-3.el6_0.1                                     base                                  15 k
    httpd                                     x86_64                             2.2.15-69.el6.centos                                base                                 836 k
    httpd-tools                               x86_64                             2.2.15-69.el6.centos                                base                                  81 k
    php56w-cli                                x86_64                             5.6.38-1.w6                                         webtatic                             2.6 M
    php56w-common                             x86_64                             5.6.38-1.w6                                         webtatic                             1.2 M

    事务概要
    =============================================================================================================================================================================
    Install       6 Package(s)

    总下载量：7.4 M
    Installed size: 28 M
    下载软件包：
    (1/6): apr-util-ldap-1.3.9-3.el6_0.1.x86_64.rpm                                                                                                       |  15 kB     00:00     
    (2/6): httpd-2.2.15-69.el6.centos.x86_64.rpm                                                                                                          | 836 kB     00:00     
    (3/6): httpd-tools-2.2.15-69.el6.centos.x86_64.rpm                                                                                                    |  81 kB     00:00     
    (4/6): php56w-5.6.38-1.w6.x86_64.rpm                                                                                                                  | 2.7 MB     00:05     
    (5/6): php56w-cli-5.6.38-1.w6.x86_64.rpm                                                                                                              | 2.6 MB     00:08     
    (6/6): php56w-common-5.6.38-1.w6.x86_64.rpm                                                                                                           | 1.2 MB     00:03     
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    总计                                                                                                                                         438 kB/s | 7.4 MB     00:17     
    warning: rpmts_HdrFromFdno: Header V4 DSA/SHA1 Signature, key ID cf4c4ff9: NOKEY
    Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-webtatic-el6
    Importing GPG key 0xCF4C4FF9:
    Userid : Webtatic EL6 <el6@webtatic.com>
    Package: webtatic-release-6-9.noarch (installed)
    From   : /etc/pki/rpm-gpg/RPM-GPG-KEY-webtatic-el6
    运行 rpm_check_debug 
    执行事务测试
    事务测试成功
    执行事务
    Warning: RPMDB altered outside of yum.
    正在安装   : php56w-common-5.6.38-1.w6.x86_64                                                                                                                          1/6 
    正在安装   : php56w-cli-5.6.38-1.w6.x86_64                                                                                                                             2/6 
    正在安装   : apr-util-ldap-1.3.9-3.el6_0.1.x86_64                                                                                                                      3/6 
    正在安装   : httpd-tools-2.2.15-69.el6.centos.x86_64                                                                                                                   4/6 
    正在安装   : httpd-2.2.15-69.el6.centos.x86_64                                                                                                                         5/6 
    正在安装   : php56w-5.6.38-1.w6.x86_64                                                                                                                                 6/6 
    Verifying  : httpd-tools-2.2.15-69.el6.centos.x86_64                                                                                                                   1/6 
    Verifying  : php56w-common-5.6.38-1.w6.x86_64                                                                                                                          2/6 
    Verifying  : httpd-2.2.15-69.el6.centos.x86_64                                                                                                                         3/6 
    Verifying  : apr-util-ldap-1.3.9-3.el6_0.1.x86_64                                                                                                                      4/6 
    Verifying  : php56w-5.6.38-1.w6.x86_64                                                                                                                                 5/6 
    Verifying  : php56w-cli-5.6.38-1.w6.x86_64                                                                                                                             6/6 

    已安装:
    php56w.x86_64 0:5.6.38-1.w6                                                                                                                                                

    作为依赖被安装:
    apr-util-ldap.x86_64 0:1.3.9-3.el6_0.1      httpd.x86_64 0:2.2.15-69.el6.centos      httpd-tools.x86_64 0:2.2.15-69.el6.centos      php56w-cli.x86_64 0:5.6.38-1.w6     
    php56w-common.x86_64 0:5.6.38-1.w6         

    完毕！

