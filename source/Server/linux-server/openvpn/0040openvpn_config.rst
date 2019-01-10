.. _openvpn-config:

======================================================================================================================================================
OpenVPN配置文件详解
======================================================================================================================================================


OpenVPN常用配置样例详解
======================================================================================================================================================


配置文件中参数官方详解：
    https://openvpn.net/community-resources/reference-manual-for-openvpn-2-0/

一般配置注解
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: bash
    :linenos:

    local 192.168.1.140
    port 52115
    proto udp
    dev tun
    ca /etc/openvpn/keys/ca.crt
    cert /etc/openvpn/keys/server.crt
    key /etc/openvpn/keys/server.key  # This file should be kept secret
    dh /etc/openvpn/keys/dh1024.pem
    server 10.8.0.0 255.255.255.0
    push "192.168.19.0 255.255.255.0"
    ifconfig-pool-persist ipp.txt
    keepalive 10 120
    comp-lzo
    persist-key
    persist-tun
    verb 3
    client-to-client
    duplicate-cn
    status openvpn-status.log
    log /var/log/openvpn.log

client-to-client
    如果允许openvpn客户端之间通信需要配置这个选项，如果不允许openvpn客户端之间互相通信可以注释掉这个配置选项。
duplicate-cn
    允许一个openvpn客户端账号同时多个系统/电脑登陆。类似于一个qq账号同时手机和电脑登陆。只不过这个功能更厉害，是多个电脑同时登陆。
    如果想一个客户端只允许同时在线一个客户端，可以注释掉这个配置
max-clients 100
    定义最大客户端并发连接数量
keepalive 10 120
    openvpn server 10秒尝试连接一次客户端，检查客户端是否存活。如果OpenVPN server连续120秒没有收到客户端回复则认为客户端掉线。
status openvpn-status.log
    openvpn的客户端链接情况记录日志。会在指定的文件中报错openvpn在线的客户端的账号名以及分配的IP地址信息。
    ``openvpn-status.log`` 这个文件名可以任意指定。默认用相对路径。即这个状态日志和这个配置文件在同一目录。可以用绝对路径指定
ifconfig-pool-persist ipp.txt
    - openvpn客户端登陆的账号和分配的IP记录在这个文件中。这样客户端再次登陆时可以使用相同的IP地址。
    - ipp.txt文件默认10分钟回写一次，如果想要两秒回写，那么在后面加个2：ifconfig-pool-persist ipp.txt 2
    - ipp.txt记录格式：CN用户名,子网网络地址。这个子网网络地址一般都是30位地址。例如：10.8.0.4，这个网络地址的第一个IP是10.8.0.5，这是这个子网段的dhcp，然后下一个才是客户端的IP，也就是10.8.0.6。
comp-lzo
    数据传输之前使用lzo压缩数据，这样节约链路带宽，但是会加大服务器的CPU开销。
persist-key
    通过keepalive检测超时后，重新启动VPN，不重新读取keys，保留第一次使用的keys。
persist-tun
    通过keepalive检测超时后，重新启动VPN，一直保持tun或者tap设备是linkup的。否则网络连接，会先linkdown然后再linkup。
proto udp
    openvpn客户端和服务器数据传输使用udp协议。使用什么协议根据具体应用结合分析。一般语音会使用udp，如果使用tcp会因为
    丢包重传而出现杂音现象。在多机房数据备份时建议使用tcp协议，不建议使用udp，因为udp协议没有重传机制。
local 192.168.1.140
    openvpn服务器的公网地址。这个地址是客户端配置文件的的openvpn server的地址。
port 52115
    openvpn客户端连接openvpn server时的openvpn server的服务端口。类似ssh的22端口。默认是：1194，建议修改成10000以上的自定义端口。
dev tun
    定义openvpn运行时使用哪一种模式，openvpn有两种运行模式一种是tap模式，一种是tun模式。
    tap模式也就是桥接模式，通过软件在系统中模拟出一个tap设备，该设备是一个二层设备，同时支持链路层协议。
    tun模式也就是路由模式，通过软件在系统中模拟出一个tun路由，tun是ip层的点对点协议。
    一般网络电话等语音通信因为运营商屏蔽而使用openvpn时会使用tap，如果日常使用基本区别不大。
verb 3
    日志冗余级别。

ca /etc/openvpn/keys/ca.crt

cert /etc/openvpn/keys/server.crt

key /etc/openvpn/keys/server.key  # This file should be kept secret

dh /etc/openvpn/keys/dh1024.pem
    ca定义ca证书文件路径,cert定义服务器证书路径，key定义服务器端key文件，dh定义哈夫曼散列值文件。这些文件可以用相对路径或绝对路径定义。
server 10.8.0.0 255.255.255.0
    定义openvpn链接后客户端和服务器通信使用的局域网IP的地址池范围。可以自定义。
push "192.168.19.0 255.255.255.0"
    把 ``192.168.19.0/24`` 推送到客户端。客户端就会把目的地址是 ``192.168.19.0/24`` 这个子网地址的数据包发往openvpn server。
push "route 192.168.10.0 255.255.255.0"
    向客户端推送的路由信息，假如客户端的IP地址为10.8.0.2，要访问192.168.10.0网段的话，使用这条命令就可以了。

tls-auth /etc/openvpn/keys/ta.key 0
    开启TLS，使用ta.key防御攻击。服务器端的第二个参数值为0，客户端的为1。










user nobody

group nogroup
    定义openvpn运行时使用的用户及用户组

log-append openvpn.log
    记录日志，每次重新启动openvpn后追加原有的log信息。

mute 20
    重复日志记录限额







OpenVPN客户端配置详解
======================================================================================================================================================

client
    定义这是一个client，配置从server端pull拉取过来，如IP地址，路由信息之类，Server使用push指令推送过来。
dev tun
    定义openvpn运行的模式，这个地方需要严格和Server端保持一致。
proto tcp
    定义openvpn使用的协议，这个地方需要严格和Server端保持一致。
remote 192.168.1.8 1194
    设置Server的IP地址和端口，这个地方需要严格和Server端保持一致。
    如果有多台机器做负载均衡，可以多次出现remote关键字。可以使用域名
remote-random
    随机选择一个Server连接，否则按照顺序从上到下依次连接。该选项默认不启用。
resolv-retry infinite
    始终重新解析Server的IP地址（如果remote后面跟的是域名），保证Server IP地址是动态的使用DDNS动态更新DNS后，Client在自动重新连接时重新解析Server的IP地址。这样无需人为重新启动，即可重新接入VPN。
nobind
    定义在本机不邦定任何端口监听incoming数据。

persist-key

persist-tun

ca ca.crt
    定义CA证书的文件名，用于验证Server CA证书合法性，该文件一定要与服务器端ca.crt是同一个文件。
cert laptop.crt
    定义客户端的证书文件。
key laptop.key
    定义客户端的密钥文件。
ns-cert-type server
    Server使用build-key-server脚本生成的，在x509 v3扩展中加入了ns-cert-type选项。防止client使用他们的keys ＋ DNS hack欺骗vpn client连接他们假冒的VPN Server，因为他们的CA里没有这个扩展。
comp-lzo
    启用允许数据压缩，这个地方需要严格和Server端保持一致。
verb 3
    设置日志记录冗长级别。




OpenVPN配置详解
======================================================================================================================================================




