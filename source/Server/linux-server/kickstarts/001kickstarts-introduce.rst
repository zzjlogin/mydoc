
.. _kickstart-introduce:

======================================================================================================================================================
kickstart和Cobbler介绍
======================================================================================================================================================

:Date: 2018-09

.. contents::

kickstart介绍
======================================================================================================================================================

参考:

    - CentOS5: http://www.centos.org/docs/5/html/Installation_Guide-en-US/s1-kickstart2-options.html
    - CentOS6: https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/s1-kickstart2-options.html
    - CentOS7：https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/7/html/installation_guide/chap-kickstart-installations


**kickstart** 是一种无人值守的安装方式。它的工作原理是在安装过程中记录人工干预填写的各种参数，并生成一个名为ks.cfg的文件。
如果在自动安装过程中出现要填写参数的情况，安装程序首先会去查找ks.cfg文件，如果找到合适的参数，就采用所找到的参数；
如果没有找到合适的参数，便会弹出对话框让安装者手工填写。所以，如果ks.cfg文件涵盖了安装过程中所有需要填写的参数，
那么安装者完全可以只告诉安装程序从何处下载ks.cfg文件，然后就去忙自己的事情。
等安装完毕，安装程序会根据ks.cfg中的设置重启/关闭系统，并结束安装。

**Cobbler** 集中和简化了通过网络安装操作系统需要使用到的DHCP、TFTP和DNS服务的配置。
Cobbler不仅有一个命令行界面，还提供了一个Web界面，大大降低了使用者的入门水平。
Cobbler内置了一个轻量级配置管理系统，但它也支持和其它配置管理系统集成，如Puppet，暂时不支持SaltStack。

** 简单的说，Cobbler是对kickstart的封装，简化安装步骤、使用流程，降低使用者的门槛。**


kickstart解决了通过网批量自动安装系统的自动化问题。我们可以理解成kickstart安装可以类似于网络安装系统。只不过是通过网络安装系统的过程再加上自动化。


通过kickstart安装需要的条件：
    - ftp/tftp服务
    - http服务(例如:apache/nginx)
    - nfs服务

如果要通过kickstart安装系统的条件：
    - 需要首先部署kickstart服务器。
    - 需要安装系统的硬件支持PXE(现在一般硬件都支持PXE)


通过kickstart结合PXE完成通过网络自动安装系统需要的步骤：
    - 带安装系统的硬件支持PXE
    - 部署DHCP
    - kickstart配置和系统文件的web服务器
    - 启动硬件，会因为没有系统自动从PXE启动，然后通过DHCP获取IP然后安装系统。


Cobbler介绍
======================================================================================================================================================

Cobbler官网：http://cobbler.github.io/

cobbler源码：https://github.com/cobbler/cobbler

Cobbler集成的服务
    - PXE服务支持
    - DHCP服务管理
    - DNS服务管理(可选bind,dnsmasq)
    - 电源管理
    - Kickstart服务支持
    - YUM仓库管理
    - TFTP(PXE启动时需要)
    - Apache(提供kickstart的安装源，并提供定制化的kickstart配置)


Cobbler是一个Linux服务器安装的服务，可以通过网络启动(PXE)的方式来快速安装、重装物理服务器和虚拟机，同时还可以管理DHCP，DNS等。

Cobbler可以使用命令行方式管理，也提供了基于Web的界面管理工具(cobbler-web)，还提供了API接口，可以方便二次开发使用。

Cobbler是较早前的kickstart的升级版，优点是比较容易配置，还自带web界面比较易于管理。

Cobbler内置了一个轻量级配置管理系统，但它也支持和其它配置管理系统集成，如Puppet，暂时不支持SaltStack。

