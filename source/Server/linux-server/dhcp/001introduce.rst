.. _dhcp-introduce:

======================================================================================================================================================
DHCP介绍
======================================================================================================================================================

:Date: 2018-08

.. contents::

.. _dhcp-abstract:

DHCP简述
======================================================================================================================================================


参考:
    - `DHCP百度百科 <https://baike.baidu.com/item/DHCP/218195?fromtitle=%EF%BC%A4%EF%BC%A8%EF%BC%A3%EF%BC%B0&fromid=11165431&fr=aladdin>`_
    - `DHCP维基百科 <https://zh.wikipedia.org/wiki/%E5%8A%A8%E6%80%81%E4%B8%BB%E6%9C%BA%E8%AE%BE%E7%BD%AE%E5%8D%8F%E8%AE%AE>`_
    - dhcp官方资料：https://www.isc.org/downloads/dhcp/
    - dhcp软件下载：http://ftp.isc.org/isc/dhcp/
DHCP:
    动态主机设置协议（英语：Dynamic Host Configuration Protocol，DHCP）是一个局域网的网络协议，使用UDP协议工作。

DHCP主要用途有两个：
    - 用于内部网络或网络服务供应商自动分配IP地址给用户
    - 用于内部网络管理员作为对所有计算机作中央管理的手段
DHCP发展历史:
    DHCP于1993年10月成为标准协议，其前身是 ``BOOTP`` 协议。

DHCP详细描述:
    - DHCP在文档 `RFC 2131`_ 中有详细描述。
    - IPv6的建议标准（DHCPv6）可以在 `RFC 3315`_ 中找到。

.. _`RFC 3315`: https://www.rfc-editor.org/rfc/rfc3315.txt
.. _`RFC 2131`: https://www.rfc-editor.org/rfc/rfc2131.txt

DHCP服务端口:
    - 服务器端使用 ``67/udp``
    - 客户端使用 ``68/udp``
    - 546号端口用于DHCPv6 Client，而不用于DHCPv4，是为DHCP failover服务，这是需要特别开启的服务，DHCP failover是用来做“双机热备”的。

DHCP服务模式:
    DHCP是CS模式，即客户端服务器端模式。此外

.. _dhcp-theory:

DHCP原理
======================================================================================================================================================

DHCP报文
------------------------------------------------------------------------------------------------------------------------------------------------------

1. DHCP一共定义了8中数据报文:

:DHCP DISCOVER: 客户端开始DHCP过程发送的包，是DHCP协议的开始
:DHCP OFFER:    服务器接收到DHCP DISCOVER之后做出的响应，它包括了给予客户端的IP（yiaddr）、客户端的MAC地址、租约过期时间、服务器的识别符以及其他信息
:DHCP REQUEST:  客户端对于服务器发出的DHCP OFFER所做出的响应。在续约租期的时候同样会使用。
:DHCP ACK:      服务器在接收到客户端发来的DHCP REQUEST之后发出的成功确认的报文。在建立连接的时候，客户端在接收到这个报文之后才会确认分配给它的IP和其他信息可以被允许使用。
:DHCP NAK:      DHCP ACK的相反的报文，表示服务器拒绝了客户端的请求。
:DHCP RELEASE:  一般出现在客户端关机、下线等状况。这个报文将会使DHCP服务器释放发出此报文的客户端的IP地址
:DHCP INFORM:   客户端发出的向服务器请求一些信息的报文
:DHCP DECLINE:  当客户端发现服务器分配的IP地址无法使用（如IP地址冲突时），将发出此报文，通知服务器禁止

2. DHCP报文交互过程如图:

.. image:: /Server/res/images/server/linux/dhcp/dhcp-exchange.png
    :align: center
    :height: 350 px
    :width: 800 px


3. DHCP数据包分析:

.. attention:: IPv4如果用 ``Wireshark`` 抓包，在过滤规则需要设置 ``bootp`` ,如果是IPv6，则设置过滤规则 ``dhcpv6``

windows系统用 ``wireshark`` 抓包分析时，可以通过释放IP重新获取的方式来抓到这些dhcp数据包。

具体过程如下:
    1. 在cmd中输入 ``ipconfig /release`` 断开网络连接,
    #. 在cmd中输入 ``ipconfig /renew`` 会重新获取IP地址。这个过程如果wireshark一直起开，则会抓到这些数据包。

样例：

.. image:: /Server/res/images/server/linux/dhcp/dhcp-data01.png
    :align: center
    :height: 400 px
    :width: 800 px

DHCP Discover数据包:
    1. Client端使用IP地址0.0.0.0发送了一个广播包，可以看到此时的目的IP为255.255.255.255。Client想通过这个数据包发现可以给它提供服务的DHCP服务器。
    2. 从下图可以看出，DHCP属于应用层协议，它在传输层使用UDP协议，目的端口是67。 

参考下面DHCP Discover抓包数据:

.. image:: /Server/res/images/server/linux/dhcp/dhcp-data02.png
    :align: center
    :height: 400 px
    :width: 800 px

DHCP Offer包:
    当DHCP服务器收到一条DHCP Discover数据包时，用一个DHCP Offerr包给予客户端响应。
    
    1. DHCP服务器仍然使用广播地址作为目的地址，因为此时请求分配IP的Client并没有自己ip,而可能有多个Client在使用0.0.0.0这个IP作为源IP向DHCP服务器发出IP分配请求，DHCP也不能使用0.0.0.0这个IP作为目的IP地址，于是依然采用广播的方式，告诉正在请求的Client们，这是一台可以使用的DHCP服务器。
    2. DHCP服务器提供了一个可用的IP,在数据包的Your (client) IP Address字段可以看到DHCP服务器提供的可用IP。
    3. 除此之外，如图中红色矩形框的内容所示，服务器还发送了子网掩码，路由器，DNS，域名，IP地址租用期等信息。

.. image:: /Server/res/images/server/linux/dhcp/dhcp-data03.png
    :align: center
    :height: 400 px
    :width: 800 px

具体信息参考:

.. image:: /Server/res/images/server/linux/dhcp/dhcp-data03-1.png
    :align: center
    :height: 400 px
    :width: 800 px

DHCP Request包:
    当Client收到了DHCP Offer包以后（如果有多个可用的DHCP服务器，那么可能会收到多个DHCP Offer包），确认有可以和它交互的DHCP服务器存在，于是Client发送Request数据包，请求分配IP。 
    此时的源IP和目的IP依然是0.0.0.0和255.255.255.255。

.. image:: /Server/res/images/server/linux/dhcp/dhcp-data04.png
    :align: center
    :height: 400 px
    :width: 800 px


DHCP ACK包:
    服务器用DHCP ACK包对DHCP请求进行响应。

在数据包中包含以下信息，表示将这些资源信息分配给Client。
    :Your(client) IP address:   分配给Client的可用IP。

后面有许多项option信息，前两项是DHCP服务器发送的消息类型（ACK）和服务器的身份标识，后面几项是：
    :Subnet Mask:               Client端分配到的IP的子网掩码； 
    :Router:                    路由器 
    :Domain Name Server:        DNS,域名服务器 
    :Domain Name:               域名 
    :IP Address Lease Time:     IP租用期。

.. image:: /Server/res/images/server/linux/dhcp/dhcp-data05.png
    :align: center
    :height: 350 px
    :width: 800 px



.. _dhcp-security:

DHCP安全
======================================================================================================================================================


常见的DHCP攻击有:
    1. DHCP饥饿攻击


1. DHCP饥饿攻击
    原理就是不法分子，伪造合法的MAC地址，不断地向DHCP服务器发出DHCP Request包，
    最后耗尽服务器的可用IP,于是原有的这台DHCP服务器便不能够给客户端分配IP了，
    此时不法分子再伪造一台DHCP服务器，给客户端分配IP,将客户端的默认网关和DNS都设置成自己的机器，
    于是便可以对客户端进行中间人攻击。

