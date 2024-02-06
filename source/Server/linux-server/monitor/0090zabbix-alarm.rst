.. _server-linux-zabbix-alerm:

======================================================================================================================================================
zabbix监控报警
======================================================================================================================================================


本地postfix配置发送邮件
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# sed -i "s/#myhostname = virtual.domain.tld/myhostname = zabbix/g" /etc/postfix/main.cf
    [root@zzjlogin ~]# sed -i "s/#mydomain = domain.tld/mydomain = alert.com/g" /etc/postfix/main.cf
    [root@zzjlogin ~]# ss -lntu | grep 25
    tcp    LISTEN     0      100                  ::1:25                   :::*     
    tcp    LISTEN     0      100            127.0.0.1:25                    *:*     

    [root@zzjlogin ~]# /etc/init.d/postfix restart
    Shutting down postfix:                                     [  OK  ]
    Starting postfix:                                          [  OK  ]

    [root@zzjlogin ~]# chkconfig postfix on

.. code-block:: bash
    :linenos:

    sed -i "s/#myhostname = virtual.domain.tld/myhostname = zabbix/g" /etc/postfix/main.cf
    sed -i "s/#mydomain = domain.tld/mydomain = alert.com/g" /etc/postfix/main.cf
    ss -lntu | grep 25

    /etc/init.d/postfix restart
    chkconfig postfix on

测试邮件发送：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# echo 'Hello world!' | mail -s 'this is test' login_root@163.com

    [root@zzjlogin ~]# su - admin
    [admin@zzjlogin ~]$ echo 'Hello world!' | mail -s 'this is test' login_root@163.com





用户相关设置(user about)
======================================================================================================================================================


告警邮件服务设置(Media types)
------------------------------------------------------------------------------------------------------------------------------------------------------

.. image:: /Server/res/images/server/linux/zabbix-config/alert/zabbix-alert-mediatype001.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/alert/zabbix-alert-mediatype002.png
    :align: center
    :height: 400 px
    :width: 800 px


告警邮件接收用户设置(users)
------------------------------------------------------------------------------------------------------------------------------------------------------

.. image:: /Server/res/images/server/linux/zabbix-config/alert/zabbix-alert-users001.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/alert/zabbix-alert-users002.png
    :align: center
    :height: 350 px
    :width: 800 px


触发器(triggers)
======================================================================================================================================================

.. image:: /Server/res/images/server/linux/zabbix-config/alert/zabbix-alert-trigger001.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/alert/zabbix-alert-trigger002.png
    :align: center
    :height: 400 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/alert/zabbix-alert-trigger003.png
    :align: center
    :height: 450 px
    :width: 800 px



动作(action)
======================================================================================================================================================





.. image:: /Server/res/images/server/linux/zabbix-config/alert/zabbix-alert-action001.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/alert/zabbix-alert-action002.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/alert/zabbix-alert-action003.png
    :align: center
    :height: 350 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/zabbix-config/alert/zabbix-alert-action004.png
    :align: center
    :height: 350 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/zabbix-config/alert/zabbix-alert-action005.png
    :align: center
    :height: 350 px
    :width: 800 px










