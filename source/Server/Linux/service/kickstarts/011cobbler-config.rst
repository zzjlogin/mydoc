
.. _centos-cobbler-config:

========================================
cobbler配置
========================================



cobbler增加镜像
========================================


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


--path
    镜像路径
--name
    为安装源定义一个名字，是cobbler中镜像的唯一标识，不可以重复，如果重复，系统会提示导入失败。可以用参数 ``--rename`` 对已存在镜像重命名。
--arch
    指定安装源是32位、64位、ia64, 目前支持的选项有: x86│x86_64│ia64


cobbler导入系统的发行版
========================================

导入的进项都存在目录：
    /var/www/cobbler/ks_mirror
查看镜像列表

.. code-block:: bash
    :linenos:
        
    [root@centos-cobbler ~]# cobbler distro list
        CentOS-6.6-x86_64

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
========================================

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
    part / --fstype=ext4 --asprimary --size=10240 --ondisk sda
    part /data --fstype=ext4 --grow --size=200 --ondisk sda
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
========================================

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
========================================

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
========================================

开机启动项以及提示的链接
----------------------------------------

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
----------------------------------------

如果调整开机启动项的顺序可以把上面 ``$pxe_timeout_profile`` 可以用 ``/var/lib/tftpboot/pxelinux.cfg/default``
中的参数 **LABEL** 后面的参数替换。

例如 ``/var/lib/tftpboot/pxelinux.cfg/default`` ：
    LABEL CentOS-6.6-x86_64
把 ``/etc/cobbler/pxe/pxedefault.template`` 中 ``$pxe_timeout_profile`` 替换为： ``CentOS-6.6-x86_64``

为PXE安装的系统加提示
----------------------------------------


cobbler同步所有配置项让其生效
========================================

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




