.. _linux-zabbix-monitor-web:

==================================
zabbix监控MySQL服务
==================================




==================================
zabbix监控web服务
==================================

zabbix默认可以设置监控web，并可以根据web的情况设置触发器和告警动作。


zabbix2.x版本的服务器在 ``configuration `` 下面有web监控项，可以绑定对应的主机，然后设置即可。

zabbix3.x版本的服务器已经把web监控集成在 ``configuration `` 的hosts中，Hosts的监控主机中有一项web，可以设置对应监控主机的web监控。


测试被监控服务器：

curl -l http://192.168.161.134/index.html


这些web监控也可以设置在模版中，这样就方便监控使用。


.. image:: /images/server/linux/zabbix-config/app/web/zabbix-monitor-web001.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /images/server/linux/zabbix-config/app/web/zabbix-monitor-web002.png
    :align: center
    :height: 450 px
    :width: 800 px



.. image:: /images/server/linux/zabbix-config/app/web/zabbix-monitor-web003.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /images/server/linux/zabbix-config/app/web/zabbix-monitor-web004.png
    :align: center
    :height: 450 px
    :width: 800 px



.. image:: /images/server/linux/zabbix-config/app/web/zabbix-monitor-web005.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /images/server/linux/zabbix-config/app/web/zabbix-monitor-web006.png
    :align: center
    :height: 450 px
    :width: 800 px



.. image:: /images/server/linux/zabbix-config/app/web/zabbix-monitor-web007.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /images/server/linux/zabbix-config/app/web/zabbix-monitor-web008.png
    :align: center
    :height: 450 px
    :width: 800 px



.. image:: /images/server/linux/zabbix-config/app/web/zabbix-monitor-web009.png
    :align: center
    :height: 450 px
    :width: 800 px






zabbix监控MySQL服务
==================================

zabbix客户端配置
----------------------------------

.. attention::
    如果没有文件 ``/etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf``
    可以在目录/usr/share/doc/zabbix-agent-XXX/目录下查找。

cp /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf.`date "+%F"`

vi /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf

:1,$ s#/var/lib/#/etc/#g

use mysql;
grant all privileges on zabbix.* to zabbix@localhost identified by 'password';
grant all privileges on zabbix.* to zabbix@192.168.161.132 identified by 'password';
flush privileges;
exit

vi /etc/zabbix/.my.conf

[mysql]
host=localhost
user=zabbix
password=password
socket=/var/lib/mysql/mysql.sock
[mysqladmin]
host=localhost
user=zabbix
password=password
socket=/var/lib/mysql/mysql.sock

zabbix服务器测试获取MySQL监控数据：

[root@localhost ~]# zabbix_get -s '192.168.161.134' -k 'mysql.status[Uptime]'
1582


图形监控配置
-----------------------------------------

.. attention::
    zabbix监控服务器默认的MySQL监控项的更新周期是1小时，所以被监控服务器和MySQL模版关联以后需要等待一个小时后所有数据才可以完全同步。




.. image:: /images/server/linux/zabbix-config/app/mysql/zabbix-monitor-mysql001.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /images/server/linux/zabbix-config/app/mysql/zabbix-monitor-mysql002.png
    :align: center
    :height: 450 px
    :width: 800 px



.. image:: /images/server/linux/zabbix-config/app/mysql/zabbix-monitor-mysql003.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /images/server/linux/zabbix-config/app/mysql/zabbix-monitor-mysql004.png
    :align: center
    :height: 450 px
    :width: 800 px



.. image:: /images/server/linux/zabbix-config/app/mysql/zabbix-monitor-mysql005.png
    :align: center
    :height: 450 px
    :width: 800 px


