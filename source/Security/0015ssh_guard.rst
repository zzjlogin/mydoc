======================================================================================================================================================
ssh防护
======================================================================================================================================================


fail2ban
======================================================================================================================================================


源码：https://github.com/fail2ban/fail2ban

安装：

.. code-block:: bash
    :linenos:
    
    yum install fail2ban -y


如果官方库没有这个软件包可以安装epel：


.. code-block:: bash
    :linenos:

    yum install epel-release -y


配置fail2ban

.. code-block:: bash
    :linenos:

    cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

    vi /etc/fail2ban/jail.local

添加配置内容

.. code-block:: bash
    :linenos:

    [ssh-iptables]
    enabled = true
    filter = sshd
    action = iptables[name=SSH, port=22, protocol=tcp]
    #sendmail-whois[name=SSH, dest=your@email.com, sender=fail2ban@email.com]
    logpath = /var/log/secure
    maxretry = 3 
    bantime = 3600
    findtime  = 300 
    [DEFAULT]
    backend = systemd

配置注解：

.. code-block:: bash
    :linenos:

    [DEFAULT]               #全局设置
    ignoreip = 127.0.0.1/8       #忽略的IP列表,不受设置限制
    bantime  = 600             #屏蔽时间，单位：秒
    findtime  = 600             #这个时间段内超过规定次数会被ban掉
    maxretry = 3                #最大尝试次数
    backend = auto            #日志修改检测机制（gamin、polling和auto这三种）

    [ssh-iptables]               #单个服务检查设置，如设置bantime、findtime、maxretry和全局冲突，服务优先级大于全局设置。
    enabled  = true             #是否激活此项（true/false）修改成 true
    filter   = sshd              #过滤规则filter的名字，对应filter.d目录下的sshd.conf
    action   = iptables[name=SSH, port=ssh, protocol=tcp]             #动作的相关参数，对应action.d/iptables.conf文件
    sendmail-whois[name=SSH, dest=you@example.com, sender=fail2ban@example.com, sendername="Fail2Ban"]#触发报警的收件人
    logpath  = /var/log/secure   #检测的系统的登陆日志文件。这里要写sshd服务日志文件。默认为logpath  = /var/log/sshd.log
    #5分钟内3次密码验证失败，禁止用户IP访问主机1小时。配置如下

    bantime  = 3600   #禁止用户IP访问主机1小时
    findtime  = 300    #在5分钟内内出现规定次数就开始工作
    maxretry = 3    #3次密码验证失败


开机自启动

.. code-block:: bash
    :linenos:

    systemctl enable fail2ban


启动

.. code-block:: bash
    :linenos:

    systemctl start fail2ban

重启ssh服务

.. code-block:: bash
    :linenos:

    systemctl restart sshd


查看fail2ban状态

.. code-block:: bash
    :linenos:

    systemctl status fail2ban


fail2ban测试

.. code-block:: bash
    :linenos:

    fail2ban-client ping


查看fail2ban日志

.. code-block:: bash
    :linenos:

    fail2ban-client status ssh-iptables

    tail /var/log/fail2ban.log

查看iptables添加的过滤条件

.. code-block:: bash
    :linenos:

    iptables -L


查看iptables过滤条件的添加命令

.. code-block:: bash
    :linenos:
    
    iptables -S









