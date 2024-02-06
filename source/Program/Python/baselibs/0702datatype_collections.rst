.. _python_collectons:

======================================================================================================================================================
:mod:`collectons` --- 容器数据类型
======================================================================================================================================================



.. contents::


collectons
======================================================================================================================================================


提供容器数据类型



ChainMap
......................................................................................................................................................

提供用于快速链接多个映射，以便将它们视为单个单元。 它通常比创建新字典和运行多个update()调用要快得多。

样例： 

.. code-block:: python

    In [53]: from collections import ChainMap

    In [54]: c= ChainMap()

    In [55]: d = c.new_child()

    In [56]: e = c.new_child()

    In [57]: e.maps[0]
    Out[57]: {}

    In [58]: e.maps[-1]
    Out[58]: {}

    In [59]: e.parents
    Out[59]: ChainMap({})

    In [60]: d['x'] = "abc"

    In [61]: d
    Out[61]: ChainMap({'x': 'abc'}, {})

    In [62]: list(d)
    Out[62]: ['x']

    In [63]: d.items()
    Out[63]: ItemsView(ChainMap({'x': 'abc'}, {}))

    In [64]: dict(d)
    Out[64]: {'x': 'abc'}

Counter
......................................................................................................................................................

计数功能

 .. code-block:: python 

    # 导入
    In [1]: from collections import Counter

    # 构造新对象
    In [2]: cnt=Counter()

    # 开始计数
    In [4]: for word in ["read","blue","green","blue","blue"]:
    ...:     cnt[word]+=1
    ...:
    # 查看
    In [5]: cnt
    Out[5]: Counter({'blue': 3, 'green': 1, 'read': 1})
    # 访问指定key
    In [6]: cnt["blue"]
    Out[6]: 3
    # 直接设置
    In [8]: cnt["yellow"] = 2
    # 转化为dict
    In [9]: dict(cnt)
    Out[9]: {'blue': 3, 'green': 1, 'read': 1, 'yellow': 2}

    # 查看所有元素
    In [14]: list(cnt.elements())
    Out[14]: ['read', 'blue', 'blue', 'blue', 'green', 'yellow', 'yellow']

    # 减法
    In [15]: c = Counter(a=4, b=2, c=0, d=-2)

    In [16]: d = Counter(a=1, b=2, c=3, d=4)

    In [17]: c.subtract(d)

    In [18]: c
    Out[18]: Counter({'a': 3, 'b': 0, 'c': -3, 'd': -6})

    # 个数总和
    In [20]: sum(c.values())
    Out[20]: -6

deque
......................................................................................................................................................

队列

常用方法： 

.. code-block:: python 

    # 导入
    In [23]: from collections import deque

    # 初始化
    In [24]: d=deque("abc")

    # 查看
    In [25]: d
    Out[25]: deque(['a', 'b', 'c'])

    # 追加
    In [26]: d.append("d")

    # 查看
    In [27]: d
    Out[27]: deque(['a', 'b', 'c', 'd'])

    # 左侧追加
    In [28]: d.appendleft("0")

    # 查看
    In [29]: d
    Out[29]: deque(['0', 'a', 'b', 'c', 'd'])

    # 特定元素的个数
    In [30]: d.count("0")
    Out[30]: 1

    # 批量追加
    In [31]: d.extend("ef")

    # 查看
    In [32]: d
    Out[32]: deque(['0', 'a', 'b', 'c', 'd', 'e', 'f'])

    # 特定位置插入
    In [33]: d.insert(4 ,"a")

    # 查看
    In [34]: d
    Out[34]: deque(['0', 'a', 'b', 'c', 'a', 'd', 'e', 'f'])

    # 右侧去除
    In [35]: d.pop()
    Out[35]: 'f'

    # 查看
    In [36]: d
    Out[36]: deque(['0', 'a', 'b', 'c', 'a', 'd', 'e'])

    # 左侧弹出
    In [37]: d.popleft()
    Out[37]: '0'

    # 查看
    In [38]: d
    Out[38]: deque(['a', 'b', 'c', 'a', 'd', 'e'])

    # 滚动2下，就是右边的元素放到第一个位置，在删除他原来的
    In [39]: d.rotate(2)

    # 查看
    In [40]: d
    Out[40]: deque(['d', 'e', 'a', 'b', 'c', 'a'])


获取到指定文件最后几行

.. code-block:: python 

    In [44]: def tail (filename ,n=10):
        ...:     with open(filename) as f:
        ...:         return deque(f,n)
        ...:

defaultdict
......................................................................................................................................................

默认字典，就是在原有字典的基础上提供默认值。

.. code-block:: python 

    In [46]: from collections import defaultdict

    In [47]: s = "zzjlogin"

    In [48]: d = defaultdict(int)

    In [49]: for k in s:
        ...:     d[k]+=1
        ...:

    In [50]: d
    Out[50]:
    defaultdict(int,
                {'a': 1, 'd': 1, 'e': 1, 'h': 1, 'i': 2, 'j': 1, 'o': 1, 'z': 1})

    In [52]: d.items()
    Out[52]: dict_items([('z', 1), ('h', 1), ('a', 1), ('o', 1), ('j', 1), ('i', 2), ('e', 1), ('d', 1)])

上面使用defaultdict指定int参数，如果没有值的话，会自动获取int的默认值0的。

namedtuple
......................................................................................................................................................

给元组提供了名字的扩展

.. code-block:: python 

    In [53]: from collections import namedtuple

    In [54]: Point=namedtuple('Point',['x','y'])

    In [55]: p=Point(11,2)

    In [56]: p
    Out[56]: Point(x=11, y=2)

    In [57]: p.x +p.y
    Out[57]: 13

    In [58]: p[0] + p[1]
    Out[58]: 13

    # list 元素转化元组
    In [59]: t=[1,2]

    In [60]: Point._make(t)
    Out[60]: Point(x=1, y=2)

    # 命名元组转化有序字典
    In [62]: p= Point(x=11,y=2)

    In [63]: p._asdict()
    Out[63]: OrderedDict([('x', 11), ('y', 2)])

    # 获取字段
    In [64]: p._fields
    Out[64]: ('x', 'y')

    # 获取属性值
    In [66]: getattr(p,'x')
    Out[66]: 11

OrderedDict
......................................................................................................................................................

有序字典与普通词典一样，但它们记住插入项的顺序。在遍历一个有序字典时，这些项将按其第一次添加的顺序返回。

.. code-block:: python 

    # 导入
    In [67]: from collections import OrderedDict

    In [68]: d= {'banana':3 , 'appale': 4 , 'orange':2}

    # 根据元素的key来排序
    In [69]: e = OrderedDict(sorted(d.items(),key=lambda t:t[0]))

    In [70]: e
    Out[70]: OrderedDict([('appale', 4), ('banana', 3), ('orange', 2)])

    # 根据元素的value来排序
    In [71]: f = OrderedDict(sorted(d.items(),key=lambda t:t[1]))

    In [72]: f
    Out[72]: OrderedDict([('orange', 2), ('banana', 3), ('appale', 4)])

