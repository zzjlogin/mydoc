
======================================================================================================================================================
文本处理
======================================================================================================================================================

.. contents::


difflib
------------------------------------------------------------------------------------------------------------------------------------------------------

类似linux环境下的diff命令。

diff样例

.. code-block:: python
    :linenos:

    In [58]: text1 = '''1. Beautiful is better than ugly.
        ...: 2. Explicit is better than implicit.
        ...: 3. Simple is better than complex.
        ...: 4. Complex is better than complicated.
        ...: '''.splitlines(keepends=True)

    In [59]: text2 = '''1. Beautiful is better than ugly.
        ...: 2. Explicit is better than implicit.
        ...: 33. Simple is better than Complex.
        ...: '''.splitlines(keepends=True)

    In [60]: import difflib

    In [61]: d = difflib.Differ()

    In [62]: result = list(d.compare(text1,text2))

    In [63]: result
    Out[63]:
    ['  1. Beautiful is better than ugly.\n',
    '  2. Explicit is better than implicit.\n',
    '- 3. Simple is better than complex.\n',
    '?                          ^\n',
    '+ 33. Simple is better than Complex.\n',
    '? +                         ^\n',
    '- 4. Complex is better than complicated.\n']

textwrap
------------------------------------------------------------------------------------------------------------------------------------------------------
textwrap提供一些转化和过滤功能。

textwrap.shorten(text, width, \*\*kwargs)

功能： 文本简化

.. code-block:: python
    :linenos:

    In [66]: import textwrap

    In [67]: textwrap.shorten("Hello  world!", width=12)
    Out[67]: 'Hello world!'

    In [68]: textwrap.shorten("Hello  world!", width=10)
    Out[68]: '[...]'

    In [69]: textwrap.shorten("Hello  world!", width=11)
    Out[69]: 'Hello [...]'

    In [70]: textwrap.shorten("Hello  world!", width=10,placeholder="...")
    Out[70]: 'Hello...'

textwrap.indent(text, prefix, predicate=None)  

功能： 文本缩进

.. code-block:: python
    :linenos:

    In [71]:  s = 'hello\n\n \nworld'

    In [72]: s
    Out[72]: 'hello\n\n \nworld'

    In [73]: print(s)
    hello


    world

    In [75]: textwrap.indent(s, '  ')
    Out[75]: '  hello\n\n \n  world'

    In [76]: print(textwrap.indent(s, '  '))
      hello


      world

使用了indent之后文本会缩进2个字符。

unicodedata
------------------------------------------------------------------------------------------------------------------------------------------------------
此模块提供对Unicode字符数据库（UCD）的访问，该字符数据库为所有Unicode字符定义字符属性。


样例： 

.. code-block:: python
    :linenos:

    In [83]: import unicodedata

    In [84]: unicodedata.lookup('left curly bracket')
    Out[84]: '{'

    In [85]: unicodedata.name('/')
    Out[85]: 'SOLIDUS'

    In [86]: unicodedata.decimal('9')
    Out[86]: 9

stringprep
------------------------------------------------------------------------------------------------------------------------------------------------------

readline
------------------------------------------------------------------------------------------------------------------------------------------------------

readline模块定义了许多函数来方便Python解释器完成和读取/写入历史文件。

rlcompleter 
------------------------------------------------------------------------------------------------------------------------------------------------------

rlcompleter模块通过完成有效的Python标识符和关键字来定义适用于readline模块的完成函数。
