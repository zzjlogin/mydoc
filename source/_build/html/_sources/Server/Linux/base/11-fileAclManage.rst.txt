
=======================================
Linux文件权限
=======================================

:Date: 2018-09-02

.. contents::

Linux文件权限说明
=======================================

文件所属用户信息
---------------------------------------

文件系统上的权限是指文件系统上文件和目录的权限，只要针对三种人群。

- owner 所有者
- group 所在组
- other 其他
- all 所有用户(是前面三种用户合称，是方便设置用户权限而设置的)

文件所属各种用户对应的权限
---------------------------------------

权限分为三种： 

- r 读取，read
- w 写入，write
- x 执行，execute

通过``ls -l``查看的结果说明：

.. image:: /images/server/linux/linuxfilels.png
    :align: center
    :alt: zzjlogin's image loss

文件权限说明：

.. image:: /images/server/linux/linuxfileprivilege.png
    :align: center
    :alt: zzjlogin's image loss

文件类型有一下几类：

- \-            普通文件
- d             目录文件
- b             块设备文件
- c             字符设备文件
- s             socket文件
- p             管道文件
- l             连接文件

权限表如下:

.. csv-table::
    :align: center
    :header: "文件类型","r","w","x"
    :widths: 30,30,30,40

    "文件","可以查看文件内容","可以写入文件","可以提交内核执行"
    "目录","可以查看目录列表","可以在目录删除和添加文件","可以进入目录"

权限表示方法： 

.. csv-table:: 
    :header: "字母表示法","二进制法","数值法"
    :widths: 30,30,30
    :align: center

    "---","000","0"
    "--x","001","1"
    "-w-","010","2"
    "-wx","011","3"
    "r--","100","4"
    "r-x","101","5"
    "rw-","110","6"
    "rwx","111","7"



文件权限的修改chmod
=======================================

修改权限方法有下面几种：

.. code-block:: bash
    :linenos:

    #1 : 直接设置所有权限的
    chmod 644 file1
    chmod a=rwx,g=rw,o=--- file1
    #2 : 添加和去除权限的
    chmod a+x file1
    chmod o-x file1

可以指定"-R"选项来递归设置下。

文件所有者的修改chown
=======================================

chown的使用案例

.. code-block:: bash
    :linenos:

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
=======================================

遮罩码用于设置创建一个新的文件或者目录时候的默认权限。

- file: 666-umask
-  dir： 777-umask

.. note:: 如果相减只有还有x权限，就再对应权限为加1。



umask查看和修改

.. code-block:: bash
    :linenos:

    [root@centos-155 ~]# umask
    0022
    [root@centos-155 ~]# umask 0002
    [root@centos-155 ~]# umask
    0002
    [root@centos-155 ~]# umask 0022
    [root@centos-155 ~]# umask
    0022

文件特殊权限
=======================================

在linux文件系统上，有是三个特殊权限，suid,sgid,sticky。

安全上下文： 
--------------------------------------------------------------------

前提条件： 进程有属主和属组，文件有属主和属组。

1. 任何一个可执行程序文件能不能启动为进程，取决于发起者对程序文件是否有执行权限。
#. 启动为进程之后，其进程的属主为发起者，进程的属组为发起者所属组。
#. 进程访问文件时候的权限，取决于进程的发起者。
#. 进程的发起者同文件的属主，则应用文件的属主权限。
#. 进程的发起者同文件的属组，则应用文件的属组权限。
#. 应用文件其他位权限。

0: 不设置特殊权限 
1: 只设置sticky 
2 : 只设置SGID 
3: 只设置SGID和sticky 
4 : 只设置SUID 
5 : 只设置SUID和sticky 
6 : 只设置SUID和SGID 
7 : 设置3种权限


suid 
--------------------------------------------------------------------

setuid 只对文件有效

前提： 此类文件有可执行权限的命令

#. 任何一个可执行程序文件能不能启动为进程，取决于发起者对程序文件是否拥有执行权限。
#. 启动为进程之后，其进程的属主为原有程序文件的属主

这个地方有点绕，给大家举个示例吧，如果一个程序文件passwd,属主root,属组root，且属主、
属组和其他人都有执行权限，且还有suid权限，那么zhao用户来执行这个命令的时候，对zhao来说
有执行权限，但是passwd这个进程起来的时候，进程的属主是root,而不是zhao。

权限设定和查看 

.. code-block:: bash
    :linenos:

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
--------------------------------------------------------------------

setgid 只对目录有效

默认情况下，用户创建文件时候，其属组为此用户所属的基本组。 

一旦目录设置了sgid，则对此目录有写权限的用户在此目录创建的文件所属的组为此目录的属组。

权限的设定

.. code-block:: bash
    :linenos:

    chmod g+s dir 
    chmod g-s dir

.. note:: 这个权限在团队开发中非常有用的， 一个目录，你创建的文件团队其他人没法访问是不是很尴尬。

sticky
--------------------------------------------------------------------

sticky只对文件有效

对于一个多人可写的目录，如果设置了sticky,则每个用户仅能删除自己创建的文件。

权限的设定

.. code-block:: bash
    :linenos:

    chmod o+t dir 
    chmod o-t dir 

.. note:: 这个权限在团队开发中是非常有用的，防止恶意删除别人的文件。

文件防篡改
=======================================

通过``chattr``命令锁定/解除文件锁定。通过``lsattr``命令查看文件是否锁定

.. hint:: chattr命令不能保护/、/dev、/tmp、/var目录

整理下chattr命令的用法：

::

    chattr [-RVf] [-+=AacDdeijsSu] [-v version] files...
    
    最关键的是[-+=AacDdeijsSu]这部分，它是用来控制文件的属性。与chmod这个命令相比，chmod只是改变文件的读写、执行权限，更底层的属性控制是由chattr来改变的。

    各参数选项中常用到的是a和i。a选项强制只可添加不可删除，多用于日志系统的安全设定。而i是更为严格的安全设定，只有superuser (root) 或具有CAP_LINUX_IMMUTABLE处理能力（标识）的进程能够施加该选项。

    +    在原有参数设定基础上，追加参数。
    -    在原有参数设定基础上，移除参数。
    =    更新为指定参数设定。
    A    文件或目录的atime(accesstime)不可被修改(modified),可以有效预防例如手提电脑磁盘I/O错误的发生。【可以重命名，可以删除，不可修改】
    a    即append，设定该参数后，只能向文件中添加数据，而不能删除内容和文件也不能修改文件名称，多用于服务器日志文件安全，只有root才能设定这个属性。【只能用>>重定向来追加内容】
    c    即compresse，设定文件是否经压缩后再存储。读取时需要经过自动解压操作。
    D    常见为目录属性，任何改变将同步到磁盘，相当于mount命令中的dirsync选项同步目录；检查压缩文件中的错误的功能。
    d    即nodump，设定文件不能成为dump程序的备份目标。
    e     (extent format)表示该文件使用ext文件系统存储，可以发现linux下几乎所有文件都有e这个隐藏属性。而且chattr-e这个命令是无法执行成功的，因为在manchattr中已经有了说明。
    i    (immutable)设定文件不能被删除、改名、设定链接关系，同时不能写入或新增内容。i参数对于文件系统的安全设置有很大帮助。
    j    即journal，设定此参数使得当通过mount参数data=ordered或者data=writeback挂载的文件系统，文件在写入时会先被记录(在journal中)。如果filesystem被设定参数为data=journal，则该参数自动失效。
    s    保密性地删除文件或目录，即硬盘空间被全部收回。
    S    (synchronous)硬盘I/O同步选项，功能类似sync，一旦应用程序对这个文件执行了写操作，使系统立刻把修改的结果写到磁盘。
    u    与s相反，当设定为u时，数据内容其实还存在磁盘中，可以用于undeletion。当一个应用程序请求删除这个文件，系统会保留其数据块以便以后能够恢复删除这个文件，用来防止意外删除文件或目录。
    
    隐藏属性:

    T    将被视为目录结构的顶极目录，这是为了Orlov块的分配
    t    它和其他文件合并时，该文件的末尾不会有部分块碎片(为支持尾部合并的文件系统使用)。
    X    用来标记一个能直接访问的裸内容压缩文件。目前它还不能使用chattr来设置或者重置，可以使用lsattr命令来显示。
    Z    用来标记一个脏的压缩文件。目前它还不能使用chattr来设置或者重置，可以使用lsattr命令来显示。
    
    其他:

    -R    递归处理，将指定目录下的所有文件及子目录一并处理。
    -V    显示指令执行过程。
    -f    显示错误信息。
    -v    <版本编号>设置文件或目录版本。

1. 可追加不可做其他修改和删除

    说明：
        设置+a参数以后可以用重定向“>>”向文件追加内容，不可删除和重命名，也不能用vi编辑，不可以用mv命令转移文件位置，可以用cp命令复制，但是不能复制+a属性。
        去掉a属性方法：把参数+a改为参数-a
    
    实例：

        .. code-block:: bash
            :linenos:

            [root@CaseServer ~]# ll
            total 4
            -rw-r--r-- 1 root root 23 Nov 25 17:27 test.txt
            [root@CaseServer ~]# lsattr 
            -------------e-- ./test.txt
            [root@CaseServer ~]# chattr +a test.txt
            [root@CaseServer ~]# lsattr 
            -----a-------e-- ./test.txt
            [root@CaseServer ~]# ll
            total 4
            -rw-r--r-- 1 root root 23 Nov 25 17:27 test.txt
            [root@CaseServer ~]# rm -rf test.txt
            rm: cannot remove ‘test.txt’: Operation not permitted

2. 不可更改不可删除锁定

    说明：
        设置+i参数以后文件不能修改和追加，也不能删除和重命名。
    
    实例：

        .. code-block:: bash
            :linenos:

            [root@CaseServer ~]# ll
            total 4
            -rw-r--r-- 1 root root 23 Nov 25 17:27 test.txt
            [root@CaseServer ~]# lsattr 
            -------------e-- ./test.txt
            [root@CaseServer ~]# chattr +i test.txt
            [root@CaseServer ~]# lsattr 
            ----i--------e-- ./test.txt
            [root@CaseServer ~]# echo "test" >> test.txt
            -bash: test.txt: Permission denied
            [root@CaseServer ~]# mv test.txt abc.txt
            mv: cannot move ‘test.txt’ to ‘abc.txt’: Operation not permitted
            [root@CaseServer ~]# chattr -i test.txt 
            [root@CaseServer ~]# lsattr 
            -------------e-- ./test.txt
