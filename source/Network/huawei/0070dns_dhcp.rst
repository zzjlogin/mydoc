
======================================================================================================================================================
dns/dhcp配置
======================================================================================================================================================


.. contents::


DNS配置
======================================================================================================================================================

DNS：域名解析系统，实现通过域名到IP的转换。

域名解析分为：
    - 静态域名解析：手动建立域名和IP的对应关系(在H3C设备配置)
    - 动态域名解析：通过DNS服务器的查询完成域名解析。
DNS服务端口：
    - 53
DNS协议类型：
    - tcp/udp
DNS服务模式：
    C/S（客户端服务端模型）
域名长度限制：
    - 对于每一级域名长度的限制是63个字符，域名总长度则不能超过253个字符。


一般H3C设备配置DNS常见有两种情况：
    1. H3C设备作为DNS客户端。配置了dns服务器地址以后。h3c设备可以通过域名访问对应的主机。
    2. H3C设备作为DNS代理。这样在一个子网内主机的dns配置为这个H3C设备的IP即可。这样这个子网的设备就可以实现通过域名访问对应的主机。而且这样可以节约网络出口带宽。

配置为DNS客户端
------------------------------------------------------------------------------------------------------------------------------------------------------

配置域名和IP对应解析（静态域名解析）：

<H3C>system-view
System View: return to User View with Ctrl+Z.
[H3C]ip host www.h3c.com 192.168.1.1

在三层接口配置DNS服务器地址，这个接口需要可以和这个DNS服务器正常通信。这样才能正常解析域名。

[H3C]interface GigabitEthernet0/1
[H3C-GigabitEthernet0/1]dns server 192.168.1.254

配置为DNS代理
------------------------------------------------------------------------------------------------------------------------------------------------------

配置步骤：
    - 系统视图开启全局的DNS代理功能
    - 配置DNS服务器地址
    - 配置允许域名解析

<H3C>system-view
System View: return to User View with Ctrl+Z.
[H3C]dns proxy enable
[H3C]interface GigabitEthernet0/1
[H3C-GigabitEthernet0/1]dns server 192.168.1.254



DHCP配置
======================================================================================================================================================


DHCP相关参考：




DHCP静态地址分配配置
------------------------------------------------------------------------------------------------------------------------------------------------------

这样配置，是让指定mac地址的主机获取指定IP信息。

配置步骤：
    1. 系统视图开启dhcp功能
    2. 系统视图下配置DHCP地址池
    3. 在对应的接口(vlan/三层物理接口)引用这个地址池

<H3C>system-view
System View: return to User View with Ctrl+Z.
[H3C]dhcp enable
[H3C]dhcp server ip-pool vlan1_pool
[H3C-dhcp-pool-vlan1_pool]static-bind ip-address 192.168.1.100 24 hardware-address 0000-ffff-0000
[H3C-dhcp-pool-vlan1_pool]dns-list 192.168.1.1
[H3C-dhcp-pool-vlan1_pool]gateway-list 192.168.1.1
[H3C-dhcp-pool-vlan1_pool]inter vlan1
[H3C-Vlan-interface1]dhcp server apply ip-pool vlan1_pool



DHCP动态地址分配配置
------------------------------------------------------------------------------------------------------------------------------------------------------

<H3C>system-view
System View: return to User View with Ctrl+Z.
[H3C]dhcp enable
[H3C]dhcp server ip-pool vlan1_pool
[H3C-dhcp-pool-vlan1_pool]network 192.168.1.0 mask 255.255.255.0
[H3C-dhcp-pool-vlan1_pool]dns-list 192.168.1.1
[H3C-dhcp-pool-vlan1_pool]gateway-list 192.168.1.1
[H3C-dhcp-pool-vlan1_pool]expired day 14
[H3C-dhcp-pool-vlan1_pool]forbidden-ip 192.168.1.1 192.168.1.254
[H3C-dhcp-pool-vlan1_pool]dis this
#
dhcp server ip-pool vlan1_pool
 gateway-list 192.168.1.1
 network 192.168.1.0 mask 255.255.255.0
 dns-list 192.168.1.1
 expired day 14
 forbidden-ip 192.168.1.1
 forbidden-ip 192.168.1.254
 static-bind ip-address 192.168.1.100 mask 255.255.255.0 hardware-address 0000-ffff-0000
#
return

[H3C-dhcp-pool-vlan1_pool]inter vlan1
[H3C-Vlan-interface1]dhcp server apply ip-pool vlan1_pool

配置地址池地址范围还可以用：

[H3C-dhcp-pool-vlan1_pool]address range 192.168.1.10 192.168.1.100


DHCP中继
------------------------------------------------------------------------------------------------------------------------------------------------------

DHCP中继配置目的：
    - 一个中型/大型网络可能有一台/多台DHCP服务器专门提供dhcp服务。
    - 那么这个较大的网络可能有不同子网(可以理解成网段)
    - 可能这里面多数子网需要用dhcp服务，且都是通过dhcp服务器获取IP
    - 那么这个子网的网关设备就可以配置DHCP中继，这样这个子网的主机就可以通过dhcp服务器获取IP
    - 实现了：dhcp服务器和dhcp客户端不再一个子网的时候主机获取IP地址。

DHCP中继配置步骤：
    1. 系统视图启动dhcp功能
    2. 系统视图设置伪dhcp检测（可以不开启）
    3. 创建dhcp服务器组
    4. 在三层接口绑定这个dhcp服务器组
    5. 在三层接口下配置用户下线检测
    5. 在三层接口下配置中继检测

<H3C>system-view
System View: return to User View with Ctrl+Z.
[H3C]dhcp enable
[H3C]dhcp relay client-information record
[H3C]dhcp relay client-information refresh enable
[H3C]dhcp relay client-information refresh auto

[H3C]interface g0/1
[H3C-GigabitEthernet0/1]dhcp relay server-address 192.168.10.1




DHCP Snooping
------------------------------------------------------------------------------------------------------------------------------------------------------








