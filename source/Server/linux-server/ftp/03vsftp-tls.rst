.. _vsftpd-ssl:

======================================================================================================================================================
vsftpd-ssl
======================================================================================================================================================

安装vsftpd
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    [root@centos-7 vsftpd]$yum install vsftpd -y

修改配置项
======================================================================================================================================================

配置文件中加入下面配置参数，

.. attention::
     ``vsftpd.pem`` 路径和对应的生成的文件路径应该一致。

.. code-block:: bash
    :linenos:

    [root@centos-7 vsftpd]$vim vsftpd.con
    ########################################################################
    #  创建完毕后自己的配置
    ########################################################################

    ssl_enable=YES
    allow_anon_ssl=NO
    force_local_logins_ssl=YES
    force_local_data_ssl=YES
    rsa_cert_file=/etc/pki/tls/certs/vsftpd.pem

修改后的配置文件内容：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# cat /etc/vsftpd/vsftpd.conf
    anonymous_enable=YES
    anon_mkdir_write_enable=NO
    anon_upload_enable=NO
    chroot_local_user=YES
    local_enable=YES
    xferlog_enable=YES
    xferlog_std_format=YES
    xferlog_file=/var/log/vsftpd.log
    vsftpd_log_file=/var/log/vsftpd.log
    write_enable=YES
    local_umask=022
    dirmessage_enable=YES
    connect_from_port_20=YES
    listen=YES
    pam_service_name=vsftpd
    userlist_enable=YES
    tcp_wrappers=YES
    ftp_data_port=2000
    ssl_enable=YES
    allow_anon_ssl=NO
    force_local_logins_ssl=YES
    force_local_data_ssl=YES
    rsa_cert_file=/etc/pki/tls/certs/vsftpd.pem



创建证书和私钥文件
======================================================================================================================================================

.. attention::
    因为是自己创建的，所以一般如果用更浏览器访问ftp，会提示不安全。就是因为证书不是可信的。不过没有关系。

创建整数密钥文件

.. code-block:: text
    :linenos:

    [root@centos-7 certs]$cd /etc/pki/tls/certs/ 
    root@centos-7 certs]$make vsftpd.pem
    umask 77 ; \
            PEM1=`/bin/mktemp /tmp/openssl.XXXXXX` ; \
            PEM2=`/bin/mktemp /tmp/openssl.XXXXXX` ; \
            /usr/bin/openssl req -utf8 -newkey rsa:2048 -keyout $PEM1 -nodes -x509 -days 365 -out $PEM2 -set_serial 0 ; \
            cat $PEM1 >  vsftpd.pem ; \
            echo ""    >> vsftpd.pem ; \
            cat $PEM2 >> vsftpd.pem ; \
            rm -f $PEM1 $PEM2
    Generating a 2048 bit RSA private key
    ..+++
    .........................+++
    writing new private key to '/tmp/openssl.kQloxz'
    -----
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [XX]:cn
    State or Province Name (full name) []:sd
    Locality Name (eg, city) [Default City]:qd
    Organization Name (eg, company) [Default Company Ltd]:display
    Organizational Unit Name (eg, section) []:it
    Common Name (eg, your name or your server's hostname) []:*.display
    Email Address []:

查看创建的文件

.. code-block:: text
    :linenos:

    [root@centos-7 certs]$ll
    总用量 1772
    -rw-r--r--. 1 root root  786601 7月  14 2014 ca-bundle.crt
    -rw-r--r--. 1 root root 1005005 7月  14 2014 ca-bundle.trust.crt
    -rwxr-xr-x. 1 root root     610 10月 15 2014 make-dummy-cert
    -rw-r--r--. 1 root root    2242 10月 15 2014 Makefile
    -rwxr-xr-x. 1 root root     829 10月 15 2014 renew-dummy-cert
    -rw-------. 1 root root    2982 9月  10 21:18 vsftpd.pem

测试
======================================================================================================================================================

这里在windows环境下使用 filezilla_ 软件进行测试。

.. _filezilla: https://filezilla-project.org/

.. image:: /Server/res/images/server/linux/ftp/ftp-ssl-client01.png
    :align: center
    :height: 500 px
    :width: 800 px


.. image:: /Server/res/images/server/linux/ftp/ftp-ssl-client02.png
    :align: center
    :height: 500 px
    :width: 800 px

.. image:: /Server/res/images/server/linux/ftp/ftp-ssl-client03.png
    :align: center
    :height: 500 px
    :width: 800 px