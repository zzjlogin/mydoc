.. _openldap-introduce:

======================================================================================================================================================
openldap介绍
======================================================================================================================================================

:Date: 2018-10

.. contents::

.. _openldap-abstract:

openldap简介
======================================================================================================================================================


官方资料：
    - 官网：http://www.openldap.org/
    - 官方文档：http://www.openldap.org/doc/
    - 官网滴在：http://www.openldap.org/software/download/

什么是openldap
------------------------------------------------------------------------------------------------------------------------------------------------------


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
 
LDAP是轻量目录访问协议，英文全称是Lightweight Directory Access Protocol，一般都简称为LDAP

openldap常用概念
======================================================================================================================================================

DIT - Directory Information Tree
    在LDAP中，整体的目录结构可以成为是DIT。

Entries.
    在LDAP中，组织方式类似于树结构的组织。在LDAP，Entries就是树的节点，无论是根节点，还是叶子节点。所以，Entries是在DIT中的一个节点。

DN
    Distinguished Name，在树结构里，你要访问某一个节点，肯定是要从根节点出发，然后，沿着不同的分支，知道走到某个节点（Entries）。所以，DN是一个路径的概念。

RDN
    Relative Distinguished Names，可用从概念上理解，DN是绝对路径，RDN是相对路径。绝对路径是由一系列的相对路径组成。
    A DN is composed of a sequence of RDNs separated by commas, such as cn=thomas,ou=itso,o=ibm.

c
    Country，c代表的是一个很大的概念，可以理解为国家。
o
    Organization，在这里，o代表的是一个组织。你可以将o设置成为你的根节点，然后往下拓展。o置于c下面，可以很好理解。
    In case you store data for multiple organizations within a country, you may want to start with a country (c) and then branch into organizations

ou
    Organization Unit，ou其实是对o的拓展，逻辑上将ou置于o下面，可以实现根到叶子之间的关系。If you have, for example, one company with different divisions, you may want to start with your company name under the root as the organization (o) and then branch into organizational units (ou)。

cn - common name


现在是具体到一个个体的时间了，一个人名字叫做是john，住在中国北京，是百度的一个销售员工，那么他的DN该是如何呢： DN: cn=john,ou=market,o=baidu,o=beijing,c=china








