.. _python_operator:

======================================================================================================================================================
:mod:`operator` --- 标准运算符函数
======================================================================================================================================================


.. contents::


operator简单测试
======================================================================================================================================================

定义写操作方法

.. code-block:: python

    In [1]: import operator

    In [2]: operator.abs
    In [3]: operator.
            abs()         eq()          ifloordiv()   invert()      itruediv()    mod()         rshift()
            add()         floordiv()    ilshift()     ior()         ixor()        mul()         setitem()
            and_()        ge()          imatmul()     ipow()        le()          ne()          sub()
            attrgetter    getitem()     imod()        irshift()     length_hint() neg()         truediv()
            concat()      gt()          imul()        is_()         lshift()      not_()        truth()
            contains()    iadd()        index()       is_not()      lt()          or_()         xor()
            countOf()     iand()        indexOf()     isub()        matmul()      pos()
            delitem()     iconcat()     inv()         itemgetter    methodcaller  pow()

operator内置函数
======================================================================================================================================================


内置函数的作用是代替了运算符，这样符合函数编程:


.. function:: lt(a, b)
              le(a, b)
              eq(a, b)
              ne(a, b)
              ge(a, b)
              gt(a, b)
              __lt__(a, b)
              __le__(a, b)
              __eq__(a, b)
              __ne__(a, b)
              __ge__(a, b)
              __gt__(a, b)

    上面这些函数是：在 *a* 和 *b*之间执行各种运算函数。
        - ``lt(a, b)`` 等价于 ``a < b``
        - ``le(a, b)`` 等价于 ``a <= b``
        - ``eq(a, b)`` 等价于 ``a == b``
        - ``ne(a, b)`` 等价于 ``a != b``
        - ``gt(a, b)`` 等价于 ``a > b``
        - ``ge(a, b)`` 等价于 ``a >= b``


.. function:: not_(obj)
              __not__(obj)

   返回 :keyword:`not` *obj*。


.. function:: truth(obj)

   如果 *obj* 是True就返回 :const:`True` ，否则返回 :const:`False`

.. function:: is_(a, b)

   会返回布尔值，判断 ``a `` 和 `` b`` 的内存id是否 **相同** （identity）

.. function:: is_not(a, b)

   会返回布尔值，判断 ``a `` 和 `` b`` 的内存id是否 **不同** （identity）

.. function:: abs(obj)
              __abs__(obj)

   返回 *obj*的绝对值


.. function:: add(a, b)
              __add__(a, b)

   返回 ``a + b``, 其中 *a* 和 *b* 是数字.


.. function:: and_(a, b)
              __and__(a, b)

   按位对 *a* 和 *b* 进行与(and)运算。


.. function:: floordiv(a, b)
              __floordiv__(a, b)

   返回 ``a // b``.


.. function:: index(a)
              __index__(a)

   返回 *a* 转换的整型数字。  等价于 ``a.__index__()``.


.. function:: inv(obj)
              invert(obj)
              __inv__(obj)
              __invert__(obj)

   对 *obj*进行按位取反。  等价于 ``~obj``.


.. function:: lshift(a, b)
              __lshift__(a, b)

   返回 *a* 向左移 *b*位。


.. function:: mod(a, b)
              __mod__(a, b)

   返回 ``a % b``，即取余数。


.. function:: mul(a, b)
              __mul__(a, b)

   返回 ``a * b``, 其中 *a* 和 *b* 是数字，返回a和b的乘积4。


.. function:: matmul(a, b)
              __matmul__(a, b)

   返回 ``a @ b``.

   .. versionadded:: 3.5


.. function:: neg(obj)
              __neg__(obj)

   返回 *obj* 取反的结果 (``-obj``).


.. function:: or_(a, b)
              __or__(a, b)

   返回 *a* 和 *b*按位取或运算的结果。其中 *a* 和 *b*是整数。


.. function:: pos(obj)
              __pos__(obj)

   返回 *obj* 的值 (``+obj``).


.. function:: pow(a, b)
              __pow__(a, b)

   返回 ``a ** b``, 其中 *a* 和 *b* 是数字。即返回 *a* 的 *b*次方。


.. function:: rshift(a, b)
              __rshift__(a, b)

   返回 *a* 向右移 *b* 位的结果。


.. function:: sub(a, b)
              __sub__(a, b)

   返回 ``a - b``，即a减去b的差。


.. function:: truediv(a, b)
              __truediv__(a, b)

   返回 ``a / b`` 结果是保留小数点儿的浮点数。


.. function:: xor(a, b)
              __xor__(a, b)

   返回 *a* 和 *b*按位取异或的结果， *a* 和 *b*是整数。


.. function:: concat(a, b)
              __concat__(a, b)

   返回 ``a + b`` ，即对列表 *a* 和 *b* 的列表的和。


.. function:: contains(a, b)
              __contains__(a, b)

   返回一个布尔值，判断值 ``b in a``。


.. function:: countOf(a, b)

   返回 *b* in *a* 的值。


.. function:: delitem(a, b)
              __delitem__(a, b)

   删除 *a* 中索引是 *b*的值，测试结果索引应该是b+1


.. function:: getitem(a, b)
              __getitem__(a, b)

   返回 *a* 中索引是 *b*的值。


.. function:: indexOf(a, b)

   返回 *a*中索引是 *b* .


.. function:: setitem(a, b, c)
              __setitem__(a, b, c)

   设置 *a* 的索引为 *b* 的值为 *c*.


.. function:: length_hint(obj, default=0)

   返回对象的长度。

   .. versionadded:: 3.4




.. function:: attrgetter(attr)
              attrgetter(*attrs)

   等价于::

      def attrgetter(*items):
          if any(not isinstance(item, str) for item in items):
              raise TypeError('attribute name must be a string')
          if len(items) == 1:
              attr = items[0]
              def g(obj):
                  return resolve_attr(obj, attr)
          else:
              def g(obj):
                  return tuple(resolve_attr(obj, attr) for attr in items)
          return g

      def resolve_attr(obj, attr):
          for name in attr.split("."):
              obj = getattr(obj, name)
          return obj


.. function:: itemgetter(item)
              itemgetter(*items)

   等价于::

      def itemgetter(*items):
          if len(items) == 1:
              item = items[0]
              def g(obj):
                  return obj[item]
          else:
              def g(obj):
                  return tuple(obj[item] for item in items)
          return g

   The items can be any type accepted by the operand's :meth:`__getitem__`
   method.  Dictionaries accept any hashable value.  Lists, tuples, and
   strings accept an index or a slice:

      >>> itemgetter(1)('ABCDEFG')
      'B'
      >>> itemgetter(1,3,5)('ABCDEFG')
      ('B', 'D', 'F')
      >>> itemgetter(slice(2,None))('ABCDEFG')
      'CDEFG'

      >>> soldier = dict(rank='captain', name='dotterbart')
      >>> itemgetter('rank')(soldier)
      'captain'

   Example of using :func:`itemgetter` to retrieve specific fields from a
   tuple record:

      >>> inventory = [('apple', 3), ('banana', 2), ('pear', 5), ('orange', 1)]
      >>> getcount = itemgetter(1)
      >>> list(map(getcount, inventory))
      [3, 2, 5, 1]
      >>> sorted(inventory, key=getcount)
      [('orange', 1), ('banana', 2), ('apple', 3), ('pear', 5)]


.. function:: methodcaller(name[, args...])

   Return a callable object that calls the method *name* on its operand.  If
   additional arguments and/or keyword arguments are given, they will be given
   to the method as well.  For example:

   * After ``f = methodcaller('name')``, the call ``f(b)`` returns ``b.name()``.

   * After ``f = methodcaller('name', 'foo', bar=1)``, the call ``f(b)``
     returns ``b.name('foo', bar=1)``.

   Equivalent to::

      def methodcaller(name, *args, **kwargs):
          def caller(obj):
              return getattr(obj, name)(*args, **kwargs)
          return caller


.. _operator-map:

操作符和函数对照表
======================================================================================================================================================


这个模块等价于操作符的操作对照表。 :mod:`operator` module.

+-----------------------+-------------------------+---------------------------------------+
| Operation             | Syntax                  | Function                              |
+=======================+=========================+=======================================+
| Addition              | ``a + b``               | ``add(a, b)``                         |
+-----------------------+-------------------------+---------------------------------------+
| Concatenation         | ``seq1 + seq2``         | ``concat(seq1, seq2)``                |
+-----------------------+-------------------------+---------------------------------------+
| Containment Test      | ``obj in seq``          | ``contains(seq, obj)``                |
+-----------------------+-------------------------+---------------------------------------+
| Division              | ``a / b``               | ``truediv(a, b)``                     |
+-----------------------+-------------------------+---------------------------------------+
| Division              | ``a // b``              | ``floordiv(a, b)``                    |
+-----------------------+-------------------------+---------------------------------------+
| Bitwise And           | ``a & b``               | ``and_(a, b)``                        |
+-----------------------+-------------------------+---------------------------------------+
| Bitwise Exclusive Or  | ``a ^ b``               | ``xor(a, b)``                         |
+-----------------------+-------------------------+---------------------------------------+
| Bitwise Inversion     | ``~ a``                 | ``invert(a)``                         |
+-----------------------+-------------------------+---------------------------------------+
| Bitwise Or            | ``a | b``               | ``or_(a, b)``                         |
+-----------------------+-------------------------+---------------------------------------+
| Exponentiation        | ``a ** b``              | ``pow(a, b)``                         |
+-----------------------+-------------------------+---------------------------------------+
| Identity              | ``a is b``              | ``is_(a, b)``                         |
+-----------------------+-------------------------+---------------------------------------+
| Identity              | ``a is not b``          | ``is_not(a, b)``                      |
+-----------------------+-------------------------+---------------------------------------+
| Indexed Assignment    | ``obj[k] = v``          | ``setitem(obj, k, v)``                |
+-----------------------+-------------------------+---------------------------------------+
| Indexed Deletion      | ``del obj[k]``          | ``delitem(obj, k)``                   |
+-----------------------+-------------------------+---------------------------------------+
| Indexing              | ``obj[k]``              | ``getitem(obj, k)``                   |
+-----------------------+-------------------------+---------------------------------------+
| Left Shift            | ``a << b``              | ``lshift(a, b)``                      |
+-----------------------+-------------------------+---------------------------------------+
| Modulo                | ``a % b``               | ``mod(a, b)``                         |
+-----------------------+-------------------------+---------------------------------------+
| Multiplication        | ``a * b``               | ``mul(a, b)``                         |
+-----------------------+-------------------------+---------------------------------------+
| Matrix Multiplication | ``a @ b``               | ``matmul(a, b)``                      |
+-----------------------+-------------------------+---------------------------------------+
| Negation (Arithmetic) | ``- a``                 | ``neg(a)``                            |
+-----------------------+-------------------------+---------------------------------------+
| Negation (Logical)    | ``not a``               | ``not_(a)``                           |
+-----------------------+-------------------------+---------------------------------------+
| Positive              | ``+ a``                 | ``pos(a)``                            |
+-----------------------+-------------------------+---------------------------------------+
| Right Shift           | ``a >> b``              | ``rshift(a, b)``                      |
+-----------------------+-------------------------+---------------------------------------+
| Slice Assignment      | ``seq[i:j] = values``   | ``setitem(seq, slice(i, j), values)`` |
+-----------------------+-------------------------+---------------------------------------+
| Slice Deletion        | ``del seq[i:j]``        | ``delitem(seq, slice(i, j))``         |
+-----------------------+-------------------------+---------------------------------------+
| Slicing               | ``seq[i:j]``            | ``getitem(seq, slice(i, j))``         |
+-----------------------+-------------------------+---------------------------------------+
| String Formatting     | ``s % obj``             | ``mod(s, obj)``                       |
+-----------------------+-------------------------+---------------------------------------+
| Subtraction           | ``a - b``               | ``sub(a, b)``                         |
+-----------------------+-------------------------+---------------------------------------+
| Truth Test            | ``obj``                 | ``truth(obj)``                        |
+-----------------------+-------------------------+---------------------------------------+
| Ordering              | ``a < b``               | ``lt(a, b)``                          |
+-----------------------+-------------------------+---------------------------------------+
| Ordering              | ``a <= b``              | ``le(a, b)``                          |
+-----------------------+-------------------------+---------------------------------------+
| Equality              | ``a == b``              | ``eq(a, b)``                          |
+-----------------------+-------------------------+---------------------------------------+
| Difference            | ``a != b``              | ``ne(a, b)``                          |
+-----------------------+-------------------------+---------------------------------------+
| Ordering              | ``a >= b``              | ``ge(a, b)``                          |
+-----------------------+-------------------------+---------------------------------------+
| Ordering              | ``a > b``               | ``gt(a, b)``                          |
+-----------------------+-------------------------+---------------------------------------+

替换原始操作数
======================================================================================================================================================


.. function:: iadd(a, b)
              __iadd__(a, b)

   ``a = iadd(a, b)`` 等价于 ``a += b``.


.. function:: iand(a, b)
              __iand__(a, b)

   ``a = iand(a, b)`` 等价于 ``a &= b``.


.. function:: iconcat(a, b)
              __iconcat__(a, b)

   ``a = iconcat(a, b)`` 等价于 ``a += b`` ，其中 *a* 和 *b* 是序列。


.. function:: ifloordiv(a, b)
              __ifloordiv__(a, b)

   ``a = ifloordiv(a, b)`` 等价于 ``a //= b``.


.. function:: ilshift(a, b)
              __ilshift__(a, b)

   ``a = ilshift(a, b)`` 等价于 ``a <<= b``.


.. function:: imod(a, b)
              __imod__(a, b)

   ``a = imod(a, b)`` 等价于 ``a %= b``.


.. function:: imul(a, b)
              __imul__(a, b)

   ``a = imul(a, b)`` 等价于 ``a *= b``.


.. function:: imatmul(a, b)
              __imatmul__(a, b)

   ``a = imatmul(a, b)`` 等价于 ``a @= b``.

   .. versionadded:: 3.5


.. function:: ior(a, b)
              __ior__(a, b)

   ``a = ior(a, b)`` 等价于 ``a |= b``.


.. function:: ipow(a, b)
              __ipow__(a, b)

   ``a = ipow(a, b)`` 等价于 ``a **= b``.


.. function:: irshift(a, b)
              __irshift__(a, b)

   ``a = irshift(a, b)`` 等价于 ``a >>= b``.


.. function:: isub(a, b)
              __isub__(a, b)

   ``a = isub(a, b)`` 等价于 ``a -= b``.


.. function:: itruediv(a, b)
              __itruediv__(a, b)

   ``a = itruediv(a, b)`` 等价于 ``a /= b``.


.. function:: ixor(a, b)
              __ixor__(a, b)

   ``a = ixor(a, b)`` 等价于 ``a ^= b``.






