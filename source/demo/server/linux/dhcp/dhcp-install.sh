[root@dhcp_server01 ~]# rpm -qa dhcp*
dhcp-common-4.1.1-43.P1.el6.centos.x86_64
[root@dhcp_server01 ~]# yum install dhcp -y
Loaded plugins: fastestmirror, security
Setting up Install Process
Loading mirror speeds from cached hostfile
 * c6-media: 
Resolving Dependencies
--> Running transaction check
---> Package dhcp.x86_64 12:4.1.1-43.P1.el6.centos will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=============================================================================================================================================================================
 Package                           Arch                                Version                                                   Repository                             Size
=============================================================================================================================================================================
Installing:
 dhcp                              x86_64                              12:4.1.1-43.P1.el6.centos                                 c6-media                              819 k

Transaction Summary
=============================================================================================================================================================================
Install       1 Package(s)

Total download size: 819 k
Installed size: 1.9 M
Downloading Packages:
Running rpm_check_debug
Running Transaction Test
Transaction Test Succeeded
Running Transaction
Warning: RPMDB altered outside of yum.
  Installing : 12:dhcp-4.1.1-43.P1.el6.centos.x86_64                                                                                                                     1/1 
  Verifying  : 12:dhcp-4.1.1-43.P1.el6.centos.x86_64                                                                                                                     1/1 

Installed:
  dhcp.x86_64 12:4.1.1-43.P1.el6.centos                                                                                                                                      

Complete!
[root@dhcp_server01 ~]# rpm -qa dhcp*      
dhcp-4.1.1-43.P1.el6.centos.x86_64
dhcp-common-4.1.1-43.P1.el6.centos.x86_64