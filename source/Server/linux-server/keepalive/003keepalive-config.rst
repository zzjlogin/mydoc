.. _keepalive-config:

======================================================================================================================================================
keepalive配置
======================================================================================================================================================

:Date: 2018-09

.. contents::

keepalive配置实例讲解
======================================================================================================================================================



keepalive配置详解
======================================================================================================================================================

官方配置详解：
    http://www.keepalived.org/manpage.html

注意事项：
    - 以 ``#`` 或者 ``!`` 开头的行是注释行，自动忽略(Comments start with '#' or '!' to the end of the  line  and  can  start anywhere in a line.)
    - 允许用 ``include`` 引入其他子配置文件(文件最好用绝对路径)，格式：
        include FILENAME
    - 配置的每一层都是关键字和 ``{}`` 结合。
    - 所有的设置项的值可以是下列值中的一个(<BOOL> is one of on|off|true|false|yes|no):
        on|off|true|false|yes|no

keepalive配置一般可以分为三个部分：
	- 全局配置GLOBAL CONFIGURATION
	- vrrp配置VRRPD CONFIGURATION
	- lvs配置LVS CONFIGURATION
    
    - BFD配置BFD CONFIGURATION


全局配置详解(Globals configurations)
------------------------------------------------------------------------------------------------------------------------------------------------------

全局配置，一般是把所有vrrp/lvs中的通用配置选项配置在全局配置中，这样配置让配置文件更简洁易读易懂。

这部分配置分为两部分：
    - 全局定义
    - 静态路由设置

全局定义
......................................................................................................................................................

net_namespace NAME
    这个配置名更改后，reload不能生效。需要重启keepalive。
    用于运行的全局守护进程时设置独立的网络命名空间。会创建一个 ``/var/run/keepalived``
    并以非共享方式挂载。并且在日志中会记录这个网络空间的名称。
instance NAME
    多实例的时候会创建一个带名称 ``NAME`` 的 ``pid`` 文件在 ``/var/run/keepalived``
    这个参数也是需要restart重启生效，reload不生效。
use_pid_dir
    在 ``/var/run/keepalived`` 中创建 ``pid`` 文件。
linkbeat_use_polling
    用ETHTOOL或MII接口检测媒体链接是否失败。
child_wait_time SECS
    默认5秒，主进程允许子进程结束后几秒退出。当实例特别多时才需要考虑这个参数。

------------------------------------------------------------------------------------------------------------------------------------------------------

.. tip::
    以上几个配置项可以放在 ``global_defs {}``
    的前面。每行一个配置项。

global_defs {}
    定义这个 ``{}`` 中的配置项都是全局配置。
notification_email {}
    发生事件时发送的邮件警告, ``{}`` 中的内容是标准的邮件地址，用于接收信息，多个邮箱用可以每行一个即可。
    可以配置在 ``global_defs {}`` 中。
notification_email_from <EMAIL ADDRESS>
    使用smtp协议的邮件发件邮箱
smtp_server 127.0.0.1 [<PORT>]
    SMTP服务器的IP地址/域名，默认端口是25
smtp_helo_name <STRING>
    指定用来建立smtp链接发送的smtp hello信息，默认时本地主机名。

smtp_connect_timeout 30
    连接远程smtp服务器超时的时间值（单位秒），默认30秒
smtp_alert <BOOL>
    为所有的 ``smtp_alerts`` 设置状态。
smtp_alert_vrrp <BOOL>
    为所有的 ``vrrp smtp_alerts`` 设置状态
smtp_alert_checker <BOOL>
    为所有的 ``smtp_alerts`` 设置检查状态
no_email_faults
    当触发fault条件时不发送警告邮件
router_id <STRING>
    在路由(vrrp)信息中的字符串，默认是本地主机名。（虚拟路由标识virtual_router_id.这个标识是一个数字，并且同一个vrrp实例使用唯一的标识。
    即同一个vrrp_stance,MASTER和BACKUP的virtual_router_id是一致的，同时在整个vrrp内是唯一的。）
linkbeat_use_polling
    链路失效的时候采取的措施
vrrp_mcast_group4 224.0.0.18
    指定vrrp广播的ipv4组播地址，默认使用 ``224.0.0.18``
vrrp_mcast_group6 ff02::12
    指定vrrp广播的ipv6组播地址，默认使用 ``ff02::12``
default_interface p33p1.3
    指定静态地址的接口，默认 ``eth0``
lvs_sync_daemon <INTERFACE> <VRRP_INSTANCE> [id <SYNC_ID>] [maxlen <LEN>] \
                           [port <PORT>] [ttl <TTL>] [group <IP ADDR>]
    
    参数 ``maxlen, port, ttl and group`` 仅在 ``Linux 4.3`` 及以后的版本才可以使用
        - syncid (0 to 255) for lvs syncd
        - maxlen (1..65507) maximum packet length
        - port (1..65535) UDP port number to use
        - ttl (1..255)
        - group - IPv4/IPv6的组播地址，multicast group address (IPv4 or IPv6)
    
    Sync daemon由IPVS内核代码提供，只支持每次一个守护进程实例来同步连接表。
lvs_flush
    启动时刷新LVS配置中不存在的配置。
vrrp_garp_master_delay 10
    备向MASTER发送ARP探测的时间间隔。0为不发送。默认是5秒。
vrrp_garp_master_repeat 1
    发送探测ARP的后没有回复多少次转换为MASTER，默认是5次。
vrrp_garp_lower_prio_delay 10
    当MASTER接收到了低优先级的探测arp消息后，备需要延迟的时间。
vrrp_garp_lower_prio_repeat 1
    一次arp探测发送的消息数量。如果message过小时如果有丢包则可能会导致裂脑。过大会加大内网带宽消耗且消耗服务器接口带宽。
vrrp_garp_master_refresh 60
    刷新探测ARP的最小时间间隔。默认为0，即不刷新(时间单位是秒)

vrrp_garp_master_refresh_repeat 2
    MASTER发送探测ARP的时候一次发送的消息数量，默认是1
vrrp_garp_interval 0.001
    在MASTER发送探测ARP的时候在网卡的时间间隔，数字是10进制，单位是秒。默认是0
vrrp_gna_interval 0.000001
    在MASTER的网络接口发送主动NA消息的时间间隔。数字是10进制，单位是秒。默认是0

vrrp_lower_prio_no_advert [<BOOL>]
    如果收到低级别的广播，则不发送其他高级别的回复。这是参考RFC文档的设置。默认是false
vrrp_higher_prio_send_advert [<BOOL>]
    在切换为备的时候，如果MASTER收到了高级别的广播就发送回复。这可能导致裂脑。
vrrp_version <2 or 3>
    设置使用的VRRP版本。默认是版本2
vrrp_iptables keepalived
    默认是INPUT。指定的链必须存在iptables和/或ip6tables配置，以及链的配置从iptables配置中的适当位置调用。\
    在接受之后，可能需要进行此过滤任何已建立的相关数据包，因为IPv4可能会选择VIP作为发送连接的源地址。
vrrp_iptables keepalived_in keepalived_out
    用在出站过滤。
vrrp_iptables
    不添加任何iptables规则
vrrp_ipsets [keepalived [keepalived6 [keepalived_if6]]]
    用ipsets来链接iptables
vrrp_check_unicast_src
    当使用单播模式时，允许检测vrrp数据包源地址。
vrrp_skip_check_adv_addr
    默认没有忽略。检测VRRP数据包的的链路延迟。
vrrp_strict
    严格遵守VRRP协议，以下这些会被禁止：
        - 0 VIPs
        - 单播邻居建立
        - vrrp版本2中的IPv6地址
vrrp_priority <-20 to 19>
    当设置检测vrrp进程时，可以设置vrrp子进程的优先级。当vrrp中的master虽然还在运行但是特别忙而无法回复备时，这可以从一个备份的vrrp实例中看到
checker_priority <-20 to 19>
    检测子进程优先级别
bfd_priority <-20 to 19>
    设置BFD子进程优先级别。
vrrp_no_swap
    设置子进程不可交换

checker_no_swap
    设置检测子进程不可交换

bfd_no_swap
    BFD子进程不可交换
vrrp_rt_priority <1..99>
    设置vrrp子进程用实时调度的优先级别
checker_rt_priority <1..99>
    检测子进程用实时调度的优先级别
bfd_rt_priority <1..99>
    设置BFD子进程用时间调度时的优先级别

vrrp_rlimit_rtime >=1

checker_rlimit_rtime >=1

bfd_rlimit_rtime >=1
    设置阻塞系统调用之间的CPU时间限制，时间单位是微秒(1/1000秒)

snmp_socket udp:1.2.3.4:705
    默认unix:/var/agentx/master，遵循RFC支持使用特定socket连接SNMP的主客户端。
    
    参考：源码模块 ``keepalived/vrrp/vrrp_snmp.c``

enable_snmp_vrrp
    允许vrrp元素使用MIB的SNMP句柄
enable_snmp_checker
    允许SNMP句柄的检测元素
enable_snmp_rfc
    允许使用snmp的RFC2787和RFC6527中定义的VRRP MIBs
enable_snmp_rfcv2
    允许使用RFC2787 VRRP MIB中定义的snmp句柄
enable_snmp_rfcv3
    允许使用RFC6527 VRRP MIB中定义的SNMP句柄
enable_traps
    允许使用snmp traps
enable_dbus
    允许使用DBus接口。需要DBus支持
dbus_service_name SERVICE_NAME
    默认值org.keepalived.Vrrp1，指定DBus服务名称。

script_user username [groupname]
    指定脚本的用户和组，如果用户存在则使用指定用户，否则用root。

enable_script_security
    设置这个参数后如果路径是非root用户可写，脚本不能使用root运行。

notify_fifo FIFO_NAME
    设置先进先出的通知名称。
    

notify_fifo_script STRING|QUOTED_STRING [username [groupname]]
    由keepalived运行的脚本，以处理通知事件将FIFO名称作为最后一个参数传递给脚本

vrrp_notify_fifo FIFO_NAME
    FIFO写入vrrp通知事件。写入的字符串将是表单的一行:实例“VI_1”MASTER 100将以一个新行字符结束

vrrp_notify_fifo_script STRING|QUOTED_STRING [username [groupname]]
    由keepalived运行的脚本，以处理vrrp通知事件将FIFO名称作为最后一个参数传递给脚本

lvs_notify_fifo FIFO_NAME
    FIFO写入通知healthchecker事件所写的字符串将是表单的一行。

lvs_notify_fifo_script STRING|QUOTED_STRING [username [groupname]]
    将FIFO名称作为最后一个参数传递给脚本，由keepalived运行脚本，以处理healthchecher通知事件


dynamic_interfaces
    允许配置包含启动时不存在的接口。这允许keepalived使用可能被删除和恢复的接口，也允许在VMAC接口上使用虚拟和静态路由和规则。

vrrp_netlink_cmd_rcv_bufs BYTES

vrrp_netlink_cmd_rcv_bufs_force <BOOL>

vrrp_netlink_monitor_rcv_bufs BYTES

vrrp_netlink_monitor_rcv_bufs_force <BOOL>
    #以下选项只适用于大型配置，其中keepalived可以创建大量的接口，或者系统有大量的接口。这些选项只需要在系统日志中看到“Netlink:接收缓冲区溢出”消息。如果需要的缓冲区大小超过/proc/sys/net/core/rmem_max中的值，则需要设置相应的force选项。这对于存在大量接口的非常大的配置非常有用，而系统上接口的初始读取导致netlink缓冲区溢出。

lvs_netlink_cmd_rcv_bufs BYTES

lvs_netlink_cmd_rcv_bufs_force <BOOL>

lvs_netlink_monitor_rcv_bufs BYTES

lvs_netlink_monitor_rcv_bufs_force <BOOL>
    vrrp网络链接和监控socket命令，监控socket缓存值大小可以单独设置。看参数值 ``/proc/sys/net/core/rmem_max``
vrrp_rx_bufs_policy [MTU|ADVERT|NUMBER]
    默认使用系统的默认值。设置socket接收的缓存值。系统文件 ``/proc/sys/net/core/rmem_default`` 是当前系统的值。

vrrp_rx_bufs_multiplier NUMBER
    默认是3

rs_init_notifies
    real server启动时发送通知。

no_checker_emails
    当real server检测状态改变时不发送邮件。只有当real server添加和删除时发送邮件。










静态路由设置
......................................................................................................................................................

静态路由设置可以包括两个部分：
    - 静态追踪组
    - 静态地址/地址组规则

**静态追踪组**

静态跟踪组用于允许vrrp实例跟踪静态
处理路由和规则。如果地址/路由/规则被删除而且一个静态地址/路由/规则指定了一个
跟踪组，那么vrrp实例将转换为故障状态无法恢复。

语法格式：

.. code-block:: bash
    :linenos:

    track_group GROUP1 {
        group {
            VI_1
            VI_2
        }
    }

**静态地址/地址组规则**

配置格式：


.. code-block:: bash
    :linenos:

    static_ipaddress {
        <IPADDR>[/<MASK>] [brd <IPADDR>] [dev <STRING>] [scope <SCOPE>]
                            [label <LABEL>] [peer <IPADDR>] [home]
                            [-nodad] [mngtmpaddr] [noprefixroute]
                            [autojoin] [track_group GROUP]
        192.168.1.1/24 dev eth0 scope global
        ...
    }

    static_routes {
        192.168.2.0/24 via 192.168.1.100 dev eth0 track_group GROUP1

        192.168.100.0/24 table 6909 nexthop via 192.168.101.1 dev wlan0
                        onlink weight 1 nexthop via 192.168.101.2
                        dev wlan0 onlink weight 2

        192.168.200.0/24 dev p33p1.2 table 6909 tos 0x04 protocol bird
                        scope link priority 12 mtu 1000 hoplimit 100
                        advmss 101 rtt 102 rttvar 103 reordering 104
                        window 105 cwnd 106 ssthresh lock 107 realms
                        PQA/0x14 rto_min 108 initcwnd 109 initrwnd 110
                        features ecn

        2001:470:69e9:1:2::4 dev p33p1.2 table 6909 tos 0x04 protocol
                            bird scope link priority 12 mtu 1000
                            hoplimit 100 advmss 101 rtt 102 rttvar 103
                            reordering 104 window 105 cwnd 106 ssthresh
                            lock 107 rto_min 108 initcwnd 109
                            initrwnd 110 features ecn fastopen_no_cookie 1
        ...
    }

    static_rules {
        from 192.168.2.0/24 table 1 track_group GROUP1

        to 192.168.2.0/24 table 1

        from 192.168.28.0/24 to 192.168.29.0/26 table small iif p33p1
                            oif wlan0 tos 22 fwmark 24/12
                            preference 39 realms 30/20 goto 40

        to 1:2:3:4:5:6:7:0/112 from 7:6:5:4:3:2::/96 table 6908
                                uidrange 10000-19999

        to 1:2:3:4:6:6:7:0/112 from 8:6:5:4:3:2::/96 l3mdev protocol 12
                                ip_proto UDP sport 10-20 dport 20-30
        ...
    }

样例配置：

.. code-block:: bash
    :linenos:

    static_routes {	
        src  10.10.10.10  to 192.168.1.0/24 via 192.168.1.1 dev eth0 scope 
        src  20.20.20.20  to 192.168.2.0/24 gw 192.168.2.1 dev eth1 scope
        src  30.30.30.30  to 192.168.3.0/24 via eth3
        40.40.40.40 dev eth4
        50.50.50.50 via 192.168.5.1/24
    }

.. code-block:: bash
    :linenos:

    static_ipaddress {	
        10.10.10.10/24 brd 10.10.10.255 dev eth1 scope global

        20.20.20.20/24 brd 20.20.20.255 dev eth2 scope global
    }

BFD配置详解(BFD configurations)
------------------------------------------------------------------------------------------------------------------------------------------------------

遵循RFC5880，通过了OpenBFDD测试(https://github.com/dyninc/OpenBFDD)


BFD配置语法格式：

.. code-block:: bash
    :linenos:

    bfd_instance <STRING> {
        # BFD Neighbor IP (synonym neighbour_ip)
        neighbor_ip <IP ADDRESS>

        # Source IP to use (optional)
        source_ip <IP ADDRESS>

        # Required min RX interval, in ms
        # (default is 10 ms)
        mix_rx <INTEGER>

        # Desired min TX interval, in ms
        # (default is 10 ms)
        min_tx <INTEGER>

        # Desired idle TX interval, in ms
        # (default is 1000 ms)
        idle_tx <INTEGER>

        # Number of missed packets after
        # which the session is declared down
        # (default is 5)
        multiplier <INTEGER>

        # Operate in passive mode (default is active)
        passive

        # outgoing IPv4 ttl to use (default 255)
        ttl <INTEGER>

        # outgoing IPv6 hoplimit to use (default 64)
        hoplimit <INTEGER>

        # maximum reduction of ttl/hoplimit
        #  in received packet (default 0)
        #  (255 disables hop count checking)
        max_hops <INTEGER>

        # Default tracking weight
        weight
    }

vrrp配置详解(VRRP configurations)
------------------------------------------------------------------------------------------------------------------------------------------------------

vrrp配置部分包括以下三个部分：
    - VRRP scripts，vrrp脚本
    - VRRP track files，vrrp文件追踪
    - VRRP synchronization group，vrrp同步组
    - VRRP instance，vrrp实例


**vrrp脚本**

vrrp_script <SCRIPT_NAME> {}
    声明vrrp脚本定义的整体，所有的配置项都可以在 ``{}`` 中
script <STRING>|<QUOTED-STRING>
    脚本的路径
interval <INTEGER>
    脚本调用的时间间隔，默认1秒
timeout <INTEGER>
    运行时间，运行指定时间后如果还在运行则认为运行失败
weight <INTEGER:-253..253>
    优先级别，默认时0
rise <INTEGER>
    状态转换位OK需要的确认次数。
fall <INTEGER>
    状态转换为结束需要的次数。
user USERNAME [GROUPNAME]
    运行脚本使用的用户和组
init_fail
    假设脚本的初始状态为运行失败。


**vrrp文件追踪**

vrrp_track_file <STRING> {}
    声明vrrp脚本追踪
file <QUOTED_STRING>
    文件追踪的权重
weight <-254..254>
    设置权重值
init_file [VALUE] [overwrite]
    文件重载写入

**vrrp同步组**


**vrrp实例**

vrrp_instance <STRING> {}
    声明vrrp实例
state MASTER
    所处的状态，可以是MASTER/SLAVE
interface eth0
    绑定vrrp的接口
use_vmac [<VMAC_INTERFACE>]
    用在vrrp的IP的虚拟mac
vmac_xmit_base
    从vrrp消息中接收的信息的mac
native_ipv6
    强制使用IPv6
dont_track_primary
    无论vrrp接口是否故障，都一直使用。
track_interface {}
    监控的网络接口，例如：
        - eth0
        - eth1
        - eth2 weight <-253..253>
track_script {}
    监听脚本
track_file {}
    监听的文件
track_bfd {}
    监听的bfd实例消息

mcast_src_ip <IPADDR>

unicast_src_ip <IPADDR>
    绑定vrrpd的默认IP是主IP
track_src_ip
    监听的源IP
version <2 or 3>
    设置vrrp版本

unicast_peer {}
    指定单播邻居的地址，不用组播

old_unicast_checksum [never]
    当vrrp3版本在1.3.6设置老版本的校验

garp_master_delay 10

garp_master_repeat 1

garp_lower_prio_delay 10

garp_lower_prio_repeat 1

garp_master_refresh 60

garp_master_refresh_repeat 2

garp_interval 100

gna_interval 100
    接口特定设置，与全局参数相同。

lower_prio_no_advert [<BOOL>]
    如果收到低级别的通知，会被忽略。

higher_prio_send_advert [<BOOL>]
    如果高级别

virtual_router_id 51
    用来做组播中的唯一标识。

priority 100
    设置优先级，MASTER比SLAVE最好高50或者更多。

advert_int 1
    VRRP广播通知的时间(单位是秒)

authentication {}
    设置认证

virtual_ipaddress {}
    添加的IP，可以在"site"|"link"|"host"|"nowhere"|"global"这些部分设置。

virtual_ipaddress_excluded {}
    vrrp地址中去除的IP地址

prompte_secondaries
    在接口用来设置promote_secondaries标记。

virtual_routes {}
    设置虚拟路由

virtual_rules {}
    设置虚拟规则

accept
    vrrp3可以设置接收模式，允许接收不是目的地址的数据包。
no_accept
    drop所有不是接收地址的数据包
nopreempt
    “nopreempt”允许低优先级的机器在线，即使有更高优先级的机器返回正常在线。
preempt
    转向备份
skip_check_adv_addr [on|off|true|false|yes|no]
    参考设置全局，默认使用vrrp_skip_check_adv_addr这个值。
strict_mode [on|off|true|false|yes|no]
    参考全局vrrp_strict，
preempt_delay 300    # waits 5 minutes
    转向备份的时间间隔
debug <LEVEL>
    调试级别，0-4

notify_master <STRING>|<QUOTED-STRING> [username [groupname]]

notify_backup <STRING>|<QUOTED-STRING> [username [groupname]]

notify_fault <STRING>|<QUOTED-STRING> [username [groupname]]
    通知脚本

notify_stop <STRING>|<QUOTED-STRING> [username [groupname]]

notify <STRING>|<QUOTED-STRING> [username [groupname]]
    当vrrp停止时执行
notify_master_rx_lower_pri <STRING>|<QUOTED-STRING> [username [groupname]]
    如果是MASTER，notify_master_rx_lower_pri脚本执行。
smtp_alert <BOOL>
    设置是否允许发送SMTP警告
kernel_rx_buf_size
    设置socket接收buffer大小，参考vrrp_rx_bufs_policy




lvs配置详解(LVS configurations)
------------------------------------------------------------------------------------------------------------------------------------------------------

lvs配置部分包括：
    - 虚拟主机组
    - 虚拟主机

**虚拟主机**

virtual_server_group <STRING> {}
    定义虚拟主机组的标识
<IPADDR> <PORT>
    主机IP和端口
<IPADDR RANGE> <PORT>
    VIP和VIP提供服务的端口
fwmark <INTEGER>
    防火墙标记

**虚拟主机组**



delay_loop <INTEGER>
    检测轮询的时间间隔

lvs_sched rr|wrr|lc|wlc|lblc|sh|mh|dh|fo|ovf|lblcr|sed|nq
    lvs的模式，可以是以下任意一种算法：
        rr|wrr|lc|wlc|lblc|sh|mh|dh|fo|ovf|lblcr|sed|nq
hashed
    允许散列

flag-x
    允许设置ipvsadm中的标记，x取值1-3
sh-port
    sh方式的sh端口，在ipvsadm中的(-b sh-port

sh-fallback
    等价与ipvsadm中参数-b sh-fallback

mh-port
    等价与ipvsadm中参数-b mh-port

mh-fallback
    等价与ipvsadm中参数-b mh-fallback

ops
    等价与ipvsadm中参数-O

lvs_method NAT|DR|TUN
    定义LVS转发方式，可以选择以下方式中一个：
        NAT|DR|TUN

persistence_engine <STRING>
    lvs持续化名字

persistence_timeout [<INTEGER>]
    lvs固化的超时时间，默认6分钟

persistence_granularity <NETMASK>
    等价与ipvsadm中参数-M

protocol TCP|UDP|SCTP
    选择4层协议


ha_suspend
    如果没有设置VIP，则健康检查推迟激活

smtp_alert <BOOL>
    邮件告警，全局设置则全局生效。

virtualhost <STRING>
    定义HTTP_GET或者SSL_GET的虚拟主机字符串。一般是域名

alpha
    在守护进程启动时，假设所有RSs关闭且healthcheck失败。这有助于防止启动时出现误报。α模式默认禁用。

omega
    Omega模式默认是禁用的。

quorum <INTEGER>
    默认值1，地址池中达到这个最小值以后就不再检查服务质量。

hysteresis <INTEGER>
    默认值0

quorum_up <STRING>|<QUOTED-STRING> [username [groupname]]
    当quorum增加的时候这个脚本会被执行

quorum_down <STRING>|<QUOTED-STRING> [username [groupname]]
    当quorum减少消失的时候这个脚本被执行

ip_family inet|inet6
    防火墙标记设置的IP地址组



sorry_server <IPADDR> <PORT>

sorry_server_inhibit
    对sorry_server应用inhibitor _on_failure行为

sorry_server_lvs_method NAT|DR|TUN
    sorry 服务器转发模式

retry <INTEGER>
    失败后重试的次数

delay_before_retry <INTEGER>
    重试的时间间隔

warmup <INTEGER>
    轮询时间过后到不可用的时间间隔

delay_loop <INTEGER>
    检测轮询的时间间隔

inhibit_on_failure
    当健康检查失败是设置权重为0
real_server <IPADDR> <PORT> {}
    lvs中的提供真实服务的rip对应的服务器IP以及对应的配置

    weight <INTEGER>
        相对权重

    lvs_method NAT|DR|TUN
        lvs转发方式

    notify_up <STRING>|<QUOTED-STRING> [username [groupname]]
        当健康检查认为服务正常运行时这个脚本会被执行

    notify_down <STRING>|<QUOTED-STRING> [username [groupname]]
        健康检查任务服务运行失败时这个脚本会被执行

    uthreshold <INTEGER>
        服务连接的最大值

    lthreshold <INTEGER>
        服务连接的最小值

    smtp_alert <BOOL>
        邮件告警

    virtualhost <STRING>
        虚拟主机名称，用来定义HTTP_GET或SSL_GET使用

    alpha <BOOL>                    # see above
    
    retry <INTEGER>                 # see above
    
    delay_before_retry <INTEGER>    # see above
    
    warmup <INTEGER>                # see above
    
    delay_loop <INTEGER>            # see above
    
    inhibit_on_failure <BOOL>       # see above

    CHECKER_TYPE {}
        定义检查的服务

        connect_ip <IPADDR>
            检测连接的IP，默认这应该是RIP

        connect_port <PORT>
            连接的RIP的端口

        bindto <IPADDR>
            使用本地的发送连接的IP

        bind_if <IFNAME>
            使用的本地接口

        bind_port <PORT>
            使用的本地端口

        connect_timeout <INTEGER>
            连接超时时间，默认是5秒

        fwmark <INTEGER>
            防火墙标记
        
        alpha <BOOL>                    # see above
        
        retry <INTEGER>                 # see above
        
        delay_before_retry <INTEGER>    # see above
        
        warmup <INTEGER>                # see above
        
        delay_loop <INTEGER>            # see above
        
        inhibit_on_failure <BOOL>       # see above


    HTTP_GET|SSL_GET {}
        用来健康检查的类型

        url {}
            测试的url地址，可以是多个url

            path <STRING>
                路径，例如/

            digest <STRING>
                健康检查需要的状态码，例如：9b3a0c85a887a256d6939da88aabd8cd

            status_code <INTEGER>
                状态码，例如：200

            virtualhost <STRING>
                虚拟主机

            regex <STRING>
                正则表达式

            regex_no_match
                对正则表达式取反

            regex_options OPTIONS 
                支持的选项有：
                    - allow_empty_class alt_bsux
                    - match_unset_backref
                    - never_ucp
                    - never_utf
                    - no_auto_capture
                    - no_auto_possess
                    - no_dotstar_anchor
                    - no_start_optimize
                    - never_backslash_c
                    - alt_circumflex
                    - alt_verbnames
                    - use_offset_limit

            regex_stack <START> <MAX>
                这允许启动和最大值要指定的字节大小

            regex_min_offset <OFFSET>
                最小偏移

            regex_max_offset <OFFSET>
                最大偏移


    SSL_GET {}
        ssl连接
        
        enable_sni
            启用ssl的时候向服务器发送ssl握手的标识

    TCP_CHECK {}
        启用tcp健康检查

    SMTP_CHECK {}
        启用smtp健康检查

       helo_name <STRING>|<QUOTED-STRING>

    DNS_CHECK {}
        启用dns健康检查

        type <STRING>
            dns检测的dns条目类型，默认是SOA记录:
                A|NS|CNAME|SOA|MX|TXT|AAAA

        name <STRING>
            用来检查的dns域名，默认是.

    MISC_CHECK {}
        MISC健康检查

        misc_path <STRING>|<QUOTED-STRING>
            执行的脚本程序

        misc_timeout <INTEGER>
            执行脚本的超时时间

        misc_dynamic
            设置后健康检查会使用脚本的结束返回code。
                0：成功
                1：失败
                2-255：成功，权重为code值-2，例如code是255，则权重为253

        user USERNAME [GROUPNAME]
            脚本使用的用户/组
    BFD_CHECK {}
        bfd健康检查
        
        name <STRING>
            bfd检测的名称

SSL {}
    使用SSL_GET check时需要设置的ssl相关配置

password <STRING>
    密码

ca <STRING>
    ca证书文件

certificate <STRING>
    cer文件

key <STRING>
    key文件



