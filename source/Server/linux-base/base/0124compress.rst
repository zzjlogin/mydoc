.. _zzjlogin-compress:

======================================================================================================================================================
解压缩
======================================================================================================================================================

:Date: 2018-09-02

.. contents::

linux下有几种压缩工具
    - gzip
    - bzip 
    - xz 
    - zip 
    - tar
    - compress
    - uncompress

各种工具和对应的格式
======================================================================================================================================================



==========  ==================================================
**包格式**      **压缩/解压/打包/解包方式**
----------  --------------------------------------------------
\*.tar           用 ``tar –xvf`` 解压
----------  --------------------------------------------------
\*.gz            用 ``gzip -d`` 或者 ``gunzip`` 解压
----------  --------------------------------------------------
\*.tar.gz        和 ``*.tgz`` 用 ``tar –xzf`` 解压
----------  --------------------------------------------------
\*.bz2           用 ``bzip2 -d`` 或者用 ``bunzip2`` 解压
----------  --------------------------------------------------
\*.tar.bz2       用 ``tar –xjf`` 解压
----------  --------------------------------------------------
\*.Z             用 ``uncompress`` 解压
----------  --------------------------------------------------
\*.tar.Z         用 ``tar –xZf`` 解压
----------  --------------------------------------------------
\*.rar           用 ``unrar e`` 解压,需要购买
----------  --------------------------------------------------
\*.zip           用 ``unzip`` 解压
==========  ==================================================



gzip的使用
======================================================================================================================================================

gzip的主要选项

-d      解压缩，相当于gunzip
-c      将压缩的输出流到特定位置
-r      递归至目录对每个文件进行压缩
-n      指定压缩级别，范围1-9，默认是6

bzip的使用
======================================================================================================================================================

bzip的主要选项

-d      解压缩，相当于bunzip2
-k      压缩后保留原文件
-n      指定压缩比


xz的使用
======================================================================================================================================================

xz的主要选项

-d      解压缩，相当于bunzip2
-k      压缩后保留原文件
-n      指定压缩比


zip的使用
======================================================================================================================================================


zip可以将多个文件压缩成单个文件

归档工具
======================================================================================================================================================

tar
------------------------------------------------------------------------------------------------------------------------------------------------------

-c      创建归档
-v      提示信息
-f      指定压缩目标位置
-z      使用gzip压缩
-j      使用bzip压缩
-J      使用xz压缩

