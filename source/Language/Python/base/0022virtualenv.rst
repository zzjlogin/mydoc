.. _python.virtualenv:

======================================================================================================================================================
Python虚拟环境
======================================================================================================================================================

.. contents::



参考
======================================================================================================================================================

虚拟环境参考官方资料：
    - http://docs.python-guide.org/en/latest/dev/virtualenvs/

.. _python.virtualenv.windows:

Windows创建Python虚拟环境
======================================================================================================================================================

虚拟环境安装：

.. code-block:: python
    :linenos:

    pip install virtualenv

创建虚拟环境：

.. code-block:: python
    :linenos:

    virtualenv venv


进入创建的python虚拟环境：

.. code-block:: python
    :linenos:

    venv\Scripts\activate

在虚拟环境中安装需要的库和框架：

.. code-block:: python
    :linenos:

    venv\Scripts\activate
    pip install django

如果安装失败，可能是对应的库的版本问题可以降低一下安装库的版本：

.. code-block:: python
    :linenos:

    pip install django==1.8.13

查看django安装版本：Django-admin --version

虚拟环境安装django框架库后创建项目报错：“Cannot find installed version of python-django or python3-django”
可能是django库版本问题导致。可以指定版本，例如：pip install Django==1.8.13



.. _python.virtualenv.linux:

linux创建Python虚拟环境
======================================================================================================================================================

虚拟环境创建virtualenv命令需要安装：
    - ubuntu安装方式： ``apt-get install virtualenv``
    - centos安装方式： ``yum install python-virtualenv``

.. tip::
    - 使用yum安装： ``yum search virtualenv`` 搜索包名。 ``sudo yum install python-virtualenv`` 。
    - 安装成功后，即有命令 ``virtualenv``
    - 搜索包 ``yum search virtualenvwrapper`` ，然后安装 ``sudo yum install python-virtualenvwrapper.noarch`` 运行下面的命令，才好有虚拟环境管理的相关命令 ``workon`` 、 ``rmvirtualen`` 、 ``mkvirtualenv`` 等
    - ``source /usr/local/python2.7.14/bin/virtualenvwrapper.sh``

创建虚拟环境
    - ``virtualenv venv``
    - venv是新创建的虚拟环境的名称。 同时会创建一个与虚拟环境名称相同的文件夹venv, 里面存储了一个独立的Python执行环境。
进入虚拟环境
    - ``source venv/bin/activate``
    - 进入虚拟环境后，命令行的提示符会加入虚拟环境的名称，例如：(venv)user@machine:~$
退出虚拟环境
    - ``deactivate``
删除虚拟环境
    - ``rm -r venv``
    - 直接删除虚拟环境所在的文件夹venv就删除了我们创建的venv虚拟环境。



