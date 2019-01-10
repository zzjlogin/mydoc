.. _openldap-faq:

======================================================================================================================================================
openldap常见问题总结
======================================================================================================================================================

:Date: 2018-10

.. contents::



openldap简介
======================================================================================================================================================


安装openldap相关包：

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# yum install nscd nss-pam-ldapd nss-* pcre-* --skip-broken -y


上面安装报错：

.. code-block:: none
    :linenos:

    Error:  Multilib version problems found. This often means that the root
        cause is something else and multilib version checking is just
        pointing out that there is a problem. Eg.:
        
            1. You have an upgrade for nss-softokn-freebl which is missing some
                dependency that another package requires. Yum is trying to
                solve this by installing an older version of nss-softokn-freebl of the
                different architecture. If you exclude the bad architecture
                yum will tell you what the root cause is (which package
                requires what). You can try redoing the upgrade with
                --exclude nss-softokn-freebl.otherarch ... this should give you an error
                message showing the root cause of the problem.
        
            2. You have multiple architectures of nss-softokn-freebl installed, but
                yum can only see an upgrade for one of those arcitectures.
                If you don't want/need both architectures anymore then you
                can remove the one with the missing update and everything
                will work.
        
            3. You have duplicate versions of nss-softokn-freebl installed already.
                You can use "yum check" to get yum show these errors.
        
        ...you can also use --setopt=protected_multilib=false to remove
        this checking, however this is almost never the correct thing to
        do as something else is very likely to go wrong (often causing
        much more problems).
        
        Protected multilib versions: nss-softokn-freebl-3.14.3-23.3.el6_8.x86_64 != nss-softokn-freebl-3.14.3-17.el6.i686

解决办法：

.. code-block:: bash
    :linenos:

    [root@ldap_001 ~]# rpm -qa nss-softokn-freebl
    nss-softokn-freebl-3.14.3-17.el6.x86_64
    nss-softokn-freebl-3.14.3-17.el6.i686

    [root@ldap_001 ~]# yum update nss-softokn-freebl -y

    [root@ldap_001 ~]# yum install nscd nss-pam-ldapd nss-* pcre-* --skip-broken -y












