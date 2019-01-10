.. _mysql_binary_install:

======================================================================================================================================================
MySQL二进制软件包安装
======================================================================================================================================================

:Date: 2018-11

.. contents::


MySQL二进制软件包说明
======================================================================================================================================================

MySQL软件的二进制软件包一般都需要针对特定平台。现在因为底层封装所以一般是针对特定系统。


.. tip::
    二进制软件包的名称和源码包的名称会有所不同，而且二进制软件包的会比较大，这是因为很多安装后生成
    的文件都已经包含在这个二进制软件包中。所以二进制软件包一般会达到180-200多MB。




二进制安装
======================================================================================================================================================

创建MySQL服务所属用户
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    useradd -s /sbin/nologin -M mysql
    id mysql

软件包下载
------------------------------------------------------------------------------------------------------------------------------------------------------

- 把软件包下载到本地。然后通过rz传到linux主机。（yum install lrzsz -y）

.. code-block:: bash
    :linenos:

    mkdir /home/tool/
    cd /home/tool/
    rz
    ls

- 在线下载

.. code-block:: bash
    :linenos:

    wget http://ftp.iij.ad.jp/pub/db/mysql/Downloads/MySQL-5.5/mysql-5.5.59-linux-glibc2.12-x86_64.tar.gz


解压并移动二进制软件包到指定安装路径
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    tar zxf mysql-5.5.59-linux-glibc2.12-x86_64.tar.gz
    mv mysql-5.5.59-linux-glibc2.12-x86_64 /usr/local/
    ls /usr/local/

创建软连接，生成去掉版本号的访问路径
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    ln -s /usr/local/mysql-5.5.59-linux-glibc2.12-x86_64 /usr/local/mysql
    chown -R mysql /usr/local/mysql

初始化配置文件
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    cd /usr/local/mysql
    ls -l /usr/local/mysql/support-files/*.cnf
    /bin/cp /usr/local/mysql/support-files/my-small.cnf /etc/my.cnf

初始化MySQL数据库文件
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    mkdir /data
    chown -R mysql.mysql /data
    /usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/data/ --user=mysql
    ll /data/

配置并启动MySQL
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
    chmod +x /etc/init.d/mysqld

修改/etc/init.d/mysqld的46-47行

.. code-block:: bash
    :linenos:
    
    basedir=/usr/local/mysql
    datadir=/data

.. note::
    如果安装路径不是/usr/local/mysql，则需要修改两个文件，修改方法：
        sed -i 's#/usr/local/mysql#/app/mysql#g' /etc/init.d/mysqld /app/mysql

.. code-block:: bash
    :linenos:

    /etc/init.d/mysqld start
    
    或者启动方式：

.. code-block:: bash
    :linenos:

    /usr/local/mysql/bin/mysqld_safe --user=mysql --datadir=/data &

增加开机启动项
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    chkconfig --add mysqld
    chkconfig --level 35 mysqld on

或者：在/etc/rc.local末尾新增一行，把/etc/init.d/mysqld start增加在这一行

查看启动结果
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    netstat -lntup| grep mysql
    lsof -i :3306

设置root密码并删除无用的MySQL用户及库
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    /usr/local/mysql/bin/mysql
    /usr/local/mysql/bin/mysqladmin -u root password '123'

为了方便操作可以把/usr/local/mysql/bin/加入到PATH中，加入方法：

.. code-block:: bash
    :linenos:

    echo 'export PATH=/usr/local/mysql/bin/:$PATH' >>/etc/profile
    tail -1 /etc/profile
    source /etc/profile
    echo $PATH
    mysql -uroot -p123
    
    select user,host from mysql.user;
    drop user "root"@"::1";
    drop user ""@"localhost";
    drop user ""@"demo";
    drop user "root"@"demo";
    flush privileges;
    drop database test;

