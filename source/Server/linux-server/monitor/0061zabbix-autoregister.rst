
.. _server-linux-zabbix-autoregister:

======================================================================================================================================================
设置客户端自动注册
======================================================================================================================================================



客户端自动向zabbix服务器注册的方法是：
    在zabbix客户端配置文件： ``/etc/zabbix/zabbix_agentd.conf`` 中修改 ``ServerActive=`` 的值等于zabbix服务器IP地址(且客户端和服务器可以正常通信)。
    
    例如：

.. code-block:: bash
    :linenos:

    ServerActive=192.168.161.132

zabbix服务器配置：
    zabbix客户端配置了主动向服务器注册以后，如果服务器没有把主动注册的客户端添加到主机列表也看不到被监控的主机。所以zabbix服务器也需要相应配置。

    具体配置就是：
        1. action中 ``Auto registration`` 源事件创建动作。
        #. conditions不用添加。只用添加一个action名称。
        #. 创建的action对应的Operations添加：添加主机动作、添加到主机组、链接模版。

.. attention::
    如果主机组、主机模版想自定义，可以在创建action之前创建主机组和对应的模版。

具体过程
======================================================================================================================================================

客户端主动注册
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@client ~]# sed -ir 's#^ServerActive=127.0.0.1#ServerActive=192.168.161.132#g' /etc/zabbix/zabbix_agentd.conf
    [root@client ~]# grep "ServerActive=192.168.161.132" /etc/zabbix/zabbix_agentd.conf
    ServerActive=192.168.161.132

    [root@client ~]# HOSTNAME=`/bin/hostname`
    [root@client ~]# sed -i "s#Hostname=#Hostname=$HOSTNAME#g" /etc/zabbix/zabbix_agentd.conf

.. code-block:: bash
    :linenos:

    sed -ir 's#^ServerActive=127.0.0.1#ServerActive=192.168.161.132#g' /etc/zabbix/zabbix_agentd.conf
    grep "ServerActive=192.168.161.132" /etc/zabbix/zabbix_agentd.conf

    HOSTNAME=`/bin/hostname`
    sed -i "s#Hostname=#Hostname=$HOSTNAME#g" /etc/zabbix/zabbix_agentd.conf
    

zabbix服务器自动添加客户端主机
------------------------------------------------------------------------------------------------------------------------------------------------------


zabbix 3.4以后版本有自带模版linux系统模版。此处不再设置模版，直接套用样例模版。



.. image:: /Server/res/images/server/linux/zabbix-config/auto-registration/zabbix-auto-registration001.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/auto-registration/zabbix-auto-registration002.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/auto-registration/zabbix-auto-registration003.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/auto-registration/zabbix-auto-registration004.png
    :align: center
    :height: 450 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/auto-registration/zabbix-auto-registration005.png
    :align: center
    :height: 450 px
    :width: 800 px



重启zabbix客户端：
    zabbix客户端需要重启才能让修改的配置文件生效且自动主动向zabbix服务器注册。

.. code-block:: bash
    :linenos:

    [root@client001 ~]# /etc/init.d/zabbix-agent restart
    Shutting down Zabbix agent:                                [  OK  ]
    Starting Zabbix agent:                                     [  OK  ]



.. image:: /Server/res/images/server/linux/zabbix-config/auto-registration/zabbix-auto-registration006.png
    :align: center
    :height: 450 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/auto-registration/zabbix-auto-registration007.png
    :align: center
    :height: 450 px
    :width: 800 px

