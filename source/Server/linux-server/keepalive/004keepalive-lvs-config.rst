.. _keepalive-lvs-config:

======================================================================================================================================================
keepalive+lvs安装配置
======================================================================================================================================================

:Date: 2018-09

.. contents::


keepalive+lvs环境
======================================================================================================================================================

服务器环境


服务器列表
    默认硬件、系统版本全部相同，只是主机名不同和网络配置不同

=================== ==============================================================
**主机名**                **IP**
------------------- --------------------------------------------------------------
web_101              192.168.1.140
------------------- --------------------------------------------------------------
web_102              192.168.1.142
------------------- --------------------------------------------------------------
web_201              192.168.1.151
------------------- --------------------------------------------------------------
web_202              192.168.1.102
=================== ==============================================================


=================== ==============================================================
系统版本                CentOS release 6.6 (Final)
------------------- --------------------------------------------------------------
硬件环境                x86_64
------------------- --------------------------------------------------------------
lvsadm                  ipvsadm-1.26
------------------- --------------------------------------------------------------
VIP                     192.168.1.250
------------------- --------------------------------------------------------------
keepalived              keepalived-1.1.19
=================== ==============================================================


服务器说明：
    - web_101：keepalive配置的master，lvs配置dr模式，vip使用192.168.1.250
    - web_102：keepalive配置的backup，lvs配置dr模式，vip使用192.168.1.250
    - web_201：lvs配置绑定VIP：192.168.1.250，提供web服务
    - web_202：lvs配置绑定VIP：192.168.1.250，提供web服务
    - web_201、web_202本实例配置的负载均衡。


keepalive+lvs安装
======================================================================================================================================================

安装准备
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    ntpdate pool.ntp.org
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    /etc/init.d/iptables stop 
    chkconfig iptables off


lvs安装
------------------------------------------------------------------------------------------------------------------------------------------------------

四台服务器都需要安装lvs的管理工具

.. code-block:: bash
    :linenos:

    yum install libnl* popt* -y
    ln -s /usr/src/kernels/2.6.32-504.el6.x86_64/ /usr/src/linux
    mkdir /data/tools -p
    cd /data/tools
    wget http://www.linuxvirtualserver.org/software/kernel-2.6/ipvsadm-1.26.tar.gz
    tar xf ipvsadm-1.26.tar.gz
    cd ipvsadm-1.26
    make
    make install


keepalive安装
------------------------------------------------------------------------------------------------------------------------------------------------------

在以下两台服务器安装keepalive：
    - web_101
    - web_102

.. code-block:: bash
    :linenos:

    yum install openssl openssl-devel libnfnetlink-devel -y
    cd /data/tools
    wget http://www.keepalived.org/software/keepalived-1.3.5.tar.gz
    tar xf keepalived-1.3.5.tar.gz
    cd keepalived-1.3.5
    ./configure
    make && make install

    cp /data/tools/keepalived-1.3.5/keepalived/etc/init.d/keepalived /etc/init.d/
    cp /usr/local/etc/sysconfig/keepalived /etc/sysconfig/
    mkdir /etc/keepalived -p
    cp /usr/local/etc/keepalived/keepalived.conf /etc/keepalived/
    cp /usr/local/sbin/keepalived /usr/sbin/
    chkconfig --add keepalived

.. note::
    keepalived1.3.5需要安装 ``libnfnetlink-devel`` 否则安装会报错。1.1.19则不用安装这个依赖包。

nginx安装
------------------------------------------------------------------------------------------------------------------------------------------------------

下面两台服务器需要安装nginx：
    - web_201
    - web_202

.. code-block:: bash
    :linenos:

    yum install pcre pcre-devel perl-CPAN gcc -y
    echo '[nginx]' >>/etc/yum.repos.d/nginx.repo
    echo 'name=nginx repo' >>/etc/yum.repos.d/nginx.repo
    echo 'baseurl=http://nginx.org/packages/centos/$releasever/$basearch/' >>/etc/yum.repos.d/nginx.repo
    echo 'gpgcheck=0' >>/etc/yum.repos.d/nginx.repo
    echo 'enabled=1' >>/etc/yum.repos.d/nginx.repo
    yum clean all
    yum makecache
    yum install nginx -y


keepalive+lvs配置
======================================================================================================================================================

web_101配置
------------------------------------------------------------------------------------------------------------------------------------------------------

keepalive配置过程：
    - keepalive日志记录配置
    - 修改配置文件

.. code-block:: bash
    :linenos:

    sed -i 's#KEEPALIVED_OPTIONS="-D"#KEEPALIVED_OPTIONS="-D -d -S 0"#g' /etc/sysconfig/keepalived
    echo '#save keepalived log to keepalive.log' >>/etc/rsyslog.conf
    echo 'local0.*                                                /var/log/keepalive.log'>>/etc/rsyslog.conf

    /etc/init.d/rsyslog restart

    
    

.. code-block:: bash
    :linenos:

    cp /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.`date +%F`
    >/etc/keepalived/keepalived.conf

.. code-block:: bash
    :linenos:

    vi /etc/keepalived/keepalived.conf

.. code-block:: bash
    :linenos:

    ! Configuration File for keepalived

    global_defs {
    #   notification_email {
    #       login_root@163.com
    #   }
    #   notification_email_from Alexandre.Cassen@firewall.loc
    #   smtp_server 127.0.0.1
    #   smtp_connect_timeout 30
        router_id LVS_101
    }

    vrrp_instance VI_1 {
        state MASTER
        interface eth0
        virtual_router_id 55
        priority 150
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.161.250
        }
    }

    virtual_server 192.168.1.250 80 {
        delay_loop 20
        lb_algo rr
        lb_kind DR
        persistence_timeout 50
        protocol TCP
        real_server 192.168.1.151 80 {
            weight 1
            TCP_CHECK {
                connect_timeout 3
                #nb_get_retry 3
                #delay_before_retry 3
                connect_port 80
            }
        }
        real_server 192.168.1.102 80 {
            weight 1
            TCP_CHECK {
                connect_timeout 3
                #nb_get_retry 3
                #delay_before_retry 3
                connect_port 80
            }
        }
    }



lvs配置过程：
    - 添加vip

.. code-block:: bash
    :linenos:

    ifconfig eth0:0 192.168.1.250/24


web_102配置
------------------------------------------------------------------------------------------------------------------------------------------------------

keepalive配置过程：
    - keepalive日志记录配置
    - 修改配置文件

.. code-block:: bash
    :linenos:

    sed -i 's#KEEPALIVED_OPTIONS="-D"#KEEPALIVED_OPTIONS="-D -d -S 0"#g' /etc/sysconfig/keepalived
    echo '#save keepalived log to keepalive.log' >>/etc/rsyslog.conf
    echo 'local0.*                                                /var/log/keepalive.log'>>/etc/rsyslog.conf

    /etc/init.d/rsyslog restart

    
    

.. code-block:: bash
    :linenos:

    cp /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.`date +%F`
    >/etc/keepalived/keepalived.conf

.. code-block:: bash
    :linenos:

    vi /etc/keepalived/keepalived.conf


.. code-block:: bash
    :linenos:

    ! Configuration File for keepalived

    global_defs {
    #   notification_email {
    #       login_root@163.com
    #   }
    #   notification_email_from Alexandre.Cassen@firewall.loc
    #   smtp_server 127.0.0.1
    #   smtp_connect_timeout 30
        router_id LVS_102
    }

    vrrp_instance VI_1 {
        state BACKUP
        interface eth0
        virtual_router_id 55
        priority 200
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.161.250
        }
    }

    virtual_server 192.168.1.250 80 {
        delay_loop 20
        lb_algo rr
        lb_kind DR
        persistence_timeout 50
        protocol TCP
        real_server 192.168.1.151 80 {
            weight 1
            TCP_CHECK {
                connect_timeout 3
                #nb_get_retry 3
                #delay_before_retry 3
                connect_port 80
            }
        }
        real_server 192.168.1.102 80 {
            weight 1
            TCP_CHECK {
                connect_timeout 3
                #nb_get_retry 3
                #delay_before_retry 3
                connect_port 80
            }
        }
    }

lvs配置过程：
    - 添加vip

.. code-block:: bash
    :linenos:

    ifconfig eth0:0 192.168.1.250/24

web_201配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    echo "1" > /proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "2" > /proc/sys/net/ipv4/conf/lo/arp_announce
    echo "1" > /proc/sys/net/ipv4/conf/all/arp_announce
    echo "2" > /proc/sys/net/ipv4/conf/all/arp_ignore
    ifconfig lo:0 192.168.1.250/32

web_202配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    echo "1" > /proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "2" > /proc/sys/net/ipv4/conf/lo/arp_announce
    echo "1" > /proc/sys/net/ipv4/conf/all/arp_announce
    echo "2" > /proc/sys/net/ipv4/conf/all/arp_ignore
    ifconfig lo:0 192.168.1.250/32

keepalive+lvs测试
======================================================================================================================================================













