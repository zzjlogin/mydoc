.. _linux-zabbix-monitor-web:

======================================================================================================================================================
zabbix监控web服务
======================================================================================================================================================


zabbix默认可以设置监控web，并可以根据web的情况设置触发器和告警动作。


zabbix2\.x版本的服务器在 ``configuration `` 下面有web监控项，
可以绑定对应的主机，然后设置即可。

zabbix3\.x版本的服务器已经把web监控集成在 ``configuration `` 的hosts中，Hosts的监控主机中有一项web，可以设置对应监控主机的web监控。


测试被监控服务器：

.. code-block:: bash
    :linenos:
    
    curl -l http://192.168.161.134/index.html


这些web监控也可以设置在模版中，这样就方便监控使用。


.. image:: /Server/res/images/server/linux/zabbix-config/app/web/zabbix-monitor-web001.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/web/zabbix-monitor-web002.png
    :align: center
    :height: 450 px
    :width: 800 px



.. image:: /Server/res/images/server/linux/zabbix-config/app/web/zabbix-monitor-web003.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/web/zabbix-monitor-web004.png
    :align: center
    :height: 450 px
    :width: 800 px



.. image:: /Server/res/images/server/linux/zabbix-config/app/web/zabbix-monitor-web005.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/app/web/zabbix-monitor-web006.png
    :align: center
    :height: 450 px
    :width: 800 px



.. image:: /Server/res/images/server/linux/zabbix-config/app/web/zabbix-monitor-web007.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/app/web/zabbix-monitor-web008.png
    :align: center
    :height: 450 px
    :width: 800 px



.. image:: /Server/res/images/server/linux/zabbix-config/app/web/zabbix-monitor-web009.png
    :align: center
    :height: 450 px
    :width: 800 px








