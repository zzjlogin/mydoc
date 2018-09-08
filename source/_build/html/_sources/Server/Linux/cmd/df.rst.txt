.. _df-cmd:

===================
df
===================



:Date: 2018-09

.. contents::


.. _df-format:

命令格式
===================




.. _df-user:

所属用户
===================




.. _df-guid:

使用指导
===================




.. _df-args:

参数
===================



.. _df-instance:

参考实例
===================


显示当前硬盘分区中空间利用率最大的值
---------------------------------------------------

.. code-block:: bash
    :linenos:
    
    [root@zzjlogin ~]# df  |egrep "[0-9]{1,3}%" -o |tr -d "%" |sort  -n |tail -n 1
    59
    [root@zzjlogin ~]# df
    Filesystem     1K-blocks    Used Available Use% Mounted on
    /dev/sda3        2549948 1419376    997708  59% /
    tmpfs             502172       0    502172   0% /dev/shm
    /dev/sda1         487652   28367    433685   7% /boot


.. _df-relevant:

相关命令
===================








