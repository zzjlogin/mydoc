.. _openldap-auth:

======================================================================================================================================================
openldap认证(结合其他软件)
======================================================================================================================================================

:Date: 2018-09

.. contents::


SASL ldap
======================================================================================================================================================

参考：
    - http://www.openldap.org/doc/admin24/security.html#Configuring%20saslauthd
    - https://www.openldap.org/doc/admin24/sasl.html
    - https://www.openldap.org/doc/admin24/security.html#SASL%20method
    - https://www.openldap.org/doc/admin24/security.html#Configuring%20saslauthd
    -

SASL:
    Simple Authentication and Security Layer (SASL)，安全层简单认证
    
    SASL遵循：https://www.rfc-editor.org/rfc/rfc4422.txt

    需要软件cyrus-sasl

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# saslauthd -v
    saslauthd 2.1.23
    authentication mechanisms: getpwent kerberos5 pam rimap shadow ldap

    [root@ldap_001 ~]# yum install cyrus-sasl-ldap -y


    [root@ldap_001 ~]# yum install sasl* -y

    [root@ldap_001 ~]# rpm -qa sasl*       
    saslwrapper-devel-0.14-1.el6.x86_64
    saslwrapper-0.14-1.el6.x86_64

    [root@ldap_001 ~]# yum install *sasl* -y

    [root@ldap_001 ~]# saslauthd -v
    saslauthd 2.1.23
    authentication mechanisms: getpwent kerberos5 pam rimap shadow ldap


    [root@ldap_001 ~]# grep -i mech /etc/sysconfig/saslauthd
    # Mechanism to use when checking passwords.  Run "saslauthd -v" to get a list
    # of which mechanism your installation was compiled with the ablity to use.
    MECH=pam
    # Options sent to the saslauthd. If the MECH is other than "pam" uncomment the next line.
    [root@ldap_001 ~]# sed -i 's#MECH=pam#MECH=shadow#g' /etc/sysconfig/saslauthd

    [root@ldap_001 ~]# /etc/init.d/saslauthd restart
    Stopping saslauthd:                                        [FAILED]
    Starting saslauthd:                                        [  OK  ]


    [root@ldap_001 ~]# useradd zzj


    [root@ldap_001 ~]# testsaslauthd -uzzj -p123
    0: OK "Success."

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# man saslauthd

参数中有关于ldap认证的配置文件

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# sed -i 's#MECH=shadow#MECH=ldap#g' /etc/sysconfig/saslauthd

    [root@ldap_001 ~]# /etc/init.d/saslauthd restart



.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# vi /etc/saslauthd.conf


    ldap_servers: ldap://192.168.161.137
    ldap_search_base: ou=People,dc=display,dc=tk
    ldap_filter: uid=%U
    ldap_bind_dn: cn=admin,dc=display,dc=tk
    ldap_bind_pw: zzjlogin
    ldap_password_attr: userPassword
    #ldap_sasl:0

官方文档介绍的配置：

.. code-block:: bash
    :linenos:

    ldap_servers: ldap://display.tk/
    ldap_search_base: ou=People,dc=display,dc=tk
    ldap_filter: uid=%U
    ldap_bind_dn: cn=admin,dc=display,dc=tk
    ldap_password: zzjlogin


    [root@ldap_001 ~]# /etc/init.d/saslauthd restart
    Stopping saslauthd:                                        [  OK  ]
    Starting saslauthd:                                        [  OK  ]


    [root@ldap_001 ~]#  testsaslauthd -utest -p123  
    0: OK "Success."



