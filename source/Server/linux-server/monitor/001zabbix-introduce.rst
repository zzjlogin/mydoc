.. _zzjlogin-zabbix-introduce:

========================================
zabbix
========================================


zabbix简介
========================================

参考:
    `zabbix百度百科 <https://baike.baidu.com/item/Zabbix>`_
    `zabbix维基百科 <https://zh.wikipedia.org/wiki/Zabbix>`_
    `zabbix官网 <https://www.zabbix.com/>`_

zabbix是一个基于WEB界面的提供分布式系统监视以及网络监视功能的企业级的开源解决方案。Zabbix的授权是属于GPLv2。

zabbix服务模式:
    是cs架构，需要专门安装客户端，从而让服务器监控到客户端。

Zabbix使用MySQL、PostgreSQL、SQLite、Oracle或IBMDB2储存资料。Server端基于C语言、Web前端则是基于PHP所制作的。Zabbix可以使用多种方式监视。
可以只使用Simple Check不需要安装Client端，亦可基于SMTP或HTTP等各种协定做死活监视。
在客户端如UNIX、Windows中安装Zabbix Agent之后，可监视CPU负荷、网络使用状况、硬盘容量等各种状态。
而就算没有安装Agent在监视对象中，Zabbix也可以经由SNMP、TCP、ICMP检查，以及利用IPMI、SSH、telnet对目标进行监视。


zabbix安装参考:
    https://www.zabbix.com/download

链接参考:
    - http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/
    - http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/
    - https://sourceforge.net/projects/zabbix/files/



zabbix工作模式：
    zabbix属于C/S架构，需要服务器端和客户端。被监控主机可以安装zabbix-agent或者使用标准snmp协议用于监控。
    zabbix也可以用icmp监控主机在线状态。
zabbix服务端口：
    zabbix server服务端口：10051
    zabbix agent服务端口：10050

    
