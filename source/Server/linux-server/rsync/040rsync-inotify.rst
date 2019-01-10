.. _rsync-inotify:

======================================================================================================================================================
rsync+inotify完成时时同步
======================================================================================================================================================

:Date:

.. contents::

服务器环境
======================================================================================================================================================

rsync服务端

rsync客户端


rsync+inotify安装基础
======================================================================================================================================================

1. 首先完成rsync的服务端和客户端配置，然后可以从客户端向rsync服务端拉取和推送数据；
    - 这一步可以参考： :ref:`rsync-linux2linux`
2. inotify安装在rsync客户端，需要检查rsync客户端环境是否满足inotify安装条件；
    - 检查rsync客户端内核是否高于2.6.13
    - 检查是否存在目录 ``/proc/sys/fs/inotify/``

检查过程：

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# rsync -avz rsync://rsync_backup@192.168.161.137/web /tmp --password-file=/etc/rsync.password
    receiving incremental file list

    sent 61 bytes  received 308 bytes  738.00 bytes/sec
    total size is 29924  speedup is 81.09
    [root@web_01 ~]# ls /proc/sys/fs/inotify/
    max_queued_events  max_user_instances  max_user_watches
    [root@web_01 ~]# uname -r
    2.6.32-504.el6.x86_64



inotify安装配置
======================================================================================================================================================

inotify安装
------------------------------------------------------------------------------------------------------------------------------------------------------

下载源码包：

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# mkdir /home/tools
    [root@web_01 ~]# cd /home/tools/
    [root@web_01 ~]# wget https://sourceforge.net/projects/inotify-tools/files/inotify-tools/3.13/inotify-tools-3.13.tar.gz --no-check-certificate

编辑安装：

.. code-block:: bash
    :linenos:

    [root@web_01 tools]# ls
    inotify-tools-3.13.tar.gz
    [root@web_01 tools]# tar zxf inotify-tools-3.13.tar.gz
    [root@web_01 tools]# cd inotify-tools-3.13
    [root@web_01 inotify-tools-3.13]# ./configure --prefix=/usr/local/inotify-tools-3.13
    [root@web_01 inotify-tools-3.13]# make && make install

    [root@web_01 inotify-tools-3.13]# ln -s /usr/local/inotify-tools-3.13 /usr/local/inotify
    [root@web_01 inotify-tools-3.13]# ll /usr/local/inotify
    lrwxrwxrwx. 1 root root 29 Sep 10 04:24 /usr/local/inotify -> /usr/local/inotify-tools-3.13



参数调整：

调整之前：

.. code-block:: bash
    :linenos:

    [root@web_01 ~]# cat /proc/sys/fs/inotify/max_queued_events
    16384
    [root@web_01 ~]# cat /proc/sys/fs/inotify/max_user_watches 
    8192
    [root@web_01 ~]# cat /proc/sys/fs/inotify/max_user_instances
    128


inotify压力测试




rsync客户端用inotify监听本地，然后和rsync服务端实时同步脚本如下：



.. code-block:: bash
    :linenos:

    #!/bin/bash
    #20181029
    #
    ###################################
    hostip=192.168.161.137
    src=/tmp/
    dst=data
    user=rsync_backup
    rsync_passfile=/etc/rsync.password
    inotify_home=/usr/local/inotify

    #judge
    if [ ! -e "$src" ] \
    || [ ! -e "${rsync_passfile}" ] \
    || [ ! -e "${inotify_home}/bin/inotifywait" ] \
    || [ ! -e "/usr/bin/rsync" ];
    then
        echo "Check File and Folder!"
        exit 9
    fi

    ${inotify_home}/bin/inotifywait -mrq --timefmt '%d/%m/%y %H:%M' \
    --format '%T %w%f' -e close_write,delete,create,attrib $src \
    while read file
        do
            #rsync -avzP --delete --timeout=100 --password-file=${rsync_passfile} \
            #$src$user@$hostip::$dst >/dev/null 2>&1
            cd $src && rsync -aruz -R --delete ./ --timeout=100 $user@$hostip::$dst \
            --password-file=${rsync_passfile} >/dev/null 2>&1
        done
    exit 0


脚本2：

.. code-block:: bash
    :linenos:

    #!/bin/bash
    #20181029
    #
    ###################################
    hostip=192.168.161.137
    src=/tmp/
    dst=data
    user=rsync_backup
    rsync_passfile=/etc/rsync.password
    inotify_home=/usr/local/inotify

    #judge
    if [ ! -e "$src" ] \
    || [ ! -e "${rsync_passfile}" ] \
    || [ ! -e "${inotify_home}/bin/inotifywait" ] \
    || [ ! -e "/usr/bin/rsync" ];
    then
        echo "Check File and Folder!"
        exit 9
    fi

    ${inotify_home}/bin/inotifywait -mrq --timefmt '%d/%m/%y %H:%M' \
    --format '%T %w%f' -e close_write,delete,create,attrib $src \
    while read line
        do
            [ ! -e "$line" ] && continue
            rsync -aruz -R --delete $line --timeout=100 $user@$hostip::$dst \
            --password-file=${rsync_passfile} >/dev/null 2>&1
        done
    exit 0



