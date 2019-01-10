.. _find-cmd:

======================================================================================================================================================
find
======================================================================================================================================================



:Date: 2018-09

.. contents::


.. _find-format:

命令格式
======================================================================================================================================================




.. _find-user:

所属用户
======================================================================================================================================================




.. _find-guid:

使用指导
======================================================================================================================================================




.. _find-args:

参数
======================================================================================================================================================



.. _find-instance:

参考实例
======================================================================================================================================================

根据用户和组信息查找文件
------------------------------------------------------------------------------------------------------------------------------------------------------

查找/var目录属主为root且属组为mail的所有文件：
    .. code-block:: bash
        :linenos:

        [root@zzjlogin ~]# find /var/ -user root -group mail
        /var/spool/mail
        [root@zzjlogin ~]# ll -d /var/spool/mail
        drwxrwxr-x. 2 root mail 4096 9月  23 2011 /var/spool/mail

查找/usr目录下不属于root，bin的文件：
    .. code-block:: bash
        :linenos:

        [root@zzjlogin ~]# find /usr/ -not \( -user root -o -user bin \)
        /usr/libexec/abrt-action-install-debuginfo-to-abrt-cache


根据访问时间找文件
------------------------------------------------------------------------------------------------------------------------------------------------------

查找/etc/目录下最近一周内其内容修改过的，且不属于bin且不属于ntp：
    .. code-block:: bash
        :linenos:

        [root@zzjlogin ~]# find /etc/ -mtime -7 -not -user bin -not -user ntp
        /etc/
        /etc/resolv.conf
        /etc/mtab
        /etc/adjtime
        /etc/prelink.cache

根据文件大小查找文件
------------------------------------------------------------------------------------------------------------------------------------------------------

查找/etc/目录不大于1M且类型为普通文件的所有文件，然后统计文件个数：
    .. code-block:: bash
        :linenos:

        [root@zzjlogin ~]# find /etc/ -size -$[1*1024*1024] -type f | wc -l
        944

根据文件权限查找文件
------------------------------------------------------------------------------------------------------------------------------------------------------

查找/etc/目录所有用户都没有写权限的文件
    .. code-block:: bash
        :linenos:

        [root@zzjlogin ~]# find /etc/ -not -perm /222 -ls
        30683    4 -r-xr-xr-x   1 root     root         1340 10月 16  2014 /etc/rc.d/init.d/blk-availability
        30685    4 -r-xr-xr-x   1 root     root         2757 10月 16  2014 /etc/rc.d/init.d/lvm2-monitor
        30684    4 -r-xr-xr-x   1 root     root         2134 10月 16  2014 /etc/rc.d/init.d/lvm2-lvmetad
        12334  236 -r--r--r--   1 root     root       240762 3月 30 17:34 /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem
        12336  188 -r--r--r--   1 root     root       191772 3月 30 17:34 /etc/pki/ca-trust/extracted/pem/objsign-ca-bundle.pem
        12335  188 -r--r--r--   1 root     root       191741 3月 30 17:34 /etc/pki/ca-trust/extracted/pem/email-ca-bundle.pem
        12333  316 -r--r--r--   1 root     root       321332 3月 30 17:34 /etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt
        12337  176 -r--r--r--   1 root     root       179212 3月 30 17:34 /etc/pki/ca-trust/extracted/java/cacerts
        29174    4 -r--r--r--   1 root     root          324 10月 15  2014 /etc/ld.so.conf.d/kernel-2.6.32-504.el6.x86_64.conf
        30679    4 -r--r--r--   1 root     root         2231 10月 16  2014 /etc/lvm/profile/command_profile_template.profile
        30681    4 -r--r--r--   1 root     root           76 9月  1  2014 /etc/lvm/profile/thin-generic.profile
        30682    4 -r--r--r--   1 root     root           80 9月  1  2014 /etc/lvm/profile/thin-performance.profile
        30680    4 -r--r--r--   1 root     root          827 10月 16  2014 /etc/lvm/profile/metadata_profile_template.profile
        31662    4 ----------   1 root     root          469 3月 30 17:39 /etc/gshadow
        129205    4 -r--------   1 root     root           45 3月 30 17:35 /etc/openldap/certs/password
        31587    4 -r--r-----   1 root     root         4002 3月  2  2012 /etc/sudoers
        613    4 ----------   1 root     root          699 3月 30 17:41 /etc/shadow-
        130    4 ----------   1 root     root          691 3月 30 17:44 /etc/shadow

查找/etc/init.d目录下，所有用户都有执行权限，且其他用户有写权限的文件
    .. code-block:: bash
        :linenos:

        [root@zzjlogin ~]# find /etc/init.d/ -perm -113

查找/etc目录下只有一类用户没有写权限的文件
    .. code-block:: bash
        :linenos:

        [root@zzjlogin ~]# find /etc/  \( -perm -220 -o -perm -202 -o -perm -022 \) -not -perm -222


.. _find-relevant:

相关命令
======================================================================================================================================================








