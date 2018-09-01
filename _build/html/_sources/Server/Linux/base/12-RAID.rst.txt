RAID
==============================================
raid(redundant arrays of independent disks,raid)廉价磁盘冗余阵列，raid可以透过一个
技术，将多个较小的磁盘整合为一个较大的磁盘装置，完成存储的扩容和数据保护功能。

raid的实现方式
------------------------------------------------

#. 外接式磁盘阵列，通过扩展卡提供适配能力。
#. 内接raid,主板集成raid控制器。
#. software raid，软件方式实现raid功能。

raid级别
-----------------------------------------------------
- raid0
- raid1
- raid3
- raid5 
- raid10
- raid01

常用的raid级别有0，1，5，10和01级别。

软raid的实现
--------------------------------------------------------------
在linux环境下需要使用mdadm这个命令创建软raid。

mdadm主要选项

-C              创建raid
-n              使用的磁盘个数
-l              级别
-a              自动创建目标raid的设置文件
-c              块大小
-x              空闲盘的个数
-D              详细信息
-A              装配模式，重新识别raid
-F              监控模式
-f              标记指定的磁盘为损坏
-a              添加磁盘
-r              移除磁盘
-S              停止软raid	

查看命令

.. code-block:: bash

    [root@centos-155 backup]# cat /proc/mdstat 
    [root@centos-155 backup]# mdadm -D /dev/md1



   



