
.. _zzjlogin-samba-windows:

======================================================================================================================================================
windows配置共享
======================================================================================================================================================


windows设置文件共享
======================================================================================================================================================

把 ``e:\app\share`` 设置共享

在window设置共享
------------------------------------------------------------------------------------------------------------------------------------------------------


windows点击进入 ``E盘`` 的 ``app`` 目录，然后 ``右击`` share文件夹，进入下图界面: 

.. image:: /Server/res/images/server/linux/samba/windows-share01.png
    :align: center
    :height: 550 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/samba/windows-share02.png
    :align: center
    :height: 450 px
    :width: 800 px

.. attention::
    上面是任意用户都有全部权限。但是可以通过设置用户来控制哪些用户可以访问这个共享目录。参考下面图片


.. image:: /Server/res/images/server/linux/samba/windows-share03.png
    :align: center
    :height: 400 px
    :width: 800 px


本机测试
------------------------------------------------------------------------------------------------------------------------------------------------------

.. note:: 下面这是没有设置用户密码。如果之后linux的链接之前会设置用户密码。

在本地用快捷键 ``ctrl+r`` 然后在运行的窗口输入: ``\\192.168.1.125`` ,如下图:

.. image:: /Server/res/images/server/linux/samba/windows-share-localtest01.png
    :align: center
    :height: 400 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/samba/windows-share-localtest02.png
    :align: center
    :height: 400 px
    :width: 800 px





linux挂载windows共享目录
======================================================================================================================================================

安装samba客户端
------------------------------------------------------------------------------------------------------------------------------------------------------

需要安装的软件包:
    - samba
    - samba-client
    - cifs-utils
    - samba-common-tools


安装过程:

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# yum install samba samba-client cifs-utils samba-common-tools -y
    [root@centos-155 ~]# rpm -ql samba 
    [root@centos-155 ~]# rpm -ql samba-client
    [root@centos-155 ~]# rpm -ql cifs-utils

linux访问windows共享目录
------------------------------------------------------------------------------------------------------------------------------------------------------

用命令查看共享:

.. code-block:: none
    :linenos:

    [root@zzjlogin ~]# smbclient -L 192.168.1.125 -m SMB2 -U zzjlogin
    Unrecognised protocol level SMB2
    Enter zzjlogin's password: 
    session request to 192.168.1.125 failed (Called name not present)
    Domain=[DESKTOP-FEMHQ4S] OS=[Windows 10 Enterprise 14393] Server=[Windows 10 Enterprise 6.3]

            Sharename       Type      Comment
            ---------       ----      -------
            ADMIN$          Disk      远程管理
            C$              Disk      默认共享
            D$              Disk      默认共享
            E$              Disk      默认共享
            F$              Disk      默认共享
            G$              Disk      默认共享
            IPC$            IPC       远程 IPC
            share           Disk      
    session request to 192.168.1.125 failed (Called name not present)
    session request to 192 failed (Called name not present)
    session request to *SMBSERVER failed (Called name not present)
    NetBIOS over TCP disabled -- no workgroup available

创建挂载密码

.. code-block:: bash
    :linenos:

    [root@centos-155 mnt]# echo -e "username=zzjlogin\npassword=12345" >> /etc/samba.pass 
    [root@centos-155 mnt]# cat /etc/samba.pass
    username=zzjlogin
    password=12345

密码文件权限设置(600)

.. code-block:: bash
    :linenos:

    [root@centos-155 mnt]# chmod 600 /etc/samba.pass

添加开机自动挂载

.. code-block:: bash
    :linenos:

    [root@centos-155 mnt]# vim -n 1 /etc/fstab 
    # 添加如下行
    //192.168.1.125/share      /mnt/zzjlogin     cifs vers=3.0,credentials=/etc/samba.pass 0 0 
    [root@centos-155 ~]# mount -a
    [root@centos-155 ~]# cd /mnt/zzjlogin
    [root@centos-155 zzjlogin]# touch test.txt 
    [root@centos-155 zzjlogin]# ll
    total 2528009
    -rwxr-xr-x 1 root root        182 May 28  2015 autorun.inf
    -rwxr-xr-x 1 root root 2588266496 Nov 19 22:42 cn_office_professional_plus_2016_x86_x64_dvd_6969182.iso
    drwxr-xr-x 2 root root          0 Nov 19 22:44 office
    -rwxr-xr-x 1 root root     413248 Aug 17  2015 setup.exe
    -rwxr-xr-x 1 root root          0 Feb  6 10:19 test.txt
    drwxr-xr-x 2 root root          0 Nov 19 21:24 下载合集









