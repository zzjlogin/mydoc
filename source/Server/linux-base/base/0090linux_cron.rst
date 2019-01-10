.. _linux-base-timedtask:

======================================================================================================================================================
Linux任务计划
======================================================================================================================================================

:Date: 2018-09-02

.. contents::


计划任务的分类：
    - 一次性的
    - 周期性的

at
======================================================================================================================================================

at是由atd服务提供的。

at的主要选项

-l 列出目前系统上面的当前用户的at队列
-d 取消一个在at排程的工作。
-v 可以使用明显的时间格式流出at的工作列表
-f 把at要执行的所有任务放置于文件中，让at读取此文件作为要运行的任务。
-c 用于查看特定job的详细信息

time的几种格式

.. code-block:: text
    :linenos:

    HH:MM
    HH:MM YYYY-MM-DD 
    HH:MM MONTH DATE 
    HH:MM + number [minutes|hour|days|weeks]

.. code-block:: text
    :linenos:

    [root@centos-155 ~]# at 10:30
    at> date 
    at> 
    at> <EOT>
    job 1 at Sun Feb 11 10:30:00 2018
    Can't open /var/run/atd.pid to signal atd. No atd running?

上面的这一句提示我们没有开启atd服务的

.. code-block:: text
    :linenos:

    [root@centos-155 ~]# systemctl start atd 
    [root@centos-155 ~]# systemctl enable atd 

查看

.. code-block:: text
    :linenos:

    [root@centos-155 ~]# at -l
    1	Sun Feb 11 10:30:00 2018 a root

查看job1的详细信息

.. code-block:: text
    :linenos:

    [root@centos-155 ~]# at -c 1

删除job1

.. code-block:: text
    :linenos:

    [root@centos-155 ~]# at -d 1

再次查看

.. code-block:: text
    :linenos:

    [root@centos-155 ~]# at -l

.. note:: at的命令输入需要ctrl+d结束。

crontab
======================================================================================================================================================

crontab是由crond服务提供的。

cron任务分为2种
    系统cron
        系统级别的例行性任务计划
    用户cron
        用户自定义的例行性任务计划

系统配置文件格式
    规范配置一般不会在这个系统配置中配置定时任务。

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# cat /etc/crontab 
    SHELL=/bin/bash
    PATH=/sbin:/bin:/usr/sbin:/usr/bin
    MAILTO=root

    # For details see man 4 crontabs

    # Example of job definition:
    # .---------------- minute (0 - 59) 分钟
    # |  .------------- hour (0 - 23)   小时
    # |  |  .---------- day of month (1 - 31) 天
    # |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ... 月
    # |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat 星期
    # |  |  |  |  |
    # *  *  *  *  * user-name  command to be executed

时间表示方法：

17
    表示单独的时间点
\*/3
    表示每3（时间单位）
3-5
    表示3-5这个区间
2,4,5
    表示几个离散的时间点

crontab命令

-l   列出已经定义的所有任务
-e   打开编辑界面定义任务
-r   移除所有任务

用户cron
------------------------------------------------------------------------------------------------------------------------------------------------------

通过 ``crontab -e`` 然后输入对应的定时任务保存退出后。会在 ``/var/spool/cron/`` 下创建一个和用户名相同的文件。这个文件就是用户的定时任务。



anacron
======================================================================================================================================================

anacron主要解决因断电或者关机原因导致的任务没有执行问题。anacron是一个程序，而非一个服务。

