
.. _linux-filesys:

======================================================================================================================================================
Linux文件系统入门
======================================================================================================================================================

:Date: 2018-09-02

.. contents::


传统文件系统
======================================================================================================================================================


linux
    ext2,ext3,ext4,xfs,btrfs,reiserfs,jfs
光盘
    iso9660
window
    fat32,vsfat,ntfs
unix
    FFS,UFS,JFS2
网络文件系统
    NFS,CIFS
集群文件系统
    GFS2,OCFS2
分布式文件系统
    FASTDFSceph,glusterfs
RAW
    裸设备

------------------------------------------------------------------------------------------------------------------------------------------------------

Windows常用的分区格式有三种，分别是FAT16、FAT32、NTFS格式。 [1]_

在Linux操作系统里有Ext2、Ext3、Linux swap和VFAT、xfs五种格式。

FAT16:
    作为一种文件名称，FAT(File Allocation Table，文件分配表)自1981年问世以来，已经成为一个计算机术语。
    由于时代的原因，包括Windows、MacOS以及多种Unix版本在内的大多数操作系统均对FAT提供支持。
    这是MS-DOS和最早期的Windows 95操作系统中使用的磁盘分区格式。它采用16位的文件分配表，是目前获得操作系统支持最多的一种磁盘分区格式，几乎所有的操作系统都支持这种分区格式，从DOS、Windows 95、Windows OSR2到现在的Windows 98、Windows Me、Windows NT、Windows 2000、Windows XP都支持FAT16，但只支持2GB的硬盘分区成为了它的一大缺点。FAT16分区格式的另外一个缺点是：磁盘利用效率低（具体的技术细节请参阅相关资料）。
    为了解决这个问题，微软公司在Windows 95 OSR2中推出了一种全新的磁盘分区格式——FAT32。

FAT32:
    这种格式采用32位的文件分配表，对磁盘的管理能力大大增强，突破了FAT16下每一个分区的容量只有2GB的限制。由于现在的硬盘生产成本下降，其容量越来越大，运用FAT32的分区格式后，我们可以将一个大容量硬盘定义成一个分区而不必分为几个分区使用，大大方便了对磁盘的管理。而且，FAT32与FAT16相比，可以极大地减少磁盘的浪费，提高磁盘利用率。目前，Windows 95 OSR2以后的操作系统都支持这种分区格式。但是，这种分区格式也有它的缺点。首先是采用FAT32格式分区的磁盘，由于文件分配表的扩大，运行速度比采用FAT16格式分区的磁盘要慢。另外，由于DOS和Windows 95不支持这种分区格式，所以采用这种分区格式后，将无法再使用DOS和Windows 95系统。
NTFS:
    为了弥补FAT在功能上的缺陷，微软公司创建了一种称作NTFS的文件系统技术。它的优点是安全性和稳定性方面非常出色，在使用中不易产生文件碎片。并且能对用户的操作进行记录，通过对用户权限进行非常严格的限制，使每个用户只能按照系统赋予的权限进行操作，充分保护了系统与数据的安全。Windows 2000、Windows NT、以及Windows XP都支持这种分区格式。
Ext2:
    Ext2是GNU/Linux系统中标准的文件系统。这是Linux中使用最多的一种文件系统，它是专门为Linux设计的，拥有极快的速度和极小的CPU占用率。Ext2既可以用于标准的块设备(如硬盘)，也被应用在软盘等移动存储设备上。 Ext3： Ext3是Ext2的下一代，也就是保有Ext2的格式之下再加上日志功能。Ext3是一种日志式文件系统（Journal File System),最大的特点是：它会将整个磁盘的写入动作完整的记录在磁盘的某个区域上，以便有需要时回溯追踪。当在某个过程中断时，系统可以根据这些记录直接回溯并重整被中断的部分，重整速度相当快。该分区格式被广泛应用在Linux系统中。
Ext3:
    现在一般CentOS5.X默认是ext3文件系统。从CentOS6开始默认是Ext4。
Ext4 [2]_: 
    适用于视频下载、流媒体、数据库、小文件业务也可以。CentOS6默认的文件系统。

    [测试性能]_ 更大的文件系统和更大的文件。较之 Ext3 目前所支持的最大 16TB 文件系统和最大 2TB 文件，Ext4 分别支持 1EB（1,048,576TB， 1EB=1024PB， 1PB=1024TB）的文件系统，以及 16TB 的文件。
    无限数量的子目录。Ext3 目前只支持 32,000 个子目录，而 Ext4 支持无限数量的子目录。用间接块映射，当操作大文件时，效率极其低下。比如一个 100MB 大小的文件，在 Ext3 中要建立 25,600 个数据块（每个数据块大小为 4KB）的映射表。而 Ext4 引入了现代文件系统中流行的 extents 概念，每个 extent为一组连续的数据块，上述文件则表示为“ 该文件数据保存在接下来的 25,600 个数据块中”，提高了不少效率。
    Ext4 的日志校验功能可以很方便地判断日志数据是否损坏，而且它将 Ext3 的两阶段日志机制合并成一个阶段，在增加安全性的同时提高了性能。
    日志总归有一些开销，Ext4 允许关闭日志，以便某些有特殊需求的用户可以借此提升性能。
    Ext4 支持在线碎片整理，并将提供 e4defrag 工具进行个别文件或整个文件系统的碎片整理。
    Ext4 支持更大的 inode，较之 Ext3 默认的 inode 大小 128 字节，Ext4为了在inode中容纳更多的扩展属性（如纳秒时间戳或inode版本），默认 inode 大小为 256 字节。Ext4 还支持快速扩展属性（fast extended attributes）和inode保留（inodes reservation）。
    默认启用 barrier。磁盘 上配有内部缓存，以便重新调整批量数据的写操作顺序，优化写入性能，因此文件系统必须在日志数据写入磁盘之后才能写 commit 记录，
    若commit 记录写入在先，而日志有可能损坏，那么就会影响数据完整性。Ext4 默认启用 barrier，只有当 barrier 之前的数据全部写入磁盘，才能写 barrier 之后的数据。（可通过 "mount -o barrier=0" 命令禁用该特性。）



Linux swap:
    它是Linux中一种专门用于交换分区的swap文件系统。Linux是使用这一整个分区作为交换空间。一般这个swap格式的交换分区是主内存的2倍。在内存不够时，Linux会将部分数据写到交换分区上。 VFAT： VFAT叫长文件名系统，这是一个与Windows系统兼容的Linux文件系统，支持长文件名，可以作为Windows与Linux交换文件的分区。

xfs
    CentOS7默认的文件系统。适合数据库业务，门户网站使用，例如MySQL数据库使用这种文件系统。

    XFS一种高性能的日志文件系统，XFS 特别擅长处理大文件，同时提供平滑的数据传输。
    
    XFS 是一个全64-bit的文件系统，它可以支持上百万T字节的存储空间。对特大文件及小尺寸文件的支持都表现出众，支持特大数量的目录。最大可支持的文件大 小为263 = 9 x 1018 = 9 exabytes，最大文件系统尺寸为18 exabytes。

    XFS使用高的表结构(B+树)，保证了文件系统可以快速搜索与快速空间分配。XFS能够持续提供高速操作，文件系统的性能不受目录中目录及文件数量的限制。

    缺点：
        XFS文件系统无法被收缩。

btrfs
    B-Tree是btrfs的核心btrfs文件系统中所有的 metadata 都由B-Tree管理。
    使用B-Tree的主要好处在于查找，插入和删除操作都很高效

reiserfs
    如果小文件超级多比较适合这种文件系统。

    ReiserFS是一种新型的文件系统，它通过完全平衡树结构来容纳数据，包括文件数据，文件名以及日志支持。

    ReiserFS搜索大量文件时，搜索速度要比ext2快得多。Reiserfs文件系统使用B*Tree存储文件，而其它文件系统使用B+Tree树。B*Tree查询速度比B+Tree要快很多。Reiserfs在文件定位上速度非常快。

    ReiserFS文件系统最大支持的文件系统尺寸为16TB。这非常适合企业级应用中。
jfs
    一种字节级日志文件系统，借鉴了数据库保护系统的技术，以日志的形式记录文件的变化。JFS通过记录文件结构而不是数据本身的变化来保证数据的完整性。这种方式可以确保在任何时刻都能维护数据的可访问性。







.. [1] http://www.ilsistemista.net/index.php/linux-a-unix/6-linux-filesystems-benchmarked-ext3-vs-ext4
.. [2] https://kernelnewbies.org/Ext4
.. [测试性能] https://www.linux.com/news/iozone-filesystem-performance-benchmarking

分布式文件系统
======================================================================================================================================================

    GFS、HDFS、Lustre 、Ceph 、GridFS 、mogileFS、TFS、FastDFS等

Google学术论文，这是众多分布式文件系统的起源
------------------------------------------------------------------------------------------------------------------------------------------------------

Google File System（大规模分散文件系统）

MapReduce （大规模分散FrameWork）

BigTable（大规模分散数据库）

Chubby（分散锁服务）

一般你搜索Google_三大论文中文版(Bigtable、 GFS、 Google MapReduce)就有了。

做个中文版下载源：http://dl.iteye.com/topics/download/38db9a29-3e17-3dce-bc93-df9286081126

做个原版地址链接：

http://labs.google.com/papers/gfs.html

http://labs.google.com/papers/bigtable.html

http://labs.google.com/papers/mapreduce.html

 
 
GFS（Google File System）
------------------------------------------------------------------------------------------------------------------------------------------------------

Google公司为了满足本公司需求而开发的基于Linux的专有分布式文件系统。。尽管Google公布了该系统的一些技术细节，但Google并没有将该系统的软件部分作为开源软件发布。
下面分布式文件系统都是类 GFS的产品。
 
HDFS
------------------------------------------------------------------------------------------------------------------------------------------------------

Hadoop 实现了一个分布式文件系统（Hadoop Distributed File System），简称HDFS。 Hadoop是Apache Lucene创始人Doug Cutting开发的使用广泛的文本搜索库。它起源于Apache Nutch，后者是一个开源的网络搜索引擎，本身也是Luene项目的一部分。Aapche Hadoop架构是MapReduce算法的一种开源应用，是Google开创其帝国的重要基石。
 
Ceph
------------------------------------------------------------------------------------------------------------------------------------------------------

是加州大学圣克鲁兹分校的Sage weil攻读博士时开发的分布式文件系统。并使用Ceph完成了他的论文。
说 ceph 性能最高，C++编写的代码，支持Fuse，并且没有单点故障依赖， 于是下载安装， 由于 ceph 使用 btrfs 文件系统， 而btrfs 文件系统需要 Linux 2.6.34 以上的内核才支持。
可是ceph太不成熟了，它基于的btrfs本身就不成熟，它的官方网站上也明确指出不要把ceph用在生产环境中。
 
Lustre
------------------------------------------------------------------------------------------------------------------------------------------------------

Lustre是一个大规模的、安全可靠的，具备高可用性的集群文件系统，它是由SUN公司开发和维护的。
该项目主要的目的就是开发下一代的集群文件系统，可以支持超过10000个节点，数以PB的数据量存储系统。
目前Lustre已经运用在一些领域，例如HP SFS产品等。
 
 
 

适合存储小文件、图片的分布文件系统研究
------------------------------------------------------------------------------------------------------------------------------------------------------

FastDFS分布文件系统  （我写的）

TFS（Taobao File System）安装方法  （我写的）

用于图片等小文件大规模存储的分布式文件系统调研
架构高性能海量图片服务器的技术要素
nginx性能改进一例（图片全部存入google的leveldb）
动态生成图片 Nginx + GraphicsMagick 
 

MogileFS
------------------------------------------------------------------------------------------------------------------------------------------------------

由memcahed的开发公司danga一款perl开发的产品，目前国内使用mogielFS的有图片托管网站yupoo等。
MogileFS是一套高效的文件自动备份组件，由Six Apart开发，广泛应用在包括LiveJournal等web2.0站点上。
MogileFS由3个部分组成：
　　第1个部分是server端，包括mogilefsd和mogstored两个程序。前者即是 mogilefsd的tracker，它将一些全局信息保存在数据库里，例如站点domain,class,host等。后者即是存储节点(store node)，它其实是个HTTP Daemon，默认侦听在7500端口，接受客户端的文件备份请求。在安装完后，要运行mogadm工具将所有的store node注册到mogilefsd的数据库里，mogilefsd会对这些节点进行管理和监控。
　　第2个部分是utils（工具集），主要是MogileFS的一些管理工具，例如mogadm等。
　　第3个部分是客户端API，目前只有Perl API(MogileFS.pm)、PHP，用这个模块可以编写客户端程序，实现文件的备份管理功能。
 
 
mooseFS
------------------------------------------------------------------------------------------------------------------------------------------------------

持FUSE，相对比较轻量级，对master服务器有单点依赖，用perl编写，性能相对较差，国内用的人比较多
MooseFS与MogileFS的性能测试对比 
 
 
FastDFS
------------------------------------------------------------------------------------------------------------------------------------------------------

是一款类似Google FS的开源分布式文件系统，是纯C语言开发的。
FastDFS是一个开源的轻量级分布式文件系统，它对文件进行管理，功能包括：文件存储、文件同步、文件访问（文件上传、文件下载）等，解决了大容量存储和负载均衡的问题。特别适合以文件为载体的在线服务，如相册网站、视频网站等等。
官方论坛  http://bbs.chinaunix.net/forum-240-1.html
FastDfs google Code     http://code.google.com/p/fastdfs/
分布式文件系统FastDFS架构剖析   http://www.programmer.com.cn/4380/
 
TFS
------------------------------------------------------------------------------------------------------------------------------------------------------

TFS（Taobao !FileSystem）是一个高可扩展、高可用、高性能、面向互联网服务的分布式文件系统，主要针对海量的非结构化数据，它构筑在普通的Linux机器 集群上，可为外部提供高可靠和高并发的存储访问。TFS为淘宝提供海量小文件存储，通常文件大小不超过1M，满足了淘宝对小文件存储的需求，被广泛地应用 在淘宝各项应用中。它采用了HA架构和平滑扩容，保证了整个文件系统的可用性和扩展性。同时扁平化的数据组织结构，可将文件名映射到文件的物理地址，简化 了文件的访问流程，一定程度上为TFS提供了良好的读写性能。
官网 ： http://code.taobao.org/p/tfs/wiki/index/
 
 
GridFS文件系统
------------------------------------------------------------------------------------------------------------------------------------------------------

MongoDB是一种知名的NoSql数据库，GridFS是MongoDB的一个内置功能，它提供一组文件操作的API以利用MongoDB存储文件，GridFS的基本原理是将文件保存在两个Collection中，一个保存文件索引，一个保存文件内容，文件内容按一定大小分成若干块，每一块存在一个Document中，这种方法不仅提供了文件存储，还提供了对文件相关的一些附加属性（比如MD5值，文件名等等）的存储。文件在GridFS中会按4MB为单位进行分块存储。

linux支持的文件系统
======================================================================================================================================================

查看linux支持的文件系统：

.. code-block:: bash
    :linenos:

    [root@Server ~]# ls /lib/modules/2.6.32-573.el6.x86_64/kernel/fs/
    autofs4     configfs  exportfs  fat      jbd    mbcache.ko  nls       xfs
    btrfs       cramfs    ext2      fscache  jbd2   nfs         squashfs
    cachefiles  dlm       ext3      fuse     jffs2  nfs_common  ubifs
    cifs        ecryptfs  ext4      gfs2     lockd  nfsd        udf

linux根简介
======================================================================================================================================================

根文件系统： linux识别的第一个与根直接关联的文件系统。

FHS:LSB组织定义的Linux发行版基础目录命名法则及功用规定。filesystem hierarchy standard，文件系统层级标准

Linux文件系统类型
------------------------------------------------------------------------------------------------------------------------------------------------------

1. 方法1

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# blkid /dev/sda1
    /dev/sda1: UUID="c85b6078-f0f4-4b56-a0b4-2d4a73a1a9a9" TYPE="ext4" <===说明是ext4

2. 方法2

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# df -T
    Filesystem     Type  1K-blocks    Used Available Use% Mounted on
    /dev/sda2      ext4    9948012 4360944   5075068  47% /
    tmpfs          tmpfs    502384       0    502384   0% /dev/shm
    /dev/sda1      ext4     194241   35993    148008  20% /boot
    /dev/sda5      ext4    8164036  308984   7433676   4% /data
                    ||<=这一列是文件系统类型

3. 方法3

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# file -sL /dev/sda1
    /dev/sda1: Linux rev 1.0 ext4 filesystem data (needs journal recovery) (extents) (huge files)
                              |<===这就显示是ext4文件系统。

3. 方法3

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# fsck -N /dev/sda1
    fsck from util-linux-ng 2.17.2
    [/sbin/fsck.ext4 (1) -- /boot] fsck.ext4 /dev/sda1

4. 方法4

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# cat /etc/fstab

    #
    # /etc/fstab
    # Created by anaconda on Wed Apr 18 07:03:04 2018
    #
    # Accessible filesystems, by reference, are maintained under '/dev/disk'
    # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
    #
    UUID=6d43e673-1f77-4001-b4fc-a9c45aed429e /                       ext4    defaults        1 1
    UUID=c85b6078-f0f4-4b56-a0b4-2d4a73a1a9a9 /boot                   ext4    defaults        1 2
    UUID=92a3db08-3ef2-4767-b849-1e9052264b14 /data                   ext4    defaults        1 2
    UUID=529a4de3-3332-4d9d-9476-1927c216c2de swap                    swap    defaults        0 0
    tmpfs                   /dev/shm                tmpfs   defaults        0 0
    devpts                  /dev/pts                devpts  gid=5,mode=620  0 0
    sysfs                   /sys                    sysfs   defaults        0 0
    proc                    /proc                   proc    defaults        0 0

5. 方法5

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# lsblk -f
    NAME   FSTYPE  LABEL            UUID                                 MOUNTPOINT
    sr0    iso9660 CentOS_6.7_Final                                      
    sda                                                                  
    ├─sda1 ext4                     c85b6078-f0f4-4b56-a0b4-2d4a73a1a9a9 /boot
    ├─sda2 ext4                     6d43e673-1f77-4001-b4fc-a9c45aed429e /
    ├─sda3 swap                     529a4de3-3332-4d9d-9476-1927c216c2de [SWAP]
    ├─sda4                                                               
    └─sda5 ext4                     92a3db08-3ef2-4767-b849-1e9052264b14 /data

6. 方法6

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# mount | grep "^/dev"
    /dev/sda2 on / type ext4 (rw)
    /dev/sda1 on /boot type ext4 (rw)
    /dev/sda5 on /data type ext4 (rw)

7. 方法7

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# cat /proc/mounts | grep "^/dev"
    /dev/sda2 / ext4 rw,seclabel,relatime,barrier=1,data=ordered 0 0
    /dev/sda1 /boot ext4 rw,seclabel,relatime,barrier=1,data=ordered 0 0
    /dev/sda5 /data ext4 rw,seclabel,relatime,barrier=1,data=ordered 0 0


Linux文件系统目录结构
------------------------------------------------------------------------------------------------------------------------------------------------------

- /boot: 系统引导启动目录
- /bin:系统相关的二进制程序
- /sbin:系统相关的管理类基础命令
- /lib:基础的共享库文件
- /lib64:专用64系统上的辅助共享库
- /etc:配置文件
- /home:家目录
- /root:管理员家目录
- /media:便携式移动设备的挂载点
- /mnt:临时文件系统挂载点
- /dev:设备文件
- /opt:第三方安装目录
- /src：服务类存放目录
- /tmp:临时文件存放目录
- /usr:unix software resource 
- /var/cache:应用缓存目录
- /var/lib:应用库目录
- /var/local:应用程序可变存储目录
- /var/lock:锁文件
- /var/log：日志文件存放目录
- /var/run：存储进程的pid目录
- /var/spool:应用程序的数据池
- /var/tmp：保存系统2次重启之间产生的临时数据
- /proc:用于输入内核与进程信息相关的虚拟文件系统
- /sys:用于输出当前系统上硬件设备相关信息的虚拟文件系统
- /selinux:selinux相关的安全策略等信息


应用程序主要组成部分
------------------------------------------------------------------------------------------------------------------------------------------------------

- 二进制程序: /bin,/sbin,/usr/bin,/usr/sbin,/usr/local/bin,/usr/local/sbin
- 库文件:/lib,/lib64,/usr/lib,/usr/lib64,/usr/local/lib,/usr/local/lib64
- 配置文件:/etc,/etc/DIRECTORY,/usr/local/etc
- 帮助文件:/usr/share/man, /usr/share/doc, /usr/local/share/man,/usr/local/share/doc








