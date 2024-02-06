
.. _server-linux-zabbix-discovery:

======================================================================================================================================================
自动发现设备
======================================================================================================================================================

通过网络IP地址自动发现被监控设备，并把被监控设备添加到监控主机列表。


此时需要结合自定义模版。否则只是发现主机，但是并没有添加到监控列表。

本实例通过ICMP发现设备，并自动根据预定义规则添加被发现主机到监控列表。

主要步骤：
    1. 设置模版，用来定义监控项、监控项的图形展示，也可以定义报警事件和条件，此处没有设置报警。
    #. 设置自动发现规则，此处设置按照icmp协议指定时间间隔的自动扫描指定网段发现设备。
    #. 设置动作，当发现设备后并不能自动把发现设备添加到监控设备列表。需要对应的动作和发现规则绑定触发这个动作。并让动作来绑定前面设置的模版，来把添加的被监控主机设备绑定到模版上。

设置发现主机的使用的模版
------------------------------------------------------------------------------------------------------------------------------------------------------


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery001.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery002.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery003.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery004.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery005.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery006.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery007.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery008.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery009.png
    :align: center
    :height: 450 px
    :width: 800 px

设置发现规则
------------------------------------------------------------------------------------------------------------------------------------------------------

.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery010.png
    :align: center
    :height: 400 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery011.png
    :align: center
    :height: 400 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery012.png
    :align: center
    :height: 400 px
    :width: 800 px


设置添加被发现设备到监控列表
------------------------------------------------------------------------------------------------------------------------------------------------------

.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery013.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery014.png
    :align: center
    :height: 350 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery015.png
    :align: center
    :height: 400 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery016.png
    :align: center
    :height: 450 px
    :width: 800 px


结果验证
------------------------------------------------------------------------------------------------------------------------------------------------------

.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery017.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery018.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery019.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/discovery/zabbix-discovery020.png
    :align: center
    :height: 450 px
    :width: 800 px






