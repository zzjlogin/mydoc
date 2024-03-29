.. _useradd-cmd:

======================================================================================================================================================
useradd
======================================================================================================================================================



:Date: 2018-09

.. contents::


.. _useradd-format:

命令格式
======================================================================================================================================================

命令格式:
    - useradd [options] LOGIN
    - useradd -D
    - useradd -D [options]

.. _useradd-user:

所属用户
======================================================================================================================================================

命令路径:
    /usr/sbin/useradd

需要权限:
    需要管理员权限。



.. _useradd-guid:

使用指导
======================================================================================================================================================

作用：
    创建一个新用户


.. _useradd-args:

参数
======================================================================================================================================================

\-b, --base-dir BASE_DIR
    - 设置新增用户主目录的基础目录，如果没有指定这个参数值， ``BASE_DIR`` 默认的目录需要存在，否则主目录会创建失败;
    - 默认基础目录在配置文件 ``/etc/default/useradd`` 中配置，或者默认是 ``/home`` 目录
    - 示例：

.. code-block:: bash
    :linenos:


\-c, --comment COMMENT
    - 加上备注文字。备注文字会保存在 ``/etc/passwd`` 的备注栏位中。
    - 默认没有备注信息。
    - 示例：

.. code-block:: bash
    :linenos:


\-d, --home HOME_DIR
    - 指定用户登入时的主目录。
    - 默认是 ``/home`` 目录下面的对应用户名的目录。
    - 示例：

.. code-block:: bash
    :linenos:

\-D, --defaults
    - 设置默认值

\-e, --expiredate EXPIRE_DATE
    - 指定用户失效的日志，格式是： ``YYYY-MM-DD``
    - 默认在配置文件 ``/etc/default/useradd`` 中的变量 ``EXPIRE``
    - 示例：

.. code-block:: bash
    :linenos:

\-f, --inactive INACTIVE
    - 指定在密码过期后多少天禁止该帐号登陆。
    - 默认在配置文件 ``/etc/default/useradd`` 中的变量 ``INACTIVE`` ，默认值-1
    - 示例：

.. code-block:: bash
    :linenos:

\-g, --gid GROUP
    - 指定创建的用户所属的主组。默认是和用户名相同的组名(默认创建用户时会同时创建一个和用户名相同的组)。
    - 这个参数会依赖配置文件 ``/etc/login.defs`` 中的变量 ``USERGROUPS_ENAB``

\-G, --groups GROUP1[,GROUP2,...[,GROUPN]]]
    - 指定用户的附属组。

\-h, --help
    - 显示帮助信息

\-k, --skel SKEL_DIR
    - 设置创建用户后用户主目录初始化复制的哪个模版目录的文件。
    - 默认在配置文件 ``/etc/default/useradd`` 中的变量 ``SKEL`` ，默认值是 ``/etc/skel``
    - 示例：

.. code-block:: bash
    :linenos:


\-K, --key KEY=VALUE
    - 重载配置文件 ``/etc/login.defs`` 中的默认值 **UID_MIN, UID_MAX, UMASK, PASS_MAX_DAYS and others**
    - 默认在配置文件 ``/etc/default/useradd`` 中的变量 ``SKEL`` ，默认值是 ``/etc/skel``
    - 例如： ``-K PASS_MAX_DAYS=-1`` ， ``-K UID_MIN=100 -K UID_MAX=499``
    - 示例：

.. code-block:: bash
    :linenos:


\-l, --no-log-init
    - 不将用户添加到lastlog和faillog数据库


\-m, --create-home
    - 如果用户主目录(家目录)不存在，则创建用户主目录。
    - 用户主目录创建的父目录定义是通过 ``/etc/login.defs`` 中的参数 ``CREATE_HOME``
    - 可以结合汆熟 ``-k`` 一起使用


\-M
    - 不创建用户的主目录。
    - 可以通过修改 ``/etc/login.defs`` 中的参数 ``CREATE_HOME`` 的值设置。默认 ``yes``

\-N, --no-user-group
    - 不创建与用户同名的组。


\-o, --non-unique
    - 此选项仅与-u选项组合有效。
    - 创建有影子账号的用户。


\-p, --password PASSWORD
    - 设置加密密码，用crypt(3)加密。

\-r, --system
    - 创建系统用户
    - 

\-s, --shell SHELL
    - 设置用户登陆系统使用的shell。默认这个值为空。
    - 可以通过配置文件 ``/etc/default/useradd`` 中变量 ``SHELL``


\-u, --uid UID
    - 设置用户的UID，这个值需要在 **UID_MIN** 和 **UID_MAX** 之间。



\-U, --user-group
    - 创建和用户名相同的组，并把用户加入这个组。
    - 可以通过 ``/etc/login.defs`` 中的变量 ``USERGROUPS_ENAB`` 设置默认是否创建这个组。
    - 如果设置了 ``-g`` , ``-N`` , ``-U`` 则会忽略配置文件中的变量的值。



\-Z, --selinux-user SEUSER
    - 这个登陆用户可以登陆SELinux，默认这个值为空。















.. _useradd-instance:

参考实例
======================================================================================================================================================



.. _useradd-relevant:

相关命令
======================================================================================================================================================








