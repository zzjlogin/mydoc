.. _server-linux-centosgrub-set:

============================================
设置开机界面及开机延迟时间
============================================

默认是5秒，改成1秒，然后关闭开机动画提示：

.. code-block:: bash
    :linenos:

    [root@Server ~]# sed -i 's#timeout=5#timeout=1#g' /etc/grub.conf 
    [root@Server ~]# sed -i 's#rhgb quiet##g' /etc/grub.conf


