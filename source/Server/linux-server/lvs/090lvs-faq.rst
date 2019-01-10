.. _lvs-faq:

======================================================================================================================================================
lvs常见问题汇总
======================================================================================================================================================

:Date: 2018-10

.. contents::



lvs裂脑
======================================================================================================================================================

导致裂脑发生的原因
    1. 高可用服务器之间心跳链路故障，导致无法相互检查心跳
    #. 高可用服务器上开启了防火墙，阻挡了心跳检测
    #. 高可用服务器上网卡地址等信息配置不正常，导致发送心跳失败
    #. 其他服务配置不当等原因，如心跳方式不同，心跳广播冲突，软件BUG等










编译报错：

.. code-block:: text
    :linenos:

    libipvs.c:526: note: expected ‘struct nlattr *’ but argument is of type ‘struct nlattr *’
    libipvs.c: In function ‘ipvs_get_dests’:
    libipvs.c:809: error: ‘NLM_F_DUMP’ undeclared (first use in this function)
    libipvs.c:813: warning: assignment makes pointer from integer without a cast
    libipvs.c:829: error: too many arguments to function ‘ipvs_nl_send_message’
    libipvs.c: In function ‘ipvs_get_service’:
    libipvs.c:939: error: too many arguments to function ‘ipvs_nl_send_message’
    libipvs.c: In function ‘ipvs_timeout_parse_cb’:
    libipvs.c:972: warning: initialization makes pointer from integer without a cast
    libipvs.c:986: error: ‘NL_OK’ undeclared (first use in this function)
    libipvs.c: In function ‘ipvs_get_timeout’:
    libipvs.c:1005: error: too many arguments to function ‘ipvs_nl_send_message’
    libipvs.c: In function ‘ipvs_daemon_parse_cb’:
    libipvs.c:1023: warning: initialization makes pointer from integer without a cast
    libipvs.c:1048: warning: passing argument 2 of ‘strncpy’ makes pointer from integer without a cast
    /usr/include/string.h:131: note: expected ‘const char * __restrict _ _’ but argument is of type ‘int’
    libipvs.c:1051: error: ‘NL_OK’ undeclared (first use in this function)
    libipvs.c: In function ‘ipvs_get_daemon’:
    libipvs.c:1071: error: ‘NLM_F_DUMP’ undeclared (first use in this function)
    libipvs.c:1072: error: too many arguments to function ‘ipvs_nl_send_message’
    make[1]: *** [libipvs.o] Error 1
    make[1]: Leaving directory ``/home/tools/ipvsadm-1.26/libipvs'``
    make: *** [libs] Error 2



由上面可以发现应该是lib库缺少


.. code-block:: bash
    :linenos:

    [root@lvs_01 ipvsadm-1.26]# yum install libnl* -y

编译发现错误

.. code-block:: text
    :linenos:

    ipvsadm.c:661: error: ‘POPT_BADOPTION_NOALIAS’ undeclared (first use in this function)
    ipvsadm.c:669: warning: implicit declaration of function ‘poptStrerror’
    ipvsadm.c:670: warning: implicit declaration of function ‘poptFreeContext’
    ipvsadm.c:677: warning: implicit declaration of function ‘poptGetArg’
    ipvsadm.c:367: warning: unused variable ‘options_table’
    ipvsadm.c: In function ‘print_largenum’:
    ipvsadm.c:1383: warning: field width should have type ‘int’, but argument 2 has type ‘size_t’
    make: *** [ipvsadm.o] Error 1

.. code-block:: bash
    :linenos:

    [root@lvs_01 ipvsadm-1.26]# yum install popt* -y



.. code-block:: bash
    :linenos:
    
    yum install libnl* popt* -y









