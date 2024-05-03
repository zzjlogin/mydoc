
======================================================================================================================================================
链路聚合
======================================================================================================================================================


.. contents::


简述链路聚合
======================================================================================================================================================

链路聚合一般可以分为：
    - 二层接口聚合
        这个聚合端口可以配置trunk/access等配置信息。
    - 三层接口聚合

链路聚合作用：
    1. 提高两个设备间的链路最大带宽。
    2. 提高设备间链路稳定性以及容灾(断掉一条还能正常使用)
    3. 手动指定。使得链路可控性良好。

链路聚合配置步骤：
    1. 创建虚拟聚合端口(可以理解成一个逻辑端口)，此时可以设置聚合端口的聚合方式。
    2. 把物理接口加入聚合端口
    3. 在聚合端口配置模式配置相应的配置信息即可。
    4. 测试是否生效。

链路聚合的协议
    - LACP协议，Link Aggregation Control Protocol，链路汇聚控制协议
    - LACP协议百度百科：https://baike.baidu.com/item/LACP/7797186?fr=aladdin
    - LACP是一种实现链路 **动态聚合** 的协议。

链路聚合模式
    1. 静态模式
        聚合组内的端口不启用LACP协议，手动维护端口状态
    2. 动态模式
        聚合组内端口启用LACP协议，端口通过协议自动维护

聚合组内链路分担类型
    1. 根据报文MAC地址进行聚合负载分担
    2. 根据报文服务端口号进行聚合负载分担
    3. 根据报文如端口进行聚合负载分担
    4. 根据报文IP地址进行聚合负载分担


二层链路聚合配置
======================================================================================================================================================

静态二层链路聚合
------------------------------------------------------------------------------------------------------------------------------------------------------

.. note::
    加入聚合组的所有物理接口需要都是默认配置，即配置相同。

创建聚合端口：

.. code-block:: none
    :linenos:

    <H3C>system-view
    System View: return to User View with Ctrl+Z.
    [H3C]interface Bridge-Aggregation 1

进入物理端口，然后把物理接口加入聚合组：

.. code-block:: none
    :linenos:

    [H3C]inter g1/0/1
    [H3C-GigabitEthernet1/0/1]port link-ag
    [H3C-GigabitEthernet1/0/1]port link-aggregation gr
    [H3C-GigabitEthernet1/0/1]port link-aggregation group 1
    [H3C-GigabitEthernet1/0/1]inter g1/0/2
    [H3C-GigabitEthernet1/0/2]port link-a group 1

聚合端口信息：

.. code-block:: none
    :linenos:

    [H3C]dis link-aggregation summary
    Aggregation Interface Type:
    BAGG -- Bridge-Aggregation, BLAGG -- Blade-Aggregation, RAGG -- Route-Aggregation, SCH-B -- Schannel-Bundle
    Aggregation Mode: S -- Static, D -- Dynamic
    Loadsharing Type: Shar -- Loadsharing, NonS -- Non-Loadsharing
    Actor System ID: 0x8000, 74b3-5502-0300

    AGG        AGG   Partner ID              Selected  Unselected  Individual  Share
    Interface  Mode                          Ports     Ports       Ports       Type
    --------------------------------------------------------------------------------
    BAGG1      S     None                    1         1           0           Shar


    [H3C]display link-aggregation verbose
    Loadsharing Type: Shar -- Loadsharing, NonS -- Non-Loadsharing
    Port: A -- Auto
    Port Status: S -- Selected, U -- Unselected, I -- Individual
    Flags:  A -- LACP_Activity, B -- LACP_Timeout, C -- Aggregation,
            D -- Synchronization, E -- Collecting, F -- Distributing,
            G -- Defaulted, H -- Expired

    Aggregate Interface: Bridge-Aggregation1
    Aggregation Mode: Static
    Loadsharing Type: Shar
    Port             Status  Priority Oper-Key
    --------------------------------------------------------------------------------
    GE1/0/1          S       32768    1
    GE1/0/2          U       32768    1


    [H3C]display interface Bridge-Aggregation 1 brief
    Brief information on interfaces in bridge mode:
    Link: ADM - administratively down; Stby - standby
    Speed: (a) - auto
    Duplex: (a)/A - auto; H - half; F - full
    Type: A - access; T - trunk; H - hybrid
    Interface            Link Speed   Duplex Type PVID Description
    BAGG1                UP   1G(a)   F(a)   A    1


动态二层链路聚合
------------------------------------------------------------------------------------------------------------------------------------------------------


创建聚合端口并指定链路聚合方式为动态聚合：

.. code-block:: none
    :linenos:

    <H3C>system-view
    System View: return to User View with Ctrl+Z.
    [H3C]interface Bridge-Aggregation 1
    [H3C-Bridge-Aggregation1]link-aggregation mode dynamic

默认情况，聚合端口LACP使用的是30s超时，即链路异常需要30s反应，可以通过在物理接口配置为short，也就是1s超时。

配置方式：

.. code-block:: none
    :linenos:

    [H3C-GigabitEthernet1/0/1]lacp period short

其余配置和静态方式一样。


三层链路聚合配置
======================================================================================================================================================

.. note::
    加入聚合组的所有物理接口需要都是默认配置，即配置相同。

这里就不再做静态聚合步骤了。



动态二层链路聚合
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: none
    :linenos:

    [H3C]interface Route-Aggregation 1
    [H3C-Route-Aggregation1]link-aggregation mode dynamic

    [H3C-Route-Aggregation1]inter g1/0/1
    [H3C-GigabitEthernet1/0/1]port link-mode route
    [H3C-GigabitEthernet1/0/1]port link-aggregation group 1

    [H3C-GigabitEthernet1/0/1]lacp period short
    [H3C-GigabitEthernet1/0/1]inter g1/0/2
    [H3C-GigabitEthernet1/0/2]port link-mode route
    [H3C-GigabitEthernet1/0/2]lacp period short
    [H3C-GigabitEthernet1/0/2]port link-aggregation group 1
    [H3C-GigabitEthernet1/0/2]inter rou 1
    [H3C-Route-Aggregation1]link-aggregation load-sharing mode source-ip destination-ip





