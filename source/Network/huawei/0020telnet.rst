.. _h3c_telnet:

======================================================================================================================================================
H3C设备telnet管理
======================================================================================================================================================


.. contents::

H3C常见telnet
======================================================================================================================================================

一般如果是新设备，需要用console线链接，然后配置开启telnet。也有的设备默认有管理端口和默认IP以及默认管理账号及密码。

.. tip::
    - console线需要安装驱动。console线的知识这里不一一赘述。
    - 现在新的设备有的带micro的管理口。可以用android数据线链接。

几种telnet登陆分类
------------------------------------------------------------------------------------------------------------------------------------------------------


常见的telnet链接方式有以下几种：
    1. 直接输入密码，登陆后即为超级用户
    2. 直接输入密码，登陆后为普通用户权限，需要输入super密码才能获取管理员权限。
    3. 输入用户名和对应的密码，登陆即为管理员
    4. 输入用户名和对应密码，登陆为普通用户权限，需要输入super密码才能获取管理员权限。
    5. 配置结合radius/AAA服务器认证





telnet配置
======================================================================================================================================================



telnet必要的准备配置
------------------------------------------------------------------------------------------------------------------------------------------------------

全局开启telnet服务。如果不开启，会导致后面配置不生效。

.. code-block:: text
    :linenos:

    <H3C>sys
    System View: return to User View with Ctrl+Z.
    [H3C]telnet server enable

telnet链接需要有处于up状态的接口(物理接口或逻辑接口)
------------------------------------------------------------------------------------------------------------------------------------------------------

配置一个交换机的接口为三层接口，并设置IP，为后面的telnet链接测试准备：

.. code-block:: text
    :linenos:

    [H3C]interface GigabitEthernet1/0/1
    [H3C-GigabitEthernet1/0/1]port link-mode route
    [H3C-GigabitEthernet1/0/1]ip address 192.168.1.1 24
    [H3C-GigabitEthernet1/0/1]exit

    [H3C]quit
    <H3C>dis ip inter brief
    *down: administratively down
    (s): spoofing  (l): loopback
    Interface                Physical Protocol IP Address      Description
    GE1/0/1                  up       up       192.168.1.1     --
    MGE0/0/0                 down     down     --              --


telnet链接只需密码（管理员权限）
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: text
    :linenos:

    <H3C>system-view
    System View: return to User View with Ctrl+Z.
    [H3C]telnet server enable
    [H3C]user-interface vty 0 4
    [H3C-line-vty0-4]authentication-mode password
    [H3C-line-vty0-4]set authentication password simple 123
    [H3C-line-vty0-4]user-role network-admin
    [H3C-line-vty0-4]idle-timeout 5 0
    [H3C-line-vty0-4]history-command max-size 100
    [H3C-line-vty0-4]quit

链接测试：

.. code-block:: text
    :linenos:

    <H3C>telnet 192.168.1.1
    Trying 192.168.1.1 ...
    Press CTRL+K to abort
    Connected to 192.168.1.1 ...

    ******************************************************************************
    * Copyright (c) 2004-2017 New H3C Technologies Co., Ltd. All rights reserved.*
    * Without the owner's prior written consent,                                 *
    * no decompiling or reverse-engineering shall be allowed.                    *
    ******************************************************************************

    Password:

上面命令汇总：

.. code-block:: text
    :linenos:

    system-view
    telnet server enable
    user-interface vty 0 4
    authentication-mode password
    set authentication password simple 123
    user-role network-admin
    idle-timeout 5 0
    history-command max-size 100
    quit


telnet链接只需密码（普通权限）
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: text
    :linenos:

    system-view
    telnet server enable
    user-interface vty 0 4
    authentication-mode password
    set authentication password simple 123
    user-role level-0
    idle-timeout 5 0
    history-command max-size 100
    quit
    super password simple 321


telnet需要用户名和密码（管理员权限）
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: text
    :linenos:

    system-view
    telnet server enable
    local-user testuser
    service-type telnet
    password simple 123
    authorization-attribute user-role network-admin
    quit
    user-interface vty 0 4
    idle-timeout 5 0
    protocol inbound telnet
    terminal type vt100
    history-command max-size 50
    authentication-mode scheme
    quit





telnet需要用户名和密码（普通权限）
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: text
    :linenos:

    system-view
    telnet server enable
    local-user testuser
    service-type telnet
    password simple 123
    authorization-attribute user-role level-1
    quit
    user-interface vty 0 4
    authentication-mode scheme
    idle-timeout 5 0
    protocol inbound telnet
    terminal type vt100
    history-command max-size 50
    quit
    super password simple 321

