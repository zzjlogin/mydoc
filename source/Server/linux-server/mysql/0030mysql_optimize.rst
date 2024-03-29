.. _mysql_optimize:

======================================================================================================================================================
MySQL优化
======================================================================================================================================================

:Date: 2018-11

.. contents::


MySQL安装后去掉不用的数据库
======================================================================================================================================================

mysql安装后初始化数据库然后启动数据库以后登录数据库会发现数据库中默认有三个数据库。
生产环境需要把不用的数据库删除。这样防止黑客扫描时数据库报错时暴露数据库相关信息。(例如暴露数据库版本、数据库类型等其他信息)



MySQL客户端登录后的默认提示符修改
======================================================================================================================================================

修改这个提示符作用：
    - 正式区分生产的线上环境和测试环境，防止误操作。(养成好习惯比改这个提示符信息更有效)
修改方法：
    - 临时修改
    - 通过配置文件修改

MySQL命令历史记录优化
======================================================================================================================================================

这一点类似修改命令的历史记录的值：
    HISTORY的值

不记录MySQL客户端登陆后操作历史：


.. code-block:: bash
    :linenos:

    vim /etc/profile

最后一行追加：

.. code-block:: bash
    :linenos:

    export MYSQL_HISTFILE=/dev/null

配置生效：

.. code-block:: bash
    :linenos:

    source /etc/profile



MySQL默认引擎修改
======================================================================================================================================================


MySQL修改手动commit
======================================================================================================================================================





