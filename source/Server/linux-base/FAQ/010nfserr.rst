.. _server-linux-nfserr:

======================================================================================================================================================
nfs报错汇总
======================================================================================================================================================


rpcbind没有启动导致nfs启动异常
======================================================================================================================================================

故障现象：

.. code-block:: bash
    :linenos:

    [root@Server ~]# /etc/init.d/nfs start
    Starting NFS services:                                     [  OK  ]
    Starting NFS quotas: Cannot register service: RPC: Unable to receive; errno = Connection refused
    rpc.rquotad: unable to register (RQUOTAPROG, RQUOTAVERS, udp).
                                                            [FAILED]
    Starting NFS mountd:                                       [FAILED]
    Starting NFS daemon: 


解决方法：

先启动rpcbind服务。

.. code-block:: bash
    :linenos:

    [root@Server ~]# /etc/init.d/rpcbind start
    Starting rpcbind:                                          [  OK  ]
    [root@Server ~]# /etc/init.d/nfs restart
    Shutting down NFS daemon:                                  [FAILED]
    Shutting down NFS mountd:                                  [FAILED]
    Shutting down NFS quotas:                                  [FAILED]
    Starting NFS services:                                     [  OK  ]
    Starting NFS quotas:                                       [  OK  ]
    Starting NFS mountd:                                       [  OK  ]
    Starting NFS daemon:                                       [  OK  ]
    Starting RPC idmapd:                                       [  OK  ]
    [root@Server ~]# 

