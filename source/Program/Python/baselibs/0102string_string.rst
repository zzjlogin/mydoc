.. _string_string:

======================================================================================================================================================
:mod:`string` --- string模块
======================================================================================================================================================

.. contents::


Python官方参考
======================================================================================================================================================

官方文档：
    - Python2：https://docs.python.org/2.7/library/string.html
    - Python3：https://docs.python.org/3/library/string.html


string(string库)
======================================================================================================================================================

string常量
------------------------------------------------------------------------------------------------------------------------------------------------------

.. csv-table::
   :header: "常量" , "描述"
   :widths: 30,40

    "string.ascii_letter","大小写字母一共52个"
    "string.ascii_lowercase","26个小写字母"
    "string.ascii_uppercase","26个的大写字母"
    "string.digits","10个数值字符"
    "string.octdigits","0-7"
    "string.puctuaction","标点符号"
    "string.printable","可打印的字符"
    "string.whitespace","空白字符"

样例：

.. code-block:: python
    :linenos:

    In [15]: import string
    In [156]: string.ascii_letters
    Out[156]: 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

    In [157]: string.ascii_lowercase
    Out[157]: 'abcdefghijklmnopqrstuvwxyz'

    In [158]: string.ascii_uppercase
    Out[158]: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    In [159]: string.digits
    Out[159]: '0123456789'

    In [160]: string.hexdigits
    Out[160]: '0123456789abcdefABCDEF'

    In [161]: string.octdigits
    Out[161]: '01234567'

    In [162]: string.printable
    Out[162]: '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!"#$%&\'()*+,-./:;<=>?@[\\]^_{|}~ \t\n\r\x0b\x0c'

    In [163]: string.punctuation
    Out[163]: '!"#$%&\'()*+,-./:;<=>?@[\\]^_{|}~'

    In [164]: string.whitespace
    Out[164]: ' \t\n\r\x0b\x0c'

格式化样例
......................................................................................................................................................

根据位置格式化

.. code-block:: python
    :linenos:

    In [166]: '{0},{1},{2}'.format('a,','b','c')
    Out[166]: 'a,,b,c'

    In [167]: '{0},{1},{2}'.format('abc','bbb','cccc')
    Out[167]: 'abc,bbb,cccc'

根据参数名格式化

.. code-block:: python
    :linenos:

    In [168]: '{lon},{lat}'.format(lon=110,lat=45)
    Out[168]: '110,45'

根据类属性格式化

.. code-block:: python
    :linenos:

    In [170]: class point:
        ...:     def __init__(self,x,y):
        ...:         self.x,self.y=x,y
        ...:     def __str__(self):
        ...:         return 'point({self.x},{self.y})'.format(self=self)
        ...:

    In [171]: str(point(2,4))
    Out[171]: 'point(2,4)'


根据参数的条目

.. code-block:: python
    :linenos:

    In [174]: coord=(3,4)

    In [175]: 'x{0[0]},y{0[1]}'.format(coord)
    Out[175]: 'x3,y4'

对齐

.. code-block:: python
    :linenos:

    In [176]: '{:<30}'.format('left aligned')
    Out[176]: 'left aligned                  '

    In [177]:  '{:>30}'.format('right aligned')
    Out[177]: '                 right aligned'

模板字符串
......................................................................................................................................................

样例： 

.. code-block:: python
    :linenos:

    In [178]:  from string import Template

    In [179]: s=Template('$who like $what')

    In [180]: s.substitute(who="zzjlogin",what="play game")
    Out[180]: 'zzjlogin like play game'

    In [181]: d={"who":"zzjlogin","what":"read book"}

    In [182]: s.substitute(d)
    Out[182]: 'zzjlogin like read book'




