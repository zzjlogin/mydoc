.. _python_configparser:

======================================================================================================================================================
:mod:`configparser` --- 配置文件解释器
======================================================================================================================================================

.. contents::


configparser实例
======================================================================================================================================================



configparser
------------------------------------------------------------------------------------------------------------------------------------------------------

提供ini风跟配置文件的解析，window下的大量配置文件都是使用的ini风格， 还有linux下的yum仓库或者mysql数据库配置文件等等。


ini风格的样例： 

.. code-block:: ini
    :linenos:

    [DEFAULT]
    ServerAliveInterval = 45
    Compression = yes
    CompressionLevel = 9
    ForwardX11 = yes

    [bitbucket.org]
    User = hg

    [topsecret.server.com]
    Port = 50022
    ForwardX11 = no

怎么生成上面的配置文件呢？

.. code-block:: python
    :linenos:

    In [66]: import configparser

    In [67]: import configparser
        ...: config = configparser.ConfigParser()
        ...: config['DEFAULT'] = {'ServerAliveInterval': '45',
        ...:                      'Compression': 'yes',
        ...:                      'CompressionLevel': '9'}
        ...: config['bitbucket.org'] = {}
        ...: config['bitbucket.org']['User'] = 'hg'
        ...: config['topsecret.server.com'] = {}
        ...: topsecret = config['topsecret.server.com']
        ...: topsecret['Port'] = '50022'     # mutates the parser
        ...: topsecret['ForwardX11'] = 'no'  # same here
        ...: config['DEFAULT']['ForwardX11'] = 'yes'
        ...: with open('example.ini', 'w') as configfile:
        ...:     config.write(configfile)

上面的代码就可以生成ini的配置文件了，下面是读取解析

.. code-block:: python
    :linenos:

    In [68]: import configparser

    In [69]: config = configparser.ConfigParser()

    In [70]: config.sections()
    Out[70]: []

    # 读取配置文件
    In [71]: config.read('example.ini')
    Out[71]: ['example.ini']

    In [72]: config.sections()
    Out[72]: ['bitbucket.org', 'topsecret.server.com']

    In [73]: 'bitbucket.org' in config
    Out[73]: True

    In [75]: config['DEFAULT']['Compression']
    Out[75]: 'yes'

    In [76]: config.getboolean('DEFAULT','Compression')
    Out[76]: True

    # 指定默认值
    In [77]: topsecret.getboolean('BatchMode', fallback=True)
    Out[77]: True


比较通用的一个样例： 

.. code-block:: python
    :linenos:

    import configparser

    config = configparser.RawConfigParser()

    # Please note that using RawConfigParser's set functions, you can assign
    # non-string values to keys internally, but will receive an error when
    # attempting to write to a file or when you get it in non-raw mode. Setting
    # values using the mapping protocol or ConfigParser's set() does not allow
    # such assignments to take place.
    config.add_section('Section1')
    config.set('Section1', 'an_int', '15')
    config.set('Section1', 'a_bool', 'true')
    config.set('Section1', 'a_float', '3.1415')
    config.set('Section1', 'baz', 'fun')
    config.set('Section1', 'bar', 'Python')
    config.set('Section1', 'foo', '%(bar)s is %(baz)s!')

    # Writing our configuration file to 'example.cfg'
    with open('example.cfg', 'w') as configfile:
        config.write(configfile)

configparser详解
======================================================================================================================================================


