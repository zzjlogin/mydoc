.. _io_csv:

======================================================================================================================================================
pandas写入或读取excel文件
======================================================================================================================================================

:Date: 2019-3

.. contents::



.. _io.excel_reader:

读取excel文件中数据
======================================================================================================================================================

方法：

.. code-block:: txt
    :linenos:

    pandas.read_excel(io, sheet_name=0, header=0, names=None, index_col=None, parse_cols=None, usecols=None, squeeze=False, dtype=None, engine=None, converters=None, true_values=None, false_values=None, skiprows=None, nrows=None, na_values=None, keep_default_na=True, verbose=False, parse_dates=False, date_parser=None, thousands=None, comment=None, skip_footer=0, skipfooter=0, convert_float=True, mangle_dupe_cols=True, **kwds)


返回值：
    返回值是DataFrame对象。


常用实例
------------------------------------------------------------------------------------------------------------------------------------------------------

.. note::
    ``pd.read_excel`` 方法没有指定解码时的编码方式，如果需要指定可以用以下方法：
    pd.read_excel(open('tmp.xlsx', 'rb', encoding='utf-8',), sheet_name='Sheet3')

1. 读取tmp.xlsx文件，并用第一列为索引。

.. code-block:: python
    :linenos:

    >>> pd.read_excel('tmp.xlsx', index_col=0)
        Name  Value
    0   string1      1
    1   string2      2
    2  #Comment      3

2. 读取tmp.xlsx文件，指定第一列和第二列数据类型：

.. code-block:: python
    :linenos:

    >>> pd.read_excel('tmp.xlsx', index_col=0, dtype={'Name': str, 'Value': float})
        Name  Value
    0   string1    1.0
    1   string2    2.0
    2  #Comment    3.0

3. 读取tmp.xlsx文件，指定文件中没有列名和索引值

.. code-block:: python
    :linenos:

    >>> pd.read_excel('tmp.xlsx', index_col=None, header=None)
        0         1      2
    0  NaN      Name  Value
    1  0.0   string1      1
    2  1.0   string2      2
    3  2.0  #Comment      3

4. 读取tmp.xlsx文件中的表明为'Sheet3'的表

.. code-block:: python
    :linenos:

    >>> pd.read_excel('tmp.xlsx', sheet_name='Sheet3')
    Unnamed: 0      Name  Value
    0           0   string1      1
    1           1   string2      2
    2           2  #Comment      3

5. 把指定的值也看作nan处理：

.. code-block:: python
    :linenos:

    >>> pd.read_excel('tmp.xlsx', index_col=0, na_values=['string1', 'string2'])
        Name  Value
    0       NaN      1
    1       NaN      2
    2  #Comment      3

6. 可以使用注释kwarg跳过excel输入文件中的注释行

.. code-block:: python
    :linenos:

    >>> pd.read_excel('tmp.xlsx', index_col=0, comment='#')
        Name  Value
    0  string1    1.0
    1  string2    2.0
    2     None    NaN



参数详解
------------------------------------------------------------------------------------------------------------------------------------------------------
 
官方参考：http://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_excel.html

io
    - 取值：str,file descriptor, pathlib.Path, ExcelFile or xlrd.Book
    - 说明：一般我们常用的就是带路径的文件名，这个名称用字符串表示。
sheet_name
    - 取值：str, int, list, or None, default 0
    - 说明：Excel中可以通过这个参数指定是那个表，但是csv对应的方法没有这个参数。
    - 注意：参数指定 ``None`` 时表示读取所有sheet
header
    - 取值：int, list of int, default 0
    - 说明：用来指定哪一行作为列的索引值(列名)，默认是第一行。如果用数字组成的列表，则表示这几行共同构成列名。
    - 注意：参数指定 ``None`` 时，表示没有头信息。用来结合 ``names`` 参数来手动指定列名。
names
    - 取值：array-like, default None
    - 说明：这个参数在 ``header=None`` 时使用，参数值是一个列表，这个列表中的元素作为指定的列名。
index_col
    - 取值：int, list of int, default None
    - 说明：指定某一列作为索引值，主要用法是指定多列，每行可以有多个索引值(即别名)
    - 注意：如果选用参数 ``usecols`` 那么 ``index_col`` 选择的列就是对应的数据。
parse_cols
    - 取值：int or list, default None
    - 说明：是参数 ``usecols`` 的别名
    - 注意：在本报version 0.21.0以后都被 ``usecols`` 替代。
usecols
    - 取值：int, str, list-like, or callable default None
    - 说明：用这个参数指定的列为基数，返回一个子集。
    - 注意： ``usecols`` 取值一个整数时，代表从从起始列到指定列为一个子集作为返回值。
squeeze
    - 取值：bool, default False
    - 说明：如果解析后只有一列，则返回 Series
dtype
    - 取值：Type name or dict of column -> type, default None
    - 说明：指定列名/数据类型名，不处理Excel中存储的数据，只作为对象存储。
engine
    - 取值：str, default None
    - 说明：如果io不是缓冲区或路径，则必须将其设置为标识io。可接受的值是None或xlrd。
converters
    - 取值：dict, default None
    - 说明：在某些列中转换值的函数的命令。键可以是整数或列标签，值是接受一个输入参数的函数，Excel单元格内容，并返回转换后的内容。
true_values
    - 取值：list, default None
    - 说明：值视为Ture，0.19.0版中的新功能。
false_values
    - 取值：list, default None
    - 说明：值被视为False
skiprows
    - 取值：list-like
    - 说明：跳过0-rows，即跳过从0行到指定行号的内容，读取后面所有行内容。
nrows
    - 取值：int, default None
    - 说明：读取0到指定行。
na_values
    - 取值：scalar, str, list-like, or dict, default None
    - 说明：指定被视为 NA/NaN 的值，默认是： ‘’, ‘#N/A’, ‘#N/A N/A’, ‘#NA’, ‘-1.#IND’, ‘-1.#QNAN’, ‘-NaN’, ‘-nan’, ‘1.#IND’, ‘1.#QNAN’, ‘N/A’, ‘NA’, ‘NULL’, ‘NaN’, ‘n/a’, ‘nan’, ‘null’.
keep_default_na
    - 取值：bool, default True
    - 说明：如果指定了na_values，且keep_default_na为False，则会覆盖默认被视为NaN的值，否则将追加这些指定值。
verbose
    - 取值：bool, default False
    - 说明：表明非数值列中NA值的数目
parse_dates
    - 取值：bool, list-like, or dict, default False
    - 说明：以下是取值对应含义：
        - bool：如果True，则分析是否有索引
        - list列表中都是int：例如：[1,2,3,] 则分析这几列都作为时间
        - list列表中还是list列表：例如:[[1,3]]，则将1,3这两列结合起来作为时间分析处理
        - dict字典：例如：{{‘foo’ : [1, 3]}}，则将1,3这两列结合起来作为时间分析处理，并把这个新的列叫做foo
date_parser
    - 取值：function, optional
thousands
    - 取值：str, default None
    - 说明：用于将字符串列解析为数值的数千分隔符。请注意，此参数仅对以文本形式存储在Excel中的列是必要的，任何数值列都会自动解析，无论显示格式如何。
comment
    - 取值：str, default None
    - 说明：注释出行的剩余部分。将一个或多个字符传递到此参数，以指示输入文件中的注释。注释字符串和当前行末尾之间的任何数据都将被忽
skip_footer
    - 取值：int, default 0
    - 说明：参数 ``skipfooter`` 的别名，省略从尾部数的int行的数据，这个参数即将被遗弃
skipfooter
    - 取值：int, default 0
    - 说明：省略从尾部数的int行的数据
convert_float
    - 取值：bool, default True
    - 说明：转换浮点型为整型（1.0——>1）
mangle_dupe_cols
    - 取值：bool, default True
    - 说明：如果列名有重复的，则显示为：‘X’, ‘X.1’, …’X.N’而不是：‘X’…’X’
    - 注意：如果传入False，则重复的列名的列会覆盖前面相同列名的列。
**kwds
    - 取值：optional
    - 说明：可选关键字参数可以传递给TextFileReader



.. _io.excel_writer:

写入excel文件
======================================================================================================================================================






