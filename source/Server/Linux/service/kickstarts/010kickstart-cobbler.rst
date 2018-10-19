.. _centos-cobbler-kickstart-cobbler:

========================================
cobbler安装配置
========================================



系统环境准备
========================================

系统版本
----------------------------------------

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
----------------------------------------

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
----------------------------------------

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
----------------------------------------

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
----------------------------------------

.. code-block:: bash
    :linenos:
    
    [root@centos-cobbler ~]# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
    [root@centos-cobbler ~]# rpm -ivh http://mirrors.aliyun.com/epel/epel-release-latest-6.noarch.rpm


cobbler安装
========================================

安装：

安装依赖包：

[root@centos-cobbler ~]# yum -y install mod_ssl python-cheetah createrepo python-netaddr genisoimage mod_wsgi syslinux PyYAM
[root@centos-cobbler pip-1.5.4]# yum install libpthread.so.0 -y
[root@centos-cobbler pip-1.5.4]# yum install libpython2.6.so.1.0 -y
[root@centos-cobbler pip-1.5.4]# yum install python-libs -y
[root@centos-cobbler pip-1.5.4]# yum install -y python-simplejson

[root@centos-cobbler pip-1.5.4]# rpm -ivh https://kojipkgs.fedoraproject.org//packages/Django14/1.4.14/1.el6/noarch/Django14-1.4.14-1.el6.noarch.rpm

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# yum -y install cobbler cobbler-web dhcp tftp-server pykickstart httpd

CentOS6.6安装会提示错误：

.. attention::
    错误信息：
        Package: cobbler-web-2.6.11-7.git95749a6.el6.noarch (epel)
            Requires: Django >= 1.4
        You could try using --skip-broken to work around the problem



[root@centos-cobbler ~]# LANG=en
[root@centos-cobbler ~]# mkdir /home/tools
[root@centos-cobbler ~]# cd /home/tools/
[root@centos-cobbler tools]# wget "https://pypi.python.org/packages/source/p/pip/pip-1.5.4.tar.gz#md5=834b2904f92d46aaa333267fb1c922bb" --no-check-certificate

[root@centos-cobbler tools]# tar -zxf pip-1.5.4.tar.gz
[root@centos-cobbler tools]# cd pip-1.5.4
[root@centos-cobbler pip-1.5.4]# python setup.py install


检查cobbler安装路径信息：

.. code-block:: bash
    :linenos:

[root@centos-cobbler ~]# rpm -ql cobbler

以下只是部分目录说明：

/etc/cobbler                  # 配置文件目录
/etc/cobbler/settings         # cobbler主配置文件，这个文件是YAML格式，Cobbler是python写的程序。
/etc/cobbler/dhcp.template    # DHCP服务的配置模板
/etc/cobbler/tftpd.template   # tftp服务的配置模板
/etc/cobbler/rsync.template   # rsync服务的配置模板
/etc/cobbler/iso              # iso模板配置文件目录
/etc/cobbler/pxe              # pxe模板文件目录
/etc/cobbler/power            # 电源的配置文件目录
/etc/cobbler/users.conf       # Web服务授权配置文件
/etc/cobbler/users.digest     # 用于web访问的用户名密码配置文件
/etc/cobbler/dnsmasq.template # DNS服务的配置模板
/etc/cobbler/modules.conf     # Cobbler模块配置文件
/var/lib/cobbler              # Cobbler数据目录
/var/lib/cobbler/config       # 配置文件
/var/lib/cobbler/kickstarts   # 默认存放kickstart文件
/var/lib/cobbler/loaders      # 存放的各种引导程序
/var/www/cobbler              # 系统安装镜像目录
/var/www/cobbler/ks_mirror    # 导入的系统镜像列表
/var/www/cobbler/images       # 导入的系统镜像启动文件
/var/www/cobbler/repo_mirror  # yum源存储目录
/var/log/cobbler              # 日志目录
/var/log/cobbler/install.log  # 客户端系统安装日志
/var/log/cobbler/cobbler.log  # cobbler日志


[root@centos-cobbler ~]# /etc/init.d/httpd restart


[root@centos-cobbler ~]# /etc/init.d/cobblerd start



cobbler配置
========================================


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


[root@centos-cobbler ~]# cp /etc/cobbler/settings{,.ori}
[root@centos-cobbler ~]# ls /etc/cobbler/
auth.conf       completions       import_rsync_whitelist  modules.conf    power      rsync.exclude       settings        users.conf    zone.template
cheetah_macros  dhcp.template     iso                     mongodb.conf    pxe        rsync.template      settings.ori    users.digest  zone_templates
cobbler_bash    dnsmasq.template  ldap                    named.template  reporting  secondary.template  tftpd.template  version
[root@centos-cobbler ~]# sed -i 's/server: 127.0.0.1/server: 192.168.6.10/' /etc/cobbler/setting           
sed: can't read /etc/cobbler/setting: No such file or directory
[root@centos-cobbler ~]# sed -i 's/server: 127.0.0.1/server: 192.168.6.10/' /etc/cobbler/settings
[root@centos-cobbler ~]# sed -i 's/next_server: 127.0.0.1/next_server: 192.168.6.10/' /etc/cobbler/settings        
[root@centos-cobbler ~]# sed -i 's/manage_dhcp: 0/manage_dhcp: 1/' /etc/cobbler/settings
[root@centos-cobbler ~]# sed -i 's/pxe_just_once: 0/pxe_just_once: 1/' /etc/cobbler/settings
[root@centos-cobbler ~]# openssl passwd -1 -salt 'abc' '123'         
$1$abc$98/EDagBiz63dxD3fhRFk1















