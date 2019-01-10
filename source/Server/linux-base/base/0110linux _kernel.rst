.. _linux-base-kernel:

======================================================================================================================================================
Linux Kernel
======================================================================================================================================================

:Date: 2018-09-02

.. contents::

kernel是操作系统的核心，掌控着所有硬件设备的控制权。

linux系统是单内核，模块化体系。

uname的使用
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    [root@centos6 ~]$ uname -a 
    Linux centos6.zzjlogin 2.6.32-696.el6.x86_64 #1 SMP Tue Mar 21 19:29:05 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
    [root@centos6 ~]$ uname -r 
    2.6.32-696.el6.x86_64
    [root@centos6 ~]$ uname -n 
    centos6.zzjlogin

内核模块管理
======================================================================================================================================================

查看模块
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash 

    # 方法1：
    [root@centos6 ~]$ lsmod 
    Module                  Size  Used by
    rfcomm                 71047  4 
    sco                    17493  2 
    bridge                 85706  0 
    bnep                   16370  2 
    l2cap                  54210  16 rfcomm,bnep
    autofs4                27000  3 
    bnx2fc                 91541  0 
    #############省去下面的行#################

    # 方法2
    [root@centos6 ~]$ cat /proc/modules 
    rfcomm 71047 4 - Live 0xffffffffa0676000
    sco 17493 2 - Live 0xffffffffa066c000
    bridge 85706 0 - Live 0xffffffffa064e000
    bnep 16370 2 - Live 0xffffffffa0646000

    # 方法3 
    [root@centos6 ~]$ modinfo e1000
    filename:       /lib/modules/2.6.32-696.el6.x86_64/kernel/drivers/net/e1000/e1000.ko
    version:        7.3.21-k8-NAPI
    license:        GPL

装载模块
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash

    [root@centos6 ~]$ insmod /lib/modules/2.6.32-696.el6.x86_64/kernel/net/bluetooth/bluetooth.ko 
    [root@centos6 ~]$ modprobe  bluetooth

卸载模块
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash

    [root@centos6 ~]$ rmmod /lib/modules/2.6.32-696.el6.x86_64/kernel/net/bluetooth/bluetooth.ko 
    [root@centos6 ~]$ modprobe -r bluetooth

内核参数
======================================================================================================================================================

修改内核参数

1. 方法1
    临时修改，重启后失效

.. code-block:: bash
    :linenos:

    [root@centos6 ~]$ echo "1" > /proc/sys/net/ipv4/ip_forward
    
2. 方法2

.. code-block:: bash
    :linenos:

    [root@centos6 ~]$ sysctl -w  net.ipv4.ip_forward=1
    net.ipv4.ip_forward = 1

3. 方法3
    重启依然生效。

.. code-block:: bash
    :linenos:

    [root@centos6 ~]$ vim /etc/sysctl.conf 
    [root@centos6 ~]$ sysctl -p 


编译内核
======================================================================================================================================================

编译内核的情况：
    - 有新的功能需求，如支持虚拟化
    - 原来的内核太过臃肿
    - 升级来提高稳定性
    - 个人定制或专业用途
    - 个人学习

编译内核的步骤
    1. 查看硬件设备信息
    #. 开发环境和源码
    #. 下载并解压源码
    #. 复制系统的默认的编译配置
    #. make menconfig
    #. make -j 4 
    #. make modules_install 
    #. make install 

screen命令
======================================================================================================================================================

screen可以让执行的命令脱离终端和终端无关。

选项：

-d      将指定的screen作业离线
-r      恢复指定的作业
-S      创建一个作业
-ls     查看作业

使用样例：

.. code-block:: bash
    :linenos:

    # 创建一个test名字的
    [root@centos-155 ~]# screen -S test
    [detached from 14681.test]
    # 使用ctrl + a +d 来离线

    # 查看作业
    [root@centos-155 ~]# screen -ls 
    There is a screen on:
        14681.test	(Detached)
    1 Socket in /var/run/screen/S-root.
    # 恢复特定的作业
    [root@centos-155 ~]# screen -r test 
