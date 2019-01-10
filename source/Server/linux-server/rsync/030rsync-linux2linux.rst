.. _rsync-linux2linux:

======================================================================================================================================================
linux推送到linux
======================================================================================================================================================

:Date:

.. contents::


linux同步到linux这个情况相对其他情况是最简单的。 

环境介绍
======================================================================================================================================================

- 2个机器
- centos7(172.18.46.7),centos6(172.18.46.6)
- centos7(/app/web)===>centos6(/app/web)

我们要完成的功能是centos7开发人员生成的web数据放到centos7的/app/web目录后，centos6能自动拉取centos7的目录保持一致。

rsync是分客户端和服务端,所以可以由如下方案:
    - 方案1： 我们在centos7上搭建服务端，centos6作为客户端，然后centos6去主动拉取centos7的数据。
    - 方案2： 我们在centos6上搭建服务端，centos7作为客户端，然后centos7主动把自己的文件推送到centos6上去。

我们下面的文章主要按照方案2来实施。


.. note:: 不管如何，拉取和推送都是在客户端完成的。


服务端的配置
======================================================================================================================================================

安装rsync软件
------------------------------------------------------------------------------------------------------------------------------------------------------

查看是否安装

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# rpm -ql rsync
    [root@rsync_bak_01 ~]# yum -y install rsync



配置rsync
------------------------------------------------------------------------------------------------------------------------------------------------------

创建文件： ``/etc/rsyncd.conf``

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# vi /etc/rsyncd.conf

输入下面内容：

.. code-block:: bash
    :linenos:

    # rsync_config_________start
    # created by zzj on 04:30 20181029
    # email:
    ## rsyncd.conf start ##
    uid = rsync
    gid = rsync
    use chroot = no
    max connections = 200
    pid file = /var/run/rsyncd.pid
    lock file = /var/run/rsync.lock
    log file = /var/log/rsync.log
    [web] 
    path = /data/
    read only = false
    list = false
    ignore errors
    auth users = rsync_backup
    secrets file = /etc/rsyncd.secrets
    hosts allow=192.168.161.0/24
    hosts deny=*
    # rsync_config_________end

守护进程方式启动rsync：

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# rsync --daemon

检查rsync：

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# ss -lntup|grep 873|column -t
    tcp  LISTEN  0  5  :::873  :::*  users:(("rsync",28097,5))
    tcp  LISTEN  0  5  *:873   *:*   users:(("rsync",28097,4))

查看rsync日志：

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# tail /var/log/rsync.log
    2018/10/29 04:43:56 [28097] rsyncd version 3.0.6 starting, listening on port 873


增加配置文件中的守护进程使用的用户：

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# useradd rsync -Ms /sbin/nologin    

授权rsync守护进程数据传输的根目录，让守护进程所属用户可以操作：

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# chown -R rsync.rsync /data

配置数据传输的用户名和密码：

.. tip::
    这是虚拟用户，系统不用存在，用这个用户传输数据会映射成配置文件中的uid对应的用户。

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# echo 'rsync_backup:zzjloginpasswd'>>/etc/rsyncd.secrets

.. tip::
    配置虚拟用户的格式： ``username:passwod``

缩小密钥文件权限：

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# chmod 600 /etc/rsyncd.secrets


rsync服务端开机自启动
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# echo '# rsync start by zzj on 20181029'>>/etc/rc.local
    [root@rsync_bak_01 ~]# echo '/usr/bin/rsync --daemon'>>/etc/rc.local



rsync客户端的配置
======================================================================================================================================================

rsync客户端配置步骤：
    1. 安装rsync软件
    #. 把rsync服务端的密码在客户端配置


rsync安装
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# yum install rsync -y

rsync密钥配置
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: bash
    :linenos:

    [root@web_01 ~]# echo 'zzjloginpasswd'>>/etc/rsync.password
    [root@web_01 ~]# chmod 400 /etc/rsync.password


rsync数据同步测试
======================================================================================================================================================

参考命令对比：

.. code-block:: text
    :linenos:

    Pull: rsync [OPTION...] [USER@]HOST::SRC... [DEST]
          rsync -avz rsync_backup@192.168.161.137::web /tmp --password-file=/etc/rsync.password
          rsync [OPTION...] rsync://[USER@]HOST[:PORT]/SRC... [DEST]
          rsync -avz rsync://rsync_backup@192.168.161.137/web /tmp --password-file=/etc/rsync.password
    Push: rsync [OPTION...] SRC... [USER@]HOST::DEST
          rsync -avz /root/ rsync_backup@192.168.161.137::web --password-file=/etc/rsync.password
          rsync [OPTION...] SRC... rsync://[USER@]HOST[:PORT]/DEST
          rsync -avz /root/ rsync://rsync_backup@192.168.161.137/web --password-file=/etc/rsync.password


.. note::
    命令中SRC是rsync服务端配置的模块名，默认数据直接到这个模块名指定的目录。也可以在这个名称后面继续加目录名称，
    则会传到指定子目录。

rsync客户端从服务端推送数据(push)
------------------------------------------------------------------------------------------------------------------------------------------------------

rsync客户端数据推送到rsync服务端：

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# rsync -avz /root/ rsync_backup@192.168.161.137::web --password-file=/etc/rsync.password
    sending incremental file list
    ./
    .bash_history
    .bash_logout
    .bash_profile
    .bashrc
    .cshrc
    .tcshrc
    anaconda-ks.cfg
    install.log
    install.log.syslog

    sent 8159 bytes  received 182 bytes  5560.67 bytes/sec
    total size is 29924  speedup is 3.59


服务端查看：

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# ll /data/
    total 36
    -rw------- 1 rsync rsync  1040 Mar 30  2018 anaconda-ks.cfg
    -rw-r--r-- 1 rsync rsync 21682 Mar 30  2018 install.log
    -rw-r--r-- 1 rsync rsync  5890 Mar 30  2018 install.log.syslog

继续push推送，则会发现全部一样会忽略：

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# rsync -avz /root/ rsync_backup@192.168.161.137::web --password-file=/etc/rsync.password
    sending incremental file list

    sent 213 bytes  received 8 bytes  442.00 bytes/sec
    total size is 29924  speedup is 135.40

rsync客户端从服务端拉取数据(pull)
------------------------------------------------------------------------------------------------------------------------------------------------------

rsync服务端数据：

.. code-block:: bash
    :linenos:

    [root@rsync_bak_01 ~]# ll /data/
    total 36
    -rw------- 1 rsync rsync  1040 Mar 30  2018 anaconda-ks.cfg
    -rw-r--r-- 1 rsync rsync 21682 Mar 30  2018 install.log
    -rw-r--r-- 1 rsync rsync  5890 Mar 30  2018 install.log.syslog

rsync客户端拉取数据前后和拉取操作过程：

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# ll /tmp/
    total 0
    -rw-------. 1 root root 0 Mar 30 17:31 yum.log
    [root@web_01 ~]# rsync -avz rsync_backup@192.168.161.137::web /tmp --password-file=/etc/rsync.password
    receiving incremental file list
    ./
    .bash_history
    .bash_logout
    .bash_profile
    .bashrc
    .cshrc
    .tcshrc
    anaconda-ks.cfg
    install.log
    install.log.syslog

    sent 235 bytes  received 8254 bytes  16978.00 bytes/sec
    total size is 29924  speedup is 3.53
    [root@web_01 ~]# ll /tmp/
    total 36
    -rw-------. 1  500  500  1040 Mar 30 17:41 anaconda-ks.cfg
    -rw-r--r--. 1  500  500 21682 Mar 30 17:41 install.log
    -rw-r--r--. 1  500  500  5890 Mar 30 17:39 install.log.syslog
    -rw-------. 1 root root     0 Mar 30 17:31 yum.log


rsync客户端使用rsync专有协议传输数据
------------------------------------------------------------------------------------------------------------------------------------------------------

push，推送本地数据到rsync服务器：

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# rsync -avz /root/ rsync://rsync_backup@192.168.161.137/web --password-file=/etc/rsync.password
    sending incremental file list

    sent 213 bytes  received 8 bytes  442.00 bytes/sec
    total size is 29924  speedup is 135.40

pull，从服务器拉取数据到本地指定目录：

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# rsync -avz rsync://rsync_backup@192.168.161.137/web /tmp --password-file=/etc/rsync.password
    receiving incremental file list

    sent 61 bytes  received 308 bytes  738.00 bytes/sec
    total size is 29924  speedup is 81.09




写脚本完成自动拉取服务器数据
------------------------------------------------------------------------------------------------------------------------------------------------------

安装inotify-tool工具

.. code-block:: bash
    :linenos:

    [root@centos66 yum.repos.d]$ yum install inotify-tools

编写rsync脚本

.. code-block:: bash
    :linenos:

    #!/bin/bash

    user=web
    remote_module=web
    local_dir=/app/web/
    ip=72.18.46.7
    password_file=/etc/rsync.pass

    /usr/bin/inotifywait -mrq --timefmt '%d/%m/%y%H:%M' --format '%T %w %f' -e modify,delete,create,attrib $local_dir | while read DATE TIME DIR FILE;do
            filechange=${DIR}${FILE}
            # 拉取服务器数据
            #/usr/bin/rsync -avz --delete --progress --password-file=$password_file    $user@$ip::$remote_module   $local_dir &
            # 推送本机的数据
            /usr/bin/rsync -avz --delete --progress --password-file=$password_file     $local_dir $user@$ip::$remote_module   &

            date_str=/var/log/rsync_$(date "+%F").log
            echo "At ${TIME} on ${DATE}, file $filechange was backed up via rsynce" >> $date_str 2>&1
    done

配置计划任务
------------------------------------------------------------------------------------------------------------------------------------------------------

将上面的脚本放到while true里面即可，或者修改脚本为sysv脚本。


