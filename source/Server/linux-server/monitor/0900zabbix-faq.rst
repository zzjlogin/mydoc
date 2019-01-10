.. _server-linux-zabbix-faq:

======================================================================================================================================================
zabbix常见问题解决汇总
======================================================================================================================================================






zabbix_get获取时错误
======================================================================================================================================================

zabbix-agent客户端的Server对应的IP地址需要配置成用zabbix_get命令测试的服务器的IP。

.. code-block:: bash
    :linenos:

    [root@zabbix_001 zabbix-server-mysql-3.4.15]# zabbix_get -s 192.168.1.142 -k "system.cpu.switches"
    zabbix_get [30565]: Check access restrictions in Zabbix agent configuration

修改客户端配置文件

.. code-block:: bash
    :linenos:

    vi /etc/zabbix/zabbix_agentd.conf

修改Server的值位zabbix服务器IP：

.. code-block:: bash
    :linenos:

    Server=192.168.1.142

修改后测试

.. code-block:: bash
    :linenos:

    [root@zabbix_001 zabbix-server-mysql-3.4.15]# /etc/init.d/zabbix-agent restart
    Shutting down Zabbix agent:                                [  OK  ]
    Starting Zabbix agent:                                     [  OK  ]
    [root@zabbix_001 zabbix-server-mysql-3.4.15]# zabbix_get -s 192.168.1.142 -k system.cpu.switches  
    671074


安装php等插件的时候报错及解决
======================================================================================================================================================

CentOS6.6官方源直接安装会包错，具体错误信息如下:

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# yum install php56w php56w-gd php56w-mysql php56w-bcmath php56w-bcmath php56w-mbstring php56w-xml php56w-ldap -y
        Loading mirror speeds from cached hostfile
        * base: mirrors.huaweicloud.com
        * extras: ftp.sjtu.edu.cn
        * updates: mirrors.huaweicloud.com
        No package php56w available.
        No package php56w-gd available.
        No package php56w-mysql available.
        No package php56w-bcmath available.
        No package php56w-mbstring available.
        No package php56w-xml available.
        No package php56w-ldap available.

有上面报错，通过下面安装第三方源:

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm






