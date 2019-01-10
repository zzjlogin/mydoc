.. _zzjlogin-nginx-rpminstall:

======================================================================================================================================================
nginx rpm安装
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

    [root@zzjlogin ~]# yum install pcre pcre-devel openssl -y


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



nginx添加nginx源
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# cat >/etc/yum.repos.d/nginx.repo<<EOF
    [nginx]
    name=nginx repo
    baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
    gpgcheck=0
    enabled=1
    EOF

    [root@zzjlogin ~]# ll /etc/yum.repos.d/nginx.repo
    -rw-r--r--. 1 root root 90 9月   6 21:17 /etc/yum.repos.d/nginx.repo
    [root@zzjlogin ~]# yum clean all
    [root@zzjlogin ~]# yum makecache




nginx yum安装
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# yum install nginx-1.12.2 -y

检查安装结果：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# rpm -qa nginx
    nginx-1.12.2-1.el6.ngx.x86_64


nginx 启动和测试
======================================================================================================================================================

yum方式安装的rpm软件包的二进制执行文件： ``/usr/sbin/nginx``

启动

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /etc/init.d/nginx start
    Starting nginx:                                            [  OK  ]

关闭

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /etc/init.d/nginx stop
    Stopping nginx:                                            [  OK  ]

状态查看

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /etc/init.d/nginx status
    nginx (pid  3188) is running...


查看监听端口

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# netstat -lntup
    Active Internet connections (only servers)
    Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name   
    tcp        0      0 0.0.0.0:22                  0.0.0.0:*                   LISTEN      1197/sshd           
    tcp        0      0 127.0.0.1:25                0.0.0.0:*                   LISTEN      1301/master         
    tcp        0      0 0.0.0.0:80                  0.0.0.0:*                   LISTEN      3246/nginx          
    tcp        0      0 :::22                       :::*                        LISTEN      1197/sshd           
    tcp        0      0 ::1:25                      :::*                        LISTEN      1301/master         
    udp        0      0 0.0.0.0:68                  0.0.0.0:*                               958/dhclient

本地测试

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# curl 127.0.0.1

查看nginx安装参数：

.. code-block:: bash
    :linenos:

    /usr/sbin/nginx -V


