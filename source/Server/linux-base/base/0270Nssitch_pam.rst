
======================================================================================================================================================
Nssitch、pam
======================================================================================================================================================

:Date: 2018-09-02

.. contents::

nsswitch
======================================================================================================================================================

nsswitch是network service switch的简写，叫做网络服务转换，主要用于调整网络服务
的名称解析机制。

nss的配置文件
------------------------------------------------------------------------------------------------------------------------------------------------------

nss的配置文件是/etc/nsswitch.conf，格式比较简单。



格式： 
    解析库： 解析库类型

样例： 
    - 密码通过文件去验证
        passwd: files
    - 主机需要去文件找，没有再去dns找
        hosts: files dns

解析库：
    - files
    - ethers
    - group
    - hosts
    - netgroup
    - networks
    - passwd 
    - protocols
    - rpm 
    - services 
    - shadow 

解析库类型：
    - files
    - dns
    - compat
    - dbm 
    - hesiod 
    - winbind
    - nis
    - nisplus

查询结果：
    - SUCCESS  成功
    - NOTFOUND 没有找到
    - UNAVIL   服务不可用
    - TRYAGAIN 临时失败

默认找到一个成功就返回了，后续的就不判断了，如果出现没有找到就继续找下一个配置项，我们可以修改默认配置。

.. code-block:: text
    :linenos:

    # 这个含义就是如果文件没有找到的话，后续的工作（去dns查找）就不做了。
    hosts: files[NOTFOUND=return] dns
 
其他命令

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# getent shadow root 
    root:$6$Y1.nEGyQRYQrX.8l$R6QPw5uthWgpv6RlY.9YfEVv5TrBwbNjWX7Di2f4kKbFsgP1W0T2Z4qyVk.N3XuSOTxp01iEvQC0y9GkDh3sB.::0:99999:7:::

pam
======================================================================================================================================================

.. note::
    pam是第三方认证模块，所以认证是不可控的。数据交互过程如果出现故障，排查比较困难定位故障节点。
    所以可以通过ldap来结合python或shell来开发自己的认证授权。


pam是可插入式认证模块，nss用于实现名称解析，pam用于实现认证工作。

pam的主配置文件是/etc/pam.conf。次级配置目录有/etc/pam.d/目录下的所有文件。

配置文件格式

.. code-block:: text
    :linenos:

    type control  module-path module-arguments

    type: 
        account: 账号相关的非认证功能
        auth: 认证和授权
        password: 用户密码修改时候使用
        session: 用户获取到服务器之前或使用服务完成之后要进行的一些附属性操作。
    control：
        这个control代表同一种功能的多种检查之间的如何配合组合，有两种方式。
        1、 使用一个关键词
            required: 这个条件必须通过才可以
            requisite: 一票通过
            sufficient: 一票拒绝
            optional: 无关紧要的
            include: 使用其他文件的认证信息来检查


        2、 使用一道多组“return value=action”
            value： 提示特定的返回值
            action: 采取的操作
            module-path: 模块路径
            module-arguments: 模块参数

