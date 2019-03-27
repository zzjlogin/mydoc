.. _network.huawei.telnet:

======================================================================================================================================================
华为设备telnet管理
======================================================================================================================================================


.. contents::

华为常见telnet
======================================================================================================================================================

一般如果是新设备，需要用console线链接，然后配置开启telnet。也有的设备默认有管理端口和默认IP以及默认管理账号及密码。

.. tip::
    - console线需要安装驱动。console线的知识这里不一一赘述。
    - 现在新的设备有的带micro的管理口。可以用android数据线链接。

几种telnet登陆分类
------------------------------------------------------------------------------------------------------------------------------------------------------







telnet配置
======================================================================================================================================================



telnet用户+super密码
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: text
    :linenos:

    <R1>sys
    Enter system view, return user view with Ctrl+Z.
    [R1]interface Ethernet0/0/0
    [R1-Ethernet0/0/0]ip address 192.168.1.1 24
    [R1-Ethernet0/0/0]quit
    [R1]user-interface vty 0 4

    [R1-ui-vty0-4]authentication-mode password
    [R1-ui-vty0-4]set authentication password cipher 123

    [R1-ui-vty0-4]quit
    [R1]super password cipher 321

    [R1]quit
    <R1>telnet 192.168.1.1
    Trying 192.168.1.1 ...
    Press CTRL+K to abort
    Connected to 192.168.1.1 ...


    Login authentication


    Password:
    Info: The max number of VTY users is 10, and the number
        of current VTY users on line is 1.
        The current login time is 2019-03-27 15:10:34.
    <R1>sys
        ^
    Error: Unrecognized command found at '^' position.



配置AAA认证
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: text
    :linenos:



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

