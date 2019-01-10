.. _nfs-faq:

======================================================================================================================================================
nfs常见问题汇总
======================================================================================================================================================


:Date: 2018-09

.. contents::


nfs启动异常
======================================================================================================================================================

nfs服务器端nfs启动报错。出错误现象：

.. code-block:: bash
    :linenos:

    /etc/init.d/nfs start

    Starting NFS services:                                     [  OK  ]
    Starting NFS quotas: Cannot register service: RPC: Unable to receive; errno = Connection refused
    rpc.rquotad: unable to register (RQUOTAPROG, RQUOTAVERS, udp).
                                                                [FAILED]
    Starting NFS mountd:                                       [FAILED]
    Starting NFS daemon: rpc.nfsd: writing fd to kernel failed: errno 111 (Connection refused)
    rpc.nfsd: unable to set any sockets for nfsd
                                                                [FAILED]


上面报错提示信息可以知道是rpcbind服务异常。这种情况一般是rpcbind没有启动导致。可以通过命令启动rpcbind服务，然后再启动nfs服务即可。

启动rpcbind命令：

.. code-block:: bash
    :linenos:

    /etc/init.d/rpcbind start

nfs客户端检测不到nfs服务器端的服务
======================================================================================================================================================


故障现象1：

.. code-block:: bash
    :linenos:

    mount -t nfs 192.168.161.137:/data /mnt/
    clnt_create: RPC: Port mapper failure - Unable to receive: errno 113 (No route to host)

故障现象2：

.. code-block:: bash
    :linenos:

    showmount -e 192.168.161.137
    mount.nfs: Connection timed out


原因：
    这两种情况原因，一般是nfs服务器端防火墙没有关闭。或者nfs客户端到nfs服务器端中间有防火墙没有开对应的端口。
    
