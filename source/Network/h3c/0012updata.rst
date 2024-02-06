.. _network_h3c_updata:

======================================================================================================================================================
系统更新/重置密码
======================================================================================================================================================


.. contents::



系统更新
======================================================================================================================================================


系统更新一般设备手册都有对应的系统更新方法。


一般更新方法包括：
    - 本地配置ftp/tftp服务器，H3C设备作为FTP客户端
    - H3C设备配置ftp服务器，本地电脑作为ftp客户端
    - 通过console管理口上传升级（一般速度慢，所以一般用上面的方法）。


本地配置ftp/tfp服务器
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: text
    :linenos:

    <Router> ftp 192.168.100.14

    ftp> get msr56.ipe
    ftp> quit

    <Router> display version

    <Router> copy cfa0:/msr56.ipe slot1#cfa0:/msr56.ipe




# 指定Router的主用主控板下次启动时所用的主用启动文件为msr56.ipe。



.. code-block:: text
    :linenos:

    <Router> boot-loader file cfa0:/msr56.ipe slot 0 main

    <Router> display boot-loader slot 0


H3C设备配置ftp/tfp服务器
------------------------------------------------------------------------------------------------------------------------------------------------------

- FTP 服务器（SwitchA）上的配置

用户登录到交换机上，配置 VLAN 接口 1 的 IP 地址为 1.1.1.1/8。

.. code-block:: text
    :linenos:

    <Sysname> system-view
    [Sysname] interface Vlan-interface 1
    [Sysname-Vlan-interface1] ip address 1.1.1.1 8
    [Sysname-Vlan-interface1] quit

在交换机上开启 FTP 服务，并设置用于登录本机 FTP 服务的用户名和密码。

.. code-block:: text
    :linenos:

    [Sysname] ftp server enable
    [Sysname] local-user switch
    [Sysname-luser-switch] password simple hello
    [Sysname-luser-switch] service-type ftp

- FTP 客户端（PC）上的配置

在 PC 上运行 FTP 客户端程序，与交换机建立 FTP 连接。这里以 Windows 系统的命令行窗口工具为例进行说明。

进入命令行窗口，并切换至 switch.bin 文件所在目录。（假设该文件存放在分区 C 的根目录下）

使用 ftp 功能访问以太网交换机，并输入用户名 switch、密码 hello 进行登录，进入 FTP 视图。

.. code-block:: text
    :linenos:

    C:\>
    C:\> ftp 1.1.1.1H3C 低端以太网交换机 典型配置指导
    Connected to 1.1.1.1.
    220 FTP service ready.
    User (1.1.1.1:(none)): switch
    331 Password required for switch.
    Password:
    230 User logged in.
    ftp>
    # 上传 switch.bin 文件。
    ftp> put switch.bin
    # 下载 config.cfg 文件。
    ftp> get config.cfg

升级交换机的应用程序

- 用户在交换机上可以通过 boot boot-loader 命令来指定已上传的应用程序为下次启动时的应用程序，然后重启交换机，实现交换机应用程序的升级。

.. code-block:: text
    :linenos:

    <Sysname> boot boot-loader switch.bin
    <Sysname> reboot


设备密码重置
======================================================================================================================================================

- 重新启动交换机。
- 在交换机完成自检后，在下面的界面键入 **Ctrl+B** ，并根据提示输入BootRom菜单登录密码，进入BootRom菜单。

.. code-block:: text
    :linenos:

    Starting......

    

                ***********************************************************

                *                                                         *

                *        H3C S5500-28C-PWR-EI BOOTROM, Version 509        *

                *                                                         *

                ***********************************************************

                Copyright (c) 2004-2009 Hangzhou H3C Tech. Co., Ltd.

                Creation date   : Jan  9 2009, 10:44:09

                CPU Clock Speed : 533MHz

                BUS Clock Speed : 133MHz

                Memory Size     : 256MB

                Mac Address     : 002389294f70

    Press Ctrl-B to enter Boot Menu... 1  

    Password:




- 缺省情况下，进入BootRom菜单的密码为空。如果您设置了BootRom菜单登录密码，但该密码已经丢失，请根据“恢复BootRom菜单登录密码”中介绍的方法进行恢复。
- 进入BootRom菜单后，请键入“7”，选择“跳过配置文件启动”功能，并在系统提示时输入“y”进行确认。

.. code-block:: text
    :linenos:

             BOOT  MENU

     

    1. Download application file to flash

    2. Select application file to boot

    3. Display all files in flash

    4. Delete file from flash

    5. Modify bootrom password

    6. Enter bootrom upgrade menu

    7. Skip current configuration file

    8. Set bootrom password recovery

    9. Set switch startup mode

    0. Reboot

     

    Enter your choice(0-9): 7

    The current setting is running configuration file when reboot.

    Are you sure to skip current configuration file when reboot? Yes or No(Y/N) y

    Setting......done! 

- 回到BootRom菜单后，输入“0”重新启动交换机。

.. code-block:: text
    :linenos:

             BOOT  MENU

     

    1. Download application file to flash

    2. Select application file to boot

    3. Display all files in flash

    4. Delete file from flash

    5. Modify bootrom password

    6. Enter bootrom upgrade menu

    7. Skip current configuration file

    8. Set bootrom password recovery

    9. Set switch startup mode

    0. Reboot

     

    Enter your choice(0-9): 0

    ^@System rebooting...


- 再次启动时，交换机会跳过配置文件，即跳过对控制台密码的配置，您可以直接登录交换机。

.. code-block:: text
    :linenos:

    ****************************************************************************

    * Copyright (c) 2004-2010 Hangzhou H3C Tech. Co., Ltd. All rights reserved.*

    * Without the owner's prior written consent,                               *

    * no decompiling or reverse-engineering shall be allowed.                  *

    ****************************************************************************

     

    Configuration file is skipped.

    User interface aux0 is available.

     

     

     

    Press ENTER to get started.

    <H3C>


- 进入命令行接口后，您可以使用display startup命令查看启动配置文件，并使用more命令查看该配置文件中的控制台密码配置。

.. code-block:: text
    :linenos:

    <H3C> display startup

      Current startup saved-configuration file:          NULL

      Next startup saved-configuration file:             flash:/startup.cfg 

    <H3C> more startup.cfg

- 如果认证方式是Password方式，请关注配置文件中的以下部分，即配置控制台登录密码的配置命令。

配置密码为明文方式的显示效果：

.. code-block:: text
    :linenos:

    #

    user-interface aux 0

    authentication-mode password

    set authentication password simple test

配置密码为密文方式的显示效果：

.. code-block:: text
    :linenos:

    #

    user-interface aux 0

    authentication-mode password

    set authentication password cipher .]@USE=B,53Q=^Q`MAF4<1!!` 



如果您设置的登录密码为明文，则密码将直接显示在“set authentication password simple”一行中，您可以选择修改登录密码或继续使用原有密码登录；
如果您设置的登录密码为密文，则密码将显示为转换后的密文字符，此时建议您修改登录密码。


- 如果认证方式是Scheme方式，请关注配置文件中的以下部分，即配置本地用户名和密码的配置命令（以用户名为admin为例）。

配置密码为明文方式的显示效果：

.. code-block:: text
    :linenos:

    #

    local-user admin

    password simple 123

    service-type terminal

配置密码为密文方式的显示效果：

.. code-block:: text
    :linenos:

    #

    local-user admin

    password cipher 7-CZB#/YX]KQ=^Q`MAF4<1!!`

    service-type terminal



- 如果设备创建有多个本地用户，请查看服务类型为终端用户的用户配置，即具有“service-type terminal”配置的用户。

- 如果您设置的登录密码为明文，则密码将直接显示在“password simple”一行中，您可以选择修改登录密码或继续使用原有密码登录；如果您设置的登录密码为密文，则密码将显示为转换后的密文字符，此时建议您修改登录密码。

 

- 通过copy命令对启动配置文件进行备份，以便在修改登录密码时保留原有启动配置文件。在本例中，我们将备份文件命名为“startup_bak.cfg”。

.. code-block:: text
    :linenos:

    <H3C> copy startup.cfg startup_bak.cfg

    Copy flash:/startup.cfg to flash:/startup_bak.cfg?[Y/N]:y

    .......

    %Copy file flash:/startup.cfg to flash:/startup_bak.cfg...Done.

- 您可以使用FTP或TFTP将启动配置文件发送到PC上，使用文本编辑软件（例如Windows系统的“记事本”或“写字板”软件）对配置文件进行编辑，请根据您的需要采用以下修改方案：

    - 修改“authentication-mode”行最后的登录认证方式为“none”，即将认证方式修改为不认证。
    - 修改“set authentication password”行后面的密码显示方式为明文（simple），并重新写入新的密码。（Password方式适用）
    - 修改“password”行后面的密码显示方式为明文（simple），并重新写入新的密码。（Scheme方式适用）



对控制台登录不进行认证的方式不利于网络设备的安全，仅适用于临时登录使用，建议您尽快修改为其他认证方式。

 

- 将配置文件上传到交换机上覆盖原配置文件。重新启动后，交换机将使用更新后的配置文件，您可以根据修改后的密码进行登录，同时其他原有配置不会丢失。










