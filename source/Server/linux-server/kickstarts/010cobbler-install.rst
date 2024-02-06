.. _centos-cobbler-install:

======================================================================================================================================================
cobbler安装配置
======================================================================================================================================================


:Date: 2018-09

.. contents::


系统环境准备
======================================================================================================================================================

系统版本
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# cat /etc/redhat-release
    CentOS release 6.6 (Final)
    [root@centos-node1 ~]# uname -r
    2.6.32-504.el6.x86_64
    [root@centos-node1 ~]# cat /etc/sysconfig/network
    NETWORKING=yes
    HOSTNAME=centos-node1

网络时间同步
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    如果时间没有和网络同步，yum安装会报错。
    
    参考:
        :ref:`linux-yuminstallerr-time`

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# date
    Thu Sep  6 21:07:25 CST 2018
    [root@centos-cobbler ~]# ntpdate pool.ntp.org
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

    [root@centos-cobbler ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    [root@centos-cobbler ~]# grep SELINUX /etc/selinux/config
    # SELINUX= can take one of these three values:
    SELINUX=disabled
    # SELINUXTYPE= can take one of these two values:
    SELINUXTYPE=targeted

**临时关闭：**
    下面配置是立即生效，但是系统重启后会失效。

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# getenforce
    Enforcing
    [root@centos-cobbler ~]# setenforce 0
    [root@centos-cobbler ~]# getenforce
    Permissive




关闭防火墙
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    防火墙一般都是关闭。如果不不关闭，也可以通过配置规则允许所有使用的端口被访问。

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# /etc/init.d/iptables stop 
    iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
    iptables: Flushing firewall rules:                         [  OK  ]
    iptables: Unloading modules:                               [  OK  ]

关闭防火墙开机自启动

.. code-block:: bash
    :linenos:
    
    [root@centos-cobbler ~]# chkconfig iptables off


epel源导入
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:
    
    [root@centos-cobbler ~]# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
    [root@centos-cobbler ~]# rpm -ivh http://mirrors.aliyun.com/epel/epel-release-latest-6.noarch.rpm

系统准备命令集合
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    ntpdate pool.ntp.org
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    /etc/init.d/iptables stop 
    chkconfig iptables off
    rpm -ivh http://mirrors.aliyun.com/epel/epel-release-latest-6.noarch.rpm


cobbler安装
======================================================================================================================================================

参考：
    https://www.ibm.com/developerworks/cn/linux/l-cobbler/index.html

安装依赖包：
    - mod_ssl
    - python-cheetah
    - createrepo
    - python-netaddr
    - genisoimage
    - mod_wsgi
    - libpthread.so.0
    - libpython2.6.so.1.0
    - python-libs
    - python-simplejson
    - libyaml
    - PyYAML
    - Django
    - syslinux


.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# yum -y install mod_ssl python-cheetah createrepo python-netaddr genisoimage mod_wsgi syslinux
    [root@centos-cobbler ~]#  yum install libpthread.so.0 -y
    [root@centos-cobbler ~]#  yum install libpython2.6.so.1.0 -y
    [root@centos-cobbler ~]#  yum install python-libs -y
    [root@centos-cobbler ~]#  yum install -y python-simplejson
    [root@centos-cobbler ~]# rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/libyaml-0.1.3-4.el6_6.x86_64.rpm
    [root@centos-cobbler ~]# rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/PyYAML-3.10-3.1.el6.x86_64.rpm
    [root@centos-cobbler ~]# rpm -ivh https://kojipkgs.fedoraproject.org//packages/Django14/1.4.14/1.el6/noarch/Django14-1.4.14-1.el6.noarch.rpm

安装cobbler和所需的服务

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# yum -y install cobbler cobbler-web dhcp tftp-server pykickstart httpd

检查cobbler安装路径信息：

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# rpm -ql cobbler

以下只是部分目录说明
------------------------------------------------------------------------------------------------------------------------------------------------------

配置文件目录 ``/etc/cobbler``

============================== =================================================================
/etc/cobbler                   配置文件目录
------------------------------ -----------------------------------------------------------------
/etc/cobbler/settings          cobbler主配置文件，这个文件是YAML格式，Cobbler是python写的程序。
------------------------------ -----------------------------------------------------------------
/etc/cobbler/dhcp.template     DHCP服务的配置模板
------------------------------ -----------------------------------------------------------------
/etc/cobbler/tftpd.template    tftp服务的配置模板
------------------------------ -----------------------------------------------------------------
/etc/cobbler/rsync.template    rsync服务的配置模板
------------------------------ -----------------------------------------------------------------
/etc/cobbler/iso               iso模板配置文件目录
------------------------------ -----------------------------------------------------------------
/etc/cobbler/pxe               pxe模板文件目录
------------------------------ -----------------------------------------------------------------
/etc/cobbler/power             电源的配置文件目录
------------------------------ -----------------------------------------------------------------
/etc/cobbler/users.conf        Web服务授权配置文件
------------------------------ -----------------------------------------------------------------
/etc/cobbler/users.digest      用于web访问的用户名密码配置文件
------------------------------ -----------------------------------------------------------------
/etc/cobbler/dnsmasq.template  DNS服务的配置模板
------------------------------ -----------------------------------------------------------------
/etc/cobbler/modules.conf      Cobbler模块配置文件
============================== =================================================================

数据目录 ``/var/lib/cobbler``

============================== =================================================================
/var/lib/cobbler/config        配置文件
------------------------------ -----------------------------------------------------------------
/var/lib/cobbler/kickstarts    默认存放kickstart文件
------------------------------ -----------------------------------------------------------------
/var/lib/cobbler/loaders       存放的各种引导程序
============================== =================================================================


cobbler导入的镜像目录 ``/var/www/cobbler``


============================== =================================================================
/var/www/cobbler/ks_mirror     导入的系统镜像列表
------------------------------ -----------------------------------------------------------------
/var/www/cobbler/images        导入的系统镜像启动文件
------------------------------ -----------------------------------------------------------------
/var/www/cobbler/repo_mirror   yum源存储目录
============================== =================================================================

cobbler日志目录 ``/var/log/cobbler``

============================== =================================================================
/var/log/cobbler/install.log   客户端系统安装日志
------------------------------ -----------------------------------------------------------------
/var/log/cobbler/cobbler.log   cobbler日志
============================== =================================================================

配置httpd配置文件并启动httpd服务

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# sed -i "277i ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf

    [root@centos-cobbler ~]# /etc/init.d/httpd restart

启动cobbler服务

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# /etc/init.d/cobblerd start

安装命令汇总
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    yum -y install mod_ssl python-cheetah createrepo python-netaddr genisoimage mod_wsgi syslinux libpthread.so.0 libpython2.6.so.1.0 python-libs python-simplejson
    rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/libyaml-0.1.3-4.el6_6.x86_64.rpm
    rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/PyYAML-3.10-3.1.el6.x86_64.rpm
    rpm -ivh https://kojipkgs.fedoraproject.org//packages/Django14/1.4.14/1.el6/noarch/Django14-1.4.14-1.el6.noarch.rpm
    yum -y install cobbler cobbler-web dhcp tftp-server pykickstart httpd
    sed -i "277i ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf
    /etc/init.d/httpd restart
    /etc/init.d/cobblerd start


cobbler配置
======================================================================================================================================================

检查cobbler，如果检查报错，可以重启cobbler服务和httpd服务。或者参考： :ref:`centos-cobbler-faq`

检查需要配置的内容
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cobbler check
    The following are potential configuration items that you may want to fix:

    1 : The 'server' field in /etc/cobbler/settings must be set to something other than localhost, or kickstarting features will not work.  This should be a resolvable hostname or IP for the boot server as reachable by all machines that will use it.
    2 : For PXE to be functional, the 'next_server' field in /etc/cobbler/settings must be set to something other than 127.0.0.1, and should match the IP of the boot server on the PXE network.
    3 : SELinux is enabled. Please review the following wiki page for details on ensuring cobbler works correctly in your SELinux environment:
        https://github.com/cobbler/cobbler/wiki/Selinux
    4 : change 'disable' to 'no' in /etc/xinetd.d/tftp
    5 : some network boot-loaders are missing from /var/lib/cobbler/loaders, you may run 'cobbler get-loaders' to download them, or, if you only want to handle x86/x86_64 netbooting, you may ensure that you have installed a *recent* version of the syslinux package installed and can ignore this message entirely.  Files in this directory, should you want to support all architectures, should include pxelinux.0, menu.c32, elilo.efi, and yaboot. The 'cobbler get-loaders' command is the easiest way to resolve these requirements.
    6 : change 'disable' to 'no' in /etc/xinetd.d/rsync
    7 : since iptables may be running, ensure 69, 80/443, and 25151 are unblocked
    8 : debmirror package is not installed, it will be required to manage debian deployments and repositories
    9 : The default password used by the sample templates for newly installed machines (default_password_crypted in /etc/cobbler/settings) is still set to 'cobbler' and should be changed, try: "openssl passwd -1 -salt 'random-phrase-here' 'your-password-here'" to generate new one
    10 : fencing tools were not found, and are required to use the (optional) power management features. install cman or fence-agents to use them

    Restart cobblerd and then run 'cobbler sync' to apply changes.

修改cobbler配置文件
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cp /etc/cobbler/settings{,.ori}
    [root@centos-cobbler ~]# ls /etc/cobbler/
    auth.conf       completions       import_rsync_whitelist  modules.conf    power      rsync.exclude       settings        users.conf    zone.template
    cheetah_macros  dhcp.template     iso                     mongodb.conf    pxe        rsync.template      settings.ori    users.digest  zone_templates
    cobbler_bash    dnsmasq.template  ldap                    named.template  reporting  secondary.template  tftpd.template  version
    [root@centos-cobbler ~]# sed -i 's/server: 127.0.0.1/server: 192.168.6.10/' /etc/cobbler/settings
    [root@centos-cobbler ~]# sed -i 's/next_server: 127.0.0.1/next_server: 192.168.6.10/' /etc/cobbler/settings
    [root@centos-cobbler ~]# sed -i 's/manage_dhcp: 0/manage_dhcp: 1/' /etc/cobbler/settings
    [root@centos-cobbler ~]# sed -i 's/pxe_just_once: 0/pxe_just_once: 1/' /etc/cobbler/settings
    [root@centos-cobbler ~]# openssl passwd -1 -salt 'abc' '123'         
    $1$abc$98/EDagBiz63dxD3fhRFk1
    [root@centos-cobbler ~]# sed -i 's#default_password_crypted: "$1$mF86/UHC$WvcIcX2t6crBz2onWxyac."#default_password_crypted: "$1$abc$98/EDagBiz63dxD3fhRFk1"#' /etc/cobbler/settings

server: 127.0.0.1
    配置cobbler服务地址，这个IP需要是服务器本地IP，否则会报错。
next_server: 127.0.0.1
    用cobbler管理dhcp时，这是dhcp地址。PXE启动时通过这个服务器获取IP。
manage_dhcp: 0
    是否启用cobbler管理DHCP，此时不用配置dhcp，直接配置cobbler的dhcp配置模版，然后同步即可。1是启用，0是关闭。
pxe_just_once: 0
    是否启用PXE安装一次后当系统重启不自动循环重启。默认关闭，需要手动开启。
default_password_crypted: "$1$mF86/UHC$WvcIcX2t6crBz2onWxyac."
    当系统的kickstart文件中配置装机的root密码配置为 ``rootpw --iscrypted $default_password_crypted`` 时，安装的系统使用这个密码。



修改cobbler的dhcp模版
------------------------------------------------------------------------------------------------------------------------------------------------------

如果简单配置，可以参考kickstart安装过程中的DHCP配置，但是那样配置很多cobbler中的变量就不能用了。

本实例使用cobbler自带的dhcp模版，进行修改使用：

愿配置文件：

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cat /etc/cobbler/dhcp.template
    # ******************************************************************
    # Cobbler managed dhcpd.conf file
    #
    # generated from cobbler dhcp.conf template ($date)
    # Do NOT make changes to /etc/dhcpd.conf. Instead, make your changes
    # in /etc/cobbler/dhcp.template, as /etc/dhcpd.conf will be
    # overwritten.
    #
    # ******************************************************************

    ddns-update-style interim;

    allow booting;
    allow bootp;

    ignore client-updates;
    set vendorclass = option vendor-class-identifier;

    option pxe-system-type code 93 = unsigned integer 16;

    subnet 192.168.1.0 netmask 255.255.255.0 {
        option routers             192.168.1.5;
        option domain-name-servers 192.168.1.1;
        option subnet-mask         255.255.255.0;
        range dynamic-bootp        192.168.1.100 192.168.1.254;
        default-lease-time         21600;
        max-lease-time             43200;
        next-server                $next_server;
        class "pxeclients" {
            match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";
            if option pxe-system-type = 00:02 {
                    filename "ia64/elilo.efi";
            } else if option pxe-system-type = 00:06 {
                    filename "grub/grub-x86.efi";
            } else if option pxe-system-type = 00:07 {
                    filename "grub/grub-x86_64.efi";
            } else {
                    filename "pxelinux.0";
            }
        }

    }

    #for dhcp_tag in $dhcp_tags.keys():
        ## group could be subnet if your dhcp tags line up with your subnets
        ## or really any valid dhcpd.conf construct ... if you only use the
        ## default dhcp tag in cobbler, the group block can be deleted for a
        ## flat configuration
    # group for Cobbler DHCP tag: $dhcp_tag
    group {
            #for mac in $dhcp_tags[$dhcp_tag].keys():
                #set iface = $dhcp_tags[$dhcp_tag][$mac]
        host $iface.name {
            hardware ethernet $mac;
            #if $iface.ip_address:
            fixed-address $iface.ip_address;
            #end if
            #if $iface.hostname:
            option host-name "$iface.hostname";
            #end if
            #if $iface.netmask:
            option subnet-mask $iface.netmask;
            #end if
            #if $iface.gateway:
            option routers $iface.gateway;
            #end if
            #if $iface.enable_gpxe:
            if exists user-class and option user-class = "gPXE" {
                filename "http://$cobbler_server/cblr/svc/op/gpxe/system/$iface.owner";
            } else if exists user-class and option user-class = "iPXE" {
                filename "http://$cobbler_server/cblr/svc/op/gpxe/system/$iface.owner";
            } else {
                filename "undionly.kpxe";
            }
            #else
            filename "$iface.filename";
            #end if
            ## Cobbler defaults to $next_server, but some users
            ## may like to use $iface.system.server for proxied setups
            next-server $next_server;
            ## next-server $iface.next_server;
        }
            #end for
    }
    #end for

修改配置文件：

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# sed -i 's#subnet 192.168.1.0 netmask 255.255.255.0 {#subnet 192.168.6.0 netmask 255.255.255.0 {#' /etc/cobbler/dhcp.template
    [root@centos-cobbler ~]# sed -i 's#option routers             192.168.1.5;#option routers             192.168.6.2;#' /etc/cobbler/dhcp.template
    [root@centos-cobbler ~]# sed -i 's/option domain-name-servers 192.168.1.1;/#option domain-name-servers 192.168.1.1;/' /etc/cobbler/dhcp.template
    [root@centos-cobbler ~]# sed -i 's#range dynamic-bootp        192.168.1.100 192.168.1.254;#range dynamic-bootp        192.168.6.100 192.168.6.200;#' /etc/cobbler/dhcp.template

    [root@centos-cobbler ~]# cat /etc/cobbler/dhcp.template
    # ******************************************************************
    # Cobbler managed dhcpd.conf file
    #
    # generated from cobbler dhcp.conf template ($date)
    # Do NOT make changes to /etc/dhcpd.conf. Instead, make your changes
    # in /etc/cobbler/dhcp.template, as /etc/dhcpd.conf will be
    # overwritten.
    #
    # ******************************************************************

    ddns-update-style interim;

    allow booting;
    allow bootp;

    ignore client-updates;
    set vendorclass = option vendor-class-identifier;

    option pxe-system-type code 93 = unsigned integer 16;

    subnet 192.168.6.0 netmask 255.255.255.0 {
        option routers             192.168.6.1;
        #option domain-name-servers 192.168.1.1;
        option subnet-mask         255.255.255.0;
        range dynamic-bootp        192.168.6.100 192.168.6.200;
        default-lease-time         21600;
        max-lease-time             43200;
        next-server                $next_server;
        class "pxeclients" {
            match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";
            if option pxe-system-type = 00:02 {
                    filename "ia64/elilo.efi";
            } else if option pxe-system-type = 00:06 {
                    filename "grub/grub-x86.efi";
            } else if option pxe-system-type = 00:07 {
                    filename "grub/grub-x86_64.efi";
            } else {
                    filename "pxelinux.0";
            }
        }

    }

    #for dhcp_tag in $dhcp_tags.keys():
        ## group could be subnet if your dhcp tags line up with your subnets
        ## or really any valid dhcpd.conf construct ... if you only use the
        ## default dhcp tag in cobbler, the group block can be deleted for a
        ## flat configuration
    # group for Cobbler DHCP tag: $dhcp_tag
    group {
            #for mac in $dhcp_tags[$dhcp_tag].keys():
                #set iface = $dhcp_tags[$dhcp_tag][$mac]
        host $iface.name {
            hardware ethernet $mac;
            #if $iface.ip_address:
            fixed-address $iface.ip_address;
            #end if
            #if $iface.hostname:
            option host-name "$iface.hostname";
            #end if
            #if $iface.netmask:
            option subnet-mask $iface.netmask;
            #end if
            #if $iface.gateway:
            option routers $iface.gateway;
            #end if
            #if $iface.enable_gpxe:
            if exists user-class and option user-class = "gPXE" {
                filename "http://$cobbler_server/cblr/svc/op/gpxe/system/$iface.owner";
            } else if exists user-class and option user-class = "iPXE" {
                filename "http://$cobbler_server/cblr/svc/op/gpxe/system/$iface.owner";
            } else {
                filename "undionly.kpxe";
            }
            #else
            filename "$iface.filename";
            #end if
            ## Cobbler defaults to $next_server, but some users
            ## may like to use $iface.system.server for proxied setups
            next-server $next_server;
            ## next-server $iface.next_server;
        }
            #end for
    }
    #end for

修改tftp配置信息
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# sed -i '14s/yes/no/' /etc/xinetd.d/tftp
    [root@centos-cobbler ~]# sed -i '6s/yes/no/' /etc/xinetd.d/rsync

从网络获取cobbler配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@server ~]# /etc/init.d/xinetd start
    [root@server ~]# /etc/init.d/cobblerd restart

    [root@centos-cobbler ~]# cobbler get-loaders



cobbler配置信息同步到运行服务中
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cobbler sync
    task started: 2018-09-07_005728_sync
    task started (id=Sync, time=Fri Sep  7 00:57:28 2018)
    running pre-sync triggers
    cleaning trees
    removing: /var/lib/tftpboot/pxelinux.cfg/default
    removing: /var/lib/tftpboot/grub/images
    removing: /var/lib/tftpboot/grub/efidefault
    removing: /var/lib/tftpboot/grub/grub-x86.efi
    removing: /var/lib/tftpboot/grub/grub-x86_64.efi
    removing: /var/lib/tftpboot/s390x/profile_list
    copying bootloaders
    trying hardlink /var/lib/cobbler/loaders/grub-x86.efi -> /var/lib/tftpboot/grub/grub-x86.efi
    trying hardlink /var/lib/cobbler/loaders/grub-x86_64.efi -> /var/lib/tftpboot/grub/grub-x86_64.efi
    copying distros to tftpboot
    copying images
    generating PXE configuration files
    generating PXE menu structure
    rendering DHCP files
    generating /etc/dhcp/dhcpd.conf
    rendering TFTPD files
    generating /etc/xinetd.d/tftp
    cleaning link caches
    running post-sync triggers
    running python triggers from /var/lib/cobbler/triggers/sync/post/*
    running python trigger cobbler.modules.sync_post_restart_services
    running: dhcpd -t -q
    received on stdout: 
    received on stderr: 
    running: service dhcpd restart
    received on stdout: 正在启动 dhcpd：[确定]

    received on stderr: 
    running shell triggers from /var/lib/cobbler/triggers/sync/post/*
    running python triggers from /var/lib/cobbler/triggers/change/*
    running python trigger cobbler.modules.scm_track
    running shell triggers from /var/lib/cobbler/triggers/change/*
    *** TASK COMPLETE ***
    [root@centos-cobbler ~]# echo $?
    0

再次检查

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cobbler check

用浏览器访问 ``http://192.168.161.137/cobbler_web`` 进入如下界面：

.. tip::
    - 初始账号：cobbler
    - 初始密码：cobbler

修改初始密码的方法：
    - ``/etc/cobbler/users.conf`` Web服务授权配置文件
    - ``/etc/cobbler/users.digest`` 用于web访问的用户名密码配置文件

查看现在的密码：

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cat /etc/cobbler/users.digest
    cobbler:Cobbler:a2d6bae81669d707b72c0bd9806e01f3

设置Cobbler web用户登陆密码，在Cobbler组添加cobbler用户，提示输入2遍密码确认

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# htdigest /etc/cobbler/users.digest "Cobbler" cobbler
    Changing password for user cobbler in realm Cobbler
    New password: 123456
    Re-type new password:123456


.. image:: /Server/res/images/server/linux/kickstart/cobbler/cobbler-install001.png
    :align: center
    :height: 400 px
    :width: 800 px



cobbler配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    cp /etc/cobbler/settings{,.ori}

    sed -i 's/server: 127.0.0.1/server: 192.168.6.10/' /etc/cobbler/settings
    sed -i 's/next_server: 127.0.0.1/next_server: 192.168.6.10/' /etc/cobbler/settings
    sed -i 's/manage_dhcp: 0/manage_dhcp: 1/' /etc/cobbler/settings
    sed -i 's/pxe_just_once: 0/pxe_just_once: 1/' /etc/cobbler/settings
    sed -i 's#default_password_crypted: "$1$mF86/UHC$WvcIcX2t6crBz2onWxyac."#default_password_crypted: "$1$abc$98/EDagBiz63dxD3fhRFk1"#' /etc/cobbler/settings


    sed -i '14s/yes/no/' /etc/xinetd.d/tftp
    sed -i '6s/yes/no/' /etc/xinetd.d/rsync

    sed -i 's#subnet 192.168.1.0 netmask 255.255.255.0 {#subnet 192.168.6.0 netmask 255.255.255.0 {#' /etc/cobbler/dhcp.template
    sed -i 's#option routers             192.168.1.5;#option routers             192.168.6.1;#' /etc/cobbler/dhcp.template
    sed -i 's/option domain-name-servers 192.168.1.1;/#option domain-name-servers 192.168.1.1;/' /etc/cobbler/dhcp.template
    sed -i 's#range dynamic-bootp        192.168.1.100 192.168.1.254;#range dynamic-bootp        192.168.6.100 192.168.6.200;#' /etc/cobbler/dhcp.template

    /etc/init.d/xinetd start
    /etc/init.d/cobblerd restart

    cobbler get-loaders
    cobbler sync
    cobbler check


    
如果修改cobbler网页登陆密码：

.. code-block:: bash
    :linenos:
    
    htdigest /etc/cobbler/users.digest "Cobbler" cobbler


cobbler安装配置命令汇总
======================================================================================================================================================

.. code-block:: bash
    :linenos:
    
    ntpdate pool.ntp.org
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    /etc/init.d/iptables stop 
    chkconfig iptables off
    rpm -ivh http://mirrors.aliyun.com/epel/epel-release-latest-6.noarch.rpm
    
    yum -y install mod_ssl python-cheetah createrepo python-netaddr genisoimage mod_wsgi syslinux libpthread.so.0 libpython2.6.so.1.0 python-libs python-simplejson
    rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/libyaml-0.1.3-4.el6_6.x86_64.rpm
    rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/PyYAML-3.10-3.1.el6.x86_64.rpm
    rpm -ivh https://kojipkgs.fedoraproject.org//packages/Django14/1.4.14/1.el6/noarch/Django14-1.4.14-1.el6.noarch.rpm
    yum -y install cobbler cobbler-web dhcp tftp-server pykickstart httpd
    sed -i "277i ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf
    /etc/init.d/httpd restart
    /etc/init.d/cobblerd start

    cp /etc/cobbler/settings{,.ori}

    sed -i 's/server: 127.0.0.1/server: 192.168.6.10/' /etc/cobbler/settings
    sed -i 's/next_server: 127.0.0.1/next_server: 192.168.6.10/' /etc/cobbler/settings
    sed -i 's/manage_dhcp: 0/manage_dhcp: 1/' /etc/cobbler/settings
    sed -i 's/pxe_just_once: 0/pxe_just_once: 1/' /etc/cobbler/settings
    sed -i 's#default_password_crypted: "$1$mF86/UHC$WvcIcX2t6crBz2onWxyac."#default_password_crypted: "$1$abc$98/EDagBiz63dxD3fhRFk1"#' /etc/cobbler/settings


    sed -i '14s/yes/no/' /etc/xinetd.d/tftp
    sed -i '6s/yes/no/' /etc/xinetd.d/rsync

    sed -i 's#subnet 192.168.1.0 netmask 255.255.255.0 {#subnet 192.168.6.0 netmask 255.255.255.0 {#' /etc/cobbler/dhcp.template
    sed -i 's#option routers             192.168.1.5;#option routers             192.168.6.1;#' /etc/cobbler/dhcp.template
    sed -i 's/option domain-name-servers 192.168.1.1;/#option domain-name-servers 192.168.1.1;/' /etc/cobbler/dhcp.template
    sed -i 's#range dynamic-bootp        192.168.1.100 192.168.1.254;#range dynamic-bootp        192.168.6.100 192.168.6.200;#' /etc/cobbler/dhcp.template

    /etc/init.d/xinetd start
    /etc/init.d/cobblerd restart

    cobbler get-loaders
    cobbler sync
    cobbler check
