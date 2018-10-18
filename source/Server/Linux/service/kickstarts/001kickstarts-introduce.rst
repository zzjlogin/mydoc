
.. _zzjlogin-kickstart-introduce:

================================
kickstart介绍
================================

参考:

    - CentOS5 : http://www.centos.org/docs/5/html/Installation_Guide-en-US/s1-kickstart2-options.html 
    - CentOS6 : https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/s1-kickstart2-options.html 

https://blog.oldboyedu.com/autoinstall-kickstart/


**kickstart** 是一种无人值守的安装方式。它的工作原理是在安装过程中记录人工干预填写的各种参数，并生成一个名为ks.cfg的文件。
如果在自动安装过程中出现要填写参数的情况，安装程序首先会去查找ks.cfg文件，如果找到合适的参数，就采用所找到的参数；
如果没有找到合适的参数，便会弹出对话框让安装者手工填写。所以，如果ks.cfg文件涵盖了安装过程中所有需要填写的参数，
那么安装者完全可以只告诉安装程序从何处下载ks.cfg文件，然后就去忙自己的事情。
等安装完毕，安装程序会根据ks.cfg中的设置重启/关闭系统，并结束安装。

**Cobbler**集中和简化了通过网络安装操作系统需要使用到的DHCP、TFTP和DNS服务的配置。
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

