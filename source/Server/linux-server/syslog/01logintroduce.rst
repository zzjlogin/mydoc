
======================================================================================================================================================
日志介绍
======================================================================================================================================================

日志主要记录时间、地点、任务和事件。

日志基础概念
======================================================================================================================================================

日志的提供程序
------------------------------------------------------------------------------------------------------------------------------------------------------

.. csv-table:: 
   :header: "系统", "包","提供程序","描述"
   :widths: 30, 30,40,40
   :align: center

   "redhat5", "sysklogd","syslogd,klogd","syslog记录应用，klogd记录内核"
   "centos6", "rsyslog","rsyslogd","兼容sysklogd,多线程，支持mysql数据库"
   "centos7", "rsyslog","同上","同上"

日志的设施
------------------------------------------------------------------------------------------------------------------------------------------------------

.. csv-table:: 
    :header: "设施","描述"
    :widths: 20,40
    :align: center

    "LOG_AUTH",       "安全和认证（弃用）"
    "LOG_AUTHPRIV",   "安全和认证"
    "LOG_CRON",       "计划任务的,包含cron,at"
    "LOG_DAEMON",     "系统守护"
    "LOG_FTP",        "ftp"
    "LOG_KERN",       "内核"
    "LOG_LOCAL[0-7]", "自定义"
    "LOG_LPR",        "打印机"
    "LOG_MAIL",       "邮件"
    "LOG_NEWS",       "新闻"
    "LOG_SYSLOG",     "syslogd"
    "LOG_USER",       "用户"
    "LOG_UUCP",       "unix to unix cp"

日志级别
------------------------------------------------------------------------------------------------------------------------------------------------------

.. csv-table:: 
    :header: "级别","描述"
    :widths: 20,40
    :align: center

    "LOG_EMERG",       系统恐慌
    "LOG_ALERT",      必须立即采取措施解决
    "LOG_CRIT",        严格问题
    "LOG_ERR",         错误
    "LOG_WARNING",     警告
    "LOG_NOTICE",      正常通知
    "LOG_INFO",        普通信息
    "LOG_DEBUG",       调试级别

rsyslog配置文件
======================================================================================================================================================

rsyslog的配置文件主要包括三个大的片段

全局片段
    全局设置，加载模块。
模板片段
    运行你指定日志消息的格式
输出通道
    给通道定义个规则，在输出上设置
规则
    规则有选择器和动作构成

模块说明
------------------------------------------------------------------------------------------------------------------------------------------------------

.. csv-table:: 
   :header: "模块名","功能"
   :widths: 20,40
   :align: center

    "omsnmp",        snmp陷阱输出模块
    "ommysql",       mysql输出模块
    "omrelp",        可靠的relp协议输出模块
    "ompgsql",       postgresql输出模块
    "omlibdbi",      通用数据库输出模块
    "imfile",        文件输入模块
    "imudp",         udp syslog的输入插件
    "imtcp",         tcp syslog的输入插件
    "imrelp",        可靠的relp协议输入模块
    "impgsapi",      tcp和gss-enable的输入插件
    "immark",        支持掩码消息
    "imklog",        内核日志    
    "imuxsock",      unix套接字


输出位置说明
------------------------------------------------------------------------------------------------------------------------------------------------------

.. csv-table:: 
   :header: "输出位置","样例","描述"
   :widths: 20,40,40
   :align: center

    "文件",         "/var/log/sample.log","直接输出到指定的文件去"
    "管道",         "| command","直接重定向到某个命令"
    "终端",     "/dev/console","直接输出的指定的登陆终端"
    "远程主机",       "@192.168.0.1","直接输出到远程指定主机"
    "用户列表",      "root,zzjloginjiedi1992",直接输出到2个用户对应的登陆终端
    "所有用户",       "*","直接给所有登陆用户发送"
    "数据库表",       "192.168.0.1,dbname,username,password","连接指定主机的数据库表"
    "丢弃",         "~","丢弃日志，不记录"
    "输出通道",        "",""
    "shell执行",     "^execute_file; template","模板作为字一个参数去执行脚本"

默认配置位置的日志记录规则说明
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: text
    :linenos:

    [root@102 ~]$vim /etc/rsyslog.conf
    #记录所有设置的info级别的信息,但是排除mail,authpriv,cron的信息。
    *.info;mail.none;authpriv.none;cron.none                /var/log/messages

    # 安全日志的所有级别的信息都记录到本机的/var/log/secure文件中去
    authpriv.*                                              /var/log/secure

    # 记录所有邮件的信息到/var/log/maillog中去，“-”代表异步写入。
    mail.*                                                  -/var/log/maillog


    # 记录计划任务(cron,at)的所有级别信息到/var/log/cron文件中去
    cron.*                                                  /var/log/cron

    # 不管是那个设施产生的emerg级别的信息，发送给登陆的所有用户
    *.emerg                                                 :omusrmsg:*

    # unix to unix cp和新闻的严格级别记录到/var/log/spooler
    uucp,news.crit                                          /var/log/spooler

    # 启动信息记录到/var/log/boot.log,这个local是自定义的，系统已经占用一个
    local7.*                                                /var/log/boot.log

样例配置
======================================================================================================================================================

修改sshd的所有日志信息到到单独的文件
------------------------------------------------------------------------------------------------------------------------------------------------------


新建 ``/etc/rsyslog.d/sshd.conf`` 并添加配置:

.. code-block:: bash
    :linenos:

    [root@102 ~]$vim /etc/rsyslog.d/sshd.conf
    [root@102 ~]$cat /etc/rsyslog.d/sshd.conf
    local1.*                 /var/log/sshd.log
    
修改sshd server的配置

.. code-block:: bash
    :linenos:

    [root@102 ~]$vim /etc/ssh/sshd_config
    # 修改如下2行内容
    SyslogFacility LOCAL1
    LogLevel INFO

重启日志服务，使配置生效:

.. code-block:: bash
    :linenos:

    [root@102 ~]$systemctl restart sshd
    [root@102 ~]$systemctl restart rsyslog

.. attention:: CentOS6重启对应的服务，用命令 ``service sshd restart`` 把sshd换成 ``rsyslog``，则重启系统日志服务。

测试日志记录

.. code-block:: bash
    :linenos:

    [root@102 ~]$ssh localhost
    Last login: Thu Feb  1 09:41:16 2018 from localhost
    Welcom you this system
    [root@102 ~]$cat /var/log/sshd.log
    Feb  1 09:42:14 102 sshd[35620]: Accepted publickey for root from ::1 port 39986 ssh2: RSA SHA256:i9zugMHEhLi77fPoR1gpco04UbuNtRcBJZkb6lLSCt4

修改sshd的所有日志信息到远程主机
------------------------------------------------------------------------------------------------------------------------------------------------------

整体步骤:
    这里涉及到2台主机，主要思路先启用服务器端的监听，然后在客户端配置要配置要推送地址


**服务器配置:**



.. code-block:: text
    :linenos:

    [root@centos-158 ~]# vim /etc/rsyslog.conf
    # 解注释如下4行
    $ModLoad imudp
    $UDPServerRun 514
    $ModLoad imtcp
    $InputTCPServerRun 514

    [root@102 ~]$vim /etc/rsyslog.d/sshd.conf
    [root@102 ~]$cat /etc/rsyslog.d/sshd.conf
    local1.*                 /var/log/sshd.log

    [root@102 ~]$vim /etc/ssh/sshd_config
    # 修改如下2行内容
    SyslogFacility LOCAL1
    LogLevel INFO
    # 重启服务
    [root@102 ~]$systemctl restart sshd
    [root@102 ~]$systemctl restart rsyslog

    # 重启服务并查看监听
    [root@centos-158 ~]# service rsyslog restart
    [root@centos-158 ~]# ss -tunl |grep 514
    udp    UNCONN     0      0         *:514                   *:*                  
    udp    UNCONN     0      0        :::514                  :::*                  
    tcp    LISTEN     0      25        *:514                   *:*                  
    tcp    LISTEN     0      25       :::514                  :::*                  

**客户端配置:**

接下来是客户端的配置

.. code-block:: text
    :linenos:

    [root@102 ~]$vim /etc/rsyslog.d/sshd.conf 
    [root@102 ~]$cat /etc/rsyslog.d/sshd.conf
    local1.*                 @172.19.104.175
    [root@102 ~]$vim /etc/ssh/sshd_config
    # 修改如下2行内容
    SyslogFacility LOCAL1
    LogLevel INFO
    [root@102 ~]$systemctl restart sshd
    [root@102 ~]$systemctl restart rsyslog

    # 102客户端尝试登陆下
    [root@102 ~]$ssh zzjlogin@localhost
    zzjlogin@localhost's password: 
    jlsdfjslfs
    Permission denied, please try again.
    zzjlogin@localhost's password: 
    Permission denied, please try again.
    zzjlogin@localhost's password: 
    Permission denied (publickey,password).

    # 服务端查看日志是否记录了
    [root@centos-158 ~]# tail /var/log/sshd.log 
    Feb  1 10:24:14 102 sshd[37196]: Failed password for zzjlogin from ::1 port 40016 ssh2
    Feb  1 10:24:15 102 sshd[37196]: Failed password for zzjlogin from ::1 port 40016 ssh2
    Feb  1 10:24:15 102 sshd[37196]: Failed password for zzjlogin from ::1 port 40016 ssh2
    Feb  1 10:24:15 102 sshd[37196]: Connection closed by ::1 port 40016 [preauth]

.. note:: 如果网络不稳定，可以使用@@替换@,@@使用的tcp协议，@使用的udp协议。

常见日志文件
------------------------------------------------------------------------------------------------------------------------------------------------------

.. csv-table:: 
   :header: "文件","功能","描述"
   :widths: 30,30,30
   :align: center

   "/var/log/message","包含大部分的日志信息",""
   "/var/log/btmp","失败登陆的日志信息","使用lastb命令查看"
   "/var/log/wtpm","成功登陆的日志信息","使用last命令查看"
   "/var/log/lastlog","每个用户最近一次登陆的日志信息","使用lastlog命令查看"
   "/var/log/dmesg","系统引导过程中的日志信息","使用dmesg命令查看"
   "/var/log/anaconda","anaconada的日志信息",""

journalctl命令使用
------------------------------------------------------------------------------------------------------------------------------------------------------

systemd统一管理所有unit的启动日志，值使用journalctl就可以管理日志。

-a              显示所有字段
-f              最新的信息
-e              跳到最后一页
-n              显示最近的几行
-r              反转输出，新的放前面
-o              指定输出格式
--utc           时间为utc时间
-k              显示内核信息
-p              设置level
-S              开始时间
--since         开始时间，日志格式'2012-10-30 18:17:16'
-U              开始时间
--until         开始时间，日志格式'2012-10-30 18:17:16'
-F              指定的字段
--disk-usage    当前日志占用系统空间情况
--no-pager      不分页
-f              实时滚动显示
-u              指定服务进程

样例使用
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    # 查看所有日志（默认情况下 ，只保存本次启动的日志）
    journalctl
    # 查看内核日志（不显示应用日志）
    journalctl -k
    # 查看系统本次启动的日志
    journalctl -b
    journalctl -b -0
    # 查看上一次启动的日志（需更改设置）
    journalctl -b -1

    # 查看指定时间的日志
    journalctl --since="2017-10-30 18:10:30"
    journalctl --since "20 min ago"
    journalctl --since yesterday
    journalctl --since "2017-01-10" --until "2017-01-11 03:00"
    journalctl --since 09:00 --until "1 hour ago"
    # 显示尾部的最新10行日志
    journalctl -n
    # 显示尾部指定行数的日志
    journalctl -n 20
    # 实时滚动显示最新日志
    journalctl -f

    日志管理journalctl
    # 查看指定服务的日志
    journalctl /usr/lib/systemd/systemd
    # 查看指定进程的日志
    journalctl _PID=1
    # 查看某个路径的脚本的日志
    journalctl /usr/bin/bash
    # 查看指定用户的日志
    journalctl _UID=33 --since today
    # 查看某个 Unit 的日志
    journalctl -u nginx.service
    journalctl -u nginx.service --since today
    # 实时滚动显示某个 Unit 的最新日志
    journalctl -u nginx.service -f
    # 合并显示多个 Unit 的日志
    journalctl -u nginx.service -u php-fpm.service --since today
    # 以 JSON 格式（单行）输出
    journalctl -b -u nginx.service -o json
    # 以 JSON 格式（多行）输出，可读性更好
    journalctl -b -u nginx.serviceqq -o json-pretty
    # 显示日志占据的硬盘空间
    journalctl --disk-usage
    # 指定日志文件占据的最大空间
    journalctl --vacuum-size=1G
    # 指定日志文件保存多久
    journalctl --vacuum-time=1years
