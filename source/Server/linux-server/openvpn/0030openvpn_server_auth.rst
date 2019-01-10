.. _openvpn-server-auth:

======================================================================================================================================================
OpenVPN客户端认证
======================================================================================================================================================

:Date: 2018-09

.. contents::


概述
======================================================================================================================================================

OpenVPN认证官方说明：
    https://openvpn.net/community-resources/using-alternative-authentication-methods/

.. tip::
    OpenVPN2.0后引入了用户名/密码的身份验证方式，它可以省略客户端证书，但是仍
    有一份服务器证书需要被用作加密。

OpenVPN认证方式总体包括以下几种：
    - 证书密钥认证
    - 证书密钥+密码口令认证
    - 证书密钥+用户名+口令认证
    - 用户名+密码

证书密钥认证
    证书即OpenVPN服务器生成的CA、dh、server相关证书
证书密钥+密码口令认证
    这部分口令可以使通过 ``./build-key-pass username`` 命令创建用户时配置的密码口令。
用户名+密码
    这部分认证分为以下几种：

    - 通过自己写程序(例如：脚本)调用本地用户配置的文件。(用户信息都在本地文件中)
    - 通过读取数据库(主要常用数据库：MySQL)验证用户信息。这种方法分为两类：
        - 通过现有模块配置使用。例如：pam_mysql
        - 通过自己写调用程序实现读取数据库认证
        - 通过ldap认证
        - 通过微软活动目录认证
    - 通过radius认证(freerdius)


验证脚本：
    http://openvpn.se/files/other/checkpsw.sh 



密钥认证(单独密钥)
======================================================================================================================================================

这一种方法是较为常用的方法。

主要步骤：
    1. OpenVPN服务端安装参考前面的安装步骤。
    2. OpenVPN生成CA/DH/服务端key。
    3. 生成客户端密钥时使用脚本 ``./build-key username`` ,这样生成的用户就没有密码。



密钥+密码结合认证(既要密钥又要密码)
======================================================================================================================================================


主要步骤：
    1. OpenVPN服务端安装参考前面的安装步骤。
    2. OpenVPN生成CA/DH/服务端key。
    3. 生成客户端密钥时使用脚本 ``./build-key-pass username`` ,这样生成的用户就在登陆时需要密钥和key双重认证。


密码+用户名认证(服务端密码/用户文本存储)
======================================================================================================================================================


这种密码结合用户名认证，不需要客户端密钥。

参考官方资料：
    - https://openvpn.net/community-resources/how-to/#auth
    - 认证脚本：http://openvpn.se/files/other/checkpsw.sh

主要步骤：
    1. OpenVPN服务端安装参考前面的安装步骤。
    2. OpenVPN生成CA/DH/服务端key。
    3. 配置OpenVPN服务端，使客户端验证通过密码+用户的方式认证。
    4. 创建认证脚本。
    5. 创建认证用户及密钥存放的用户及密钥文件。
    6. 客户端配置

OpenVPN服务端配置文件配置
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 openvpn]# vi /etc/openvpn/server.conf

    local 192.168.1.140
    port 52115
    proto udp
    dev tun
    ca /etc/openvpn/keys/ca.crt
    cert /etc/openvpn/keys/server.crt
    key /etc/openvpn/keys/server.key  # This file should be kept secret
    dh /etc/openvpn/keys/dh1024.pem
    tls-auth /etc/openvpn/keys/ta.key 0
    server 10.8.0.0 255.255.255.0
    push "192.168.19.0 255.255.255.0"
    ifconfig-pool-persist ipp.txt
    keepalive 10 120
    comp-lzo
    persist-key
    persist-tun
    verb 3
    client-to-client
    duplicate-cn
    status openvpn-status.log
    log /var/log/openvpn.log
    script-security 3
    client-cert-not-required
    username-as-common-name
    auth-user-pass-verify /etc/openvpn/checkpsw.sh via-env

OpenVPN 2.1.x及以上版本新增加了脚本安全调用参数设置项：
    - script-security
    - 在openvpn服务端配置方法：加入一行 ``script-security 3``


如果不设置这个参数会出现如下错误：
    NOTE: OpenVPN 2.1 requires '--script-security 2' or higher to call user-defined scripts or executables

openvpn网站对于这个变化的日志记录原文：
    OpenVPN 2.1.1 -- released on 2009.12.11 (Change Log)
    Changes include:
    ...
    Users upgrading from 2.x should note that the new script-security option must be set to enable OpenVPN to run scripts. 

    --script-security level [method] 
    This directive offers policy-level control over OpenVPN's usage of external programs and scripts. Lower level values are more restrictive, higher values are more permissive. Settings for level: 
    0 -- Strictly no calling of external programs. 
    1 -- (Default) Only call built-in executables such as ifconfig, ip, route, or netsh. 
    2 -- Allow calling of built-in executables and user-defined scripts. 
    3 -- Allow passwords to be passed to scripts via environmental variables (potentially unsafe). 

    The method parameter indicates how OpenVPN should call external commands and scripts. Settings for method: 

    execve -- (default) Use execve() function on Unix family OSes and CreateProcess() on Windows. 
    system -- Use system() function (deprecated and less safe since the external program command line is subject to shell expansion). 

    The --script-security option was introduced in OpenVPN 2.1_rc9. For configuration file compatibility with previous OpenVPN versions, use: --script-security 3 system 





认证脚本
------------------------------------------------------------------------------------------------------------------------------------------------------

脚本参考：
    - 认证脚本：http://openvpn.se/files/other/checkpsw.sh

脚本内容如下：

.. code-block:: bash
    :linenos:

    #!/bin/sh
    ###########################################################
    # checkpsw.sh (C) 2004 Mathias Sundman <mathias@openvpn.se>
    #
    # This script will authenticate OpenVPN users against
    # a plain text file. The passfile should simply contain
    # one row per user with the username first followed by
    # one or more space(s) or tab(s) and then the password.

    PASSFILE="/etc/openvpn/psw-file"
    LOG_FILE="/var/log/openvpn-password.log"
    TIME_STAMP=`date "+%Y-%m-%d %T"`

    ###########################################################

    if [ ! -r "${PASSFILE}" ]; then
        echo "${TIME_STAMP}: Could not open password file \"${PASSFILE}\" for reading." >> ${LOG_FILE}
        exit 1
    fi

    CORRECT_PASSWORD=`awk '!/^;/&&!/^#/&&$1=="'${username}'"{print $2;exit}' ${PASSFILE}`

    if [ "${CORRECT_PASSWORD}" = "" ]; then 
        echo "${TIME_STAMP}: User does not exist: username=\"${username}\", password=\"${password}\"." >> ${LOG_FILE}
        exit 1
    fi

    if [ "${password}" = "${CORRECT_PASSWORD}" ]; then 
        echo "${TIME_STAMP}: Successful authentication: username=\"${username}\"." >> ${LOG_FILE}
        exit 0
    fi

    echo "${TIME_STAMP}: Incorrect password: username=\"${username}\", password=\"${password}\"." >> ${LOG_FILE}
    exit 1


如果可以访问上面脚本网址页面。可以通过下面命令：

.. code-block:: bash
    :linenos:

    wget http://openvpn.se/files/other/checkpsw.sh

添加脚本运行权限：

.. code-block:: bash
    :linenos:
    
    chmod +x checkpsw.sh



用户配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    mkdir /etc/openvpn/

    vi /etc/openvpn/psw-file

用户和密码如下：

.. code-block:: bash
    :linenos:

    test    test123
    abc     abc123


设置密码文件权限及安全锁定：

.. code-block:: bash
    :linenos:

    qchmod 400 /etc/openvpn/psw-file
    chattr +i /etc/openvpn/psw-file


客户端配置
------------------------------------------------------------------------------------------------------------------------------------------------------

密码结合用户名认证并且不用客户端密钥的认证方式需要配置特定参数：
    - 添加参数：auth-user-pass
    - 注释掉原来 ``cert user.crt`` 和 ``key user.key``


官方说明：
    - 参考：https://openvpn.net/community-resources/how-to/#auth
    - To use this authentication method, first add the auth-user-pass directive to the client configuration. It will direct the OpenVPN client to query the user for a username/password, passing it on to the server over the secure TLS channel.
