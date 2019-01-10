.. _server-linux-centosgrub-set:

======================================================================================================================================================
设置开机界面及开机延迟时间
======================================================================================================================================================


系统版本
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    [root@centos-node1 ~]# cat /etc/redhat-release
    CentOS release 6.6 (Final)
    [root@centos-node1 ~]# uname -r
    2.6.32-504.el6.x86_64
    [root@centos-node1 ~]# cat /etc/sysconfig/network
    NETWORKING=yes
    HOSTNAME=centos-node1

默认是5秒，改成1秒，然后关闭开机动画提示：

.. code-block:: bash
    :linenos:

    [root@Server ~]# sed -i 's#timeout=5#timeout=1#g' /etc/grub.conf 
    [root@Server ~]# sed -i 's#rhgb quiet##g' /etc/grub.conf

timeout=5
    进入系统启动等待时间，单位是秒。
rhgb
    redhat graphics boot，就是会看到图片来代替启动过程中显示的文本信息，这些信息在启动后用dmesg也可以看到。
quiet
    表示在启动过程中只有重要信息显示，类似硬件自检的消息不回显示。



    