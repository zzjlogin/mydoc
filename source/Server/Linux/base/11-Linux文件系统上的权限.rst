Linux文件系统上的权限
=======================================
文件系统上的权限是指文件系统上文件和目录的权限，只要针对三种人群。

- owner 所有者
- group 所在组
- other 其他

权限分为三种： 

- r 读取
- w 写入
- x 执行

权限表如下:

.. csv-table:: 
   :header: "文件类型","r","w","x"
   :widths: 30,30,30,40

   "文件","可以查看文件内容","可以写入文件","可以提交内核执行"
   "目录","可以查看目录列表","可以在目录删除和添加文件","可以进入目录"

权限表示方法： 

.. csv-table:: 
   :header: "字母表示法","二进制法","数值法"
   :widths: 30,30,30

    "---","000","0"
    "--x","001","1"
    "-w-","010","2"
    "-wx","011","3"
    "r--","100","4"
    "r-x","101","5"
    "rw-","110","6"
    "rwx","111","7"


文件权限的修改chmod
----------------------------------------------------------------

修改权限方法有下面几种：

.. code-block:: bash

    #1 : 直接设置所有权限的
    chmod 644 file1
    chmod a=rwx,g=rw,o=--- file1
    #2 : 添加和去除权限的
    chmod a+x file1
    chmod o-x file1

可以指定"-R"选项来递归设置下。

文件所有者的修改chown
----------------------------------------------------------------

chown的使用案例

.. code-block:: bash

    # 修改属主和属组
    chown mysql.mysql file.txt
    # 修改属主
    chown mysql file.txt
    # 修改属组
    chown .mysql file.txt 
    # 修改属组
    chgrp mysql file.txt

.. note:: 文件的属主和属组仅root可以修改。

umask
----------------------------------------------------------------
遮罩码用于设置创建一个新的文件或者目录时候的默认权限。

- file: 666-umask
-  dir： 777-umask

.. note:: 如果相减只有还有x权限，就再对应权限为加1。

更详细的umask参考_

.. _更详细的umask参考: http://www.cnblogs.com/zhaojiedi1992/p/zhaojiedi_linux_001.html

umask查看和修改

.. code-block:: bash

    [root@centos-155 ~]# umask
    0022
    [root@centos-155 ~]# umask 0002
    [root@centos-155 ~]# umask
    0002
    [root@centos-155 ~]# umask 0022
    [root@centos-155 ~]# umask
    0022

特殊权限
--------------------------------------------------------------------

在linux文件系统上，有是三个特殊权限，suid,sgid,sticky。

安全上下文： 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
前提条件： 进程有属主和属组，文件有属主和属组。

#. 任何一个可执行程序文件能不能启动为进程，取决于发起者对程序文件是否有执行权限。
#. 启动为进程之后，其进程的属主为发起者，进程的属组为发起者所属组。
#. 进程访问文件时候的权限，取决于进程的发起者。
#. 进程的发起者同文件的属主，则应用文件的属主权限。
#. 进程的发起者同文件的属组，则应用文件的属组权限。
#. 应用文件其他位权限。

suid 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
前提： 此类文件有可执行权限的命令

#. 任何一个可执行程序文件能不能启动为进程，取决于发起者对程序文件是否拥有执行权限。
#. 启动为进程之后，其进程的属主为原有程序文件的属主

这个地方有点绕，给大家举个示例吧，如果一个程序文件passwd,属主root,属组root，且属主、
属组和其他人都有执行权限，且还有suid权限，那么zhao用户来执行这个命令的时候，对zhao来说
有执行权限，但是passwd这个进程起来的时候，进程的属主是root,而不是zhao。

权限设定和查看 

.. code-block:: bash

    [root@centos-155 bin]# cd /usr/bin                      # 进入bin目录
    [root@centos-155 bin]# ls -l vim                        # 查看默认权限信息
    -rwxr-xr-x. 1 root root 2289640 Aug  2  2017 vim
    [root@centos-155 bin]# chmod u+s vim                    # 添加suid
    [root@centos-155 bin]# ls -l vim                        # 查看
    -rwsr-xr-x. 1 root root 2289640 Aug  2  2017 vim
    [root@centos-155 bin]# chmod a-x vim                    # 去除执行权限
    [root@centos-155 bin]# ls -l vim                        # 查看
    -rwSr--r--. 1 root root 2289640 Aug  2  2017 vim
    [root@centos-155 bin]# chmod a+x vim                    # 恢复执行权限
    [root@centos-155 bin]# chmod u-s vim                    # 去除suid权限
    [root@centos-155 bin]# ls -l vim                        # 查看
    -rwxr-xr-x. 1 root root 2289640 Aug  2  2017 vim

通过上面的实验，可以看出来原有属主有执行权限的时候添加suid对应执行权限位为s,如果
原有属主没有执行权限的时候，添加suid对应的执行权限为S。

.. warning:: suid设置有风险，普通用户可以通过suid权限临时使用属主身份修改重要文件。慎用！

sgid
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
默认情况下，用户创建文件时候，其属组为此用户所属的基本组。 

一旦目录设置了sgid，则对此目录有写权限的用户在此目录创建的文件所属的组为此目录的属组。

权限的设定

.. code-block:: bash

    chmod g+s dir 
    chmod g-s dir

.. note:: 这个权限在团队开发中非常有用的， 一个目录，你创建的文件团队其他人没法访问是不是很尴尬。

sticky
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
对于一个多人可写的目录，如果设置了sticky,则每个用户仅能删除自己创建的文件。

权限的设定

.. code-block:: bash

    chmod o+t dir 
    chmod o-t dir 

.. note:: 这个权限在团队开发中是非常有用的，防止恶意删除别人的文件。

