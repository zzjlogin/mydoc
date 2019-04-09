.. _python.buildin.fuc:

======================================================================================================================================================
内建函数
======================================================================================================================================================

.. contents::


官方参考
======================================================================================================================================================


参考官方文档：
    - python3内建函数：https://docs.python.org/3/library/functions.html
    - python2内建函数：https://docs.python.org/2/library/functions.html


内建函数列表
======================================================================================================================================================

以下是python3环境：

===================  =================  ==================  ==================  ====================
..                   ..                 Built-in Functions  ..                  ..
===================  =================  ==================  ==================  ====================
:func:`abs`          :func:`delattr`    :func:`hash`        |func-memoryview|_  |func-set|_
:func:`all`          |func-dict|_       :func:`help`        :func:`min`         :func:`setattr`
:func:`any`          :func:`dir`        :func:`hex`         :func:`next`        :func:`slice`
:func:`ascii`        :func:`divmod`     :func:`id`          :func:`object`      :func:`sorted`
:func:`bin`          :func:`enumerate`  :func:`input`       :func:`oct`         :func:`staticmethod`
:func:`bool`         :func:`eval`       :func:`int`         :func:`open`        |func-str|_
:func:`breakpoint`   :func:`exec`       :func:`isinstance`  :func:`ord`         :func:`sum`
|func-bytearray|_    :func:`filter`     :func:`issubclass`  :func:`pow`         :func:`super`
|func-bytes|_        :func:`float`      :func:`iter`        :func:`print`       |func-tuple|_
:func:`callable`     :func:`format`     :func:`len`         :func:`property`    :func:`type`
:func:`chr`          |func-frozenset|_  |func-list|_        |func-range|_       :func:`vars`
:func:`classmethod`  :func:`getattr`    :func:`locals`      :func:`repr`        :func:`zip`
:func:`compile`      :func:`globals`    :func:`map`         :func:`reversed`    :func:`__import__`
:func:`complex`      :func:`hasattr`    :func:`max`         :func:`round`
===================  =================  ==================  ==================  ====================

.. using :func:`dict` would create a link to another page, so local targets are
   used, with replacement texts to make the output in the table consistent

.. |func-dict| replace:: ``dict()``
.. |func-frozenset| replace:: ``frozenset()``
.. |func-memoryview| replace:: ``memoryview()``
.. |func-set| replace:: ``set()``
.. |func-list| replace:: ``list()``
.. |func-str| replace:: ``str()``
.. |func-tuple| replace:: ``tuple()``
.. |func-range| replace:: ``range()``
.. |func-bytearray| replace:: ``bytearray()``
.. |func-bytes| replace:: ``bytes()``


内建函数详解
======================================================================================================================================================


.. function:: abs(x)

   返回数值 ``x`` 的绝对值。如果x是复数，则返回这个点到原点的距离。

.. function:: all(iterable)

   如果可迭代的（ *iterable* ）对象所有元素都是 **True** （非空也非 **False/0** ）则返回 **True** 
   和下面是等价的::

      def all(iterable):
          for element in iterable:
              if not element:
                  return False
          return True


.. function:: any(iterable)

   如果可迭代的（ *iterable* ）对象的元素中有非空也非 **False/0** 的元素则返回 **True** ，否则返回 **False** 
   和下面是等价的::

      def any(iterable):
          for element in iterable:
              if element:
                  return True
          return False


.. function:: ascii(object)

   等价 :func:`repr`, 返回一个包含对象可打印表示形式的字符串，
   使用\x、\u或\u转义repr()返回的字符串中的非ascii字符。
   这将生成一个类似于Python 2中的repr()返回的字符串。
   如下面例子：

      In [10]: s = ascii('ab好人\nc')
      In [11]: s
      Out[11]: "'ab\\u597d\\u4eba\\nc'"


.. function:: bin(x)

   转换为以 "0b" 为开始的字符串。这个字符串是数字x的二进制表示。 
   下面例子:

      >>> bin(3)
      '0b11'
      >>> bin(-10)
      '-0b1010'

   返回字符串中 "0b" 是否去除可以用下面方法：

      >>> format(14, '#b'), format(14, 'b')
      ('0b1110', '1110')
      >>> f'{14:#b}', f'{14:b}'
      ('0b1110', '1110')

   查看更多： :func:`format` .


.. class:: bool([x])

   如果传入非空列表，则返回True，否则返回False。

   .. index:: pair: Boolean; type

   .. versionchanged:: 3.7
      *x* is now a positional-only parameter.

.. function:: breakpoint(*args, **kws)

   此函数将置于调用站点的调试器中。具体来说，它会直接传递args和kws调用sys.breakpointhook()。
   默认情况下sys.breakpointhook()调用pdb.set_trace()，不需要任何参数。
   在本例中，它纯粹是一个方便的函数，因此不必显式地导入pdb或输入足够多的代码来进入调试器。
   但是可以将sys.breakpointhook()设置为其他函数，而breakpoint()将自动调用该函数，从而允许进入所选的调试器。

   .. versionadded:: 3.7

.. _func-bytearray:
.. class:: bytearray([source[, encoding[, errors]]])
   :noindex:

   返回一个新的字节数组。bytearray类是一个范围为0 <= x < 256的可变整数序列。
   它拥有可变序列的大多数常用方法(在可变序列类型中描述)，以及字节类型拥有的大多数方法

   参数 *source* 可以用下面方法进行初始化：

   * 如果传入 *string*, 需要传入指定编码类型 *encoding* (和可选参数 *errors*)。
     :func:`bytearray` 会用传入的编码类型调用字符串对应的方法转换为字节类型。

   * 如果传入一个整数 *integer*,则数组将具有该整数大小，并将使用空字节初始化。

   * 如果对象符合缓冲区接口 *buffer* ，则使用对象的只读缓冲区初始化字节数组。

   * 如果它是可迭代的（ *iterable* ），那么它必须是0 <= x < 256范围内的整数的迭代，这些整数用作数组的初始内容。

   没有传入参数则创建一个大小为0的array



.. _func-bytes:
.. class:: bytes([source[, encoding[, errors]]])
   :noindex:

   返回一个新的长度在0-255范围的 **bytes** 对象，该对象是不可变的整数序列。

.. function:: callable(object)

   如果传入对象(object)是可调用的则返回常量 ``True`` ，否则返回常量 ``False`` 
   类是可调用的（调用类会返回一个新实例）; 如果实例的类具有 ``__call__()`` 方法，则它们是可调用的。

   版本3.2中的新功能：此功能首先在Python 3.0中删除，然后在Python 3.2中恢复。


.. function:: chr(i)

   返回整数 **i** 的字符串表示，例如：chr(97)返回字符串'a'，同时 chr(8364)返回字符串'€'。
   这个内置函数功能和 ``ord()`` 相反。
   
   整数 **i** 取值范围是 **0** 到 **1,114,111** (16进制的0x10FFFF)。
   超出范围会触发错误：:exc:`ValueError` 


.. decorator:: classmethod

   将方法转换为类方法。
   
   类方法接收类作为隐式的第一个参数，就像实例方法接收实例一样。
   要声明一个类方法，使用方法：

      class C:
          @classmethod
          def f(cls, arg1, arg2, ...): ...

   该 ``@classmethod`` 形式是一个函数装饰器

   类方法与C ++或Java静态方法不同。如果你想要那些，请参阅 :func:`staticmethod`.

.. function:: compile(source, filename, mode, flags=0, dont_inherit=False, optimize=-1)

   将源代码编译为代码或AST对象。代码对象可以由 ``exec()`` 或 ``eval()`` 执行。
   ``source`` 可以是普通字符串，字节字符串或AST对象。

   ``filename`` 该文件名参数应该给从代码读取的文件; 如果没有从文件中读取（'<string>'通常使用），
   则传递一些可识别的值。

   ``mode`` 参数值可以是 ``'eval'`` 、  ``'exec'`` 、``'single'`` 。该模式参数指定什么样的代码必须进行编译; 


.. class:: complex([real[, imag]])

   返回值为 ``real + imag*1j`` 的复数，或将字符串或数字转换为复数。
   如果第一个参数是字符串，那么它将被解释为一个复数，并且必须在没有第二个参数的情况下调用该函数。
   第二个参数永远不能是字符串。每个参数可以是任何数字类型(包括复数)。
   如果省略 **imag** ，它的默认值为零，构造函数充当一个数字转换，如int和float。
   如果省略了两个参数，则返回 ``0j``。

   .. note::

      从字符串转换时，字符串必须用不让空格包裹中心 ``+`` 或 ``-`` 运算符
      例如： ``complex('1+2j')`` 是正常的，但是 ``complex('1 + 2j')`` 会报错：
      :exc:`ValueError`.

   .. versionchanged:: 3.6
      Grouping digits with underscores as in code literals is allowed.


.. function:: delattr(object, name)

   这个内置函数和 :func:`setattr` 相关联。参数是一个对象和一个字符串。字符串必须是对象
   的属性。这个函数功能是删除这个对象的指定的属性。例如：
    ``delattr(x, 'foobar')`` 等价于 ``del x.foobar``.


.. _func-dict:
.. class:: dict(**kwarg)
           dict(mapping, **kwarg)
           dict(iterable, **kwarg)
   :noindex:

   创建一个新的字典，这个字典对象是一个字典类（dictionary class）。


.. function:: dir([object])

   如果没有参数，则返回当前本地范围中的名称列表。使用参数，尝试返回该对象的有效属性列表。
   
   如果出入对象有对应的方法 ``__dir__()`` 则调用对象的方法。

   如果对象未提供 ``__dir__()``，则该函数会尽力从对象的 ``__dict__``属性（如果已定义）和其类型对象中收集信息。
   结果列表不一定完整，并且在对象具有自定义时可能不准确 ``__getattr__()``。

   默认dir()机制对不同类型的对象的行为有所不同，因为它尝试生成最相关的信息，而不是完整的信息：

   * 如果对象是模块对象，则列表包含模块属性的名称。
   * 如果对象是类型或类对象，则列表包含其属性的名称，并且递归地包含其基础的属性。
   * 否则，该列表包含对象的属性名称，其类的属性的名称，以及其类的基类的属性的递归。
   
   结果列表按字母顺序排序。例如：

   The resulting list is sorted alphabetically.  For example:

      >>> import struct
      >>> dir()   # show the names in the module namespace  # doctest: +SKIP
      ['__builtins__', '__name__', 'struct']
      >>> dir(struct)   # show the names in the struct module # doctest: +SKIP
      ['Struct', '__all__', '__builtins__', '__cached__', '__doc__', '__file__',
       '__initializing__', '__loader__', '__name__', '__package__',
       '_clearcache', 'calcsize', 'error', 'pack', 'pack_into',
       'unpack', 'unpack_from']
      >>> class Shape:
      ...     def __dir__(self):
      ...         return ['area', 'perimeter', 'location']
      >>> s = Shape()
      >>> dir(s)
      ['area', 'location', 'perimeter']


.. function:: divmod(a, b)

   取两个（非复数）数作为参数，并在使用整数除法时返回由商和余数组成的一对数字。
   等价于 ``(a // b, a % b)`` 。浮点型数字的结果是 ``(q, a % b)`` ，其中
   *q* 等于 ``math.floor(a / b)``


.. function:: enumerate(iterable, start=0)

   返回一个枚举对象。 *iterable* 必须是一个序列，一个迭代器或一些支持迭代的对象。
   可以用 ``__next__()`` 返回的迭代器的方法 enumerate()返回一个包含计数的元组（ *start* 默认为0）和迭代得到的值。

      >>> seasons = ['Spring', 'Summer', 'Fall', 'Winter']
      >>> list(enumerate(seasons))
      [(0, 'Spring'), (1, 'Summer'), (2, 'Fall'), (3, 'Winter')]
      >>> list(enumerate(seasons, start=1))
      [(1, 'Spring'), (2, 'Summer'), (3, 'Fall'), (4, 'Winter')]

   等价于::

      def enumerate(sequence, start=0):
          n = start
          for elem in sequence:
              yield n, elem
              n += 1


.. function:: eval(expression, globals=None, locals=None)

   参数是一个字符串和可选的全局变量和本地变量。如果提供， *globals* 必须是字典。
   如果提供，则 *locals* 可以是任何映射对象。

   参数 *expression* 是一个可以被解析和计算的值。例如：

      >>> x = 1
      >>> eval('x+1')
      2



.. index:: builtin: exec

.. function:: exec(object[, globals[, locals]])

   此函数支持Python代码的动态执行。 *object* 必须是字符串或代码对象。
   如果它是一个字符串，则将该字符串解析为一组Python语句，然后执行该语句（除非发生语法错误）。
   如果是代码对象，则只执行它。在所有情况下，执行的代码应该作为文件输入有效。
   请注意， 即使在传递给函数的代码的上下文中，也不能在函数定义之外使用return和yield语句 :func:`exec`。
   返回值是 ``None`` 。

.. function:: filter(function, iterable)

   用 *iterable* 的元素构造一个迭代器， *function* 返回true。
   *iterable* 可以是序列，支持迭代的容器，也可以是迭代器。
   如果 *function* 是 ``None``，同样会假定 *function* 所有的元素迭代是假的被删除。
 
   函数 ``filter(function, iterable)`` 等价于生成器表达式：
    ``(item for item in iterable if function(item))`` 如果函数不是
   ``None`` 和 ``(item for item in iterable if item)`` 

   可以参考 :func:`itertools.filterfalse` 


.. class:: float([x])

   .. index::
      single: NaN
      single: Infinity

   返回由数字或字符串x构造的浮点数。

   如果参数是一个字符串，它应该包含一个十进制数字，也可以用符号 ``'+'`` 或 ``'-'`` 开头。
   也可以用空格包裹。参数也可以是表示NaN（非数字）或正或负无穷大的字符串。
   更确切地说，在删除前导和尾随空格字符后，输入必须符合以下语法：

   .. productionlist::
      sign: "+" | "-"
      infinity: "Infinity" | "inf"
      nan: "nan"
      numeric_value: `floatnumber` | `infinity` | `nan`
      numeric_string: [`sign`] `numeric_value`

   如果传入的整数超出了python 的float的范围，则会触发错误：:exc:`OverflowError` 。

   对象 ``x`` 使用 ``float(x)`` 时，会调用 ``x.__float__()``。

   如果没有传入参数，则返回： ``0.0`` 

   Examples::

      >>> float('+1.23')
      1.23
      >>> float('   -12345\n')
      -12345.0
      >>> float('1e-003')
      0.001
      >>> float('+1E6')
      1000000.0
      >>> float('-Infinity')
      -inf

   .. versionchanged:: 3.6
      Grouping digits with underscores as in code literals is allowed.

   .. versionchanged:: 3.7
      *x* is now a positional-only parameter.


.. index::
   single: __format__
   single: string; format() (built-in function)

.. function:: format(value[, format_spec])

   转换 *value* 成为一个格式化的字符串，这个格式化的格式被 *format_spec* 控制。
   *format_spec* 的解释依赖于参数 *value* 。

   默认 *format_spec* 是空字符串。通常与调用具有和 :func:`str(value) <str>` 相同的效果
 
.. _func-frozenset:
.. class:: frozenset([iterable])
   :noindex:

   返回一个新 *frozenset* 对象，可选地包含从iterable中获取的元素，生成的对象可以看作是一个集合。


.. function:: getattr(object, name[, default])

   返回对象 ``object`` 的 ``name`` 属性的值。 **name** 必须是一个字符串。
   如果字符串是对象一个属性的名称，则结果是该属性的值。如果 ``name`` 属性不存在，
   则返回 *default* （如果提供）。否则引发 :exc:`AttributeError`

.. function:: globals()

   返回表示当前全局符号表的字典。这始终是当前模块的字典（在函数或方法内部，这是定义它的模块，而不是调用它的模块）。


.. function:: hasattr(object, name)

   参数是一个对象和一个字符串。如果字符串是对象属性之一的名称，则返回 **True** ，如果不是 **False** 。
   这是通过调用 ``getattr(object, name)`` 并查看它是否会引发 :exc:`AttributeError` 来实现的。


.. function:: hash(object)

   返回对象的哈希值（如果有的话）。哈希值是整数。它们用于在字典查找期间快速比较字典键。
   比较相等的数字值具有相同的哈希值（即使它们具有不同的类型，如1和1.0的情况）。

   .. note::

      对于具有自定义 ``__hash__()`` 方法的对象，请注意 :func:`hash` 根据主机的位宽截断返回值。 


.. function:: help([object])

   显示对象的帮助信息

   这个帮助函数是通过内置模块 **site** 提供.

   .. versionchanged:: 3.4
      Changes to :mod:`pydoc` and :mod:`inspect` mean that the reported
      signatures for callables are now more comprehensive and consistent.


.. function:: hex(x)

   把数字转换为小写前缀 "0x" 开头的16进制数字。x需要是整型制数字(int)。
   实例：

      >>> hex(255)
      '0xff'
      >>> hex(-42)
      '-0x2a'

   如果转换大写字母开始的十六进制的16进制数字可以参考下面实例：

     >>> '%#x' % 255, '%x' % 255, '%X' % 255
     ('0xff', 'ff', 'FF')
     >>> format(255, '#x'), format(255, 'x'), format(255, 'X')
     ('0xff', 'ff', 'FF')
     >>> f'{255:#x}', f'{255:x}', f'{255:X}'
     ('0xff', 'ff', 'FF')

   可以参考 :func:`format` 查看更多的信息。

   查看 :func:`int` 函数把字符串转换为int，然后再转换位16进制数字

   .. note::

      To obtain a hexadecimal string representation for a float, use the
      :meth:`float.hex` method.


.. function:: id(object)

   返回对象的唯一标识（"identity"）。返回的唯一标识是整数。

   .. impl-detail:: 这是内存中对象的地址。


.. function:: input([prompt])

   如果输入参数 *prompt* 设置了。那么在输入的内容直接在这个参数同一行输入，不用在新的一行输入。
   如果在读入内容读取到 EOF 会触发错误 :exc:`EOFError` 。例如：

      >>> s = input('--> ')  # doctest: +SKIP
      --> Monty Python's Flying Circus
      >>> s  # doctest: +SKIP
      "Monty Python's Flying Circus"

   - 这个函数功能等于Python2中的 ``raw_input`` ，Python2中的input已经在python3中取消。

.. class:: int([x])
           int(x, base=10)

   如果没有传入参数返回0。 如果传入则返回字符串x的整数形式。
   如果传入浮点数，则返回这个浮点数的下界整数。

   如果给定参数base，那么x就必须是字符串。这也给参数base的作用是把指定base进制的数字
   转换位int类型数字。其中base常见的参数是2、8、16。在指定base为2进制8进制16进制时
   x可以有前缀或者没有前缀0b/0B、0o/0O、0x/0X。

   The integer type is described in :ref:`typesnumeric`.

   .. versionchanged:: 3.4
      If *base* is not an instance of :class:`int` and the *base* object has a
      :meth:`base.__index__ <object.__index__>` method, that method is called
      to obtain an integer for the base.  Previous versions used
      :meth:`base.__int__ <object.__int__>` instead of :meth:`base.__index__
      <object.__index__>`.

   .. versionchanged:: 3.6
      Grouping digits with underscores as in code literals is allowed.

   .. versionchanged:: 3.7
      *x* is now a positional-only parameter.


.. function:: isinstance(object, classinfo)

   如果返回True，那么参数 *object* 是参数 *classinfo* 类型的一个实例。
   否则返回False。如果参数 *classinfo* 不是一种类型或者一些类型组成的元组
   会触发一个错误 :exc:`TypeError` 。


.. function:: issubclass(class, classinfo)

   返回True，则说明class是classinfo的子类(direct, indirect or :term:`virtual
   <abstract base class>` 也就是直接子类、间接子类、虚拟子类) 。
   否则返回False。In any other
   classinfo可以是类名或者类名组成的元组，否则会触发错误 :exc:`TypeError` .


.. function:: iter(object[, sentinel])

   返回一个迭代器对象。

   如果只有第一个参数（没有传入第二个参数），那么对象必须是一个支持迭代协议的
   集合对象( *__iter__()* 方法)，或者它必须支持序列协议( *__getitem__()* 方法，整数参数从0开始)，
   如果它不支持这两个协议中的任何一个，就会引发类型错误。
   
   如果给出第二个参数 *sentinel* ，那么对象必须是一个可调用的对象。
   在本例中创建的迭代器将调用对象，每次调用其 *__next__()* 方法时不带参数;
   如果返回的值等于sentinel，则将引发StopIteration，否则将返回该值。


.. function:: len(s)

   返回一个整数，这个整数是传入s（可以是字符串/元组/列表/字典/集合）的长度。

.. _func-list:
.. class:: list([iterable])
   :noindex:

   list不是一个函数，而是一个可变序列类型。

.. function:: locals()

   更新并返回表示当前环境(函数或模块内)符号（变量）表的字典。
   自由变量在函数块中调用时由局部变量()返回，但在类块中不返回。

.. note:: 这个字典不可以被修改。

.. function:: map(function, iterable, ...)

   返回一个迭代器。这个迭代器的每个元素，是用函数 *function* 处理传入 *iterable* 的每一项
   的结果,这个结果是通过 yielding 返回的结果。如果传入多个 *iterable* 参数。那么会必须用
   *function* 函数取到每个参数的每个项。实例：

.. code-block:: python
    :linenos:

   In [1]: def jian(x,y):
   ...:     return x-y
   ...:

   In [2]: s = [1,2,3,4]

   In [3]: a = [1,1,1,1]

   In [4]: list(map(jian,s,a))
   Out[4]: [0, 1, 2, 3]

.. function:: max(iterable, *[, key, default])
              max(arg1, arg2, *args[, key])

   返回传入第一个可迭代对象的最大值，或者传入多个参数中的最小值

   .. versionadded:: 3.4
      The *default* keyword-only argument.


.. _func-memoryview:
.. function:: memoryview(obj)
   :noindex:

   返回传入参数的内存视图。


.. function:: min(iterable, *[, key, default])
              min(arg1, arg2, *args[, key])

   返回传入第一个可迭代对象的最小值，或者传入多个参数中的最小值

   .. versionadded:: 3.4
      The *default* keyword-only argument.


.. function:: next(iterator[, default])

   返回可迭代对象的下一个值。
   通过调用迭代器的 *__next__()* 方法从迭代器中检索下一项。
   如果给出了缺省值，则在迭代器耗尽时返回缺省值，否则将引发StopIteration。


.. function:: oct(x)

   把整数x转换为八进制数字。
   例如:

      >>> oct(8)
      '0o10'
      >>> oct(-56)
      '-0o70'

   如果想要去掉转换的8进制的"0o" 可以通过下面方法：

      >>> '%#o' % 10, '%o' % 10
      ('0o12', '12')
      >>> format(10, '#o'), format(10, 'o')
      ('0o12', '12')
      >>> f'{10:#o}', f'{10:o}'
      ('0o12', '12')


.. function:: open(file, mode='r', buffering=-1, encoding=None, errors=None, newline=None, closefd=True, opener=None)

   打开传入的 *file* 然后返回一个file类型。如果打开失败，则
   触发一个 :exc:`OSError` 错误。

   *file* 是一个绝对路径或相对路径的文件名。

   *mode* 是打开文件的方式。可以支持 ``'r'`` 读， ``'w'`` 写，
   ``'x'`` 写模式，新建一个文件，如果该文件已存在则会报错。
   ``'a'`` 追加方式打开问卷。

   .. _filemodes:

   .. index::
      pair: file; modes

   ========= ===============================================================
   Character Meaning
   ========= ===============================================================
   ``'r'``   读方式打开文件 (默认)
   ``'w'``   写方式打开文件
   ``'x'``   独占资源打开，如果没有文件则报错
   ``'a'``   写方式打开文件，如果没有则创建。写入时会默认在最后追加到文件。
   ``'b'``   二进制文件打开
   ``'t'``   文本模式 (default)
   ``'+'``   打开硬盘文件。(reading and writing)
   ========= ===============================================================


   * ``'strict'`` 默认的值。可能会触发错误 :exc:`ValueError` 和
     指定值 ``None`` 作用相同。

   * ``'ignore'`` 忽略错误，不会因为编码而触发错误。

   * ``'replace'`` causes a replacement marker (such as ``'?'``) to be inserted
     where there is malformed data.


.. function:: ord(c)

   返回传入字符c的整型值。
   
   相反功能的参数参考 :func:`chr`.


.. function:: pow(x, y[, z])

   如果只传入参数 **x，y** 则返回x的y次方，即 *x**y*

   如果传入三个参数则返回x的y次方对z取模。效率比
   *pow(x, y) % z)* 高。

.. function:: print(*objects, sep=' ', end='\\n', file=sys.stdout, flush=False)

   将 *objects* 输出到标准输出。

   .. versionchanged:: 3.3
      Added the *flush* keyword argument.


.. class:: property(fget=None, fset=None, fdel=None, doc=None)

   在新式类中返回属性值。

   *fget* 获取属性值的函数。
   *fset* 设置属性值的函数
   *fdel* 删除属性值函数
   *doc* 属性描述信息

   A typical use is to define a managed attribute ``x``::

      class C:
          def __init__(self):
              self._x = None

          def getx(self):
              return self._x

          def setx(self, value):
              self._x = value

          def delx(self):
              del self._x

          x = property(getx, setx, delx, "I'm the 'x' property.")

      class Parrot:
          def __init__(self):
              self._voltage = 100000

          @property
          def voltage(self):
              """Get the current voltage."""
              return self._voltage

      class C:
          def __init__(self):
              self._x = None

          @property
          def x(self):
              """I'm the 'x' property."""
              return self._x

          @x.setter
          def x(self, value):
              self._x = value

          @x.deleter
          def x(self):
              del self._x


.. _func-range:
.. function:: range(stop)
              range(start, stop[, step])
   :noindex:

   返回一个迭代器。迭代器的元素数值是从start开始以step为步长到stop为截至。

   如果没有传入step，则默认步长为1。

   功能可以看作相当于Python2中的xrange。

.. function:: repr(object)

   返回字对象的字符串形式。

.. function:: reversed(seq)

   返回逆序序列的迭代器。逆序序列中的元素是传入序列的值。


.. function:: round(number[, ndigits])

   返回一个整数。
   
   这个小数是传入 *number* 四舍五入到ndigits精度的数字。如果省略了ndigit或为None，则返回其输入的最近整数。

   实例::

   In [5]: round(2.15,1)
   Out[5]: 2.1

   In [6]: round(2.151,1)
   Out[6]: 2.2

.. _func-set:
.. class:: set([iterable])
   :noindex:

   返回一个集合。

.. function:: setattr(object, name, value)

   这个函数和 :func:`getattr` 很相似。传入的参数是一个对象, 设置这个对象指定字符串名称的属性值。
   例如, ``setattr(x, 'foobar', 123)`` 作用等效于 ``x.foobar = 123``.

.. class:: slice(stop)
           slice(start, stop[, step])

   .. index:: single: Numerical Python

   返回一个切片对象。


.. function:: sorted(iterable, *, key=None, reverse=False)

   返回一个新的排序好的可迭代对象，这个迭代对象的原始是传入 *iterable* 的元素。

   Has two optional arguments which must be specified as keyword arguments.

   *key* 可以是一个比较 *iterable* 中元素的方法(例如, ``key=str.lower``). 默认
   是 ``None`` (直接比较里面的元素).

   *reverse* 值是布尔型. 如果传入 ``True``, 那么比较的值会被反序排序。


.. decorator:: staticmethod

   声明静态方法::

      class C:
          @staticmethod
          def f(arg1, arg2, ...): ...

      class C:
          builtin_open = staticmethod(open)


.. index::
   single: string; str() (built-in function)

.. _func-str:
.. class:: str(object='')
           str(object=b'', encoding='utf-8', errors='strict')
   :noindex:

   把传入对象转换位字符串类型返回。


.. function:: sum(iterable[, start])

   返回可迭代带对象iterable的和。

   如果传入start，则计算的和以后再加上start为返回值。

.. function:: super([type[, object-or-type]])

   这个函数是用于调用父类(超类)的一个方法。

   super 是用来解决多重继承问题的，直接用类名调用父类方法在使用单继承的时候没问题，但是如果使用多继承，会涉及到查找顺序（MRO）、重复调用（钻石继承）等种种问题。

   MRO 就是类的方法解析顺序表, 其实也就是继承父类方法时的顺序表。
   
   例如::

      class C(B):
          def method(self, arg):
              super().method(arg)    # This does the same thing as:
                                     # super(C, self).method(arg)


.. _func-tuple:
.. function:: tuple([iterable])
   :noindex:

   是元组类型，这不是函数。

.. class:: type(object)
           type(name, bases, dict)

   .. index:: object: type

   返回 *object* 的类型。
   例如::

      >>> class X:
      ...     a = 1
      ...
      >>> X = type('X', (object,), dict(a=1))


.. function:: vars([object])

   返回对象object的属性和属性值的字典对象。

   如果没有传入参数，则这个函数作用和 :func:`locals` 作用相同。


.. function:: zip(*iterables)

   创建一个迭代器，它聚合来自每个迭代器的元素。

   返回值是一个元组迭代器。会把传入的所有可迭代对象都依次取出，然后构成一个元组。
   例如::

        def zip(*iterables):
            # zip('ABCD', 'xy') --> Ax By
            sentinel = object()
            iterators = [iter(it) for it in iterables]
            while iterators:
                result = []
                for it in iterators:
                    elem = next(it, sentinel)
                    if elem is sentinel:
                        return
                    result.append(elem)
                yield tuple(result)

   参考下面实例::

      >>> x = [1, 2, 3]
      >>> y = [4, 5, 6]
      >>> zipped = zip(x, y)
      >>> list(zipped)
      [(1, 4), (2, 5), (3, 6)]
      >>> x2, y2 = zip(*zip(x, y))
      >>> x == list(x2) and y == list(y2)
      True


.. function:: __import__(name, globals=None, locals=None, fromlist=(), level=0)

   .. index::
      statement: import
      module: imp

   .. note::

      This is an advanced function that is not needed in everyday Python
      programming, unlike :func:`importlib.import_module`.

   This function is invoked by the :keyword:`import` statement.  It can be
   replaced (by importing the :mod:`builtins` module and assigning to
   ``builtins.__import__``) in order to change semantics of the
   :keyword:`!import` statement, but doing so is **strongly** discouraged as it
   is usually simpler to use import hooks (see :pep:`302`) to attain the same
   goals and does not cause issues with code which assumes the default import
   implementation is in use.  Direct use of :func:`__import__` is also
   discouraged in favor of :func:`importlib.import_module`.

   The function imports the module *name*, potentially using the given *globals*
   and *locals* to determine how to interpret the name in a package context.
   The *fromlist* gives the names of objects or submodules that should be
   imported from the module given by *name*.  The standard implementation does
   not use its *locals* argument at all, and uses its *globals* only to
   determine the package context of the :keyword:`import` statement.

   *level* specifies whether to use absolute or relative imports. ``0`` (the
   default) means only perform absolute imports.  Positive values for
   *level* indicate the number of parent directories to search relative to the
   directory of the module calling :func:`__import__` (see :pep:`328` for the
   details).

   When the *name* variable is of the form ``package.module``, normally, the
   top-level package (the name up till the first dot) is returned, *not* the
   module named by *name*.  However, when a non-empty *fromlist* argument is
   given, the module named by *name* is returned.

   For example, the statement ``import spam`` results in bytecode resembling the
   following code::

      spam = __import__('spam', globals(), locals(), [], 0)

   The statement ``import spam.ham`` results in this call::

      spam = __import__('spam.ham', globals(), locals(), [], 0)

   Note how :func:`__import__` returns the toplevel module here because this is
   the object that is bound to a name by the :keyword:`import` statement.

   On the other hand, the statement ``from spam.ham import eggs, sausage as
   saus`` results in ::

      _temp = __import__('spam.ham', globals(), locals(), ['eggs', 'sausage'], 0)
      eggs = _temp.eggs
      saus = _temp.sausage

   Here, the ``spam.ham`` module is returned from :func:`__import__`.  From this
   object, the names to import are retrieved and assigned to their respective
   names.

   If you simply want to import a module (potentially within a package) by name,
   use :func:`importlib.import_module`.

   .. versionchanged:: 3.3
      Negative values for *level* are no longer supported (which also changes
      the default value to 0).


.. rubric:: Footnotes

.. [#] Note that the parser only accepts the Unix-style end of line convention.
   If you are reading the code from a file, make sure to use newline conversion
   mode to convert Windows or Mac-style newlines.
