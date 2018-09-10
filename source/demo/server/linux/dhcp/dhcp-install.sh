[root@zzjlogin ~]# rpm -qa dhcp*
dhcp-common-4.1.1-43.P1.el6.centos.x86_64

[root@zzjlogin ~]# yum install dhcp -y
已加载插件：fastestmirror, security
设置安装进程
Determining fastest mirrors
 * base: mirrors.zju.edu.cn
 * extras: mirrors.zju.edu.cn
 * updates: mirrors.zju.edu.cn
base                                                     | 3.7 kB     00:00     
extras                                                   | 3.4 kB     00:00     
updates                                                  | 3.4 kB     00:00     
updates/primary_db                                       | 1.2 MB     00:00     
解决依赖关系
--> 执行事务检查
---> Package dhcp.x86_64 12:4.1.1-61.P1.el6.centos will be 安装
--> 处理依赖关系 dhcp-common = 12:4.1.1-61.P1.el6.centos，它被软件包 12:dhcp-4.1.1-61.P1.el6.centos.x86_64 需要
--> 处理依赖关系 portreserve，它被软件包 12:dhcp-4.1.1-61.P1.el6.centos.x86_64 需要
--> 执行事务检查
---> Package dhcp-common.x86_64 12:4.1.1-43.P1.el6.centos will be 升级
--> 处理依赖关系 dhcp-common = 12:4.1.1-43.P1.el6.centos，它被软件包 12:dhclient-4.1.1-43.P1.el6.centos.x86_64 需要
---> Package dhcp-common.x86_64 12:4.1.1-61.P1.el6.centos will be an update
---> Package portreserve.x86_64 0:0.0.4-11.el6 will be 安装
--> 执行事务检查
---> Package dhclient.x86_64 12:4.1.1-43.P1.el6.centos will be 升级
---> Package dhclient.x86_64 12:4.1.1-61.P1.el6.centos will be an update
--> 完成依赖关系计算

依赖关系解决

================================================================================
 软件包           架构        版本                           仓库          大小
================================================================================
正在安装:
 dhcp             x86_64      12:4.1.1-61.P1.el6.centos      updates      824 k
为依赖而安装:
 portreserve      x86_64      0.0.4-11.el6                   base          23 k
为依赖而更新:
 dhclient         x86_64      12:4.1.1-61.P1.el6.centos      updates      323 k
 dhcp-common      x86_64      12:4.1.1-61.P1.el6.centos      updates      145 k

事务概要
================================================================================
Install       2 Package(s)
Upgrade       2 Package(s)

总下载量：1.3 M
下载软件包：
(1/4): dhclient-4.1.1-61.P1.el6.centos.x86_64.rpm        | 323 kB     00:00     
(2/4): dhcp-4.1.1-61.P1.el6.centos.x86_64.rpm            | 824 kB     00:00     
(3/4): dhcp-common-4.1.1-61.P1.el6.centos.x86_64.rpm     | 145 kB     00:00     
(4/4): portreserve-0.0.4-11.el6.x86_64.rpm               |  23 kB     00:00     
--------------------------------------------------------------------------------
总计                                            3.1 MB/s | 1.3 MB     00:00     
运行 rpm_check_debug 
执行事务测试
事务测试成功
执行事务
  正在升级   : 12:dhcp-common-4.1.1-61.P1.el6.centos.x86_64                 1/6 
  正在安装   : portreserve-0.0.4-11.el6.x86_64                              2/6 
  正在安装   : 12:dhcp-4.1.1-61.P1.el6.centos.x86_64                                                                                                                     3/6 
  正在升级   : 12:dhclient-4.1.1-61.P1.el6.centos.x86_64                                                                                                                 4/6 
  清理       : 12:dhclient-4.1.1-43.P1.el6.centos.x86_64                                                                                                                 5/6 
  清理       : 12:dhcp-common-4.1.1-43.P1.el6.centos.x86_64                                                                                                              6/6 
  Verifying  : portreserve-0.0.4-11.el6.x86_64                                                                                                                           1/6 
  Verifying  : 12:dhcp-4.1.1-61.P1.el6.centos.x86_64                                                                                                                     2/6 
  Verifying  : 12:dhclient-4.1.1-61.P1.el6.centos.x86_64                                                                                                                 3/6 
  Verifying  : 12:dhcp-common-4.1.1-61.P1.el6.centos.x86_64                                                                                                              4/6 
  Verifying  : 12:dhclient-4.1.1-43.P1.el6.centos.x86_64                                                                                                                 5/6 
  Verifying  : 12:dhcp-common-4.1.1-43.P1.el6.centos.x86_64                                                                                                              6/6 

已安装:
  dhcp.x86_64 12:4.1.1-61.P1.el6.centos                                                                                                                                      

作为依赖被安装:
  portreserve.x86_64 0:0.0.4-11.el6                                                                                                                                          

作为依赖被升级:
  dhclient.x86_64 12:4.1.1-61.P1.el6.centos                                           dhcp-common.x86_64 12:4.1.1-61.P1.el6.centos                                          

完毕！

[root@zzjlogin ~]# rpm -qa dhcp*
dhcp-common-4.1.1-61.P1.el6.centos.x86_64
dhcp-4.1.1-61.P1.el6.centos.x86_64