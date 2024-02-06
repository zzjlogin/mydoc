.. _string_re:

======================================================================================================================================================
:mod:`re` --- 正则模块
======================================================================================================================================================

.. contents::


Python官方参考
======================================================================================================================================================

官方文档：
    - Python2：https://docs.python.org/2.7/library/re.html
    - Python3：https://docs.python.org/3/library/re.html




re
======================================================================================================================================================


re是regulare expression的简写。即正则表达式

正则表达式元字符

.. code-block:: text
    :linenos:

    .           任意单个字符（除了换行），如果想包含换行，指定DOTALL标记
    ^           开始位置锚定
    $           结束位置锚定
    *           前面的分组或者字符重复任意次数，包括0次，也就是不重复。
    +           前面的分组或者字符至少一次
    ?           前面的分组或者字符0次或者1次，
    *?,+?       终止贪婪模式，*,+都是尽可能多的通配，加上?不采用贪婪模式了。
    {m}         前面的匹配m次数
    {m,n}       前面的匹配m到n次，既包含m次也包含n次
    {m,n}?      终止贪婪模式的
    \           转义功能
    []          集合中的任何任意
    |           |两侧的都可以，a|b代表既可以a也可以b
    (...)       分组，中间可以写其他的正则表达式
    (?...)      不创建组
    (?<=...)    匹配到一个就不匹配下一个了。
    \A          开始是字符串的
    \b          匹配边界
    \B          匹配不是开头或者单词的结果
    \d          数值0-9
    \D          不是\d的
    \s          空白字符
    \S          不是空白字符的
    \w          匹配a-zA-Z0-9_这些字符
    \W          除了\w 之外的字符


模块内容
------------------------------------------------------------------------------------------------------------------------------------------------------

re.splitpattern, string, maxsplit=0, flags=0)

.. code-block:: python
    :linenos:

    In [190]: re.split(r'\W+','words, words, words.')
    Out[190]: ['words', 'words', 'words', '']

    In [191]: re.split('[a-f]+','0a3B9',flags=re.IGNORECASE)
    Out[191]: ['0', '3', '9']

re.findall(pattern, string, flags=0)

.. code-block:: python
    :linenos:

    In [192]: re.findall("\w+",'words, words, words.')
    Out[192]: ['words', 'words', 'words']

re.sub(pattern, repl, string, count=0, flags=0)

.. code-block:: python
    :linenos:

    In [193]:  re.sub(r'def\s+([a-zA-Z_][a-zA-Z_0-9]*)\s*\(\s*\):',
               r'static PyObject*\npy_\1(void)\n{','def myfunc():')
    Out[193]: 'static PyObject*\npy_myfunc(void)\n{'

如果pattern匹配了string,就把repl的应用替换为string。

正则表达式对象
======================================================================================================================================================

regex.search(string[, pos[, endpos]])

功能： 扫描字符串查找正则表达式产生匹配的第一个位置，并返回相应的匹配对象。 如果字符串中没有位置与模式匹配，则返回None;

.. code-block:: python
    :linenos:

    In [1]: import re

    In [2]: re.compile('d').search("dog")
    Out[2]: <_sre.SRE_Match object; span=(0, 1), match='d'>

    In [3]: re.compile('d').search("dog",1)

regex.match(string[, pos[, endpos]])

功能： 如果字符串开头的零个或多个字符匹配此正则表达式，则返回一个相应的匹配对象。 如果字符串与模式不匹配则返回None; 

.. code-block:: python
    :linenos:

    In [9]: pattern = re.compile("o")

    In [10]: b=pattern.match("dog")

    In [11]: print(b)
    None

    In [12]: c=pattern.match("dog",1)

    In [13]: print(c)
    <_sre.SRE_Match object; span=(1, 2), match='o'>

regex.fullmatch(string[, pos[, endpos]])

功能： 如果整个字符串匹配这个正则表达式，返回一个相应的匹配对象。 如果字符串与模式不匹配则返回None;

.. code-block:: python
    :linenos:

    In [16]: pattern = re.compile("o[gh]")

    In [17]: pattern.fullmatch("dog")

    In [18]: pattern.fullmatch("ogre")

    In [19]: pattern.fullmatch("og")
    Out[19]: <_sre.SRE_Match object; span=(0, 2), match='og'>

    In [20]: pattern.fullmatch("oh")
    Out[20]: <_sre.SRE_Match object; span=(0, 2), match='oh'>

    In [21]: pattern.fullmatch("ohh")

    In [22]: pattern.fullmatch("ohh",0,2)
    Out[22]: <_sre.SRE_Match object; span=(0, 2), match='oh'>

regex.split(string, maxsplit=0)

功能： 分割字符串，基本同re.split函数

.. code-block:: python 

    In [23]: pattern =re.compile("\W+")

    In [24]: pattern.split("world zzjlogin    test")
    Out[24]: ['world', 'zzjlogin', 'test']

匹配对象
======================================================================================================================================================

使用正则表达式匹配有成功有失败，可以使用简单的if判定结果状态。

.. code-block:: python
    :linenos:

    match = re.search(pattern, string)
    if match:
        process(match)

match.group([group1, ...])

功能： 返回一个或多个匹配的子组。

.. code-block:: python
    :linenos:

    # 使用索引分组
    In [25]:  m = re.match(r"(\w+) (\w+)", "Isaac Newton, physicist")

    In [26]: m.group()
    Out[26]: 'Isaac Newton'

    In [27]: m.group(0)
    Out[27]: 'Isaac Newton'

    In [28]: m.group(1)
    Out[28]: 'Isaac'

    In [29]: m.group(2)
    Out[29]: 'Newton'

    In [30]: m.group(1,2)
    Out[30]: ('Isaac', 'Newton')

    In [31]: m.groups()
    Out[31]: ('Isaac', 'Newton')


    # 使用命名分组
    In [32]: m = re.match(r"(?P<first_name>\w+) (?P<last_name>\w+)","zhao jiedi")

    In [33]: m.group()
    Out[33]: 'zhao jiedi'

    In [35]: m.group("first_name")
    Out[35]: 'zhao'

    In [36]: m.group("last_name")
    Out[36]: 'jiedi'

    In [37]: m.group(0)
    Out[37]: 'zhao jiedi'

    In [38]: m.group(1)
    Out[38]: 'zhao'

    # 直接索引方式访问
    In [39]: m[0]
    Out[39]: 'zhao jiedi'

    In [40]: m[1]
    Out[40]: 'zhao'

match.groupdict(default=None)

功能： 将匹配的直接转化为字典

.. code-block:: python
    :linenos:

    In [41]: m = re.match(r"(?P<first_name>\w+) (?P<last_name>\w+)", "Malcolm Reynolds")

    In [42]: m.groupdict()
    Out[42]: {'first_name': 'Malcolm', 'last_name': 'Reynolds'}

match.start([group])

功能： 获取匹配到的开始位置

.. code-block:: python
    :linenos:

    In [44]: m = re.search("remove_this", email)

    In [45]: email
    Out[45]: 'tony@tiremove_thisger.net'

    In [46]: m
    Out[46]: <_sre.SRE_Match object; span=(7, 18), match='remove_this'>

    In [47]: m[0]
    Out[47]: 'remove_this'

    In [49]: m.start()
    Out[49]: 7

    In [50]: m.end()
    Out[50]: 18

    In [52]: email[m.start() : m.end()]
    Out[52]: 'remove_this'

    In [54]: email[:m.start()]    +     email[m.end():]
    Out[54]: 'tony@tiger.net'





