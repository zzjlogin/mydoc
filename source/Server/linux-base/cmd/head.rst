.. _head-cmd:

======================================================================================================================================================
head
======================================================================================================================================================



:Date: 2018-09

.. contents::


.. _head-format:

命令格式
======================================================================================================================================================




.. _head-user:

所属用户
======================================================================================================================================================




.. _head-guid:

使用指导
======================================================================================================================================================




.. _head-args:

参数
======================================================================================================================================================



.. _head-instance:

参考实例
======================================================================================================================================================


取出/etc/passwd 文件中的第6行至第10行，并将这些信息按第3个字段数值进行排序，最后显示进显示第一个字段

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# head -n 10 /etc/passwd | tail -n 5 | sort -t ":" -k 3 | cut -d ":" -f 1
    uucp
    sync
    shutdown
    halt
    mail

将/etc/passwd 文件的前5行内容转化为大写后保存到/tmp/passwd.out文件 

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# head -n 5 /etc/passwd |tr 'a-z' 'A-Z' > /tmp/passwd.out

.. _head-relevant:

相关命令
======================================================================================================================================================








