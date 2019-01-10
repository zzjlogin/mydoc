
.. _server-linux-zabbix-clients:

======================================================================================================================================================
zabbix不同系统客户端安装配置
======================================================================================================================================================



windows系统zabbix agent
======================================================================================================================================================

客户端下载地址：
    https://www.zabbix.com/download_agents

解压： ``zabbix_agents_3.4.6.win.zip``

1. 下载解压

解压后有两个文件目录：
    bin
        放置zabbix客户端程序，里面有32位系统程序和64位系统的
    conf
        目录下存放的是配置文件样例

2. 解压后创建zabbix程序目录
    在windows系统的C盘创建目录 ``zabbix``
3. 程序和配置文件目录转移
    把bin目录下的win64目录下的文件复制到上面创建的zabbix文件中(C:\zaabix)

    把conf目录下的 ``zabbix_agentd.win.conf`` 文件复制到C盘根目录。
    
.. tip::
    这个win64下主要有三个文件：
        - zabbix_agentd.exe
        - zabbix_get.exe
        - zabbix_sender.exe
        - zabbix3.4客户端会多一个dev文件

.. attention::
    zabbix_agentd.win.conf文件放在根目录zabbix启动的服务会自动匹配。如果放在其他目录zabbix服务需要用参数 ``-c`` 指定配置文件绝对路径。


4. zabbix客户端配置文件修改

    修改文件 ``zabbix_agentd.win.conf`` 文件名为 ``zabbix_agentd.conf``

5. 安装zabbix客户端

    用管理员运行命理提示符(cmd)，然后按照下面操作：

    C:\Windows\system32>cd C:\zabbix

    C:\zabbix>zabbix_agentd.exe --install
    zabbix_agentd.exe [193644]: service [Zabbix Agent] installed successfully
    zabbix_agentd.exe [193644]: event source [Zabbix Agent] installed successfully

.. attention::
    如果cmd不是用管理员运行，那么运行 ``zabbix_agentd.exe --install`` 会报错。


6. 设置自定义监控项

    把windows可以设置的监控项输出到文件中，方便后序设置监控项：

    C:\zabbix>typeperf -qx >monitoritems.txt

    此时windows的C盘的zabbix文件夹会有一个文件：monitoritems.txt

    这个文件中是所有可以在客户端设置的监控项。

    如果寻找某些项例如网卡的启动配置可以参考：
        typeperf -qx | find "Network Interface" | find "Bytes"


7. 设置zabbix客户端开机自启动及防火墙设置

    客户端开机自启动：
        - win+R调出运行窗口输入gpedit.msc进入组策略界面
        - 系统工具——人物激活程序库——创建任务
        - 常规页面注意选择 **不管用户是否登陆都运行**
        - 触发器选择 ``启动时`` ，操作选择脚本写入：``c:\zabbix\zabbix_agentd.exe -c c:\zabbix_agentd.conf -s``

    .. attention::
        默认zabbix安装后会自动开机启动，但是如果没有开机自动启动可以参考上面配置设置开机自启动。

    防火墙设置：
        控制面板--选择windows 防火墙--高级设置--设置入站规则--新建规则


8. zabbix客户端相关参考

zabbix_agentd.exe命令说明:
      -c    制定配置文件所在位置
      -i    安装客户端
      -s    启动客户端
      -x    停止客户端
      -d    卸载客户端

9. zabbix客户端启动脚本

脚本内容：

.. code-block:: text
    :linenos:

    @echo off

    CHCP 65001

    echo ****************************************

    echo *****Zabbix Agentd Operation************

    echo ****************************************

    echo ** a. start Zabbix Agentd********

    echo ** b. stop Zabbix Agentd********

    echo ** c. restart Zabbix Agentd********

    echo ** d. install Zabbix Agentd********

    echo ** e. uninstall Zabbix Agentd********

    echo ** f. exit Zabbix Agentd********

    echo ****************************************

    :loop

    choice /c abcdef /M "please choose"

    if errorlevel 6 goto :exit 

    if errorlevel 5 goto uninstall

    if errorlevel 4 goto install

    if errorlevel 3 goto restart

    if errorlevel 2 goto stop

    if errorlevel 1 goto start

    :start

    c:\zabbix\zabbix_agentd.exe -c c:\zabbix_agentd.conf -s

    goto loop

    :stop

    c:\zabbix\zabbix_agentd.exe -c c:\zabbix_agentd.conf -x

    goto loop

    :restart

    c:\zabbix\zabbix_agentd.exe -c c:\zabbix_agentd.conf -x

    c:\zabbix\zabbix_agentd.exe -c c:\zabbix_agentd.conf -s

    goto loop

    :install

    c:\zabbix\zabbix_agentd.exe -c c:\zabbix_agentd.conf -i

    goto loop

    :uninstall

    c:\zabbix\zabbix_agentd.exe -c c:\zabbix_agentd.conf -d

    goto loop

    :exit

    exit


Linux系统zabbix agent
======================================================================================================================================================



客户端环境：
    - 系统： 和服务器端一致(可以不一致)
    - 客户端软件: zabbix-agent


.. code-block:: bash
    :linenos:

    [root@client ~]# rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
    Retrieving https://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
    Preparing...                ########################################### [100%]
    1:zabbix-release         ########################################### [100%]

    [root@client ~]# yum install zabbix-agent -y
    Loaded plugins: fastestmirror, security
    Setting up Install Process
    Loading mirror speeds from cached hostfile
    * base: mirror.bit.edu.cn
    * extras: mirror.bit.edu.cn
    * updates: mirrors.tuna.tsinghua.edu.cn
    Resolving Dependencies
    --> Running transaction check
    ---> Package zabbix-agent.x86_64 0:3.4.14-1.el6 will be installed
    --> Finished Dependency Resolution

    Dependencies Resolved

    =========================================================================================================================
    Package                        Arch                     Version                          Repository                Size
    =========================================================================================================================
    Installing:
    zabbix-agent                   x86_64                   3.4.14-1.el6                     zabbix                   362 k

    Transaction Summary
    =========================================================================================================================
    Install       1 Package(s)

    Total size: 362 k
    Installed size: 1.4 M
    Downloading Packages:
    warning: rpmts_HdrFromFdno: Header V4 RSA/SHA512 Signature, key ID a14fe591: NOKEY
    Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
    Importing GPG key 0xA14FE591:
    Userid : Zabbix LLC <packager@zabbix.com>
    Package: zabbix-release-3.4-1.el6.noarch (installed)
    From   : /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
    Running rpm_check_debug
    Running Transaction Test
    Transaction Test Succeeded
    Running Transaction
    Warning: RPMDB altered outside of yum.
    Installing : zabbix-agent-3.4.14-1.el6.x86_64                                                                      1/1 
    Verifying  : zabbix-agent-3.4.14-1.el6.x86_64                                                                      1/1 

    Installed:
    zabbix-agent.x86_64 0:3.4.14-1.el6                                                                                     

    Complete!

客户端配置：

.. code-block:: bash
    :linenos:

    [root@client ~]# cp -a /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.`date '+%F'`
    [root@client ~]# sed -ir 's#^Server=127.0.0.1#Server=192.168.161.132#g' /etc/zabbix/zabbix_agentd.conf
    [root@client ~]# grep "Server=192.168.161.132" /etc/zabbix/zabbix_agentd.conf
    Server=192.168.161.132

.. attention::
    如果配置客户端主动向zabbix服务器注册需要添加： ``sed -ir 's#^ServerActive=127.0.0.1#ServerActive=192.168.161.132#g' /etc/zabbix/zabbix_agentd.conf``
    zabbix服务器也需要添加对应的action。
    
启动客户端：

.. code-block:: bash
    :linenos:

    [root@client ~]# /etc/init.d/zabbix-agent start
    Starting Zabbix agent:                                     [  OK  ]

开机自启动zabbix客户端：

方法1：

.. code-block:: bash
    :linenos:

    [root@client ~]# chkconfig zabbix-agent on

方法2：


.. code-block:: bash
    :linenos:

    [root@client ~]# echo '############################' >>/etc/rc.local
    [root@client ~]# echo '#add by zzj at 20180930' >>/etc/rc.local
    [root@client ~]# echo '/etc/init.d/zabbix-agent start' >>/etc/rc.local

zabbix客户端安装配置命令集合
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: bash
    :linenos:

    rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
    yum install zabbix-agent -y
    cp -a /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.`date '+%F'`

    sed -ir 's#^Server=127.0.0.1#Server=192.168.161.132#g' /etc/zabbix/zabbix_agentd.conf
    grep "Server=192.168.161.132" /etc/zabbix/zabbix_agentd.conf

    /etc/init.d/zabbix-agent start
    echo '############################' >>/etc/rc.local
    echo '#add by zzj at 20180930' >>/etc/rc.local
    echo '/etc/init.d/zabbix-agent start' >>/etc/rc.local



