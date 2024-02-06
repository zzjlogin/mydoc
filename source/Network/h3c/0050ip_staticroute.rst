.. _network_h3c_ip_staticroute:

======================================================================================================================================================
配置IP及静态路由
======================================================================================================================================================


.. contents::


配置端口IP
======================================================================================================================================================

IP一般需要配置的地方：
    - vlan虚接口
    - 三层网络接口
    - 同一接口的子接口IP
    - 一些设备专用管理端口

通过DHCP获取IP
------------------------------------------------------------------------------------------------------------------------------------------------------

配置接口通过dhcp获取IP

.. code-block:: none
    :linenos:
    
    [H3C-GigabitEthernet1/0/10]ip address dhcp-alloc


vlan接口IP配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: none
    :linenos:

    <H3C>sys
    System View: return to User View with Ctrl+Z.
    [H3C]vlan 10
    [H3C-vlan10]inter vlan 10
    [H3C-Vlan-interface10]ip addres 192.168.1.1 24
    [H3C-Vlan-interface10]dis this
    #
    interface Vlan-interface10
    ip address 192.168.1.1 255.255.255.0
    #
    return


三层接口IP配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: none
    :linenos:

    <H3C>sys
    System View: return to User View with Ctrl+Z.
    [H3C]inter g
    [H3C]inter GigabitEthernet1/0/10
    [H3C-GigabitEthernet1/0/10]dis this
    #
    interface GigabitEthernet1/0/10
    port link-mode bridge
    combo enable fiber
    #
    return
    [H3C-GigabitEthernet1/0/10]port link-mode route
    [H3C-GigabitEthernet1/0/10]ip address 192.168.2.1 24
    [H3C-GigabitEthernet1/0/10]dis this
    #
    interface GigabitEthernet1/0/10
    port link-mode route
    combo enable fiber
    ip address 192.168.2.1 255.255.255.0
    #

同一接口的子接口IP
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: none
    :linenos:

    <H3C>sys
    System View: return to User View with Ctrl+Z.
    [H3C]vlan 10
    [H3C-vlan10]inter vlan 10
    [H3C-Vlan-interface10]ip addres 192.168.1.1 24
    [H3C-Vlan-interface10]dis this
    #
    interface Vlan-interface10
    ip address 192.168.1.1 255.255.255.0
    #
    return

    [H3C]interface vlan 10
    [H3C-Vlan-interface10]ip address 192.168.10.1 24 sub
    [H3C-Vlan-interface10]dis this
    #
    interface Vlan-interface10
    ip address 192.168.1.1 255.255.255.0
    ip address 192.168.10.1 255.255.255.0 sub



静态路由配置
======================================================================================================================================================

简单配置静态路由
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: none
    :linenos:

    [H3C]ip route-static 10.8.0.0 255.255.0.0 192.168.1.1


配置静态路由时配置备用路由
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: none
    :linenos:

    <H3C>sys
    System View: return to User View with Ctrl+Z.
    [H3C]inter g0/0
    [H3C-GigabitEthernet0/0]ip add 192.168.1.1 24
    [H3C-GigabitEthernet0/0]inter g0/1
    [H3C-GigabitEthernet0/1]ip add 192.168.2.1 24
    [H3C-GigabitEthernet0/1]quit
    [H3C]ip route-static 10.8.0.0 255.255.0.0 GigabitEthernet 0/0 192.168.1.2
    [H3C]ip route-static 10.8.0.0 255.255.0.0 GigabitEthernet 0/1 192.168.2.2 preference 100



配置静态路由负载分担
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: none
    :linenos:

    <H3C>sys
    System View: return to User View with Ctrl+Z.
    [H3C]inter g0/0
    [H3C-GigabitEthernet0/0]ip add 192.168.1.1 24
    [H3C-GigabitEthernet0/0]inter g0/1
    [H3C-GigabitEthernet0/1]ip add 192.168.2.1 24
    [H3C-GigabitEthernet0/1]quit
    [H3C]ip route-static 10.8.0.0 255.255.0.0 GigabitEthernet 0/0 192.168.1.2
    [H3C]ip route-static 10.8.0.0 255.255.0.0 GigabitEthernet 0/1 192.168.2.2

验证静态路由负载分担和备份的区别，可以查看路由表验证：

.. code-block:: none
    :linenos:

    [H3C]dis ip routing-table all-routes statistics

    VPN instance: public instance
    Total prefixes: 17      Active prefixes: 17

    Proto      route       active      added       deleted
    DIRECT     16          16          16          0
    STATIC     1           1           1           0
    RIP        0           0           0           0
    OSPF       0           0           0           0
    IS-IS      0           0           0           0
    LISP       0           0           0           0
    BGP        0           0           0           0
    Total      17          17          17          0
    [H3C]no ip route-static 10.8.0.0 255.255.0.0 GigabitEthernet 0/1 192.168.2.2 pre
    ference 100
    [H3C]ip route-static 10.8.0.0 255.255.0.0 GigabitEthernet 0/1 192.168.2.2
    [H3C]dis ip routing-table statistics

    Total prefixes: 17      Active prefixes: 17

    Proto      route       active      added       deleted
    DIRECT     16          16          16          0
    STATIC     2           2           2           0
    RIP        0           0           0           0
    OSPF       0           0           0           0
    IS-IS      0           0           0           0
    LISP       0           0           0           0
    BGP        0           0           0           0
    Total      18          18          18          0



静态路由结合BFD检测
------------------------------------------------------------------------------------------------------------------------------------------------------













