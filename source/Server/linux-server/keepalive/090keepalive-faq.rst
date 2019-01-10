.. _keepalived-faq:

======================================================================================================================================================
keepalived常见问题汇总
======================================================================================================================================================

:Date: 2018-10

.. contents::


命令 ``./configure`` 报错：

.. code-block:: text
    :linenos:

    checking for sys/time.h... yes
    checking openssl/ssl.h usability... no
    checking openssl/ssl.h presence... no
    checking for openssl/ssl.h... no
    configure: error:
    !!! OpenSSL is not properly installed on your system. !!!
    !!! Can not include OpenSSL headers files.            !!!

解决办法：

.. code-block:: bash
    :linenos:

    [root@lvs_01 keepalived-1.1.19]# yum install openssl openssl-devel -y