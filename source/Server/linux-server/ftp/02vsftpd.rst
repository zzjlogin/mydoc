.. _vsftpd-introduce:

======================================================================================================================================================
vsftp简介
======================================================================================================================================================


参考：
    - 文档:http://vsftpd.beasts.org/vsftpd_conf.html
    - 文档:https://security.appspot.com/vsftpd.html
    - 文档:https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/s1-ftp
    


vsftpd相关文件:

.. code-block:: text
    :linenos:

    /etc/logrotate.d/vsftpd     日志文件
    /etc/pam.d/vsftpd           vsftpd认证模块
    /etc/rc.d/init.d/vsftpd     vsftpd启动脚本
    /etc/vsftpd                 vsftpd配置文件存放目录
    /etc/vsftpd/ftpusers
    /etc/vsftpd/user_list
    /etc/vsftpd/vsftpd.conf
    /etc/vsftpd/vsftpd_conf_migrate.sh
    /usr/sbin/vsftpd            vsftpd执行文件(主程序)



vsftpd安全机制
------------------------------------------------------------------------------------------------------------------------------------------------------

vsftpd默认是通过PAM认证。支持虚拟用户。

PAM认证：
    - 通过 ``/etc/pam.d/*``
    - ``/lib/security/*``
    - ``/lib64/security/*``



vsftpd会强制检查用户权限:
    - 默认ftp服务根目录是 ``/var/ftp`` 这个目录不可以让除了root用户以外的用户有写权限。即使ftp用户也不可以。如果需要写权限(上传文件)，则可以创建子目录，然后授权子目录写权限。
    - vsftpd会受到selinux控制，所以需要把selinux设置成disable。

vsftpd用户分类：
    - 匿名用户---会映射成系统用户
    - 虚拟用户---会映射成系统用户
    - 系统用户

.. attention::
    vsftpd默认用户是ftp，所有访问用户会被映射成ftp用户。



======================================================================================================================================================
vsftp安装配置
======================================================================================================================================================


vsftp安装
======================================================================================================================================================


.. code-block:: bash
    :linenos:

    [root@centos-7 ~]$yum install vsftpd


.. hint::
    默认服务器ftp的根目录是: ``/var/ftp/``


普通配置样例
======================================================================================================================================================


配置实现:
    - 主动模式，数据端口2000
    - 可以匿名登陆。匿名登陆是一个目录。匿名账号有下载权限，没有上传权限和删除权限。
    - 系统账户可以登陆。登陆都是用户的家目录。可以上传、下载、删除。
    - 登陆用户被锁定到自己的家目录，进制更改根目录到其他未授权目录。
    - 记录日志 ``/var/log/vsftpd.log``

配置过程
------------------------------------------------------------------------------------------------------------------------------------------------------

备份源配置文件

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# cd /etc/vsftpd/
    [root@zzjlogin vsftpd]# cp vsftpd.conf vsftpd.conf.backup

过滤掉注释和空行

.. code-block:: bash
    :linenos:

    [root@zzjlogin vsftpd]# grep -Ev '^#|^$' vsftpd.conf.backup >vsftpd.conf

修改配置文件

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# cat /etc/vsftpd/vsftpd.conf
    anonymous_enable=YES
    anon_mkdir_write_enable=NO
    anon_upload_enable=NO
    chroot_local_user=YES
    local_enable=YES
    xferlog_enable=YES
    xferlog_std_format=YES
    xferlog_file=/var/log/vsftpd.log
    vsftpd_log_file=/var/log/vsftpd.log
    write_enable=YES
    local_umask=022
    dirmessage_enable=YES
    connect_from_port_20=YES
    listen=YES
    pam_service_name=vsftpd
    userlist_enable=YES
    tcp_wrappers=YES
    ftp_data_port=2000

启动(重启)vsftpd服务

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /etc/init.d/vsftpd restart

测试配置结果
------------------------------------------------------------------------------------------------------------------------------------------------------

1. 创建系统用户

.. attention::
    系统用户登陆默认是用户的家目录，即 ``/home/username`` ,username就是对应的用户民。

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# useradd ftpuser
    [root@zzjlogin ~]# passwd ftpuser
    Changing password for user ftpuser.
    New password: 
    BAD PASSWORD: it is WAY too short
    BAD PASSWORD: is too simple
    Retype new password: 
    passwd: all authentication tokens updated successfully.

2. 测试创建的系统用户登陆

用客户端登陆测试

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# ftp 192.168.161.134
    Connected to 192.168.161.134 (192.168.161.134).
    220 (vsFTPd 2.2.2)
    Name (192.168.161.134:root): ftpuser
    331 Please specify the password.
    Password:               ====>输入用户名对应的密码
    230 Login successful.
    Remote system type is UNIX.
    Using binary mode to transfer files.
    ftp> ls                 ====>查看当前目录文件
    227 Entering Passive Mode (192,168,161,134,176,144).
    150 Here comes the directory listing.
    226 Directory send OK.
    ftp> mkdir test         ====>创建目录test
    257 "/test" created
    ftp> put hello.sh       ====>把本地hello.sh文件推送到服务器
    local: hello.sh remote: hello.sh
    227 Entering Passive Mode (192,168,161,134,193,62).
    150 Ok to send data.
    226 Transfer complete.
    120 bytes sent in 0.037 secs (3.25 Kbytes/sec)
    ftp> ls                 ====>查看此时目录的所有文件
    227 Entering Passive Mode (192,168,161,134,238,215).
    150 Here comes the directory listing.
    -rw-r--r--    1 501      501           120 Sep 10 17:04 hello.sh
    drwxr-xr-x    2 501      501          4096 Sep 10 17:03 test
    226 Directory send OK.
    ftp> rename hello.sh hell   ====>对文件进行重命名。
    350 Ready for RNTO.
    250 Rename successful.
    ftp> ls                 ====>查看重命名是否真的成功
    227 Entering Passive Mode (192,168,161,134,221,3).
    150 Here comes the directory listing.
    -rw-r--r--    1 501      501           120 Sep 10 17:04 hell
    drwxr-xr-x    2 501      501          4096 Sep 10 17:03 test
    226 Directory send OK.
    ftp>


3. 测试匿名用户

用客户端登陆测试

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# ftp 192.168.161.134
    Connected to 192.168.161.134 (192.168.161.134).
    220 (vsFTPd 2.2.2)
    Name (192.168.161.134:root): anonymous  ====>匿名用户需要输入这个用户名
    331 Please specify the password.
    Password:           ====>密码为空，即直接回车。
    230 Login successful.
    Remote system type is UNIX.
    Using binary mode to transfer files.
    ftp> ls             ====>查看当前目录文件
    227 Entering Passive Mode (192,168,161,134,215,53).
    150 Here comes the directory listing.
    drwxr-xr-x    2 0        0            4096 Sep 10 17:01 pub
    226 Directory send OK.
    ftp> cd pub         ====>切换到pub目录内
    250 Directory successfully changed.
    ftp> pwd            ====>查看当前目录路径
    257 "/pub"
    ftp> ls             ====>查看当前目录文件
    227 Entering Passive Mode (192,168,161,134,248,181).
    150 Here comes the directory listing.
    -rwxr--r--    1 0        0           21682 Sep 10 17:01 install.log
    226 Directory send OK.
    ftp> rename install.log     ====>对文件重命名，失败
    (to-name) 123
    550 Permission denied.
    ftp> rename install.log 123
    550 Permission denied.
    ftp> put hello.sh           ====>上传文件，失败
    local: hello.sh remote: hello.sh
    227 Entering Passive Mode (192,168,161,134,172,143).
    550 Permission denied.
    ftp> mkdir test             ====>创建目录文件，失败
    550 Permission denied.
    ftp> ls         ====>查看当前目录文件
    227 Entering Passive Mode (192,168,161,134,138,40).
    150 Here comes the directory listing.
    -rwxr--r--    1 0        0           21682 Sep 10 17:01 install.log
    226 Directory send OK.
    ftp> get install.log        ====>下载文件，成功。
    local: install.log remote: install.log
    227 Entering Passive Mode (192,168,161,134,248,239).
    150 Opening BINARY mode data connection for install.log (21682 bytes).
    226 Transfer complete.
    21682 bytes received in 0.000767 secs (28268.58 Kbytes/sec)
    ftp> by
    221 Goodbye

4. 查看日志

vsftpd服务器

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# tail /var/log/vsftpd.log 
    Tue Sep 11 00:59:17 2018 1 192.168.161.132 0 /hello.sh b _ i r abc ftp 0 * i
    Tue Sep 11 01:02:49 2018 1 192.168.161.132 21682 /pub/install.log b _ o a ? ftp 0 * c
    Tue Sep 11 01:04:11 2018 1 192.168.161.132 120 /hello.sh b _ i r ftpuser ftp 0 * c
    Tue Sep 11 01:13:53 2018 1 192.168.161.132 21682 /pub/install.log b _ o a ? ftp 0 * c


修改默认端口和被动模式的端口范围
======================================================================================================================================================

修改配置文件

.. code-block:: bash
    :linenos:

    [root@centos-7 vsftpd]$cp vsftpd.conf vsftpd.conf.backup
    [root@centos-7 vsftpd]$grep -Ev "^$|^[#;]" vsftpd.conf.backup >vsftpd.conf
    [root@centos-7 vsftpd]$vim vsftpd.conf
    # 添加3行
    listen_port=20021
    pasv_max_port=20080
    pasv_min_port=20050

重启vsftpd服务

.. code-block:: bash
    :linenos:
    
    [root@centos-7 vsftpd]$systemctl restart vsftpd

另一个机器测试

.. attention::
    下面初始配置增加了上面配置。这时候登陆用户是 ``ftp`` ， ``密码为空``



.. code-block:: bash
    :linenos:

    [root@centos-152 ~]# ftp 172.18.46.7 20021
    Connected to 172.18.46.7 (172.18.46.7).
    220 (vsFTPd 3.0.2)
    Name (172.18.46.7:root): ftp
    331 Please specify the password.
    Password:
    230 Login successful.
    Remote system type is UNIX.
    Using binary mode to transfer files.
    ftp> cd pub
    250 Directory successfully changed.
    ftp> git bigfile 
    ?Invalid command
    ftp> get bigfile
    local: bigfile remote: bigfile
    227 Entering Passive Mode (172,18,46,7,78,83).
    150 Opening BINARY mode data connection for bigfile (1025507328 bytes).
    226 Transfer complete.
    1025507328 bytes received in 7.68 secs (133606.18 Kbytes/sec)
    ftp> quit
    221 Goodbye.

服务端查看服务端口信息

.. code-block:: bash
    :linenos:

    [root@centos-7 vsftpd]$ss -tun 
    Netid  State      Recv-Q Send-Q                          Local Address:Port                                         Peer Address:Port             
    tcp    ESTAB      0      52                                172.18.46.7:22                                          172.18.101.69:49932            
    tcp    ESTAB      0      0                          ::ffff:172.18.46.7:20021                               ::ffff:172.18.104.253:56238            
    tcp    ESTAB      0      3363872                     ::ffff:172.18.46.7:20051                               ::ffff:172.18.104.253:54037   

映射user1,user2为comm
======================================================================================================================================================


修改配置文件

.. code-block:: bash
    :linenos:

    [root@centos-7 vsftpd]$vim vsftpd.conf  

    # 添加如下行
    guest_enable=YES
    guest_username=comm
    local_root=/home/comm
    #这个默认就有，确认下
    local_enable=YES

添加用户

.. code-block:: bash
    :linenos:

    [root@centos-7 vsftpd]$useradd user1
    [root@centos-7 vsftpd]$useradd user2
    [root@centos-7 vsftpd]$useradd comm
    [root@centos-7 vsftpd]$mkdir /home/comm/pub
    [root@centos-7 vsftpd]$ll -d /var/ftp/pub
    drwxr-xr-x. 3 root root 4096 Feb  3 12:40 /var/ftp/pub
    [root@centos-7 vsftpd]$ll -d /var/ftp
    drwxr-xr-x. 3 root root 4096 Aug  3  2017 /var/ftp
    [root@centos-7 vsftpd]$chmod 555 /home/comm
    [root@centos-7 vsftpd]$chmod 755 /home/comm/pub

测试

.. code-block:: bash
    :linenos:

    [root@centos-152 ~]# ftp 172.18.46.7 
    Connected to 172.18.46.7 (172.18.46.7).
    220 (vsFTPd 3.0.2)
    Name (172.18.46.7:root): user1
    331 Please specify the password.
    Password:
    230 Login successful.
    Remote system type is UNIX.
    Using binary mode to transfer files.
    ftp> ls
    227 Entering Passive Mode (172,18,46,7,78,94).
    150 Here comes the directory listing.
    drwxr-xr-x    2 1037     0            4096 Feb 03 13:55 pub
    226 Directory send 

禁锢用户只能在自己家目录,但是除了user1
======================================================================================================================================================

修改配置文件

.. code-block:: bash
    :linenos:

    [root@centos-7 vsftpd]$tail -n 2 vsftpd.conf
    chroot_list_enable=YES
    chroot_list_file=/etc/vsftpd/chroot_list

.. attention::
    - ``chroot_list_enable`` 启用用户家目录锁定
    - ``chroot_list_file`` 指定chroot_list文件（带绝对路径）


添加用户

.. code-block:: bash
    :linenos:

    [root@centos-7 vsftpd]$vim /etc/vsftpd/chroot_list
    [root@centos-7 vsftpd]$cat /etc/vsftpd/chroot_list
    user1

测试

.. code-block:: bash
    :linenos:

    [root@centos-152 ~]# ftp 172.18.46.7 
    Connected to 172.18.46.7 (172.18.46.7).
    220 (vsFTPd 3.0.2)
    Name (172.18.46.7:root): user1
    331 Please specify the password.
    Password:
    500 OOPS: vsftpd: refusing to run with writable root inside chroot()
    Login failed.
    421 Service not available, remote server has closed connection
    ftp> ls
    Not connected.
    ftp> quit
    [root@centos-152 ~]# ftp 172.18.46.7 
    Connected to 172.18.46.7 (172.18.46.7).
    220 (vsFTPd 3.0.2)
    Name (172.18.46.7:root): user2
    331 Please specify the password.
    Password:
    230 Login successful.
    Remote system type is UNIX.
    Using binary mode to transfer files.
    ftp> ls
    227 Entering Passive Mode (172,18,46,7,78,89).
    150 Here comes the directory listing.
    226 Directory send OK.
    ftp> pwd
    257 "/home/user2"

这样就可以让在chroot_list文件中的用户禁锢了

禁止系统特定用户登陆ftp
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    [root@centos-7 vsftpd]$echo "user1" >> /etc/vsftpd/user_list

.. attention::
    user_list可以通过vsftpd.conf中配置参数来设置这是白名单还是黑名单。默认是黑名单。

    具体参数:
        - userlist_enable=YES,开启用user_list文件来控制用户。
        - userlist_deny=YES,如果是YES则user_list中用户名都被加入黑名单，不允许登陆，如果是NO，则user_list中用户都被允许登陆。


.. code-block:: text
    :linenos:

    [root@zzjlogin ~]# cat /etc/pam.d/vsftpd 
    #%PAM-1.0
    session    optional     pam_keyinit.so    force revoke
    auth       required     pam_listfile.so item=user sense=deny file=/etc/vsftpd/ftpusers onerr=succeed
    auth       required     pam_shells.so
    auth       include      password-auth
    account    include      password-auth
    session    required     pam_loginuid.so
    session    include      password-auth

``/etc/vsftpd/ftpusers`` 可以控制用户黑名单，user_list也可以控制用户黑名单。一般如果设置了user_list，会先匹配user_list。




限制每个ip连接的个数为5个，下载速度为100k.最多支持10个连接
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    [root@centos-7 vsftpd]$vim vsftpd.conf
    [root@centos-7 vsftpd]$tail -n 4  vsftpd.conf 
    max_clients=100
    max_per_ip=5
    anon_max_rate=102400



vsftp的配置项
======================================================================================================================================================

.. attention::
    配置文件配置的时候最后的末尾不能留有空格，否则客户端访问会出现500错误。


布尔选项
------------------------------------------------------------------------------------------------------------------------------------------------------

.. csv-table:: 
   :header: "名称","默认值","描述"
   :widths: 30,30,50

   "allow_annon_ssl","NO","匿名用户被允许使用安装的ssl连接，需要ssl_enable启用"
   "anon_mkdir_write_enable","NO","匿名用户被允许在一定条件下创建新目录，需要write_enable启用，且匿名ftp用户对父目录有写权限"
   "anon_other_write_anble","NO","匿名用于被允许写入和创建目录，删除其他用户上传的文件"
   "anon_upload_enable","NO","匿名用户将被运行上传文件，需要write_enable激活，且在指定目录有写权限"
   "anon_world_readable_only","YES","匿名用户只能下载所有人都能读取的文件"
   "anonmous_enable","YES","是否启用匿名用户"
   "ascii_download_enable","NO","启用文本模式下载"
   "ascii_upload_enable","NO","启用文本模式上传"
   "async_abor_enable","NO","异步abor命令启用"
   "background","YES","启用后vsftpd是监听模式"
    "check_shell","YES","是使用pam_shell模块，只有在/etc/shells中指定的shell类型用户才能登陆"
    "chmod_enable","YES","运行使用SITE chmod命令，只适用于本地用户"
    "chown_uploads","No","如果启用，所有匿名上传的文件将编程chown_username所有者"
    "chroot_list_enable","NO","默认是列表文件是/etc/vsftpd/chroot_list,可以使用chroot_list_file重写"
    "chroot_local_user","yes","本地用户被禁锢在自己的家目录"
    "connect_from_port_20","NO","主动模式启用20端口来数据连接，可以配合其他命令修改20端口"
    "debug_ssl","NO","将openssl的诊断信息写到日志文件去"
    "delete_failed_uploads","NO","任何上传失败的文件被删除"
    "deny_email_enable","NO","拒绝登陆的电子邮件恢复，默认列表是/etc/vsftpd/banned_emails,可以使用banned_email_file覆盖设置"
    "dirlist_enable","YES","如果设置no,所有目录列表命令被拒绝"
    "dirmessage_enable","no","如果启用,进入目录扫描目录.message内容给用户显示"
    "download_enable","Yes","如果设置为NO,下载请求都被拒绝"
    "dual_log_enable","no","如果yes,两种风格日志都写,/var/log/xferlog和/var/log/vsftpd.log"
    "force_dot_file","NO","如果激活，目录列表不显示..,.这些内容"
    "force_annon_data_ssl","NO","只有ssl_enable启用的时候，所有匿名用户必须使用ssl数据传输"
    "force_anon_logins_ssl","NO","你有ssl_enable启用的时候，匿名用户强制使用登陆"
    "force_local_data_ssl","YES","只有ssl_enable启用的时候，本地用户数据传输使用ssl数据传输"
    "force_local_logins_ssl","YES","你有ssl_enable启用的时候，本地用户强制使用登陆"
    "guest_enable","NO","如果启用，将所有非匿名用户归为来宾，映射为guest_username用户"
    "hide_ids","NO","如果启用，目录列表的所有用户和组信息显示为ftp"
    "implicit_ssl","NO","如果启用，ssl握手第一件事情是希望所有连接支持ssl"
    "listen_ipv6","NO","监听ipv6地址，和ipv4互斥的"
    "local_enable","No","控制本地用户是否能登陆"
    "lock_upload_files","yes","启用后，所有上传者对上传文件写锁，所有下载者对下载文件共享读锁"
    "log_ftp_protocol","no","启用后，所有ftp请求和响应记录日志记录，非常有用的调试选项"
    "ls_recurse_enable","no","启用ls -R命令，来递归访问你的目录"
    "mdtm_write","YES","该设置允许使用MDTM设置文件的修改时间"
    "no_anon_password","NO","匿名用户将直接登陆"
    "no_log_lock","no","当启用时，可以方式vsftpd的从写日志文件采取文件锁定"
    "one_process_model","NO","每个连接一个进程安全模式"
    "password_chroot_enable","no","如果启用，根据chroot_local_user，然后根据/etc/passwd的家目录来限制"
    "pasv_addr_resolve","NO","如果使用主机名，设置YES"  
    "pasv_enable","YES","支持被动模式"  
    "pasv_promiscuous","yes","设置yes禁用安全检查" 
    "require_cert","no","如果启用，所有客户端需要提供客户端证书"  
    "require_ssl_reuse","YES","要求ssl会话重用"  
    "reverse_lookup_enable","yes","方向查找，将ip转为主机名"
    "run_as_launching_user","No",""
    "secure_email_list_enable","NO",""
    "session_support","no","会话支持，保持会话"
    "set_proctitle_enable","No","如果启用，将尝试和显示系统进程列表中的会话状态信息"  
    "ssl_enable","NO","设置yes，启用ssl"   
    "ssl_request_cert","YES","如果启用"
    "ssl_sslv2","No","只有ssl_enable启用，启用此项，允许sslv2协议"
    "ssl_sslv3","NO","只有ssl_enable启用，启用此项，允许sslv3协议"
    "ssl_tlsv1","YES","只有ssl_enable启用，启用此项，允许TLSV1协议"
    "strict_ssl_read_eof","NO","如果启用，需要ssl数据上传通过ssl终止，而不是eof终止"
    "strict_ssl_write_shutdown","NO","如果启用，需要ssl下载通过ssl终止，"
    "syslog_enable","NO","如果启用，使用系统日志来代替/var/log/vsftpd.log"
    "text_userdb_names","NO","默认情况下数字id显示目录列表的用户和组字段，开启这个参数得到文本"
    "tilde_user","NO","如果启用，解析路径带有~username这样的路径"
    "use_localtime","NO","启用后使用本地时区信息，默认是utc时间的"
    "use_sendfile","YES","减少内核和应用数据交换"
    "userlist_deny","YES","如果userlist_enable是激活的，userlist_file是拒绝用户的"
    "userlist_enable","NO","如果启用，userlist_file中的用户能登陆"
    "validate_cert","NO","收到的所有ssl客户端证书必须验证确定"
    "userlist_log","NO","如果userlist_enable启用了，可以uselist_log记录失败登陆"
    "virtual_use_local_privs","NO","如果启用，虚拟用户将是哦那个相同的权限作为本地用户"
    "write_enable","NO","写权限启用"
    "xferlog_enable","NO","如果启用，文件被防止到/var/log/vsftpd.log,可以使用vsftpd_log_file来覆盖"
    "xferlog_std_format","YES","如果启用，日志文件是哦那个标准的xferlog格式记录，可以修改xferlog_file来修改日志位置，默认是/var/log/xferlog"
    "isoate_network","YES","如果启用使用clone_newnet隔离不可信进程"


数值选项
------------------------------------------------------------------------------------------------------------------------------------------------------

.. csv-table:: 
   :header: "名称","默认值","描述"
   :widths: 30,30,50

    "accpet_timeout","60","超时时间，客户端建立被动数据连接的超时时间"
    "anon_max_rate","0","匿名客户端的最大速率"
    "anon_umask","077","匿名用户创建危机的umask"
    "chmod_upload_mode","0600","修改上传文件的mode"
    "connect_timeout","60","客户端相应主动连接的数据连接超时时间"
    "data_connection_timeout","300","数据传输的连接超时时间"
    "delay_failed_login","1","报告登陆失败秒数"
    "delay_successful_log","0","报告登陆成功的描述"
    "file_open_mode","0666",""
    "ftp_data_port","20","指定主动模式的连接端口，需要connect_form_port_20启用"
    "idle_session_timeout","300","空闲会话超时时间"
    "listen_port","21","监听端口"
    "local_max_rate","0","本地最大速率"
    "local_umask","077","本地用户的umask设置"
    "max_clients","2000","支持的最大客户端个数"
    "max_login_fails","3","登陆的失败的最大次数，超过次数被杀掉"
    "max_per_ip","50","每个ip最大连接个数"
    "pasv_max_port","0","被动模式的最大端口"
    "pasv_min_port","0","被动模式的最小端口"
    "trans_chunk_size","0","传输chunck大小"

字符串选项
------------------------------------------------------------------------------------------------------------------------------------------------------

.. csv-table:: 
   :header: "名称","默认值","描述"
   :widths: 30,30,50

    "anon_root","-","表示一个目录，匿名用户登陆后的根目录"
    "banned_email_file","/etc/vsftpd/banned_emails","不允许匿名的电子邮件文件路径，需要deny_email_enable启用"
    "banner_file","-","欢迎文件路径"
    "ca_certs_file","-","ca证书文件"
    "chown_username","root","匿名用户上传的所有者的用户名称，需要chown_uploads配合"
    "chown_list_file","/etc/vsftpd.conf/vsftpd.chroot_list",""
    "cmds_allowed","-","指定ftp使用的命令"
    "cmds_denied","-","不能使用的ftp命令，allowed优先"
    "deny_file","-","设置文件名或者目录名不能任何方式访问"
    "dsa_cert_file","-","dsa证书文件"
    "dsa_private_key_file","-","如果没有指定，使用dsa证书文件"
    "email_password_file","/etc/vsftpd/email_passwords",""
    "ftp_username","ftp","用户的主目录是匿名的根"
    "ftpd_banner","-","ftp的提示信息"
    "guest_username","ftp","来宾映射名字"
    "hide_file","-","指定隐藏文件hide_file = {* MP3，.hidden}"
    "listen_address","-","提供一个地址"
    "listen_address6","-","ip6地址"
    "local_root","-","代表该目录的vsftpd将试图改变成后本地（即非匿名）登录"
    "message_file",".message","需要配合dirmessage_enable配合使用"
    "pam_service_name","ftp","pam名字"
    "pasv_address","-","被动模式地址"
    "rsa_cert_file","/usr/share/ssl/certs/vsftpd.pem","rsa证书文件"
    "ra_private_key_file","-","如果没有指定去rsa-cert_file里面找私钥"
    "secure_chroot_dir","/usr/share/empty",""
    "user_config_dir","-","将用户的配置文件定义到/etc/vsftpd/user_conf文件中"
    "user_sub_token","-","配合虚拟用户使用，自动为每个虚拟用户的主目录，记录模板"
    "userlist_file","/etc/vsftpd/user_list","需要userlist_enable启用"
    "vsftpd_log_file","/var/log/vsftpd.log","日志文件"
    "xferlog_file","/var/log/xferlog","日志文件"


