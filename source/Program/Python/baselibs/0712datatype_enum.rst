.. _python_enum:

======================================================================================================================================================
:mod:`enum` --- 枚举
======================================================================================================================================================


.. contents::

enum
======================================================================================================================================================


枚举

.. code-block:: python 

    In [135]: from enum import Enum,auto

    In [137]: class Color(Enum):
        ...:     RED=1
        ...:     GREEN =2
        ...:     BLUE =auto()
        ...:

    In [138]: print(Color.RED)
    Color.RED

    In [139]: print(Color.RED.name)
    RED

    In [140]: print(Color.RED.value)
    1

    # 判断
    In [141]: Color.RED == Color(1)
    Out[141]: True

    # 给枚举加唯一条件
    In [142]: from enum import Enum , unique

    In [143]: @unique
        ...: class MIsstake(Enum):
        ...:     one=1
        ...:     two=2
        ...:     three=3
        ...:     four=3
        ...:
    ---------------------------------------------------------------------------
    ValueError                                Traceback (most recent call last)
    <ipython-input-143-8f8798c8b548> in <module>()
        1 @unique
    ----> 2 class MIsstake(Enum):
        3     one=1
        4     two=2
        5     three=3

    D:\Users\Administrator\Anaconda3\lib\enum.py in unique(enumeration)
        832                 ["%s -> %s" % (alias, name) for (alias, name) in duplicates])
        833         raise ValueError('duplicate values found in %r: %s' %
    --> 834                 (enumeration, alias_details))
        835     return enumeration
        836

    ValueError: duplicate values found in <enum 'MIsstake'>: four -> three

    # 遍历
    In [145]: [ name for name, member in Color.__members__.items() ]
    Out[145]: ['RED', 'GREEN', 'BLUE']

IntEnum
......................................................................................................................................................

整型枚举

.. code-block:: python

    In [146]: from enum import IntEnum
        ...: class Shape(IntEnum):
        ...:     circle =1
        ...:     square =2
        ...:

    In [147]: Shape.circle ==1
    Out[147]: True

IntFlag
......................................................................................................................................................

整型标记

.. code-block:: python

    In [150]: class Perm(IntFlag):
        ...:     R =4
        ...:     W =2
        ...:     X =1
        ...:
        ...:

    In [151]: Perm.R
    Out[151]: <Perm.R: 4>

    In [152]: Perm.R  ==4
    Out[152]: True

    In [153]: Perm.R | Perm.W
    Out[153]: <Perm.R|W: 6>

    In [154]: Perm.R | Perm.W  ==6
    Out[154]: True

Flag
------------------------------------------------------------------------------------------------------------------------------------------------------

标记

.. code-block:: python 

    In [160]: from enum import Flag
        ...: class Color(Flag):
        ...:     red=auto()
        ...:     blue=auto()
        ...:     green=auto()
        ...:

    In [161]: Color.red
    Out[161]: <Color.red: 1>

    In [162]: Color.red ==1
    Out[162]: False

    In [163]: Color.blue
    Out[163]: <Color.blue: 2>

    In [164]: Color.green
    Out[164]: <Color.green: 4>

使用Flag，每个item都是按照1，2，4，8，16这样的值。

这种flag的主要用于后续有异或运算的情况下。
