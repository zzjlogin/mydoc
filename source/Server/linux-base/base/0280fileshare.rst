
======================================================================================================================================================
文件共享服务
======================================================================================================================================================

:Date: 2018-09-02

.. contents::

常见的文件共享服务有ftp,nfs,samba这三种，其中ftp是一种应用层的服务，nfs是基于
内核来实现的网络文件共享服务，samba是在linux上实现cifs协议来解决扩平台的文件共享
服务。

网络集中式存储模型
    DAS: 
        直接附加存储，也就是直接附加在主板上的存储设备。
    NAS: 
        网络附加存储，通过网络文件服务的形式来提供文件共享存储。
    SAN: 
        存储区域网络，通过块儿级别协议来实现将数据存储在远程主机上的共享存储模式

一些区别： 
    nas是文件系统级别的，san是块级别的，nas工作在应用层空间上，san工作在内核模式的，
    nas拿过来就是文件系统，直接可以存储，而san拿过来相当一块新的磁盘，自己格式化才能存储。

ftp
======================================================================================================================================================

ftp数据传输模式: 

主动模式： 
    1. 客户端先随机一个端口如5000去连接服务器的21端口来建立命令传输连接
    #. 服务器以20端口来主动连接客户端的5001（5000+1）端口，来进行数据传输
被动模式： 
    1. 客户端先随机一个端口如5000去连接服务器的21端口来建立命令传输连接
    #. 服务器通过命令传输连接告诉客户端自己的监听端口如6000
    #. 服务器就以5001（5000+1）去连接服务器的6000端口来进行数据传输

提供ftp的软件：
    - wu-ftpd
    - proftpd
    - pureftp
    - vsftp
    - ServU

客户端工具：
    - ftp
    - lftp
    - lftpget
    - wget
    - curl
    - filezilla
    - gftp
    - flashfxp
    - cuteftp

ftp用户分类： 

实体账号： 
    取到的权限比较完整
匿名用户： 
    取到的权限很小，通常只是一些公共下载资源

vsftpd的安装
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# yum install vsftpd 

常见配置项
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: text
    :linenos:

    1、 匿名用户的配置
        anonymouns_enable=YES 是否启用匿名
        anon_upload_enable=YES
        anon_mkdir_write_enable=YES
        anon_other_write_enable=YES

    2、 系统用户的配置
        local_enable=YES
        write_enable=YES
        local_umask=022
    3、 禁锢所有的本地用户访问自己的家目录
        chroot_local_user=YES
    4、 禁锢文件中指定的用户在其家目录
        chroot_list_enable=YES
        chroot_list_file=/etc/vsftpd/chroot_list
    5、 日志
        xferlog_enable=YES
        xferlog_std_format=YES
        xferlog_file=/var/log/xferlog
        dual_log_enable=YES
        vsftpd_log_file=/var/log/vsftpd.log
    6、 改变上传文件的属主
        chown_uploads=YES
        chown_usernmae=root
    7、 vsftpd使用pam完整用户身份认证
        pam_service_name=vsftpd
    8、 是否启用控制用户登陆的列表
        userlist_enable=YES
        userlist_deny=YES
    9、 连接限制
        max_clients
        max_per_ip
    10、传输速率
        anon_max_rate
        local_max_rate
    11、ssl
        ssl_enable=YES
        allow_anon_ssl=NO
        force_local_data_ssl=YES
        force_local_login_ssl=YES
        ssl_tlsv1=YES
        ssl_tlsv2=YES
        ssl_tlsv3=YES
        rsa_cert_file=/etc/vsftpd/vsftpd.pem
        
    12、其他相关设置
        connect_from_port_20
        listen_port
        listen
        pasv_enable=YES
        connect_timeout=60
        accept_timeout=60
        data_connection_timeout=300
        pasv_min_port
        pasv_max_port
        tcp_wrappers

基于虚拟用户的vsftpd
------------------------------------------------------------------------------------------------------------------------------------------------------

主要步骤：
    1. 创建虚拟用户账户和密码文件，并使用db_load转化
    #. 创建本地账户，修改权限
    #. 添加pam文件
    #. 配置文件添加guest相关项目，pam_service_name,user_config_dir
    #. 创建user_config_dir目录，在目录下创建虚拟用户同名的文件，添加配置项
    #. 重启服务，测试。

详细步骤参考：

lftp
------------------------------------------------------------------------------------------------------------------------------------------------------

命令样例

.. code-block:: bash
    :linenos:

    # 直接输入用户密码和端口等详细信息的方式
    [root@centos-155 virtualftp]# lftp -p 21 -u user1:user1 192.168.46.155
    lftp user1@192.168.46.155:~> ls
    drwxr-xr-x    3 1017     1020           15 Feb 12 08:34 pub
    lftp user1@192.168.46.155:/> help
        !<shell-command>                     (commands)                           alias [<name> [<value>]]             attach [PID]                         bookmark [SUBCMD]
        cache [SUBCMD]                       cat [-b] <files>                     cd <rdir>                            chmod [OPTS] mode file...            close [-a]
        [re]cls [opts] [path/][pattern]      debug [<level>|off] [-o <file>]      du [options] <dirs>                  exit [<code>|bg]
        get [OPTS] <rfile> [-o <lfile>]      glob [OPTS] <cmd> <args>             help [<cmd>]                         history -w file|-r file|-c|-l [cnt]
        jobs [-v] [<job_no...>]              kill all|<job_no>                    lcd <ldir>                           lftp [OPTS] <site>
        ln [-s] <file1> <file2>              ls [<args>]                          mget [OPTS] <files>                  mirror [OPTS] [remote [local]]       mkdir [-p] <dirs>
        module name [args]                   more <files>                         mput [OPTS] <files>                  mrm <files>                          mv <file1> <file2>
        [re]nlist [<args>]                   open [OPTS] <site>                   pget [OPTS] <rfile> [-o <lfile>]     put [OPTS] <lfile> [-o <rfile>]      pwd [-p]
        queue [OPTS] [<cmd>]                 quote <cmd>                          repeat [OPTS] [delay] [command]      rm [-r] [-f] <files>                 rmdir [-f] <dirs>
        scache [<session_no>]                set [OPT] [<var> [<val>]]            site <site-cmd>                      source <file>
        torrent [-O <dir>] <file|URL>...     user <user|URL> [<pass>]             wait [<jobno>]                       zcat <files>                         zmore <files>
    lftp user1@192.168.46.155:/> quit

    # 后输入用户和密码方式
    [root@centos-155 virtualftp]# lftp localhost
    lftp localhost:~> user user1
    Password: 
    lftp user1@localhost:~> ls
    drwxr-xr-x    3 1017     1020           28 Feb 12 08:44 pub
    lftp user1@localhost:/> cd pub/
    lftp user1@localhost:/pub> ls
    drwx------    2 1017     1020            6 Feb 12 08:34 a
    -rw-r--r--    1 0        0               0 Feb 12 08:44 a.txt
    lftp user1@localhost:/pub> get a.txt 

wget
------------------------------------------------------------------------------------------------------------------------------------------------------

wget是gpl许可的一个文件下载软件包，支持http,https，ftp协议，支持代理服务器和断点续传功能。

主要常用选项：
    -r          递归下载
    -b          后台下载
    -m          镜像
    -c          断点续传
    -I          指定下载目录列表
    -A          指定接受和拒绝下载列表
    --proxy     代理
    -t          重试次数
    -nc         不覆盖原有的
    -N          只下载新的文件
    -nd         不进行目录结构创建
    -x          强制创建目录结构
    -nH         不继承主机主机目录结构
    -P          设置目录前缀

nfs
======================================================================================================================================================

nfs是network filesystem的缩写，能通过网络在不同主机之间彼此实现资源共享。

nfs是通过rpc调用来实现文件共享的，先启动rpc服务，在启动nfs服务，这样nfs的端口就被注册到
了rpc了，用户使用网络文件系统先通过rpc获取nfs的监听端口，然后在给监听的端口通信，来获取数据。

nfs的配置比较简单

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# vim /etc/exports  
    # 添加如下行
    /data 192.168.46.7/24(rw,sync,no_root_squash)

    # 格式就是  数据 限定ip(选项) 
    #启动服务
    [root@centos-155 ~]# systemctl restart rpcbind nfs
    
    #查看共享出来的信息
    [root@centos-155 ~]# showmount -e 192.168.46.155
    Export list for 192.168.46.155:
    /data/nfs 192.168.46.0/24
    # 创建目录
    [root@centos-155 ~]# mkdir /mnt/nfs
    [root@centos-155 ~]# mkdir /data/nfs
    # 挂载
    [root@centos-155 ~]# mount 192.168.46.155:/data/nfs /mnt/nfs
    
    # 开机自动挂载
    [root@centos-155 ~]# tail -n 1 /etc/mtab  >> /etc/fstab

一个简单的nfs配置就是这么简答，有些命令比较实用 

.. code-block:: bash

    export -ar   重新导入所有的文件系统
    export -au   关闭导出的所有文件系统
    export -u FS 关闭指定的文件系统

samba
======================================================================================================================================================

samba是为window和linux之间共享文件而生的。

安装

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# yum install samba 

创建密码使用smbpasswd命令就可以了，不过要本地有这个用户。





