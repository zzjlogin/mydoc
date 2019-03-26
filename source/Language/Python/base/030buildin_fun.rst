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

   Invoke the built-in help system.  (This function is intended for interactive
   use.)  If no argument is given, the interactive help system starts on the
   interpreter console.  If the argument is a string, then the string is looked up
   as the name of a module, function, class, method, keyword, or documentation
   topic, and a help page is printed on the console.  If the argument is any other
   kind of object, a help page on the object is generated.

   Note that if a slash(/) appears in the parameter list of a function, when
   invoking :func:`help`, it means that the parameters prior to the slash are
   positional-only. For more info, see
   :ref:`the FAQ entry on positional-only parameters <faq-positional-only-arguments>`.

   This function is added to the built-in namespace by the :mod:`site` module.

   .. versionchanged:: 3.4
      Changes to :mod:`pydoc` and :mod:`inspect` mean that the reported
      signatures for callables are now more comprehensive and consistent.


.. function:: hex(x)

   Convert an integer number to a lowercase hexadecimal string prefixed with
   "0x". If *x* is not a Python :class:`int` object, it has to define an
   :meth:`__index__` method that returns an integer. Some examples:

      >>> hex(255)
      '0xff'
      >>> hex(-42)
      '-0x2a'

   If you want to convert an integer number to an uppercase or lower hexadecimal
   string with prefix or not, you can use either of the following ways:

     >>> '%#x' % 255, '%x' % 255, '%X' % 255
     ('0xff', 'ff', 'FF')
     >>> format(255, '#x'), format(255, 'x'), format(255, 'X')
     ('0xff', 'ff', 'FF')
     >>> f'{255:#x}', f'{255:x}', f'{255:X}'
     ('0xff', 'ff', 'FF')

   See also :func:`format` for more information.

   See also :func:`int` for converting a hexadecimal string to an
   integer using a base of 16.

   .. note::

      To obtain a hexadecimal string representation for a float, use the
      :meth:`float.hex` method.


.. function:: id(object)

   Return the "identity" of an object.  This is an integer which
   is guaranteed to be unique and constant for this object during its lifetime.
   Two objects with non-overlapping lifetimes may have the same :func:`id`
   value.

   .. impl-detail:: This is the address of the object in memory.


.. function:: input([prompt])

   If the *prompt* argument is present, it is written to standard output without
   a trailing newline.  The function then reads a line from input, converts it
   to a string (stripping a trailing newline), and returns that.  When EOF is
   read, :exc:`EOFError` is raised.  Example::

      >>> s = input('--> ')  # doctest: +SKIP
      --> Monty Python's Flying Circus
      >>> s  # doctest: +SKIP
      "Monty Python's Flying Circus"

   If the :mod:`readline` module was loaded, then :func:`input` will use it
   to provide elaborate line editing and history features.


.. class:: int([x])
           int(x, base=10)

   Return an integer object constructed from a number or string *x*, or return
   ``0`` if no arguments are given.  If *x* defines :meth:`__int__`,
   ``int(x)`` returns ``x.__int__()``.  If *x* defines :meth:`__trunc__`,
   it returns ``x.__trunc__()``.
   For floating point numbers, this truncates towards zero.

   If *x* is not a number or if *base* is given, then *x* must be a string,
   :class:`bytes`, or :class:`bytearray` instance representing an :ref:`integer
   literal <integers>` in radix *base*.  Optionally, the literal can be
   preceded by ``+`` or ``-`` (with no space in between) and surrounded by
   whitespace.  A base-n literal consists of the digits 0 to n-1, with ``a``
   to ``z`` (or ``A`` to ``Z``) having
   values 10 to 35.  The default *base* is 10. The allowed values are 0 and 2--36.
   Base-2, -8, and -16 literals can be optionally prefixed with ``0b``/``0B``,
   ``0o``/``0O``, or ``0x``/``0X``, as with integer literals in code.  Base 0
   means to interpret exactly as a code literal, so that the actual base is 2,
   8, 10, or 16, and so that ``int('010', 0)`` is not legal, while
   ``int('010')`` is, as well as ``int('010', 8)``.

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

   Return true if the *object* argument is an instance of the *classinfo*
   argument, or of a (direct, indirect or :term:`virtual <abstract base
   class>`) subclass thereof.  If *object* is not
   an object of the given type, the function always returns false.
   If *classinfo* is a tuple of type objects (or recursively, other such
   tuples), return true if *object* is an instance of any of the types.
   If *classinfo* is not a type or tuple of types and such tuples,
   a :exc:`TypeError` exception is raised.


.. function:: issubclass(class, classinfo)

   Return true if *class* is a subclass (direct, indirect or :term:`virtual
   <abstract base class>`) of *classinfo*.  A
   class is considered a subclass of itself. *classinfo* may be a tuple of class
   objects, in which case every entry in *classinfo* will be checked. In any other
   case, a :exc:`TypeError` exception is raised.


.. function:: iter(object[, sentinel])

   Return an :term:`iterator` object.  The first argument is interpreted very
   differently depending on the presence of the second argument. Without a
   second argument, *object* must be a collection object which supports the
   iteration protocol (the :meth:`__iter__` method), or it must support the
   sequence protocol (the :meth:`__getitem__` method with integer arguments
   starting at ``0``).  If it does not support either of those protocols,
   :exc:`TypeError` is raised. If the second argument, *sentinel*, is given,
   then *object* must be a callable object.  The iterator created in this case
   will call *object* with no arguments for each call to its
   :meth:`~iterator.__next__` method; if the value returned is equal to
   *sentinel*, :exc:`StopIteration` will be raised, otherwise the value will
   be returned.

   See also :ref:`typeiter`.

   One useful application of the second form of :func:`iter` is to build a
   block-reader. For example, reading fixed-width blocks from a binary
   database file until the end of file is reached::

      from functools import partial
      with open('mydata.db', 'rb') as f:
          for block in iter(partial(f.read, 64), b''):
              process_block(block)


.. function:: len(s)

   Return the length (the number of items) of an object.  The argument may be a
   sequence (such as a string, bytes, tuple, list, or range) or a collection
   (such as a dictionary, set, or frozen set).


.. _func-list:
.. class:: list([iterable])
   :noindex:

   Rather than being a function, :class:`list` is actually a mutable
   sequence type, as documented in :ref:`typesseq-list` and :ref:`typesseq`.


.. function:: locals()

   Update and return a dictionary representing the current local symbol table.
   Free variables are returned by :func:`locals` when it is called in function
   blocks, but not in class blocks.

   .. note::
      The contents of this dictionary should not be modified; changes may not
      affect the values of local and free variables used by the interpreter.

.. function:: map(function, iterable, ...)

   Return an iterator that applies *function* to every item of *iterable*,
   yielding the results.  If additional *iterable* arguments are passed,
   *function* must take that many arguments and is applied to the items from all
   iterables in parallel.  With multiple iterables, the iterator stops when the
   shortest iterable is exhausted.  For cases where the function inputs are
   already arranged into argument tuples, see :func:`itertools.starmap`\.


.. function:: max(iterable, *[, key, default])
              max(arg1, arg2, *args[, key])

   Return the largest item in an iterable or the largest of two or more
   arguments.

   If one positional argument is provided, it should be an :term:`iterable`.
   The largest item in the iterable is returned.  If two or more positional
   arguments are provided, the largest of the positional arguments is
   returned.

   There are two optional keyword-only arguments. The *key* argument specifies
   a one-argument ordering function like that used for :meth:`list.sort`. The
   *default* argument specifies an object to return if the provided iterable is
   empty. If the iterable is empty and *default* is not provided, a
   :exc:`ValueError` is raised.

   If multiple items are maximal, the function returns the first one
   encountered.  This is consistent with other sort-stability preserving tools
   such as ``sorted(iterable, key=keyfunc, reverse=True)[0]`` and
   ``heapq.nlargest(1, iterable, key=keyfunc)``.

   .. versionadded:: 3.4
      The *default* keyword-only argument.


.. _func-memoryview:
.. function:: memoryview(obj)
   :noindex:

   Return a "memory view" object created from the given argument.  See
   :ref:`typememoryview` for more information.


.. function:: min(iterable, *[, key, default])
              min(arg1, arg2, *args[, key])

   Return the smallest item in an iterable or the smallest of two or more
   arguments.

   If one positional argument is provided, it should be an :term:`iterable`.
   The smallest item in the iterable is returned.  If two or more positional
   arguments are provided, the smallest of the positional arguments is
   returned.

   There are two optional keyword-only arguments. The *key* argument specifies
   a one-argument ordering function like that used for :meth:`list.sort`. The
   *default* argument specifies an object to return if the provided iterable is
   empty. If the iterable is empty and *default* is not provided, a
   :exc:`ValueError` is raised.

   If multiple items are minimal, the function returns the first one
   encountered.  This is consistent with other sort-stability preserving tools
   such as ``sorted(iterable, key=keyfunc)[0]`` and ``heapq.nsmallest(1,
   iterable, key=keyfunc)``.

   .. versionadded:: 3.4
      The *default* keyword-only argument.


.. function:: next(iterator[, default])

   Retrieve the next item from the *iterator* by calling its
   :meth:`~iterator.__next__` method.  If *default* is given, it is returned
   if the iterator is exhausted, otherwise :exc:`StopIteration` is raised.


.. class:: object()

   Return a new featureless object.  :class:`object` is a base for all classes.
   It has the methods that are common to all instances of Python classes.  This
   function does not accept any arguments.

   .. note::

      :class:`object` does *not* have a :attr:`~object.__dict__`, so you can't
      assign arbitrary attributes to an instance of the :class:`object` class.


.. function:: oct(x)

  Convert an integer number to an octal string prefixed with "0o".  The result
  is a valid Python expression. If *x* is not a Python :class:`int` object, it
  has to define an :meth:`__index__` method that returns an integer. For
  example:

      >>> oct(8)
      '0o10'
      >>> oct(-56)
      '-0o70'

  If you want to convert an integer number to octal string either with prefix
  "0o" or not, you can use either of the following ways.

      >>> '%#o' % 10, '%o' % 10
      ('0o12', '12')
      >>> format(10, '#o'), format(10, 'o')
      ('0o12', '12')
      >>> f'{10:#o}', f'{10:o}'
      ('0o12', '12')

  See also :func:`format` for more information.

   .. index::
      single: file object; open() built-in function

.. function:: open(file, mode='r', buffering=-1, encoding=None, errors=None, newline=None, closefd=True, opener=None)

   Open *file* and return a corresponding :term:`file object`.  If the file
   cannot be opened, an :exc:`OSError` is raised.

   *file* is a :term:`path-like object` giving the pathname (absolute or
   relative to the current working directory) of the file to be opened or an
   integer file descriptor of the file to be wrapped.  (If a file descriptor is
   given, it is closed when the returned I/O object is closed, unless *closefd*
   is set to ``False``.)

   *mode* is an optional string that specifies the mode in which the file is
   opened.  It defaults to ``'r'`` which means open for reading in text mode.
   Other common values are ``'w'`` for writing (truncating the file if it
   already exists), ``'x'`` for exclusive creation and ``'a'`` for appending
   (which on *some* Unix systems, means that *all* writes append to the end of
   the file regardless of the current seek position).  In text mode, if
   *encoding* is not specified the encoding used is platform dependent:
   ``locale.getpreferredencoding(False)`` is called to get the current locale
   encoding. (For reading and writing raw bytes use binary mode and leave
   *encoding* unspecified.)  The available modes are:

   .. _filemodes:

   .. index::
      pair: file; modes

   ========= ===============================================================
   Character Meaning
   ========= ===============================================================
   ``'r'``   open for reading (default)
   ``'w'``   open for writing, truncating the file first
   ``'x'``   open for exclusive creation, failing if the file already exists
   ``'a'``   open for writing, appending to the end of the file if it exists
   ``'b'``   binary mode
   ``'t'``   text mode (default)
   ``'+'``   open a disk file for updating (reading and writing)
   ========= ===============================================================

   The default mode is ``'r'`` (open for reading text, synonym of ``'rt'``).
   For binary read-write access, the mode ``'w+b'`` opens and truncates the file
   to 0 bytes.  ``'r+b'`` opens the file without truncation.

   As mentioned in the :ref:`io-overview`, Python distinguishes between binary
   and text I/O.  Files opened in binary mode (including ``'b'`` in the *mode*
   argument) return contents as :class:`bytes` objects without any decoding.  In
   text mode (the default, or when ``'t'`` is included in the *mode* argument),
   the contents of the file are returned as :class:`str`, the bytes having been
   first decoded using a platform-dependent encoding or using the specified
   *encoding* if given.

   There is an additional mode character permitted, ``'U'``, which no longer
   has any effect, and is considered deprecated. It previously enabled
   :term:`universal newlines` in text mode, which became the default behaviour
   in Python 3.0. Refer to the documentation of the
   :ref:`newline <open-newline-parameter>` parameter for further details.

   .. note::

      Python doesn't depend on the underlying operating system's notion of text
      files; all the processing is done by Python itself, and is therefore
      platform-independent.

   *buffering* is an optional integer used to set the buffering policy.  Pass 0
   to switch buffering off (only allowed in binary mode), 1 to select line
   buffering (only usable in text mode), and an integer > 1 to indicate the size
   in bytes of a fixed-size chunk buffer.  When no *buffering* argument is
   given, the default buffering policy works as follows:

   * Binary files are buffered in fixed-size chunks; the size of the buffer is
     chosen using a heuristic trying to determine the underlying device's "block
     size" and falling back on :attr:`io.DEFAULT_BUFFER_SIZE`.  On many systems,
     the buffer will typically be 4096 or 8192 bytes long.

   * "Interactive" text files (files for which :meth:`~io.IOBase.isatty`
     returns ``True``) use line buffering.  Other text files use the policy
     described above for binary files.

   *encoding* is the name of the encoding used to decode or encode the file.
   This should only be used in text mode.  The default encoding is platform
   dependent (whatever :func:`locale.getpreferredencoding` returns), but any
   :term:`text encoding` supported by Python
   can be used.  See the :mod:`codecs` module for
   the list of supported encodings.

   *errors* is an optional string that specifies how encoding and decoding
   errors are to be handled—this cannot be used in binary mode.
   A variety of standard error handlers are available
   (listed under :ref:`error-handlers`), though any
   error handling name that has been registered with
   :func:`codecs.register_error` is also valid.  The standard names
   include:

   * ``'strict'`` to raise a :exc:`ValueError` exception if there is
     an encoding error.  The default value of ``None`` has the same
     effect.

   * ``'ignore'`` ignores errors.  Note that ignoring encoding errors
     can lead to data loss.

   * ``'replace'`` causes a replacement marker (such as ``'?'``) to be inserted
     where there is malformed data.

   * ``'surrogateescape'`` will represent any incorrect bytes as code
     points in the Unicode Private Use Area ranging from U+DC80 to
     U+DCFF.  These private code points will then be turned back into
     the same bytes when the ``surrogateescape`` error handler is used
     when writing data.  This is useful for processing files in an
     unknown encoding.

   * ``'xmlcharrefreplace'`` is only supported when writing to a file.
     Characters not supported by the encoding are replaced with the
     appropriate XML character reference ``&#nnn;``.

   * ``'backslashreplace'`` replaces malformed data by Python's backslashed
     escape sequences.

   * ``'namereplace'`` (also only supported when writing)
     replaces unsupported characters with ``\N{...}`` escape sequences.

   .. index::
      single: universal newlines; open() built-in function

   .. _open-newline-parameter:

   *newline* controls how :term:`universal newlines` mode works (it only
   applies to text mode).  It can be ``None``, ``''``, ``'\n'``, ``'\r'``, and
   ``'\r\n'``.  It works as follows:

   * When reading input from the stream, if *newline* is ``None``, universal
     newlines mode is enabled.  Lines in the input can end in ``'\n'``,
     ``'\r'``, or ``'\r\n'``, and these are translated into ``'\n'`` before
     being returned to the caller.  If it is ``''``, universal newlines mode is
     enabled, but line endings are returned to the caller untranslated.  If it
     has any of the other legal values, input lines are only terminated by the
     given string, and the line ending is returned to the caller untranslated.

   * When writing output to the stream, if *newline* is ``None``, any ``'\n'``
     characters written are translated to the system default line separator,
     :data:`os.linesep`.  If *newline* is ``''`` or ``'\n'``, no translation
     takes place.  If *newline* is any of the other legal values, any ``'\n'``
     characters written are translated to the given string.

   If *closefd* is ``False`` and a file descriptor rather than a filename was
   given, the underlying file descriptor will be kept open when the file is
   closed.  If a filename is given *closefd* must be ``True`` (the default)
   otherwise an error will be raised.

   A custom opener can be used by passing a callable as *opener*. The underlying
   file descriptor for the file object is then obtained by calling *opener* with
   (*file*, *flags*). *opener* must return an open file descriptor (passing
   :mod:`os.open` as *opener* results in functionality similar to passing
   ``None``).

   The newly created file is :ref:`non-inheritable <fd_inheritance>`.

   The following example uses the :ref:`dir_fd <dir_fd>` parameter of the
   :func:`os.open` function to open a file relative to a given directory::

      >>> import os
      >>> dir_fd = os.open('somedir', os.O_RDONLY)
      >>> def opener(path, flags):
      ...     return os.open(path, flags, dir_fd=dir_fd)
      ...
      >>> with open('spamspam.txt', 'w', opener=opener) as f:
      ...     print('This will be written to somedir/spamspam.txt', file=f)
      ...
      >>> os.close(dir_fd)  # don't leak a file descriptor

   The type of :term:`file object` returned by the :func:`open` function
   depends on the mode.  When :func:`open` is used to open a file in a text
   mode (``'w'``, ``'r'``, ``'wt'``, ``'rt'``, etc.), it returns a subclass of
   :class:`io.TextIOBase` (specifically :class:`io.TextIOWrapper`).  When used
   to open a file in a binary mode with buffering, the returned class is a
   subclass of :class:`io.BufferedIOBase`.  The exact class varies: in read
   binary mode, it returns an :class:`io.BufferedReader`; in write binary and
   append binary modes, it returns an :class:`io.BufferedWriter`, and in
   read/write mode, it returns an :class:`io.BufferedRandom`.  When buffering is
   disabled, the raw stream, a subclass of :class:`io.RawIOBase`,
   :class:`io.FileIO`, is returned.

   .. index::
      single: line-buffered I/O
      single: unbuffered I/O
      single: buffer size, I/O
      single: I/O control; buffering
      single: binary mode
      single: text mode
      module: sys

   See also the file handling modules, such as, :mod:`fileinput`, :mod:`io`
   (where :func:`open` is declared), :mod:`os`, :mod:`os.path`, :mod:`tempfile`,
   and :mod:`shutil`.

   .. versionchanged::
      3.3

         * The *opener* parameter was added.
         * The ``'x'`` mode was added.
         * :exc:`IOError` used to be raised, it is now an alias of :exc:`OSError`.
         * :exc:`FileExistsError` is now raised if the file opened in exclusive
           creation mode (``'x'``) already exists.

   .. versionchanged::
      3.4

         * The file is now non-inheritable.

   .. deprecated-removed:: 3.4 4.0

      The ``'U'`` mode.

   .. versionchanged::
      3.5

         * If the system call is interrupted and the signal handler does not raise an
           exception, the function now retries the system call instead of raising an
           :exc:`InterruptedError` exception (see :pep:`475` for the rationale).
         * The ``'namereplace'`` error handler was added.

   .. versionchanged::
      3.6

         * Support added to accept objects implementing :class:`os.PathLike`.
         * On Windows, opening a console buffer may return a subclass of
           :class:`io.RawIOBase` other than :class:`io.FileIO`.

.. function:: ord(c)

   Given a string representing one Unicode character, return an integer
   representing the Unicode code point of that character.  For example,
   ``ord('a')`` returns the integer ``97`` and ``ord('€')`` (Euro sign)
   returns ``8364``.  This is the inverse of :func:`chr`.


.. function:: pow(x, y[, z])

   Return *x* to the power *y*; if *z* is present, return *x* to the power *y*,
   modulo *z* (computed more efficiently than ``pow(x, y) % z``). The two-argument
   form ``pow(x, y)`` is equivalent to using the power operator: ``x**y``.

   The arguments must have numeric types.  With mixed operand types, the
   coercion rules for binary arithmetic operators apply.  For :class:`int`
   operands, the result has the same type as the operands (after coercion)
   unless the second argument is negative; in that case, all arguments are
   converted to float and a float result is delivered.  For example, ``10**2``
   returns ``100``, but ``10**-2`` returns ``0.01``.  If the second argument is
   negative, the third argument must be omitted.  If *z* is present, *x* and *y*
   must be of integer types, and *y* must be non-negative.


.. function:: print(*objects, sep=' ', end='\\n', file=sys.stdout, flush=False)

   Print *objects* to the text stream *file*, separated by *sep* and followed
   by *end*.  *sep*, *end*, *file* and *flush*, if present, must be given as keyword
   arguments.

   All non-keyword arguments are converted to strings like :func:`str` does and
   written to the stream, separated by *sep* and followed by *end*.  Both *sep*
   and *end* must be strings; they can also be ``None``, which means to use the
   default values.  If no *objects* are given, :func:`print` will just write
   *end*.

   The *file* argument must be an object with a ``write(string)`` method; if it
   is not present or ``None``, :data:`sys.stdout` will be used.  Since printed
   arguments are converted to text strings, :func:`print` cannot be used with
   binary mode file objects.  For these, use ``file.write(...)`` instead.

   Whether output is buffered is usually determined by *file*, but if the
   *flush* keyword argument is true, the stream is forcibly flushed.

   .. versionchanged:: 3.3
      Added the *flush* keyword argument.


.. class:: property(fget=None, fset=None, fdel=None, doc=None)

   Return a property attribute.

   *fget* is a function for getting an attribute value.  *fset* is a function
   for setting an attribute value. *fdel* is a function for deleting an attribute
   value.  And *doc* creates a docstring for the attribute.

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

   If *c* is an instance of *C*, ``c.x`` will invoke the getter,
   ``c.x = value`` will invoke the setter and ``del c.x`` the deleter.

   If given, *doc* will be the docstring of the property attribute. Otherwise, the
   property will copy *fget*'s docstring (if it exists).  This makes it possible to
   create read-only properties easily using :func:`property` as a :term:`decorator`::

      class Parrot:
          def __init__(self):
              self._voltage = 100000

          @property
          def voltage(self):
              """Get the current voltage."""
              return self._voltage

   The ``@property`` decorator turns the :meth:`voltage` method into a "getter"
   for a read-only attribute with the same name, and it sets the docstring for
   *voltage* to "Get the current voltage."

   A property object has :attr:`~property.getter`, :attr:`~property.setter`,
   and :attr:`~property.deleter` methods usable as decorators that create a
   copy of the property with the corresponding accessor function set to the
   decorated function.  This is best explained with an example::

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

   This code is exactly equivalent to the first example.  Be sure to give the
   additional functions the same name as the original property (``x`` in this
   case.)

   The returned property object also has the attributes ``fget``, ``fset``, and
   ``fdel`` corresponding to the constructor arguments.

   .. versionchanged:: 3.5
      The docstrings of property objects are now writeable.


.. _func-range:
.. function:: range(stop)
              range(start, stop[, step])
   :noindex:

   Rather than being a function, :class:`range` is actually an immutable
   sequence type, as documented in :ref:`typesseq-range` and :ref:`typesseq`.


.. function:: repr(object)

   Return a string containing a printable representation of an object.  For many
   types, this function makes an attempt to return a string that would yield an
   object with the same value when passed to :func:`eval`, otherwise the
   representation is a string enclosed in angle brackets that contains the name
   of the type of the object together with additional information often
   including the name and address of the object.  A class can control what this
   function returns for its instances by defining a :meth:`__repr__` method.


.. function:: reversed(seq)

   Return a reverse :term:`iterator`.  *seq* must be an object which has
   a :meth:`__reversed__` method or supports the sequence protocol (the
   :meth:`__len__` method and the :meth:`__getitem__` method with integer
   arguments starting at ``0``).


.. function:: round(number[, ndigits])

   Return *number* rounded to *ndigits* precision after the decimal
   point.  If *ndigits* is omitted or is ``None``, it returns the
   nearest integer to its input.

   For the built-in types supporting :func:`round`, values are rounded to the
   closest multiple of 10 to the power minus *ndigits*; if two multiples are
   equally close, rounding is done toward the even choice (so, for example,
   both ``round(0.5)`` and ``round(-0.5)`` are ``0``, and ``round(1.5)`` is
   ``2``).  Any integer value is valid for *ndigits* (positive, zero, or
   negative).  The return value is an integer if *ndigits* is omitted or
   ``None``.
   Otherwise the return value has the same type as *number*.

   For a general Python object ``number``, ``round`` delegates to
   ``number.__round__``.

   .. note::

      The behavior of :func:`round` for floats can be surprising: for example,
      ``round(2.675, 2)`` gives ``2.67`` instead of the expected ``2.68``.
      This is not a bug: it's a result of the fact that most decimal fractions
      can't be represented exactly as a float.  See :ref:`tut-fp-issues` for
      more information.


.. _func-set:
.. class:: set([iterable])
   :noindex:

   Return a new :class:`set` object, optionally with elements taken from
   *iterable*.  ``set`` is a built-in class.  See :class:`set` and
   :ref:`types-set` for documentation about this class.

   For other containers see the built-in :class:`frozenset`, :class:`list`,
   :class:`tuple`, and :class:`dict` classes, as well as the :mod:`collections`
   module.


.. function:: setattr(object, name, value)

   This is the counterpart of :func:`getattr`.  The arguments are an object, a
   string and an arbitrary value.  The string may name an existing attribute or a
   new attribute.  The function assigns the value to the attribute, provided the
   object allows it.  For example, ``setattr(x, 'foobar', 123)`` is equivalent to
   ``x.foobar = 123``.


.. class:: slice(stop)
           slice(start, stop[, step])

   .. index:: single: Numerical Python

   Return a :term:`slice` object representing the set of indices specified by
   ``range(start, stop, step)``.  The *start* and *step* arguments default to
   ``None``.  Slice objects have read-only data attributes :attr:`~slice.start`,
   :attr:`~slice.stop` and :attr:`~slice.step` which merely return the argument
   values (or their default).  They have no other explicit functionality;
   however they are used by Numerical Python and other third party extensions.
   Slice objects are also generated when extended indexing syntax is used.  For
   example: ``a[start:stop:step]`` or ``a[start:stop, i]``.  See
   :func:`itertools.islice` for an alternate version that returns an iterator.


.. function:: sorted(iterable, *, key=None, reverse=False)

   Return a new sorted list from the items in *iterable*.

   Has two optional arguments which must be specified as keyword arguments.

   *key* specifies a function of one argument that is used to extract a comparison
   key from each element in *iterable* (for example, ``key=str.lower``).  The
   default value is ``None`` (compare the elements directly).

   *reverse* is a boolean value.  If set to ``True``, then the list elements are
   sorted as if each comparison were reversed.

   Use :func:`functools.cmp_to_key` to convert an old-style *cmp* function to a
   *key* function.

   The built-in :func:`sorted` function is guaranteed to be stable. A sort is
   stable if it guarantees not to change the relative order of elements that
   compare equal --- this is helpful for sorting in multiple passes (for
   example, sort by department, then by salary grade).

   For sorting examples and a brief sorting tutorial, see :ref:`sortinghowto`.

.. decorator:: staticmethod

   Transform a method into a static method.

   A static method does not receive an implicit first argument. To declare a static
   method, use this idiom::

      class C:
          @staticmethod
          def f(arg1, arg2, ...): ...

   The ``@staticmethod`` form is a function :term:`decorator` -- see
   :ref:`function` for details.

   A static method can be called either on the class (such as ``C.f()``) or on an instance (such
   as ``C().f()``).

   Static methods in Python are similar to those found in Java or C++. Also see
   :func:`classmethod` for a variant that is useful for creating alternate class
   constructors.

   Like all decorators, it is also possible to call ``staticmethod`` as
   a regular function and do something with its result.  This is needed
   in some cases where you need a reference to a function from a class
   body and you want to avoid the automatic transformation to instance
   method.  For these cases, use this idiom::

      class C:
          builtin_open = staticmethod(open)

   For more information on static methods, see :ref:`types`.


.. index::
   single: string; str() (built-in function)

.. _func-str:
.. class:: str(object='')
           str(object=b'', encoding='utf-8', errors='strict')
   :noindex:

   Return a :class:`str` version of *object*.  See :func:`str` for details.

   ``str`` is the built-in string :term:`class`.  For general information
   about strings, see :ref:`textseq`.


.. function:: sum(iterable[, start])

   Sums *start* and the items of an *iterable* from left to right and returns the
   total.  *start* defaults to ``0``. The *iterable*'s items are normally numbers,
   and the start value is not allowed to be a string.

   For some use cases, there are good alternatives to :func:`sum`.
   The preferred, fast way to concatenate a sequence of strings is by calling
   ``''.join(sequence)``.  To add floating point values with extended precision,
   see :func:`math.fsum`\.  To concatenate a series of iterables, consider using
   :func:`itertools.chain`.

.. function:: super([type[, object-or-type]])

   Return a proxy object that delegates method calls to a parent or sibling
   class of *type*.  This is useful for accessing inherited methods that have
   been overridden in a class. The search order is same as that used by
   :func:`getattr` except that the *type* itself is skipped.

   The :attr:`~class.__mro__` attribute of the *type* lists the method
   resolution search order used by both :func:`getattr` and :func:`super`.  The
   attribute is dynamic and can change whenever the inheritance hierarchy is
   updated.

   If the second argument is omitted, the super object returned is unbound.  If
   the second argument is an object, ``isinstance(obj, type)`` must be true.  If
   the second argument is a type, ``issubclass(type2, type)`` must be true (this
   is useful for classmethods).

   There are two typical use cases for *super*.  In a class hierarchy with
   single inheritance, *super* can be used to refer to parent classes without
   naming them explicitly, thus making the code more maintainable.  This use
   closely parallels the use of *super* in other programming languages.

   The second use case is to support cooperative multiple inheritance in a
   dynamic execution environment.  This use case is unique to Python and is
   not found in statically compiled languages or languages that only support
   single inheritance.  This makes it possible to implement "diamond diagrams"
   where multiple base classes implement the same method.  Good design dictates
   that this method have the same calling signature in every case (because the
   order of calls is determined at runtime, because that order adapts
   to changes in the class hierarchy, and because that order can include
   sibling classes that are unknown prior to runtime).

   For both use cases, a typical superclass call looks like this::

      class C(B):
          def method(self, arg):
              super().method(arg)    # This does the same thing as:
                                     # super(C, self).method(arg)

   Note that :func:`super` is implemented as part of the binding process for
   explicit dotted attribute lookups such as ``super().__getitem__(name)``.
   It does so by implementing its own :meth:`__getattribute__` method for searching
   classes in a predictable order that supports cooperative multiple inheritance.
   Accordingly, :func:`super` is undefined for implicit lookups using statements or
   operators such as ``super()[name]``.

   Also note that, aside from the zero argument form, :func:`super` is not
   limited to use inside methods.  The two argument form specifies the
   arguments exactly and makes the appropriate references.  The zero
   argument form only works inside a class definition, as the compiler fills
   in the necessary details to correctly retrieve the class being defined,
   as well as accessing the current instance for ordinary methods.

   For practical suggestions on how to design cooperative classes using
   :func:`super`, see `guide to using super()
   <https://rhettinger.wordpress.com/2011/05/26/super-considered-super/>`_.


.. _func-tuple:
.. function:: tuple([iterable])
   :noindex:

   Rather than being a function, :class:`tuple` is actually an immutable
   sequence type, as documented in :ref:`typesseq-tuple` and :ref:`typesseq`.


.. class:: type(object)
           type(name, bases, dict)

   .. index:: object: type

   With one argument, return the type of an *object*.  The return value is a
   type object and generally the same object as returned by
   :attr:`object.__class__ <instance.__class__>`.

   The :func:`isinstance` built-in function is recommended for testing the type
   of an object, because it takes subclasses into account.


   With three arguments, return a new type object.  This is essentially a
   dynamic form of the :keyword:`class` statement. The *name* string is the
   class name and becomes the :attr:`~definition.__name__` attribute; the *bases*
   tuple itemizes the base classes and becomes the :attr:`~class.__bases__`
   attribute; and the *dict* dictionary is the namespace containing definitions
   for class body and is copied to a standard dictionary to become the
   :attr:`~object.__dict__` attribute.  For example, the following two
   statements create identical :class:`type` objects:

      >>> class X:
      ...     a = 1
      ...
      >>> X = type('X', (object,), dict(a=1))

   See also :ref:`bltin-type-objects`.

   .. versionchanged:: 3.6
      Subclasses of :class:`type` which don't override ``type.__new__`` may no
      longer use the one-argument form to get the type of an object.

.. function:: vars([object])

   Return the :attr:`~object.__dict__` attribute for a module, class, instance,
   or any other object with a :attr:`~object.__dict__` attribute.

   Objects such as modules and instances have an updateable :attr:`~object.__dict__`
   attribute; however, other objects may have write restrictions on their
   :attr:`~object.__dict__` attributes (for example, classes use a
   :class:`types.MappingProxyType` to prevent direct dictionary updates).

   Without an argument, :func:`vars` acts like :func:`locals`.  Note, the
   locals dictionary is only useful for reads since updates to the locals
   dictionary are ignored.


.. function:: zip(*iterables)

   Make an iterator that aggregates elements from each of the iterables.

   Returns an iterator of tuples, where the *i*-th tuple contains
   the *i*-th element from each of the argument sequences or iterables.  The
   iterator stops when the shortest input iterable is exhausted. With a single
   iterable argument, it returns an iterator of 1-tuples.  With no arguments,
   it returns an empty iterator.  Equivalent to::

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

   The left-to-right evaluation order of the iterables is guaranteed. This
   makes possible an idiom for clustering a data series into n-length groups
   using ``zip(*[iter(s)]*n)``.  This repeats the *same* iterator ``n`` times
   so that each output tuple has the result of ``n`` calls to the iterator.
   This has the effect of dividing the input into n-length chunks.

   :func:`zip` should only be used with unequal length inputs when you don't
   care about trailing, unmatched values from the longer iterables.  If those
   values are important, use :func:`itertools.zip_longest` instead.

   :func:`zip` in conjunction with the ``*`` operator can be used to unzip a
   list::

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
