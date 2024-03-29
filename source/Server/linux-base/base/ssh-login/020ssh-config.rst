======================================================================================================================================================
ssh配置
======================================================================================================================================================

:Date: 2018-11

.. contents::


ssh服务端配置
======================================================================================================================================================

服务端配置参考：
    - https://www.ssh.com/ssh/sshd_config/
    - https://www.freebsd.org/cgi/man.cgi?sshd_config(5)

常用配置
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    Port 22
    PermitRootLogin no
    PermitEmptyPasswords no
    #PasswordAuthentication no
    UseDNS no
    GSSAPIAuthentication no


配置详解
------------------------------------------------------------------------------------------------------------------------------------------------------


Port
    - 本地sshd守护进程监听的监听端口号，默认监听22端口。默认监听所有发起连接到本地的地址。
    - 端口号范围 **0-65535** ，但是 **0-1024** 位系统服务端口，所以建议设置在1024之后的不冲突的端口号
    - 可以通过 ``ListenAddress`` 参数指定只监听特定客户端IP发起的ssh连接请求。
    - 修改默认端口号： ``Port 52113``

PermitEmptyPasswords
    - 是否允许密码为空的用户远程登录。默认不允许（即为“no”）
PermitRootLogin
    - 是否允许root登录。
    - 参数指定值和意义：
        - yes：允许root远程ssh登录
        - no：禁止root远程ssh登录（默认）
        - without-password：禁止使用密码认证登录
        - forced-commands-only：只有指定了command参数的情况下才允许使用公钥认证登录同时其他认证方法全部被禁用，这个值常用于做远程备份之类的事情

UseDNS
    - sshd是否对远程主机名进行反向解析，以检查此主机名是否与其IP地址真实对应。默认是“yes”
    - 远程解析会使ssh连接变慢，所以可以改成“no”

GSSAPIAuthentication
    - 指定是否允许基于GSSAPI的用户身份验证。默认是no。
    - 设置为“no”解决ssh连接慢的问题
PasswordAuthentication
    - 指定是否允许密码验证。默认是no。
    - 需要参考 ``UsePAM`` 。
Banner /etc/banner
    - 这是终端登陆输入密码之前的提示信息。

AcceptEnv
    - 配置接受客户端发送的环境变量。默认是不接受。
    - 和ssh客户端配置文件 ``ssh_config`` 中的参数 ``SendEnv`` 配合使用

AddressFamily
    - 指定sshd守护进程监听的本地地址。可以指定单独IP、IP地址段(IPv4/IPv6)
    - 默认是所有地址。
AllowAgentForwarding
    - 配置 ``ssh-agent`` 转发允许。默认即允许转发
    - 禁用代理转发并不能提高安全性，除非用户也被拒绝shell访问，因为他们总是可以安装自己的代理。
AllowGroups
    - 这个关键字后面可以跟一个组名称模式列表，由空格分隔。如果指定，则只允许主组或补充组列表与其中一种模式匹配的用户登录。只有组名有效;无法识别数字组ID。默认情况下，所有组都允许登录。
    - 允许/拒绝指令按照以下顺序处理:DenyUsers、AllowUsers、DenyGroups，最后是AllowGroups。
AllowStreamLocalForwarding

ssh客户端配置
======================================================================================================================================================

客户端配置参考：
    https://www.ssh.com/ssh/config/

linux服务器的ssh客户端配置文件，一般都不用修改。

配置详解
------------------------------------------------------------------------------------------------------------------------------------------------------













