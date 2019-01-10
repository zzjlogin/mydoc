
======================================================================================================================================================
Openssl
======================================================================================================================================================

:Date: 2018-09-02

.. contents::

ssl(secure socket layer)安全套接字协议，是一种应用层协议，主要用于传输数据加密，
而openssl是ssl协议的开源实现，是广泛使用的商业及ssl工具。

常见的加密算法和协议
======================================================================================================================================================

对称加密
------------------------------------------------------------------------------------------------------------------------------------------------------

对称加密： 加密和加密使用同一个秘钥，依赖于算法和秘钥，但其安全性依赖于秘钥而非算法。

常见对称加密算法：
    - DES 
    - 3DES 
    - AES 
    - Blowfish 
    - Twofish 
    - IDEA 
    - RC6 
    - CAST5 

对称加密的特点
    1. 加密和解密使用同一秘钥
    #. 将明文分割为固定大小的块，逐个进行加密
    #. 秘钥过多
    #. 密码分发复杂

非对称加密
------------------------------------------------------------------------------------------------------------------------------------------------------

非对称加密： 采用的是公钥加密方法，需要私钥来解密。公钥可以公开，私钥只能个人使用。 

特点：
    - 可以身份认证，私钥加密的，对应公钥才能解密
    - 公钥加密只能私钥解密，私钥加密只能公钥解密。
    - 秘钥长度较大

常要的非对称加密算法：
    - RSA 
    - DSA 
    - ELGamal

单向加密
------------------------------------------------------------------------------------------------------------------------------------------------------

只能加密，不能解密。

特点：
    - 定长输出
    - 同样数据，每次结果都一样
    - 不同数据，计算结果不同
    - 雪崩效应，数据修改一点点，结果变换很大
    - 不可逆


常见的单向加密算法
    - MD5 
    - SHA1
    - SHA256
    - SHA384
    - SHA512
    - CRC32

用处：
    - 数据完整性校验
    - 系统账号密码校验

秘钥交换
------------------------------------------------------------------------------------------------------------------------------------------------------

秘钥交互（internet key exchange）： 双方通过交互秘钥来实现数据加密解密。

交互方法：
    - 公钥加密
    - DH

一次加密通信过程
======================================================================================================================================================

发送方： 
    1. 使用单向加密算法提取生成数据的特征码
    #. 使用自己的私钥加密特征码放到数据后面
    #. 生成用于对称加密的临时秘钥
    #. 用临时秘钥来加密数据和私钥加密后的特征码
    #. 使用接受方的公钥加密临时秘钥，附加到对称加密后的数据后方

接受方：
    1. 使用自己的私钥解密临时秘钥，获取对称秘钥
    #. 使用对称秘钥解密数据，得到数据和特征码的密文
    #. 使用发送的公钥来解密特征码的密文，获取特征码
    #. 使用对方同样的单向加密算法来计算数据的特征码和获取到的特征码进行比较

数字证书
======================================================================================================================================================

ca是一个证书颁发机构，这个机构负责证书的颁发。

ca只是pki（public key infrastructure 公钥基础设施）的一个组成部分。pki包括：
    - 签证机构ca
    - 注册机构ra
    - 证书吊销列表crl
    - 证书存放库

数字证书格式：
    - 版本号
    - 序列号
    - 签名算法标志
    - 发行者的名称
    - 有效期
    - 证书主体名称
    - 证书主体公钥信息
    - 发行商的唯一标示
    - 证书主体的唯一标示
    - 扩展信息
    - 签名（ca对证书的签名）

证书样例： 

.. code-block:: text
    :linenos:

    [root@centos-155 CA]# openssl x509 -in cacert.pem -noout -text 
    Certificate:
        Data:
            Version: 3 (0x2)
            Serial Number:
                98:6c:25:23:b5:0a:bd:8c
        Signature Algorithm: sha256WithRSAEncryption
            Issuer: C=cn, ST=henan, L=nanyang, O=display, OU=opt, CN=ca.display.tk
            Validity
                Not Before: Feb 11 11:27:19 2018 GMT
                Not After : Feb  9 11:27:19 2028 GMT
            Subject: C=cn, ST=henan, L=nanyang, O=display, OU=opt, CN=ca.display.tk
            Subject Public Key Info:
                Public Key Algorithm: rsaEncryption
                    Public-Key: (2048 bit)
                    Modulus:
                        00:da:74:2d:f7:bd:ca:8f:ea:88:c0:f9:c4:1f:be:
                        80:7d:30:7e:ad:2a:dc:25:84:1f:3c:54:82:3a:f3:
                        ed:63:5f:93:5b:84:d1:24:58:32:12:cb:b5:ff:09:
                        07:06:fa:33:96:bf:4e:cf:10:b0:6c:2b:27:52:58:
                        38:76:d5:42:47:9c:cb:fc:f1:72:cf:22:f8:5a:f4:
                        a6:d5:58:b5:99:3f:ec:41:3f:09:63:d8:dd:ec:19:
                        1a:d2:59:f8:cb:7d:36:1d:0e:ef:cf:01:7c:53:49:
                        70:6d:1d:f3:da:44:dd:a0:c4:55:7b:d0:8b:b4:f7:
                        44:a5:29:13:b3:16:f9:8d:c9:0b:65:5c:d8:a1:95:
                        9a:57:95:e0:76:d5:13:a7:7a:46:d0:0e:3f:91:6e:
                        f3:de:ef:0b:b8:19:42:52:48:ea:fb:53:8d:c5:9f:
                        6f:f5:ad:f6:99:85:45:ec:02:1b:57:84:74:c8:16:
                        70:b4:17:c0:a2:80:83:e4:3a:46:07:91:72:45:7b:
                        53:24:b5:fc:d3:a2:a8:28:04:ce:38:e6:e5:0c:3e:
                        21:54:17:7a:40:fe:59:76:71:ab:e2:de:c2:eb:7e:
                        07:5f:8e:46:f5:da:a6:45:d7:cb:73:bf:05:f7:70:
                        5f:ab:e5:0a:0f:20:28:ac:80:75:88:eb:fe:83:77:
                        c6:1f
                    Exponent: 65537 (0x10001)
            X509v3 extensions:
                X509v3 Subject Key Identifier: 
                    67:61:B2:E8:29:18:2A:CD:80:6C:98:03:3F:80:DF:A4:85:06:A0:69
                X509v3 Authority Key Identifier: 
                    keyid:67:61:B2:E8:29:18:2A:CD:80:6C:98:03:3F:80:DF:A4:85:06:A0:69

                X509v3 Basic Constraints: 
                    CA:TRUE
        Signature Algorithm: sha256WithRSAEncryption
            ae:de:c6:64:88:8d:a1:8d:0d:86:8c:b5:ae:5e:20:eb:07:9c:
            dc:c1:68:17:28:f5:7c:e8:fa:c3:2d:24:7b:fe:34:73:fd:0f:
            1a:f6:51:1b:f4:2d:49:03:d3:24:ca:83:ac:8b:7e:df:bf:6c:
            56:f3:0c:76:30:31:76:a2:dd:7a:63:aa:7b:d4:55:49:a2:ae:
            aa:c3:5e:58:71:f7:43:9b:d3:11:4c:d8:1e:29:69:bc:77:b4:
            47:d6:eb:09:15:2b:a2:96:ba:11:1c:ba:c6:1b:ff:ed:02:15:
            3b:17:58:eb:f2:c8:66:c9:ef:02:a8:f0:8b:1a:67:91:07:b5:
            11:67:38:de:22:31:0b:0f:06:3c:14:39:ba:77:08:fe:3d:14:
            2d:ee:3d:5c:46:91:ce:67:10:4d:79:ce:b0:22:cd:81:70:14:
            b9:63:ba:79:23:80:24:0a:1d:18:92:9a:3f:d6:16:63:91:74:
            90:cc:0f:2b:87:ff:d1:22:63:ae:64:3f:eb:a2:94:78:6d:fc:
            3d:17:26:68:e4:88:a3:93:8a:15:10:2d:7c:db:d0:04:2d:89:
            f2:f8:26:aa:a2:b7:b4:74:01:61:dd:a7:15:6c:d7:ba:d9:4d:
            54:e5:df:b5:c1:55:5a:f8:ad:24:b8:89:f2:1f:98:45:4c:d4:
            3a:4f:61:97


ssl
======================================================================================================================================================

ssl(secure sockets layers 安全套接层) 是为网络通信提供安全及数据完整性的一种安全协议。

tls(translater layer secure 传输层安全) 是ssl的继承版本，与sslzai 传输层对网络连接进行加密。

openssl
======================================================================================================================================================

openssl是ssl的一个开源项目，由三部分组成。

加密文件
    des,3des,aes,blowfish ,twofish,idea,CAST5
单向加密
    md5,sha1,
生成用户密码
    passwd
生成随机数
    rand

样例： 

.. code-block:: bash
    :linenos:

    # 加密文件和解密文件
    [root@centos-155 ~]# cat /root/test.sh
    date
    df -h
    [root@centos-155 ~]# openssl  enc -e -a -salt -in /root/test.sh  -out /root/test.sh.enc
    [root@centos-155 ~]# cat /root/test.sh.enc
    ZGF0ZQpkZiAtaAo=
    [root@centos-155 ~]# openssl  enc -d -a -salt -out /root/test.sh.dec  -in /root/test.sh.enc
    [root@centos-155 ~]# cat /root/test.sh.dec 
    date
    df -h

    # 单向加密
    [root@centos-155 ~]# openssl dgst  /root/test.sh 
    MD5(/root/test.sh)= 220f72b1a4e636373d4b9310569cf027

    # 生成密码
    [root@centos-155 ~]# openssl passwd -1 
    Password: 
    Verifying - Password: 
    $1$QfprG3kQ$WrY4N1mbw4IdQc0uFyvBF/

    # 生成随机数
    [root@centos-155 ~]# openssl rand 24  -base64  | head -c 8
    VnNpgcFj

    # 生成公钥和秘钥
    VnNpgcFj[root@centos-155 ~]# openssl genrsa -out test 1024 
    [root@centos-155 ~]# ll test
    -rw-r--r-- 1 root root 887 Feb 11 19:16 test
    [root@centos-155 ~]# openssl rsa -in test -pubout  -out test.pub
    [root@centos-155 ~]# cat test.pub 
    -----BEGIN PUBLIC KEY-----
    MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC9agUiRyfROeBNy2ZPIduxwcwo
    mRssh2gMv7I7EIHA/GNKJiW8znjq/uuZDERD699+y9d1C8Q4sh761Za6ec0DU5eP
    QcTEuOByi4Dh34B6Ofco00d+30nku8AaXE+vBouE9oL95vJbYz0uCcVNXycZQL42
    qYmtfutw/Qnek44a1QIDAQAB
    -----END PUBLIC KEY-----

数字证书的获取
======================================================================================================================================================

生成证书
------------------------------------------------------------------------------------------------------------------------------------------------------

1. 生成自己的私钥

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# (umask 066; openssl genrsa -out /etc/pki/CA/private/cakey.pem 2048)

2. 给自己颁发证书

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# openssl req -new -x509 -key /etc/pki/CA/private/cakey.pem -out /etc/pki/CA/cacert.pem -days 3650

3. 查看辅助文件

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# cat /etc/pki/tls/openssl.cnf  |grep dir
    dir		= /etc/pki/CA		# Where everything is kept
    certs		= $dir/certs		# Where the issued certs are kept
    crl_dir		= $dir/crl		# Where the issued crl are kept
    database	= $dir/index.txt	# database index file.
    new_certs_dir	= $dir/newcerts		# default place for new certs.
    certificate	= $dir/cacert.pem 	# The CA certificate
    serial		= $dir/serial 		# The current serial number
    crlnumber	= $dir/crlnumber	# the current crl number
    crl		= $dir/crl.pem 		# The current CRL
    private_key	= $dir/private/cakey.pem# The private key
    RANDFILE	= $dir/private/.rand	# private random number file
    dir		= ./demoCA		# TSA root directory
    serial		= $dir/tsaserial	# The current serial number (mandatory)
    signer_cert	= $dir/tsacert.pem 	# The TSA signing certificate
    certs		= $dir/cacert.pem	# Certificate chain to include in reply
    signer_key	= $dir/private/tsakey.pem # The TSA private key (optional)

4. 创建辅助文件

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# touch /etc/pki/CA/index.txt 
    [root@centos-155 ~]# echo "01" >> /etc/pki/CA/serial


5. 节点生成自己的证书请求

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# (umask 066; openssl genrsa -out test 1024)
    [root@centos-155 ~]# openssl req -new -days 365 -key test -out test.csr

6. ca颁发证书

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# openssl ca -in test.csr -out /etc/pki/CA/certs/test.pem -days 300


吊销证书
------------------------------------------------------------------------------------------------------------------------------------------------------


1. 查看吊销证书编号

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# openssl x509 -in /etc/pki/CA/cacert.pem  -noout  -serial  -subject 
    serial=986C2523B50ABD8C
    subject= /C=cn/ST=henan/L=nanyang/O=display/OU=opt/CN=ca.display.tk

2. 吊销证书

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# openssl ca -revoke /etc/pki/CA/cacert.pem 

3. 生成吊销证书编号

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# echo 01 >> /etc/pki/CA/crlnumber

更新证书吊销列表






