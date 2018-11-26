.. _openldap-introduce:

=============================================
openldap介绍
=============================================

:Date: 2018-10

.. contents::

.. _openldap-abstract:

openldap简介
=============================================


官方资料：
    - 官网：http://www.openldap.org/
    - 官方文档：http://www.openldap.org/doc/
    - 官网滴在：http://www.openldap.org/software/download/

什么是openldap
----------------------------------------------


参考：
    https://www.openldap.org/doc/admin24/intro.html


OpenLDAP软件可以提供目录服务，类似于微软的活动目录。

作用：
    - 用轻量级的专用数据库
    - 条目是具有全局唯一性的属性集合专有名称（DN）


使用ldap的场景：
    - Machine Authentication(机器授权)
    - User Authentication(用户授权)
    - User/System Groups(用户组和系统组管理)
    - Address book(通讯录管理)
    - Organization Representation
    - Asset Tracking(资产管理)
    - Telephony Information Store
    - User resource management
    - E-mail address lookups
    - Application Configuration store
    - PBX Configuration store
    - etc.....

 LDAP是基于OSI模型中 ``X.500`` 目录访问协议的实现。但是LDAP是基于TCP/IP协议实现的。
 












