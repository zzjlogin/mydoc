.. _python-save-messy:

======================================================================================================================================================
Python数据存储乱码汇总
======================================================================================================================================================

:Date: 2019-03

.. contents::


pandas的to_csv函数写入csv文件中文乱码
======================================================================================================================================================

Python版本信息：
    Python 3.6.5 |Anaconda, Inc
系统信息：
    windows7 64位

造成python乱码的代码：
    以下是过程

.. code-block:: python
    :linenos:

    >>> import pandas as pd
    >>> data_dic = {'id':['第一'], 'name':['测试']}
    >>> data_dic
    {'id': ['第一'], 'name': ['测试']}
    >>> data = pd.DataFrame(data=data_dic)
    >>> data
        id name
    0  第一   测试
    >>> data.to_csv('test.csv')

.. tip::
    ``data``不加参数写入csv文件后，如果想用read_csv原格式读取回来，需要在使用read_csv函数时加两个参数：
        - `header=0`
        - `index_col=0`


乱码调试：
    - 测试发现  `data.to_csv('test.csv', encoding='utf-8')` 也同样会导致乱码。
    - csv文件用office打开显示乱码。但是用python的pandas的read_csv读取，发现程序可以识别。

解决：
    - 使用DataFrame元素的to_csv函数时，指定编码： `encoding='utf_8_sig'` 或者指定 `encoding='gb2312'` 或者指定 `encoding='gbk'` 如果再不行，可以指定 `encoding='gb18030'` 
    - 测试发现DataFrame数据量比较大时gbk和gb2312会报错。所以还是建议使用utf_8_sig
    - pandas数据存入csv时。最好指定不要把行序号存入文件。即增加参数： `index=0`
    - 读取csv文件时，pd.read_csv函数指定第一行为列名，即增加参数： `header=0`


有的csv文件读取提示解码错误。可能需要指定编码。如果上面编码都不能解决报错。可以尝试编码：ISO-8859-1



