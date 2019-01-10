
.. _file-manage:

======================================================================================================================================================
Linux文件管理
======================================================================================================================================================

:Date: 2018-09-02

.. contents::


linux中文件删除原理
======================================================================================================================================================

Linux系统中文件受两个条件控制：
    - i_count
    - i_nlink
i_count
    意义是当前文件使用者（或被调用）的数量
i_nlink
    意义是介质连接的数量（硬链接的数量)

.. tip:: 可以理解为i_count是内存引用计数器即文件正在被几个程序使用，i_nlink是磁盘的引用计数器。

当一个文件被某一个进程引用时
    对应i_count数就会增加。
当创建文件的硬链接的时候
    对应i_nlink数就会增加。

对于删除命令rm而言，实际就是减少磁盘引用计数i_nlink(或者说置0)。当i_count也是0时，文件才真的被释放。

如果一个程序正在使用一个文件。此时用rm删除这个文件。再通过ls查看会发现文件已经删除。但是程序还可以继续读取这个文件。此时是因为：i_count不为0，所以文件并没有真的被释放。
此时磁盘的空间也没有被释放。这种问题常出现再web服务器没有日志删除但是磁盘空间依然没有改变的情况。此时可以通过重启对应的占用文件的程序即可。

通过命令可以查看到没有被释放的文件：

.. code-block:: bash
    :linenos:

    lsof |grep delete


Linux文件系统中区块和inode
======================================================================================================================================================

操作系统在挂载一个硬盘时需要先格式化。

在格式化的过程中，操作系统会把硬盘分为两部分。一部分是inode，一部分是block。

文件存储都是存储在block中。一个block一般默认时4K，这就是为什么创建一个文件即使是空文件也占用4k空间。
因为一个文件至少占用一个block。而block是linux操作系统识别的最小的存储单元。


inode介绍
------------------------------------------------------------------------------------------------------------------------------------------------------

inode包含文件的元信息，具体来说有以下内容：
　　* 文件的字节数
　　* 文件拥有者的User ID
　　* 文件的Group ID
　　* 文件的读、写、执行权限
　　* 文件的时间戳，共有三个：ctime指inode上一次变动的时间，mtime指文件内容上一次变动的时间，atime指文件上一次打开的时间。
　　* 链接数，即有多少文件名指向这个inode
　　* 文件数据block的位置

查看文件inode信息:

可以用stat命令，查看某个文件的inode信息：

.. code-block:: bash

　　stat example.txt

也可以用命令ls:

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# ls -i hello.sh
    25984 hello.sh

查看硬盘/存储的inode数量信息:

.. code-block:: bash
    :linenos:

    df -i

.. attention::
    每个目录项，由两部分组成：所包含文件的文件名，以及该文件名对应的inode号码。




inode是当存储文件时，一个文件对应一般对应一个inode，正如我们日常常见的场景。很多文件都比4k大(排除特殊的小文件特别多的情况)
所以inode都比block数量少。而且一个inode的大小默认大小128byte（C58），256byte（C64）。

.. attention:: 如果有硬连接则一个inode可以指向多个文件，创建硬连接的方法参考ln用法。简单举例: ln src.txt dest

查看操作系统inode大小：

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# dumpe2fs -h /dev/sda3 | grep "Inode size"
    dumpe2fs 1.41.12 (17-May-2010)
    Inode size:               256
    [root@zzjlogin ~]# dumpe2fs -h /dev/sda1 | grep "Inode size"
    dumpe2fs 1.41.12 (17-May-2010)
    Inode size:               128
    [root@zzjlogin ~]# df -h
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/sda3       2.5G  1.7G  621M  74% /
    tmpfs           491M     0  491M   0% /dev/shm
    /dev/sda1       477M   28M  424M   7% /boot


Linux操作系统把文件名和文件分离开，操作系统识别文件是通过inode号来识别文件。
所以有一些特殊情况:

-  有时，文件名包含特殊字符，无法正常删除。这时，直接删除inode节点，就能起到删除文件的作用。
    删除命令: ``find ./* -inum 1049741 |xargs rm -f`` 或者 ``find ./* -inum 1049741 -delete``
    或者 ``find ./* -inum 1049741 -exec rm -i {} \;``
- 移动文件或重命名文件，只是改变文件名，不影响inode号码。
- 打开一个文件以后，系统就以inode号码来识别这个文件，不再考虑文件名。因此，通常来说，系统无法从inode号码得知文件名。



block介绍
------------------------------------------------------------------------------------------------------------------------------------------------------



如果/var分区的Superblock损坏了，那么/var分区将无法挂载。在这时候，一般会执行fsck来自动选择一份Superblock备份来替换损坏的Superblock，并尝试修复文件系统。
主Superblock存储在分区的block0或者block1中，而Superblock的备份则分散存储在文件系统的多组block中。当需要手工恢复时，我们可以使用

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# dumpe2fs /dev/sda1 | grep -i superblock
    dumpe2fs 1.41.12 (17-May-2010)
        主 superblock at 1, Group descriptors at 2-3
        备份 superblock at 8193, Group descriptors at 8194-8195
        备份 superblock at 24577, Group descriptors at 24578-24579
        备份 superblock at 40961, Group descriptors at 40962-40963
        备份 superblock at 57345, Group descriptors at 57346-57347
        备份 superblock at 73729, Group descriptors at 73730-73731
        备份 superblock at 204801, Group descriptors at 204802-204803
        备份 superblock at 221185, Group descriptors at 221186-221187
        备份 superblock at 401409, Group descriptors at 401410-401411
    [root@zzjlogin ~]# dumpe2fs /dev/sda3 | grep -i superblock 
    dumpe2fs 1.41.12 (17-May-2010)
        主 superblock at 0, Group descriptors at 1-1
        备份 superblock at 32768, Group descriptors at 32769-32769
        备份 superblock at 98304, Group descriptors at 98305-98305
        备份 superblock at 163840, Group descriptors at 163841-163841
        备份 superblock at 229376, Group descriptors at 229377-229377
        备份 superblock at 294912, Group descriptors at 294913-294913



指定block大小和inode数量
------------------------------------------------------------------------------------------------------------------------------------------------------

可以格式化的时候指定硬盘的block默认大小和inode数量

通过 ``mkfs.ext`` 格式化并指定block和inode信息。

指定block默认大小为8K,每16k创建一个inode:

.. code-block:: bash
    :linenos:
    
    [root@zzjlogin ~]# mkfs.ext4 -b 8192 -i 16384 /dev/sdb


mkfs.ext主要参数:
    b   指定block默认大小
    f   fragment-size
    i   bytes-per-inode
    I   inode-size


硬链接
------------------------------------------------------------------------------------------------------------------------------------------------------

一般情况下一个文件名和inode号码是一一对应的。多个文件名指向同一个inode就是硬链接。

ln 源文件   目标文件

软连接
------------------------------------------------------------------------------------------------------------------------------------------------------

软连接文件和源文件的inode是不同的， 软连接文件存储的是相对应源文件的路径。

ln -s 源文件   目标文件

