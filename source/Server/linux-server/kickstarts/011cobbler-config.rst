
.. _centos-cobbler-config:

======================================================================================================================================================
cobbler配置
======================================================================================================================================================

:Date: 2018-09

.. contents::


常用命令
======================================================================================================================================================


=================== ===================================
cobbler check       核对当前设置是否有问题
------------------- -----------------------------------
cobbler list        列出所有的cobbler元素
------------------- -----------------------------------
cobbler report      列出元素的详细信息
------------------- -----------------------------------
cobbler sync        同步配置到数据目录,更改配置最好都要执行下
------------------- -----------------------------------
cobbler reposync    同步yum仓库
------------------- -----------------------------------
cobbler distro      查看导入的发行版系统信息
------------------- -----------------------------------
cobbler system      查看添加的系统信息
------------------- -----------------------------------
cobbler profile     查看配置信息
=================== ===================================


cobbler增加镜像
======================================================================================================================================================


.. attention::
    本配置是在 :ref:`centos-cobbler-install` 的基础上配置

如果是外接光驱挂载命令：

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# mount /dev/cdrom /mnt/
    mount: block device /dev/sr0 is write-protected, mounting read-only

如果是把系统镜像文件传入cobbler服务器，则用：

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# mount -o loop /data/CentOS-6.6-x86_64-bin-DVD1.iso /mnt/

把挂载的镜像加入cobbler仓库：

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cobbler import --path=/mnt/ --name=CentOS-6.6-x86_64 --arch=x86_64
    task started: 2018-10-20_165429_import
    task started (id=Media import, time=Sat Oct 20 16:54:29 2018)
    Found a candidate signature: breed=redhat, version=rhel6
    Found a matching signature: breed=redhat, version=rhel6
    Adding distros from path /var/www/cobbler/ks_mirror/CentOS-6.6-x86_64:
    creating new distro: CentOS-6.6-x86_64
    trying symlink: /var/www/cobbler/ks_mirror/CentOS-6.6-x86_64 -> /var/www/cobbler/links/CentOS-6.6-x86_64
    creating new profile: CentOS-6.6-x86_64
    associating repos
    checking for rsync repo(s)
    checking for rhn repo(s)
    checking for yum repo(s)
    starting descent into /var/www/cobbler/ks_mirror/CentOS-6.6-x86_64 for CentOS-6.6-x86_64
    processing repo at : /var/www/cobbler/ks_mirror/CentOS-6.6-x86_64
    need to process repo/comps: /var/www/cobbler/ks_mirror/CentOS-6.6-x86_64
    looking for /var/www/cobbler/ks_mirror/CentOS-6.6-x86_64/repodata/*comps*.xml
    Keeping repodata as-is :/var/www/cobbler/ks_mirror/CentOS-6.6-x86_64/repodata
    *** TASK COMPLETE ***


--path=PATH
    必填项，镜像路径
--name
    必选项，为安装源定义一个名字，是cobbler中镜像的唯一标识，不可以重复，如果重复，系统会提示导入失败。可以用参数 ``--rename`` 对已存在镜像重命名。
--arch=ARCH
    非必选项，指定安装源是32位、64位、ia64, 目前支持的选项有: x86│x86_64│ia64
--breed=BREED
    非必选项，标记系统版本。


导入用光驱挂载的镜像
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    mount /dev/cdrom /mnt/
    cobbler import --path=/mnt/ --name=CentOS-6.6-x86_64 --arch=x86_64



cobbler导入系统操作
======================================================================================================================================================

删除导入的系统镜像
    - 查看导入的系统镜像
    - 删除导入的镜像

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cobbler distro list
        CentOS-6.6-x86_64
    [root@centos-cobbler ~]# cobbler distro remove --name=CentOS-6.6-x86_64 --recursive

导入的进项都存在目录：
    /var/www/cobbler/ks_mirror


命令帮助

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cobbler distro help
    usage
    =====
    cobbler distro add
    cobbler distro copy
    cobbler distro edit
    cobbler distro find
    cobbler distro list
    cobbler distro remove
    cobbler distro rename
    cobbler distro report

    [root@server ~]# cobbler distro add -h       
    Usage: cobbler [options]

    Options:
    -h, --help            show this help message and exit
    --name=NAME           Name (Ex: Fedora-11-i386)
    --ctime=CTIME         
    --mtime=MTIME         
    --uid=UID             
    --owners=OWNERS       Owners (Owners list for authz_ownership (space
                            delimited))
    --kernel=KERNEL       Kernel (Absolute path to kernel on filesystem)
    --initrd=INITRD       Initrd (Absolute path to kernel on filesystem)
    --kopts=KERNEL_OPTIONS
                            Kernel Options (Ex: selinux=permissive)
    --kopts-post=KERNEL_OPTIONS_POST
                            Kernel Options (Post Install) (Ex: clocksource=pit
                            noapic)
    --ksmeta=KS_META      Kickstart Metadata (Ex: dog=fang agent=86)
    --arch=ARCH           Architecture (valid options:
                            i386,x86_64,ia64,ppc,ppc64,ppc64le,s390,arm)
    --breed=BREED         Breed (What is the type of distribution?)
    --os-version=OS_VERSION
                            OS Version (Needed for some virtualization
                            optimizations)
    --source-repos=SOURCE_REPOS
                            Source Repos
    --depth=DEPTH         Depth
    --comment=COMMENT     Comment (Free form text description)
    --tree-build-time=TREE_BUILD_TIME
                            Tree Build Time
    --mgmt-classes=MGMT_CLASSES
                            Management Classes (Management classes for external
                            config management)
    --boot-files=BOOT_FILES
                            TFTP Boot Files (Files copied into tftpboot beyond the
                            kernel/initrd)
    --fetchable-files=FETCHABLE_FILES
                            Fetchable Files (Templates for tftp or wget/curl)
    --template-files=TEMPLATE_FILES
                            Template Files (File mappings for built-in config
                            management)
    --redhat-management-key=REDHAT_MANAGEMENT_KEY
                            Red Hat Management Key (Registration key for RHN,
                            Spacewalk, or Satellite)
    --redhat-management-server=REDHAT_MANAGEMENT_SERVER
                            Red Hat Management Server (Address of Spacewalk or
                            Satellite Server)
    --clobber             allow add to overwrite existing objects
    --in-place            edit items in kopts or ksmeta without clearing the
                            other items

导入镜像配置kickstart文件
======================================================================================================================================================

Cobbler会给镜像指定一个默认的kickstart自动安装文件在/var/lib/cobbler/kickstarts下的sample_end.ks

参考下面两个kickstart文件内容。


以下cobbler使用的 **CentOS7** 的kickstart文件内容

.. code-block:: bash
    :linenos:

    #Kickstart configurator by xxx
    #platform=x86, AMD64, OR Intel EM64T

    #system language
    lang en_US
    #system keyboard
    keyboard us
    #system timezone
    timezone Asia/Shanghai
    #root password
    rootpw --iscrypted $default_password_crypted
    #rootpw  --iscrypted $6$1dJ3jLaaqfvC/LtM$OmebQgFzajnH2svus360CeF7HOBeiWaQBqgrDxmZ.W4WS8J.VVkQhcI035S85ZxlDWHxBGtPhVHLM5PTH3bij/
    #use text mode install
    text
    #install os instead of upgrade
    install
    #use NFS installation media
    url --url=$tree
    #url --url=http://192.168.6.10/CentOS-6.6-x86_64
    #system bootloader configuration
    bootloader --location=mbr
    #clear the master boot record
    zerombr
    #partition clearing information
    clearpart --all initlabel
    #disk partitioning information
    part /boot --fstype xfs --size 200 --ondisk sda
    part swap --size 2048 --ondisk sda
    part / --fstype xfs --asprimary --grow --size=10240 --ondisk sda
    #part /data --fstype xfs --grow --size=200 --ondisk sda
    #system authorization information
    auth --useshadow --enablemd5
    #network information
    $SNIPPET('network_config')
    #network --bootproto=dhcp --device=eth0 --onboot=on
    #reboot after installation
    reboot
    #firewall configuration
    firewall --disabled
    #selinux configuration
    selinux --disabled
    #do not configure xwindows
    skipx
    #package install information
    %pre
    @ base
    @ core
    sysstat
    iptraf
    ntp
    lrzsz
    ncurses-devel
    openssl-devel
    zlib-devel
    OpenIPMI-tools
    nmap
    screen
    %end

    %post
    systemctl disable postfix.service

    #start yum configuration
    $yum_config_stanza
    #end yum configuration

    %end

以下cobbler使用的 **CentOS6** 的kickstart文件内容

.. code-block:: bash
    :linenos:

    # Cobbler for Kickstart Configurator for CentOS 6.6

    #install os instead of upgrade
    install
    #use text mode install
    text
    #use NFS installation media
    url --url=$tree
    #url --url=http://192.168.6.10/CentOS-6.6-x86_64

    #system language
    lang en_US.UTF-8
    #system keyboard
    keyboard us
    #clear the master boot record
    zerombr
    #system bootloader configuration
    bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"
    #network configuration
    $SNIPPET('network_config')
    #system timezone
    timezone --utc Asia/Shanghai
    #auth configuration
    authconfig --enableshadow --passalgo=sha512
    #root password
    rootpw --iscrypted $default_password_crypted
    #rootpw  --iscrypted $6$1dJ3jLaaqfvC/LtM$OmebQgFzajnH2svus360CeF7HOBeiWaQBqgrDxmZ.W4WS8J.VVkQhcI035S85ZxlDWHxBGtPhVHLM5PTH3bij/
    #partition clearing information
    clearpart --all --initlabel
    #disk partitioning information
    part /boot --fstype=ext4 --asprimary --size=200
    part swap --size=2048
    part / --fstype=ext4 --grow --asprimary --size=200
    #part / --fstype=ext4 --asprimary --size=10240
    #part /data --fstype=ext4 --grow --size=200
    firstboot --disable
    selinux --disabled
    firewall --disabled
    logging --level=info
    reboot

    %pre
    #$SNIPPET('log_ks_pre')
    #$SNIPPET('kickstart_start')
    #$SNIPPET('pre_install_network_config')
    # Enable installation monitoring
    #$SNIPPET('pre_anamon')
    %end

    %packages
    @base
    @compat-libraries
    @debugging
    @development
    tree
    nmap
    sysstat
    lrzsz
    dos2unix
    telnet
    %end

    %post --nochroot
    #$SNIPPET('log_ks_post_nochroot')
    %end

    %post
    #$SNIPPET('log_ks_post')
    # Start yum configuration
    $yum_config_stanza
    # End yum configuration
    #$SNIPPET('post_install_kernel_options')
    #$SNIPPET('post_install_network_config')
    #$SNIPPET('func_register_if_enabled')
    #$SNIPPET('download_config_files')
    #$SNIPPET('koan_environment')
    #$SNIPPET('redhat_register')
    #$SNIPPET('cobbler_register')
    # Enable post-install boot notification
    #$SNIPPET('post_anamon')
    # Start final steps
    #$SNIPPET('kickstart_done')
    # End final steps
    %end



指定系统名称安装时使用指定的kickstart文件：

.. code-block:: bash
    :linenos:

    cobbler profile edit --name=xxx --kickstart=/var/lib/cobbler/kickstarts/xxx.cfg


CentOS7控制网卡配置名称的参数：
    - net.ifnames=0
    - biosdevname=0

CentOS7安装的过程把网卡名称调整为ethx，

.. code-block:: bash
    :linenos:

    cobbler profile edit --name=xxx --kopts='net.ifnames=0 biosdevname=0'


profile命令查看cobbler镜像所使用的参数
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cobbler profile list
    CentOS-6.6-x86_64
    [root@centos-cobbler ~]# cobbler profile help
    usage
    =====
    cobbler profile add
    cobbler profile copy
    cobbler profile dumpvars
    cobbler profile edit
    cobbler profile find
    cobbler profile getks
    cobbler profile list
    cobbler profile remove
    cobbler profile rename
    cobbler profile report

    [root@centos-cobbler ~]# cobbler profile report
    Name                           : CentOS-6.6-x86_64
    TFTP Boot Files                : {}
    Comment                        : 
    DHCP Tag                       : default
    Distribution                   : CentOS-6.6-x86_64
    Enable gPXE?                   : 0
    Enable PXE Menu?               : 1
    Fetchable Files                : {}
    Kernel Options                 : {}
    Kernel Options (Post Install)  : {}
    Kickstart                      : /var/lib/cobbler/kickstarts/CentOS-6-x86_64.cfg
    Kickstart Metadata             : {}
    Management Classes             : []
    Management Parameters          : <<inherit>>
    Name Servers                   : []
    Name Servers Search Path       : []
    Owners                         : ['admin']
    Parent Profile                 : 
    Internal proxy                 : 
    Red Hat Management Key         : <<inherit>>
    Red Hat Management Server      : <<inherit>>
    Repos                          : []
    Server Override                : <<inherit>>
    Template Files                 : {}
    Virt Auto Boot                 : 1
    Virt Bridge                    : xenbr0
    Virt CPUs                      : 1
    Virt Disk Driver Type          : raw
    Virt File Size(GB)             : 5
    Virt Path                      : 
    Virt RAM (MB)                  : 512
    Virt Type                      : kvm


用cobbler构建yum仓库
======================================================================================================================================================

.. attention::
    导入镜像以后会自动构建一个对应的yum仓库：
        仓库的位置： ``/var/www/cobbler/ks_mirror/CentOS-6.6-x86_64``
        其中 ``CentOS-6.6-x86_64`` 是导入的镜像名。
    
    可以通过网页访问：http://192.168.6.10/cobbler/ks_mirror/CentOS-6.6-x86_64

cobbler自动化安装的系统会自动有一个 ``cobbler-config.repo`` 文件，这就是以cobbler服务器为yum源对应的yum源配置文件。

具体路径：
    /etc/yum.repos.d/
修改yum源为cobbler的源：
    cd /etc/yum.repos.d/
    
    cp CentOS-Base.repo CentOS-Base.repo.ori
    
    mv cobbler-config.repo CentOS-Base.repo

.. code-block:: bash
    :linenos:

    cobbler repo add --name=CentOS-6-x86_64-epel --mirrro=https://mirrors.aliyun.com/epel/6/x86_64/ --arch=x86_64 --breed=yum



cobbler reposync

推送yum源到自动安装的客户机

.. code-block:: bash
    :linenos:

    cobbler profile edit --name=xxx --repos="xxx"
    cobbler profile edit --name=CentOS-6.6-x86_64






cobbler安装时PXE界面设置
======================================================================================================================================================

开机启动项以及提示的链接
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cat /etc/cobbler/pxe/pxedefault.template 
    DEFAULT menu
    PROMPT 0
    MENU TITLE Cobbler | http://cobbler.github.io
    TIMEOUT 200
    TOTALTIMEOUT 6000
    ONTIMEOUT $pxe_timeout_profile

    LABEL local
            MENU LABEL (local)
            MENU DEFAULT
            LOCALBOOT -1

    $pxe_menu_items

    MENU end

调整开机启动项的顺序
------------------------------------------------------------------------------------------------------------------------------------------------------

如果调整开机启动项的顺序可以把上面 ``$pxe_timeout_profile`` 可以用 ``/var/lib/tftpboot/pxelinux.cfg/default``
中的参数 **LABEL** 后面的参数替换。

例如 ``/var/lib/tftpboot/pxelinux.cfg/default`` ：
    LABEL CentOS-6.6-x86_64

把 ``/etc/cobbler/pxe/pxedefault.template`` 中 ``$pxe_timeout_profile`` 替换为： ``CentOS-6.6-x86_64``

PXE启动菜单加密码提示
------------------------------------------------------------------------------------------------------------------------------------------------------

参考文档：
    https://cobbler.github.io/manuals/2.6.0/4/11\_-_PXE-boot_Menu_Passwords.html

可以修改的文件包括两个：
    - 菜单密码：/etc/cobbler/pxe/pxedefault.template
    - 安装的系统引用密码：/etc/cobbler/pxe/pxeprofile.template

生成密码

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# openssl passwd -1 -salt 123321 123
    $1$123321$KK2zXP/R/mQqLGasdNskP.

菜单密码添加到文件： ``/etc/cobbler/pxe/pxedefault.template``

添加格式：
    MENU MASTER PASSWD mypassword

在安装系统所有时都提示输入密码。需要在配置文件 ``/etc/cobbler/pxe/pxeprofile.template``

添加格式(在 ``LABEL $profile_name`` 行下面)：
    MENU PASSWD

修改后配置文件如下：

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cat /etc/cobbler/pxe/pxedefault.template
    DEFAULT menu
    PROMPT 0
    MENU TITLE Cobbler | http://cobbler.github.io
    MENU MASTER PASSWD $1$123321$KK2zXP/R/mQqLGasdNskP.
    TIMEOUT 200
    TOTALTIMEOUT 6000
    ONTIMEOUT $pxe_timeout_profile

    LABEL local
            MENU LABEL (local)
            MENU DEFAULT
            LOCALBOOT -1

    $pxe_menu_items

    MENU end
    [root@centos-cobbler ~]# cat /etc/cobbler/pxe/pxeprofile.template
    LABEL $profile_name
            MENU PASSWD
            kernel $kernel_path
            $menu_label
            $append_line
            ipappend 2

配置后新机器通过PXE安装系统时进入下界面，然后通过方向键/tab键选择要安装的系统会提示输入密码(这个密码就是上面生成的密码123)：


.. image:: /Server/res/images/server/linux/kickstart/cobbler/cobbler-pxe-install001.png
    :align: center
    :height: 400 px
    :width: 800 px


cobbler同步所有配置项让其生效
======================================================================================================================================================

一般如果修改了cobbler配置都需要同步配置才能使配置生效。

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cobbler sync
    task started: 2018-10-20_211742_sync
    task started (id=Sync, time=Sat Oct 20 21:17:42 2018)
    running pre-sync triggers
    cleaning trees
    removing: /var/www/cobbler/images/CentOS-6.6-x86_64
    removing: /var/lib/tftpboot/pxelinux.cfg/default
    removing: /var/lib/tftpboot/grub/efidefault
    removing: /var/lib/tftpboot/grub/grub-x86_64.efi
    removing: /var/lib/tftpboot/grub/images
    removing: /var/lib/tftpboot/grub/grub-x86.efi
    removing: /var/lib/tftpboot/images/CentOS-6.6-x86_64
    removing: /var/lib/tftpboot/s390x/profile_list
    copying bootloaders
    trying hardlink /var/lib/cobbler/loaders/grub-x86_64.efi -> /var/lib/tftpboot/grub/grub-x86_64.efi
    trying hardlink /var/lib/cobbler/loaders/grub-x86.efi -> /var/lib/tftpboot/grub/grub-x86.efi
    copying distros to tftpboot
    copying files for distro: CentOS-6.6-x86_64
    trying hardlink /var/www/cobbler/ks_mirror/CentOS-6.6-x86_64/images/pxeboot/vmlinuz -> /var/lib/tftpboot/images/CentOS-6.6-x86_64/vmlinuz
    trying hardlink /var/www/cobbler/ks_mirror/CentOS-6.6-x86_64/images/pxeboot/initrd.img -> /var/lib/tftpboot/images/CentOS-6.6-x86_64/initrd.img
    copying images
    generating PXE configuration files
    generating PXE menu structure
    copying files for distro: CentOS-6.6-x86_64
    trying hardlink /var/www/cobbler/ks_mirror/CentOS-6.6-x86_64/images/pxeboot/vmlinuz -> /var/www/cobbler/images/CentOS-6.6-x86_64/vmlinuz
    trying hardlink /var/www/cobbler/ks_mirror/CentOS-6.6-x86_64/images/pxeboot/initrd.img -> /var/www/cobbler/images/CentOS-6.6-x86_64/initrd.img
    Writing template files for CentOS-6.6-x86_64
    rendering DHCP files
    generating /etc/dhcp/dhcpd.conf
    rendering TFTPD files
    generating /etc/xinetd.d/tftp
    processing boot_files for distro: CentOS-6.6-x86_64
    cleaning link caches
    running post-sync triggers
    running python triggers from /var/lib/cobbler/triggers/sync/post/*
    running python trigger cobbler.modules.sync_post_restart_services
    running: dhcpd -t -q
    received on stdout: 
    received on stderr: 
    running: service dhcpd restart
    received on stdout: Shutting down dhcpd: [  OK  ]
    Starting dhcpd: [  OK  ]

    received on stderr: 
    running shell triggers from /var/lib/cobbler/triggers/sync/post/*
    running python triggers from /var/lib/cobbler/triggers/change/*
    running python trigger cobbler.modules.scm_track
    running shell triggers from /var/lib/cobbler/triggers/change/*
    *** TASK COMPLETE ***




根据mac地址让服务器自动安装对应的系统
======================================================================================================================================================

根据mac可以有两种安装系统方式：
    - 通过命令添加mac地址对应的设备，然后自动化安装。
    - 通过python脚本，调用cobbler的api接口然后把mac对应的设备都添加到cobbler中然后自动化安装。

.. attention::
    上面两种方法都需要先知道要装系统的服务器的mac地址才可以。

通过命令添加mac对应的设备然后装机
------------------------------------------------------------------------------------------------------------------------------------------------------
cobbler默认是local启动，如果需要自动安装，需要改PXE启动项，或者统计需要安装系统的服务器的mac地址，然后根据mac地址安装对应的cobbler中的系统。

具体步骤是：

服务器mac地址是： ``00:0C:29:4F:FF:56``

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cobbler system add --name=qd_web001 --hostname=qd_web001 \
    > --mac=00:50:56:3A:E0:B1 \
    > --profile=CentOS-6.6-x86_64 \
    > --ip-address=192.168.6.210 --subnet=255.255.255.0 --gateway=192.168.6.2 --interface=eth0 \
    > --static=1 --name-servers="114.114.114.114 8.8.8.8" \
    > --kickstart=/var/lib/cobbler/kickstarts/CentOS6-x86_64.ks

查看通过cobbler安装的系统的系统名称和通过上面命令指定mac地址要安装的系统名称：

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cobbler system list
    qd_web001

删除通过上面命令通过mac指定安装的设备，然后可以重新添加：

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cobbler system remove --name=qd_web001
    [root@centos-cobbler ~]# cobbler system list

上面命令集合
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    cobbler system add --name=qd_web001 --hostname=qd_web001 \
    --mac=00:50:56:3A:E0:B1 \
    --profile=CentOS-6.6-x86_64 \
    --ip-address=192.168.6.210 --subnet=255.255.255.0 --gateway=192.168.6.2 --interface=eth0 \
    --static=1 --name-servers="114.114.114.114 8.8.8.8" \
    --kickstart=/var/lib/cobbler/kickstarts/CentOS6-x86_64.ks
    
    cobbler system list
    cobbler system remove --name=qd_web001


python调用cobbler的api完成mac添加
------------------------------------------------------------------------------------------------------------------------------------------------------

python脚本如下：

下面的脚本名 ``cobbler_api.py``

上传到cobbler服务器，然后执行即可：

[root@centos-cobbler ~]# python cobbler_api.py

.. code-block:: python
    :linenos:

    #!/usr/bin/env python
    # -*- coding: utf-8 -*-

    import xmlrpclib

    class CobblerAPI(object):
        
        def __init__(self, url, user, password):
            self.cobbler_user = user
            self.cobbler_pass = password
            self.cobbler_url = url
            
        def add_system(self, hostname, ip_add, mac_add, profile):
            
            ret = {
                "result": True,
                "comment": [],
            }
            
            # get token
            remote = xmlrpclib.Server(self.cobbler_url)
            token = remote.login(self.cobbler_user, self.cobbler_pass)
            
            # add system
            system_id = remote.new_system(token)
            remote.modify_system(system_id, "name", hostname, token)
            remote.modify_system(system_id, "hostname", hostname, token)
            remote.modify_system(system_id, "modify_interface", {
                "macaddress-eth0": mac_add,
                "ipaddress-eth0": ip_add,
                "dnsname-eth0": hostname
            }, token)
            remote.modify_system(system_id, "profile", profile, token)
            remote.modify_system(system_id, token)
            try:
                remote.sync(token)
            except Exception as e:
                ret['result'] = False
                ret['comment'].append(str(e))
            return ret

    def main():
        SERVER_IP = '192.168.6.10'
        cobbler = CobblerAPI("http://192.168.6.10/cobbler_api", "cobbler", "123")
        #cobbler = CobblerAPI("http://{}/cobbler_api".format(SERVER_IP), "cobbler", "123")
        ret = cobbler.add_system(hostname='cobbler-api-test', ip_add='192.168.6.20', mac_add='00:50:56:3A:E0:B1',
                                profile='CentOS-6.6-x86_64')
        print(ret)

    if __name__ == '__main__':
        main()
    
测试cobbler的api：

.. code-block:: python
    :linenos:

    #!/usr/bin/env python
    # -*- coding: utf-8 -*-

    import xmlrpclib

    SERVER_IP = '192.168.6.10'

    remote = xmlrpclib.Server("http://192.168.6.10/cobbler_api")
    #remote = xmlrpclib.Server("http://{}/cobbler_api".format(SERVER_IP))

    print(remote.get_distros())
    print(remote.get_profiles())
    print(remote.get_systems())
    print(remote.get_images())
    print(remote.get_repos())




























