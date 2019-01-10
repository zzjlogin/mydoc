
.. _openldap-config:

======================================================================================================================================================
openldap配置
======================================================================================================================================================


日志设置

参考：
    http://www.openldap.org/doc/admin24/guide.html#cn=config
    

.. code-block:: bash
    :linenos:

    [root@ldap_001 openldap]# slapd -d ?
    Installed log subsystems:

            Any                            (-1, 0xffffffff)
            Trace                          (1, 0x1)
            Packets                        (2, 0x2)
            Args                           (4, 0x4)
            Conns                          (8, 0x8)
            BER                            (16, 0x10)
            Filter                         (32, 0x20)
            Config                         (64, 0x40)
            ACL                            (128, 0x80)
            Stats                          (256, 0x100)
            Stats2                         (512, 0x200)
            Shell                          (1024, 0x400)
            Parse                          (2048, 0x800)
            Sync                           (16384, 0x4000)
            None                           (32768, 0x8000)

    NOTE: custom log subsystems may be later installed by specific code

详解：
    Any (-1, 0xffffffff)
        开启所有的dug信息
    Trace (1, 0x1)
        跟踪trace函数调用
    Packets (2, 0x2)
        与软件包的处理相关的dug信息
    Args (4, 0x4)
        全面的debug信息
    Conns (8, 0x8)
        链接数管理的相关信息
    BER (16, 0x10)
        记录包发送和接收的信息
    Filter (32, 0x20)
        记录过滤处理的过程
    Config (64, 0x40)
        记录配置文件的相关信息
    ACL (128, 0x80)
        记录访问控制列表的相关信息
    Stats (256, 0x100)
        记录链接、操作以及统计信息
    Stats2 (512, 0x200)
        记录向客户端响应的统计信息
    Shell (1024, 0x400)
        记录与shell后端的通信信息
    Parse (2048, 0x800)
        记录条目的分析结果信息
    Sync (16384, 0x4000)
        记录数据同步资源消耗的信息
    None (32768, 0x8000)
        不记录


