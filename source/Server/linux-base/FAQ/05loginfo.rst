.. _linux-loginfo:

======================================================================================================================================================
Linux 登陆提示信息设置
======================================================================================================================================================

.. contents::

登陆信息设置说明
======================================================================================================================================================


在本机字符终端登录时，除显示原有信息外，再显示当前登录终端号，主机名和当前时间
我们使用man mingetty可以获取到如下的帮助信息。

-d      insert current day (localtime), 插入当前日期
-l      insert line on which mingetty is running,终端类型
-m      inserts machine architecture (uname -m),机器架构
-n      inserts machine’s network node hostname (uname -n),主机名
-o      inserts domain name,域名
-r      inserts operating system release (uname -r),版本号
-t      insert current time (localtime),时间
-s      inserts operating system name,操作系统名字
-u      resp.  \U  the current number of users which are currently loggedin. 显示登陆用户数量
-v      inserts operating system version (uname -v).操作系统版本

.. code-block:: bash
    :linenos:

    [root@centos6 ~]# cat /etc/issue
    CentOS release 6.9 (Final)
    Kernel \r on an \m
    current time: \d \t
    hostname : \n
    tty:    \l
















