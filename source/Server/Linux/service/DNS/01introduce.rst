.. _zzjlogin-dns-introduce:

=============================================
DNS介绍
=============================================

:Date:

.. contents::

.. _zzjlogin-dns-abstract:

DNS简述
=============================================


参考:
    - `DNS百度百科 <https://baike.baidu.com/item/DNS/427444>`_
    - `DNS维基百科 <https://zh.wikipedia.org/wiki/%E5%9F%9F%E5%90%8D%E7%B3%BB%E7%BB%9F>`_

.. tip::
    基于504个全球范围的“根域名服务器”（分成13组，分别编号为A至M）

DNS:
    DNS（Domain Name System，域名系统），万维网上作为域名和IP地址相互映射的一个分布式数据库，
    能够使用户更方便的访问互联网，而不用去记住能够被机器直接读取的IP数串。

.. attention::
    DNS和DNS服务器以及DNS服务软件是不同的概念。DNS是指协议标准。DNS服务器是提供DNS这种服务的服务器(硬件和软件的综合体)。
    DNS软件是根据DNS协议开发的能够运行在硬件系统上并提供DNS服务的软件，这其中以bind为代表。

DNS主要用途：
    - 能够使用户更方便的访问互联网，而不用去记住能够被机器直接读取的IP数串。
DNS发展历史:
    DNS最早于1983年由保罗·莫卡派乔斯（Paul Mockapetris）发明；
    原始的技术规范在882号因特网标准草案（RFC 882）中发布。
    1987年发布的第1034和1035号草案修正了DNS技术规范，并废除了之前的第882和883号草案。
    在此之后对因特网标准草案的修改基本上没有涉及到DNS技术规范部分的改动。

.. hint::
    早期的域名必须以英文句号“.”结尾。如今DNS服务器已经可以自动补上结尾的句号。

DNS详细描述:
    - 原始的技术规范: `RFC 882`_ 。
    - 1987年发布的 `RFC 1034`_ 和 `RFC 1035`_ 号草案修正了DNS技术规范。

.. _`RFC 882`: https://www.rfc-editor.org/rfc/rfc882.txt
.. _`RFC 1034`: https://www.rfc-editor.org/rfc/rfc1034.txt
.. _`RFC 1035`: https://www.rfc-editor.org/rfc/rfc1035.txt

DNS服务端口:
    - DNS使用 ``TCP和UDP`` 端口 ``53``,**这是服务端口**。
        - tcp 53: 用于区域传输
        - ucp 53: 用于查询

DHCP服务模式:
    DHCP工作在应用层，是c/s结构

.. _zzjlogin-dns-theory:

DNS原理
=============================================

DNS记录类型
---------------------------------------------

DNS系统中，常见的资源记录类型有：
    - 主机记录（A记录）: `RFC 1035`_ 定义，A记录是用于名称解析的重要记录，它将特定的主机名映射到对应主机的IP地址上。
    - 别名记录（CNAME记录）: `RFC 1035`_ 定义，CNAME记录用于将某个别名指向到某个A记录上，这样就不需要再为某个新名字另外创建一条新的A记录。
    - IPv6主机记录（AAAA记录）: `RFC 3596`_ 定义，与A记录对应，用于将特定的主机名映射到一个主机的IPv6地址。
    - 服务位置记录（SRV记录）: `RFC 2782`_ 定义，用于定义提供特定服务的服务器的位置，如主机（hostname），端口（port number）等。
    - NAPTR记录: `RFC 3403`_ 定义，它提供了正则表达式方式去映射一个域名。NAPTR记录非常著名的一个应用是用于ENUM查询。

以上记录类型可以简写成:
    - A:            ipv4
    - AAAA:         ipv6
    - PTR:          ip->fqdn
    - SOA:          起始授权记录
    - NS:           域名
    - CNAME:        别名
    - MX:           邮件

.. note::
    DNS所有记录累心可以参考:https://zh.wikipedia.org/wiki/%E5%9F%9F%E5%90%8D%E7%B3%BB%E7%BB%9F

.. _`RFC 3403`: https://www.rfc-editor.org/rfc/rfc3403.txt
.. _`RFC 2782`: https://www.rfc-editor.org/rfc/rfc2782.txt
.. _`RFC 3596`: https://www.rfc-editor.org/rfc/rfc3596.txt

DNS软件
----------------------------------------------

- BIND（Berkeley Internet Name Domain），使用最广的DNS软件
- DJBDNS（Dan J Bernstein's DNS implementation）
- MaraDNS
- Name Server Daemon（Name Server Daemon）
- PowerDNS
- Dnsmasq


.. _zzjlogin-dns-security:

DNS安全
=============================================


常见的dns攻击有:
    1. DDOS攻击造成域名解析瘫痪。
    #. 域名劫持：修改注册信息、劫持解析结果。
    #. 系统上运行的DNS服务存在漏洞，导致被黑客获取权限，从而篡改DNS信息。
    #. DNS设置不当，导致泄漏一些敏感信息。提供给黑客进一步攻击提供有力信息。




