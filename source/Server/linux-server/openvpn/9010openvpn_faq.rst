
.. _server-linux-openvpn-faq:

======================================
OpenVPN常见问题解决汇总
======================================





.. code-block:: bash
    :linenos:

    [root@OpenVPN_001 2.0]# ./build-key-pass user101
    Generating a 1024 bit RSA private key
    .........++++++
    ................................++++++
    writing new private key to 'user101.key'
    Enter PEM pass phrase:
    140348621158216:error:28069065:lib(40):UI_set_result:result too small:ui_lib.c:869:You must type in 4 to 1024 characters
    140348621158216:error:0906406D:PEM routines:PEM_def_callback:problems getting password:pem_lib.c:111:
    140348621158216:error:0907E06F:PEM routines:DO_PK8PKEY:read key:pem_pk8.c:130:

重新再次运行生成账户就可以了

