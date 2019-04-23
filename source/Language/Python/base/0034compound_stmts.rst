.. _python_compound_stmts:

======================================================================================================================================================
复合语句
======================================================================================================================================================

.. contents::


复合语句语法
======================================================================================================================================================



语法简介:

.. productionlist::
   compound_stmt: `if_stmt`
                : | `while_stmt`
                : | `for_stmt`
                : | `try_stmt`
                : | `with_stmt`
                : | `funcdef`
                : | `classdef`
                : | `async_with_stmt`
                : | `async_for_stmt`
                : | `async_funcdef`
   suite: `stmt_list` NEWLINE | NEWLINE INDENT `statement`+ DEDENT
   statement: `stmt_list` NEWLINE | `compound_stmt`
   stmt_list: `simple_stmt` (";" `simple_stmt`)* [";"]



.. _if:
.. _elif:
.. _else:

:keyword:`!if` 语句
======================================================================================================================================================


:keyword:`if` 条件语句：

.. productionlist::
   if_stmt: "if" `expression` ":" `suite`
          : ("elif" `expression` ":" `suite`)*
          : ["else" ":" `suite`]



.. _while:

:keyword:`!while` 语句
======================================================================================================================================================


:keyword:`while` 条件语句：

.. productionlist::
   while_stmt: "while" `expression` ":" `suite`
             : ["else" ":" `suite`]

这个语句可以结合 :keyword:`!else` 条件，并且可以结合
:keyword:`break` 和  :keyword:`continue`




.. _for:

:keyword:`!for` 语句
======================================================================================================================================================


:keyword:`for` 语句用来循环可迭代的序列对象（例如：列表、字符串、元组）。

.. productionlist::
   for_stmt: "for" `target_list` "in" `expression_list` ":" `suite`
           : ["else" ":" `suite`]

这个语句可以结合 :keyword:`break` 和 :keyword:`continue`
.. index::
   statement: break
   statement: continue

::

   for i in range(10):
       print(i)
       i = 5             # this will not affect the for-loop
                         # because i will be overwritten with the next
                         # index in the range





.. _try:
.. _except:
.. _finally:

:keyword:`!try` 语句
======================================================================================================================================================


:keyword:`try` 语句可以捕获处理异常语句:

.. productionlist::
   try_stmt: `try1_stmt` | `try2_stmt`
   try1_stmt: "try" ":" `suite`
            : ("except" [`expression` ["as" `identifier`]] ":" `suite`)+
            : ["else" ":" `suite`]
            : ["finally" ":" `suite`]
   try2_stmt: "try" ":" `suite`
            : "finally" ":" `suite`



::

   except E as N:
       foo

上面语句可以翻译成下面的语句 ::

   except E as N:
       try:
           foo
       finally:
           del N





在执行try代码块语句结束后会执行finally的代码块::

   >>> def foo():
   ...     try:
   ...         return 'try'
   ...     finally:
   ...         return 'finally'
   ...
   >>> foo()
   'finally'

   >>> def f():
   ...     try:
   ...         1/0
   ...     finally:
   ...         return 42
   ...
   >>> f()
   42

可以结合 :keyword:`raise` 语句生成指定异常。



.. _with:
.. _as:

:keyword:`!with` 语句
======================================================================================================================================================


:keyword:`with` 语句用来执行一个子代码块。


.. productionlist::
   with_stmt: "with" `with_item` ("," `with_item`)* ":" `suite`
   with_item: `expression` ["as" `target`]

::

   with A() as a, B() as b:
       suite

上面代码等价于 ::

   with A() as a:
       with B() as b:
           suite

.. versionchanged:: 3.1
   Support for multiple context expressions.

.. seealso::

   :pep:`343` - The "with" statement
      The specification, background, and examples for the Python :keyword:`with`
      statement.


.. index::
   single: parameter; function definition

.. _function:
.. _def:

函数定义
======================================================================================================================================================



.. productionlist::
   funcdef: [`decorators`] "def" `funcname` "(" [`parameter_list`] ")"
          : ["->" `expression`] ":" `suite`
   decorators: `decorator`+
   decorator: "@" `dotted_name` ["(" [`argument_list` [","]] ")"] NEWLINE
   dotted_name: `identifier` ("." `identifier`)*
   parameter_list: `defparameter` ("," `defparameter`)* ["," [`parameter_list_starargs`]]
                 : | `parameter_list_starargs`
   parameter_list_starargs: "*" [`parameter`] ("," `defparameter`)* ["," ["**" `parameter` [","]]]
                          : | "**" `parameter` [","]
   parameter: `identifier` [":" `expression`]
   defparameter: `parameter` ["=" `expression`]
   funcname: `identifier`


::

   @f1(arg)
   @f2
   def func(): pass

上面代码等价于下面的代码：::

   def func(): pass
   func = f1(arg)(f2(func))

定义的函数名称是： ``func``.

定义一个函数，函数名是： ``whats_on_the_telly``，处理传入的值，如果没有传入参数，
则使用默认参数值： ``None`` ::

   def whats_on_the_telly(penguin=None):
       if penguin is None:
           penguin = []
       penguin.append("property of the zoo")
       return penguin


.. _class:

类定义
======================================================================================================================================================


.. productionlist::
   classdef: [`decorators`] "class" `classname` [`inheritance`] ":" `suite`
   inheritance: "(" [`argument_list`] ")"
   classname: `identifier`

定义一个类 ::

   class Foo:
       pass

等价于 ::

   class Foo(object):
       pass



.. _async:

Coroutines
======================================================================================================================================================

.. versionadded:: 3.5

.. index:: statement: async def
.. _`async def`:

协同函数定义
-----------------------------

.. productionlist::
   async_funcdef: [`decorators`] "async" "def" `funcname` "(" [`parameter_list`] ")"
                : ["->" `expression`] ":" `suite`

例如::

    async def func(param1, param2):
        do_stuff()
        await some_coroutine()


.. index:: statement: async for
.. _`async for`:

:keyword:`!async for` 语句
-----------------------------------

.. productionlist::
   async_for_stmt: "async" `for_stmt`

An :term:`asynchronous iterable` is able to call asynchronous code in its
*iter* implementation, and :term:`asynchronous iterator` can call asynchronous
code in its *next* method.

 ``async for`` 语句作用是异步执行。

例如下面代码::

    async for TARGET in ITER:
        BLOCK
    else:
        BLOCK2

等价于::

    iter = (ITER)
    iter = type(iter).__aiter__(iter)
    running = True
    while running:
        try:
            TARGET = await type(iter).__anext__(iter)
        except StopAsyncIteration:
            running = False
        else:
            BLOCK
    else:
        BLOCK2



.. index:: statement: async with
.. _`async with`:

:keyword:`!async with` 语句
------------------------------------

.. productionlist::
   async_with_stmt: "async" `with_stmt`

:term:`asynchronous context manager` 也就是 :term:`context manager` 
管理上下文。

例如：::

    async with EXPR as VAR:
        BLOCK

等价于::

    mgr = (EXPR)
    aexit = type(mgr).__aexit__
    aenter = type(mgr).__aenter__(mgr)

    VAR = await aenter
    try:
        BLOCK
    except:
        if not await aexit(mgr, *sys.exc_info()):
            raise
    else:
        await aexit(mgr, None, None, None)


