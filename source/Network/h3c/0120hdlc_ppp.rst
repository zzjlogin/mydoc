.. _network_h3c_hdlc_ppp:

======================================================================================================================================================
HDLC和PPP
======================================================================================================================================================


.. contents::


HDLC
======================================================================================================================================================

用H3C模拟器使用自定义设备加载E1接口即可。

.. code-block:: text
    :linenos:

    <H3C>sys
    System View: return to User View with Ctrl+Z.
    [H3C]inter se1/0/2:0
    [H3C-Serial1/0/2:0]link-protocol ?
    fr    Frame Relay protocol
    hdlc  High-level Data Link Control protocol
    mfr   Multilink Frame Relay protocol
    ppp   Point-to-Point protocol
    stlp  Synchronization Transparent Transport Link protocol

    [H3C-Serial1/0/2:0]link-protocol hdlc
    [H3C-Serial1/0/2:0]ip address 192.168.1.1 30
    [H3C-Serial1/0/2:0]quit





PPP
======================================================================================================================================================

ppp的pap认证
------------------------------------------------------------------------------------------------------------------------------------------------------

pap认证为：两次握手，且密码为明文

ppp基于pap可以基于一方认证，也可以双方两次认证。此处用单方认证。双方认证参考下面chap的配置方法配置即可。

主认证方配置：

.. code-block:: text
    :linenos:

    <H3C>sys
    System View: return to User View with Ctrl+Z.
    [H3C]controller e1 1/0/2
    [H3C-E1 1/0/2]using e1
    [H3C-E1 1/0/2]quit
    [H3C]inter se1/0/2:0
    [H3C-Serial1/0/2:0]link-protocol ppp
    [H3C-Serial1/0/2:0]timer-hold 20
    [H3C-Serial1/0/2:0]ppp timer negotiate 5
    [H3C-Serial1/0/2:0]ppp compression iphc enable
    [H3C-Serial1/0/2:0]ppp authentication-mode pap domain system
    [H3C-Serial1/0/2:0]ip address 192.168.1.1 30
    [H3C-Serial1/0/2:0]remote address 192.168.1.2
    [H3C-Serial1/0/2:0]quit
    [H3C]domain name system
    [H3C-isp-system]authentication ppp local
    # h3c设备默认创建用户属于manage类，只有network类才有ppp
    [H3C]local-user h3c class network
    New local user added.
    [H3C-luser-network-h3c]service-type ?
    advpn       ADVPN service
    ike         IKE service
    ipoe        IPOE service
    lan-access  LAN access service
    portal      Portal service
    ppp         PPP service
    sslvpn      SSL VPN service

    [H3C-luser-network-h3c]service-type ppp
    [H3C-luser-network-h3c]password simple 123
    [H3C-luser-network-h3c]quit

被认证方配置：

.. code-block:: text
    :linenos:

    <H3C>sys
    System View: return to User View with Ctrl+Z.
    [H3C]controller e1 1/0/2
    [H3C-E1 1/0/2]using e1
    [H3C-E1 1/0/2]quit
    [H3C]inter se1/0/2:0
    [H3C-Serial1/0/2:0]link-protocol ppp
    [H3C-Serial1/0/2:0]timer-hold 20
    [H3C-Serial1/0/2:0]ppp timer negotiate 5
    [H3C-Serial1/0/2:0]ppp compression iphc enable


    <H3C>display inter brief
    Brief information on interfaces in route mode:
    Link: ADM - administratively down; Stby - standby
    Protocol: (s) - spoofing
    Interface            Link Protocol Primary IP      Description
    InLoop0              UP   UP(s)    --
    MGE0/0/0             DOWN DOWN     --
    NULL0                UP   UP(s)    --
    Pos1/0/1             DOWN DOWN     --
    REG0                 UP   --       --
    Ser1/0/2:0           UP   UP       192.168.1.2

    <H3C>ping 192.168.1.1
    Ping 192.168.1.1 (192.168.1.1): 56 data bytes, press CTRL_C to break
    56 bytes from 192.168.1.1: icmp_seq=0 ttl=255 time=4.000 ms






ppp的chap认证
------------------------------------------------------------------------------------------------------------------------------------------------------

chap认证：三次握手，密码是密文，所以比pap认证安全。

chap和pap一样可以单方认证和双方认证。此处配置双方认证。

- 第一台配置：

.. code-block:: text
    :linenos:

    <H3C>sys
    System View: return to User View with Ctrl+Z.
    [H3C]controller e1 1/0/2
    [H3C-E1 1/0/2]using e1
    [H3C-E1 1/0/2]quit
    [H3C]inter se1/0/2:0
    [H3C-Serial1/0/2:0]link-protocol ppp
    [H3C-Serial1/0/2:0]ppp authentication-mode chap
    [H3C-Serial1/0/2:0]ppp chap user test1
    [H3C-Serial1/0/2:0]ppp chap password simple test1

    [H3C-Serial1/0/2:0]ip address 192.168.1.1 30
    [H3C-Serial1/0/2:0]quit

    [H3C]local-user test class network
    New local user added.
    [H3C-luser-network-test]password simple 123456
    [H3C-luser-network-test]service-type ppp
    [H3C-luser-network-test]quit


- 第二台配置配置：

.. code-block:: text
    :linenos:

    <H3C>sys
    System View: return to User View with Ctrl+Z.
    [H3C]local-user test1 class network
    New local user added.
    [H3C-luser-network-test1]ser
    [H3C-luser-network-test1]service-type ppp
    [H3C-luser-network-test1]password simple test1
    [H3C-luser-network-test1]quit

    [H3C]controller e1 1/0/2
    [H3C-E1 1/0/2]using e1
    [H3C-E1 1/0/2]quit
    [H3C]inter se1/0/2:0
    [H3C-Serial1/0/2:0]link-protocol ppp
    [H3C-Serial1/0/2:0]ppp authentication-mode chap
    [H3C-Serial1/0/2:0]ppp chap user test
    [H3C-Serial1/0/2:0]ppp chap password simple 123456

    [H3C-Serial1/0/2:0]ip address 192.168.1.2 30
    [H3C-Serial1/0/2:0]quit



    <H3C>display inter brief
    Brief information on interfaces in route mode:
    Link: ADM - administratively down; Stby - standby
    Protocol: (s) - spoofing
    Interface            Link Protocol Primary IP      Description
    InLoop0              UP   UP(s)    --
    MGE0/0/0             DOWN DOWN     --
    NULL0                UP   UP(s)    --
    Pos1/0/1             DOWN DOWN     --
    REG0                 UP   --       --
    Ser1/0/2:0           UP   UP       192.168.1.2

    <H3C>ping 192.168.1.1
    Ping 192.168.1.1 (192.168.1.1): 56 data bytes, press CTRL_C to break
    56 bytes from 192.168.1.1: icmp_seq=0 ttl=255 time=4.000 ms




ppp链路捆绑（MP）
------------------------------------------------------------------------------------------------------------------------------------------------------

一共有三种主要方式：
    - 用MP-Group方式配置MP
    - 用虚拟接口模版（Virtual-Template）捆绑物理接口方式配置MP
    - 用虚拟接口模版（Virtual-Template）捆绑用户名配置MP

- MP-Group方式配置MP

两台绑定的方式相同

.. code-block:: text
    :linenos:

    <H3C>sys
    System View: return to User View with Ctrl+Z.
    [H3C]inter MP-group 1/0/?
    <0-1023>  MP-group interface number

    [H3C]inter MP-group 1/0/1
    [H3C-MP-group1/0/1]ip add 192.168.1.1 30
    [H3C-MP-group1/0/1]quit
    [H3C]controller e1 1/0/3
    [H3C-E1 1/0/3]using e1
    [H3C-E1 1/0/3]quit

    [H3C]inter se 1/0/3:0
    [H3C-Serial1/0/3:0]ppp mp mp-g 1/0/1
    [H3C-Serial1/0/3:0]quit

    [H3C]controller e1 1/0/4
    [H3C-E1 1/0/4]using e1
    [H3C-E1 1/0/4]quit

    [H3C]inter se1/0/4:0
    [H3C-Serial1/0/4:0]ppp mp mp-g 1/0/1
    [H3C-Serial1/0/4:0]quit


- 虚拟接口模版（Virtual-Template）捆绑物理接口方式配置MP

.. code-block:: text
    :linenos:

    [H3C]interface Virtual-Template 1
    [H3C-Serial1/0/3:0]ppp mp Virtual-Template 1
    [H3C-Serial1/0/3:0]inter se1/0/4:0
    [H3C-Serial1/0/4:0]ppp mp Virtual-Template 1
    [H3C-Virtual-Template1]ip address 192.168.1.1 30
    [H3C-Virtual-Template1]ppp mp max-bind 2
    [H3C-Virtual-Template1]quit
    [H3C]inter Serial 1/0/3:0
    [H3C-Serial1/0/3:0]ppp mp Virtual-Template 1
    [H3C-Serial1/0/3:0]inter se1/0/4:0
    [H3C-Serial1/0/4:0]ppp mp Virtual-Template 1


- 虚拟接口模版（Virtual-Template）捆绑用户名配置MP


[H3C]local-user user1 class network
New local user added.
[H3C-luser-network-user1]password simple 12345
[H3C-luser-network-user1]service-type ppp
[H3C-luser-network-user1]quit

[H3C]ppp mp user use1 bind Virtual-Template 1
[H3C]interface Virtual-Template 1
[H3C-Virtual-Template1]ip address 192.168.1.1 30
[H3C-Virtual-Template1]ppp mp binding-mode authentication




