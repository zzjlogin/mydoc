.. _python_simple_stmts:

======================================================================================================================================================
简单语句
======================================================================================================================================================

.. contents::


简单语句语法
======================================================================================================================================================

简单语句的语法：

.. productionlist::
   simple_stmt: `expression_stmt`
              : | `assert_stmt`
              : | `assignment_stmt`
              : | `augmented_assignment_stmt`
              : | `annotated_assignment_stmt`
              : | `pass_stmt`
              : | `del_stmt`
              : | `return_stmt`
              : | `yield_stmt`
              : | `raise_stmt`
              : | `break_stmt`
              : | `continue_stmt`
              : | `import_stmt`
              : | `future_stmt`
              : | `global_stmt`
              : | `nonlocal_stmt`


表达式语句
======================================================================================================================================================

.. productionlist::
   expression_stmt: `starred_expression`


赋值语句
======================================================================================================================================================

.. productionlist::
   assignment_stmt: (`target_list` "=")+ (`starred_expression` | `yield_expression`)
   target_list: `target` ("," `target`)* [","]
   target: `identifier`
         : | "(" [`target_list`] ")"
         : | "[" [`target_list`] "]"
         : | `attributeref`
         : | `subscription`
         : | `slicing`
         : | "*" `target`

增量赋值语句
------------------------------------------------------------------------------------------------------------------------------------------------------


.. productionlist::
   augmented_assignment_stmt: `augtarget` `augop` (`expression_list` | `yield_expression`)
   augtarget: `identifier` | `attributeref` | `subscription` | `slicing`
   augop: "+=" | "-=" | "*=" | "@=" | "/=" | "//=" | "%=" | "**="
        : | ">>=" | "<<=" | "&=" | "^=" | "|="

带注释的赋值语句
------------------------------------------------------------------------------------------------------------------------------------------------------



.. productionlist::
   annotated_assignment_stmt: `augtarget` ":" `expression` ["=" `expression`]


:keyword:`!assert` 语句
======================================================================================================================================================




.. productionlist::
   assert_stmt: "assert" `expression` ["," `expression`]

简单语句格式 ``assert expression``等价于 ::

   if __debug__:
       if not expression: raise AssertionError

扩展格式： ``assert expression1, expression2`` 等价于 ::

   if __debug__:
       if not expression1: raise AssertionError(expression2)

.. _pass:

:keyword:`!pass` 语句
======================================================================================================================================================


.. index::
   statement: pass
   pair: null; operation
           pair: null; operation

.. productionlist::
   pass_stmt: "pass"

:keyword:`pass` 是一个空操作语句，代表什么都不做，当条件复杂语句中
子语句不执行任何命令时，如果留空会报错，所以这时候执行这个语句，例如::

   def f(arg): pass    # a function that does nothing (yet)

   class C: pass       # a class with no methods (yet)


.. _del:

:keyword:`!del` 语句
======================================================================================================================================================



.. productionlist::
   del_stmt: "del" `target_list`

删除已经定义的变量。


.. _return:

:keyword:`!return` 语句
======================================================================================================================================================


.. productionlist::
   return_stmt: "return" [`expression_list`]

:keyword:`return` 只会出现在定义的函数中。函数返回值。

.. _yield:

:keyword:`!yield` 语句
======================================================================================================================================================



.. productionlist::
   yield_stmt: `yield_expression`

生成器，例如 ::

  yield <expr>
  yield from <expr>

等价语句 ::

  (yield <expr>)
  (yield from <expr>)


.. _raise:

:keyword:`!raise` 语句
======================================================================================================================================================



.. productionlist::
   raise_stmt: "raise" [`expression` ["from" `expression`]]

在except后面抛出指定异常。

::

   >>> try:
   ...     print(1 / 0)
   ... except Exception as exc:
   ...     raise RuntimeError("Something bad happened") from exc
   ...
   Traceback (most recent call last):
     File "<stdin>", line 2, in <module>
   ZeroDivisionError: division by zero

   The above exception was the direct cause of the following exception:

   Traceback (most recent call last):
     File "<stdin>", line 4, in <module>
   RuntimeError: Something bad happened

::

   >>> try:
   ...     print(1 / 0)
   ... except:
   ...     raise RuntimeError("Something bad happened")
   ...
   Traceback (most recent call last):
     File "<stdin>", line 2, in <module>
   ZeroDivisionError: division by zero

   During handling of the above exception, another exception occurred:

   Traceback (most recent call last):
     File "<stdin>", line 4, in <module>
   RuntimeError: Something bad happened

::

   >>> try:
   ...     print(1 / 0)
   ... except:
   ...     raise RuntimeError("Something bad happened") from None
   ...
   Traceback (most recent call last):
     File "<stdin>", line 4, in <module>
   RuntimeError: Something bad happened


.. versionchanged:: 3.3
    :const:`None` is now permitted as ``Y`` in ``raise X from Y``.

.. versionadded:: 3.3
    The ``__suppress_context__`` attribute to suppress automatic display of the
    exception context.

.. _break:

:keyword:`!break` 语句
======================================================================================================================================================




.. productionlist::
   break_stmt: "break"

在for/while循环中，跳出循环部分代码，继续下面的语句。




.. _continue:

:keyword:`!continue` 语句
======================================================================================================================================================




.. productionlist::
   continue_stmt: "continue"

结束for/while的本次循环，直接进入下一次循环。




.. _import:
.. _from:

:keyword:`!import` 语句
======================================================================================================================================================



.. productionlist::
   import_stmt: "import" `module` ["as" `identifier`] ("," `module` ["as" `identifier`])*
              : | "from" `relative_module` "import" `identifier` ["as" `identifier`]
              : ("," `identifier` ["as" `identifier`])*
              : | "from" `relative_module` "import" "(" `identifier` ["as" `identifier`]
              : ("," `identifier` ["as" `identifier`])* [","] ")"
              : | "from" `module` "import" "*"
   module: (`identifier` ".")* `identifier`
   relative_module: "."* `module` | "."+

在当前模块中导入指定模块/指定模块的指定功能。

Examples::

   import foo                 # foo imported and bound locally
   import foo.bar.baz         # foo.bar.baz imported, foo bound locally
   import foo.bar.baz as fbb  # foo.bar.baz imported and bound as fbb
   from foo.bar import baz    # foo.bar.baz imported and bound as baz
   from foo import attr       # foo imported and foo.attr bound as attr




.. _global:

:keyword:`!global` 语句
======================================================================================================================================================



.. productionlist::
   global_stmt: "global" `identifier` ("," `identifier`)*


定义全局变量，这个变量名会在所有使用本模块的代码中都可以调用并使用。

.. _nonlocal:

:keyword:`!nonlocal` 语句
======================================================================================================================================================



.. productionlist::
   nonlocal_stmt: "nonlocal" `identifier` ("," `identifier`)*

在定义变量的代码块上一级别可以调用的变量。







