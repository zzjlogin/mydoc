.. _lvs-introduce:

======================================================================================================================================================
lvs介绍
======================================================================================================================================================

:Date: 2018-10

.. contents::

.. _lvs-abstract:

lvs简述
======================================================================================================================================================

lvs官方资料：
    - 官网：http://zh.linuxvirtualserver.org/
    - lvs中文文档：http://www.linuxvirtualserver.org/zh/
    - lvs英文文档：http://www.linuxvirtualserver.org/Documents.html
    - lvs官方下载地址：http://www.linuxvirtualserver.org/software/index.html
    - ipvsadm命令参考：http://zh.linuxvirtualserver.org/node/5
    - lvs中文论坛精粹文章：http://zh.linuxvirtualserver.org/node/96
    - lvs调度算法说明：http://www.linuxvirtualserver.org/zh/lvs4.html
    - lvs常用的四种负载均衡模式详解：http://www.linuxvirtualserver.org/zh/lvs3.html


lvs可以理解为一种负载均衡软件。这里的负载均衡是网络中的第四层的负载均衡。所以几乎所有应用层的协议都可以用lvs实现负载均衡。

lvs理解：
    - 硬件条件：例如有五台机器。
    - lvs安装情况：需要在所有lvs调度的机器都需要安装lvs，现在主流的linux内核基本都已经集成了lvs，只需要开启lvs功能即可，然后安装lvs管理工具ipvsadm即可。
    - 这五台机器可以构成一个集群，对外用一台IP提供服务，例如www服务。
    - 对外服务的IP，就是VIP，每个机器又有自己在本网络获取或分配的IP，这个本地的IP是RIP。
    - 这五台机器需要有一台类似master，其余的是slave，这个master就是负载均衡器，然后把所有的提供服务的机器的IP加入到本地，并选择合适的轮询算法。

lvs缺点：
    lvs一般是一个主多个从，所以有单点故障的问题，但是一般lvs会结合keepalive，这样就解决了单点故障。








