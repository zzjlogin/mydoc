.. _zzjlogin-linux-install:

======================================================================================================================================================
CentOS6安装
======================================================================================================================================================

:Date: 2018-09

.. contents::


Linux系列系统，不同的发行版，安装步骤会有所出入。


.. _centos6-install:

CentOS6安装
======================================================================================================================================================


具体安装过程，参考下面安装图片。注意图片中的选项。


1. 如前面U盘启动盘制作完成，BIOS启动项也已经调整。则开机后进入下图所示界面。可以选择第一个选项或者第二个选项，然后按“回车键”。

.. hint::
    第一个选项是安装/更新系统；第二个选项是使用基本的图形界面安装(如果电脑/服务器显卡比较老，建议选择第二个选项)

.. image:: /Server/res/images/server/linux/system-install/centos6/01.png
    :align: center
    :height: 400 px
    :width: 800 px

2. 选择“Skip”跳过即可。

.. image:: /Server/res/images/server/linux/system-install/centos6/02.png
    :align: center
    :height: 400 px
    :width: 800 px

3. 上面操作后，会进入如下界面。选择语言。建议选择“English”(默认为英语，选择使用上下方向键即可)。如果选择简体中文，后续可能会出现乱码以及其他不兼容问题。选择语言后同第一步按“回车键”。

.. attention::
    即使选择了汉语，安装完成后也可以在系统里面调整系统语言。

.. image:: /Server/res/images/server/linux/system-install/centos6/02-1.png
    :align: center
    :height: 400 px
    :width: 800 px

4. 选择语言后会进入如下图界面。选择键盘类型。一般中国使用的是美国式键盘。然后按“回车键”即可确认。

.. image:: /Server/res/images/server/linux/system-install/centos6/03.png
    :align: center
    :height: 400 px
    :width: 800 px

5. 选择完键盘类型后，选择安装方式。因为是U盘安装，所以选择第二个选项，即硬盘驱动。然后按“回车键”。

.. image:: /Server/res/images/server/linux/system-install/centos6/04.png
    :align: center
    :height: 400 px
    :width: 800 px

6. 	选择了安装方式，进入图形界面。此过程可以用鼠标点击，结合键盘使用。如下图，选择“Next”。


.. image:: /Server/res/images/server/linux/system-install/centos6/05.png
    :align: center
    :height: 500px
    :width: 800 px

7. 进入下图界面。一般没有特殊存储装置的，下图的两个选项基本一样。本例选择第二个选项测试。然后选择“Next”。

.. image:: /Server/res/images/server/linux/system-install/centos6/06.png
    :align: center
    :height: 500px
    :width: 800 px

8. 进入如下图所示界面。勾选安装使用的硬盘。可以根据下图中硬盘大小来判断哪个硬盘是安装系统的硬盘。然后选择“Next”。

.. image:: /Server/res/images/server/linux/system-install/centos6/07.png
    :align: center
    :height: 500px
    :width: 800 px

9. 此时会弹出下图界面。选择“Yes,discard any data”，即不保存任何数据。

.. attention::
    如果之前安装了centos系统并且没有格式化硬盘，则不是下面界面。

.. image:: /Server/res/images/server/linux/system-install/centos6/08.png
    :align: center
    :height: 400 px
    :width: 800 px

10. 进入如下图界面。填写内容“主机名+域名”，可以此时配置网卡，也可以安装完系统后再配置网卡。然后选择“Next”。

.. image:: /Server/res/images/server/linux/system-install/centos6/09.png
    :align: center
    :height: 500px
    :width: 800 px

11. 进入如下图界面。选择时区。可以用鼠标选择“ShangHai”,如果选错了，可以安装完成后再配置时区。然后选择“Next”。

.. image:: /Server/res/images/server/linux/system-install/centos6/10.png
    :align: center
    :height: 500px
    :width: 800 px

12. 进入如下界面，输入密码和确认密码。(如果密码不是复杂的，而且只有六位，则会弹出Week Password窗口)。然后选择“Next”。

.. image:: /Server/res/images/server/linux/system-install/centos6/11.png
    :align: center
    :height: 500px
    :width: 800 px

13. 上面输入的密码如果只是一般的六位简单密码。(例:123456)会弹出下图界面。选择“Use Anyway”。

.. image:: /Server/res/images/server/linux/system-install/centos6/12.png
    :align: center
    :height: 400 px
    :width: 800 px

14. 进入下图界面。选择“Create Custom Layout”创建定制硬盘分区。然后选择“Next”。


.. image:: /Server/res/images/server/linux/system-install/centos6/13.png
    :align: center
    :height: 500px
    :width: 800 px

15. 进入下图界面。选择系统硬盘。(用鼠标点击对应的硬盘后，上方会显示对应硬盘的大小，此时为选中)，点击“Create”

.. image:: /Server/res/images/server/linux/system-install/centos6/14.png
    :align: center
    :height: 400 px
    :width: 800 px

15. 进入下图界面。选择系统硬盘。(用鼠标点击对应的硬盘后，上方会显示对应硬盘的大小，此时为选中)，点击“Create”

.. image:: /Server/res/images/server/linux/system-install/centos6/15.png
    :align: center
    :height: 500px
    :width: 800 px

17. 进入下图所示界面。“Mount Point”即挂载点。可以点击选择对应的此分区挂载点儿。“File System Type”即文件系统类型，选择对应的文件系统类型（一般有两种，“ext4”和“swap”）。在“Allowable Drivers”后面即硬盘。选择使用的硬盘。然后下面是此分区大小。也可以选择使用所有空间。如果此分区是“/boot”分区需要选择“Force to be a primary partition”。如果没有“/boot”分区，则“/”根分区选择此选项。“Encrypt”为加密，可根据自己需要选择此选项。然后选择“OK”。（此时此分区为主分区）


.. image:: /Server/res/images/server/linux/system-install/centos6/16.png
    :align: center
    :height: 500px
    :width: 800 px

18. 具体分区举例，如下图。

.. attention:: “/boot”分区一般为200MB或者500MB，建议500MB

.. image:: /Server/res/images/server/linux/system-install/centos6/17.png
    :align: center
    :height: 500px
    :width: 800 px


19. 创建完第一个分区后如下图界面，然后继续创建分区，即点击“Create”

.. image:: /Server/res/images/server/linux/system-install/centos6/18.png
    :align: center
    :height: 500px
    :width: 800 px

20. 进入下图界面。点击“File System Type”后面的下拉栏。选择“swap”，选择对应硬盘，然后选择交换分区的大小。一般建议为内存大小，或者是内存的两倍。如果内存很大。则不建议使用此种规则。然后点击“OK”

.. image:: /Server/res/images/server/linux/system-install/centos6/19.png
    :align: center
    :height: 500px
    :width: 800 px

21. 进入下图界面。继续选择“Create”

.. image:: /Server/res/images/server/linux/system-install/centos6/20.png
    :align: center
    :height: 500px
    :width: 800 px

22. 进入下图界面。然后选择“Mount Point”点击下拉栏。选择“/”即根节点。然后选择硬盘，然后选择使用所有剩余空间“Fill to maximum allowable size”，然后点击“OK”

.. image:: /Server/res/images/server/linux/system-install/centos6/21.png
    :align: center
    :height: 500px
    :width: 800 px

23. 进入下图，显示所有的分区信息。然后点击“Next”

.. image:: /Server/res/images/server/linux/system-install/centos6/22.png
    :align: center
    :height: 500px
    :width: 800 px

24. 会弹出下图窗口。点击格式化“Format”

.. image:: /Server/res/images/server/linux/system-install/centos6/23.png
    :align: center
    :height: 500px
    :width: 800 px

25. 还会弹出下图窗口，然后点击写入硬盘“Write changes to disk”

.. image:: /Server/res/images/server/linux/system-install/centos6/24.png
    :align: center
    :height: 400 px
    :width: 800 px

26. 进入下图界面，一般默认安装的boot分区是U盘，需要手动改为系统硬盘。即选择“Change device”

.. image:: /Server/res/images/server/linux/system-install/centos6/25.png
    :align: center
    :height: 500px
    :width: 800 px

27. 弹出下图界面。选择主分区为“/dev/sda1”此处也可以选择第一个。本实例使用的是“/dev/sda1”。然后选择“BIOS Drive Order”中的“First BIOS drive”选择装系统的硬盘。然后点击“OK”

.. image:: /Server/res/images/server/linux/system-install/centos6/26.png
    :align: center
    :height: 500px
    :width: 800 px

28. 进入下图，然后选择“Next”

.. image:: /Server/res/images/server/linux/system-install/centos6/27.png
    :align: center
    :height: 500px
    :width: 800 px

29. 选择安装系统的类型。本例使用最小化安装结合指定安装软件包。然后选择“Next”

.. image:: /Server/res/images/server/linux/system-install/centos6/28.png
    :align: center
    :height: 500px
    :width: 800 px

30. 进入下图界面。选择“Base System”组中的“Base”“Compatibility libraries”“Debugging Tools”

.. image:: /Server/res/images/server/linux/system-install/centos6/29.png
    :align: center
    :height: 500px
    :width: 800 px

31. 然后再选择“Development”组中的“Development tools”，然后点击“Next”进入自动安装界面。

.. image:: /Server/res/images/server/linux/system-install/centos6/30.png
    :align: center
    :height: 500px
    :width: 800 px

32. 安装完成进入下图界面，点击“reboot”重启即可进入centos系统（此时可以拔出U盘）

.. image:: /Server/res/images/server/linux/system-install/centos6/31.png
    :align: center
    :height: 500px
    :width: 800 px


.. _centos6-install-faq:

CentOS6安装过程常见问题
======================================================================================================================================================

之前安装了系统，再次安装
------------------------------------------------------------------------------------------------------------------------------------------------------

会进入下面界面。选择上面第一个选项“Fresh Installation”按回车键继续即可。

.. image:: /Server/res/images/server/linux/system-install/centos6/faq01.png
    :align: center
    :height: 500px
    :width: 800 px


