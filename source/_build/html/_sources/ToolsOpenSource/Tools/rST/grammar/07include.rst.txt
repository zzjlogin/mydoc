.. _rst-include:

==============================
包含 [1]_
==============================

.. _include-code:

包含代码
----------------

.. rubric:: 参考 [code]_

详解
...............

.. rst:directive:: .. literalinclude:: filename

   目录里不显示的文件可能被一个外部纯文本文件保存为例子文本.  文件使用指令 ``literalinclude`` 包含. 
   [1]_ 例如包含Python源文件 :file:\`example.py`, 使用::

      .. literalinclude:: example.py

   文件名为当前文件的相对路径.  如果是绝对路径 (以 ``/`` 开始), 则是源目录的相对路径.

   输入标签可以扩展，给出 ``tab-width`` 选项指定标签宽度.

   该指令也支持 ``linenos`` 选项产生行号, ``emphasize-lines`` 选项生成强调行, 
   以及 ``language`` 选项选择不同于当前文件使用的标准语言的语言.  例如::

      .. literalinclude:: example.rb
         :language: ruby
         :emphasize-lines: 12,15-18
         :linenos:

   被包含文件的编码会被认定为 :confval:

   如果文件有不同的编码，可以使用 ``encoding`` 选项::

      .. literalinclude:: example.py
         :encoding: latin-1

   指令支持包含文件的一部分.  例如
   Python模块, 可以选择类，函数或方法，使用 ``pyobject`` 选项::

      .. literalinclude:: example.py
         :pyobject: Timer.start

   这会包含文件中 ``Timer`` 类的 ``start()`` 方法后面的代码行.

   使用 ``lines`` 选项精确的控制所包含的行::

      .. literalinclude:: example.py
         :lines: 1,3,5-10,20-

   包含1, 3, 5 到 10 及 20 之后的代码行.

   另一种实现包含文件特定部分的方式是使用 ``start-after`` 或 ``end-before`` 选项 (仅使用一种).  
   选项 ``start-after`` 给出一个字符串, 第一行包含该字符串后面的所有行均被包含.  
   选项 ``end-before`` 也是给出一个字符串，包含该字符串的第一行前面的文本将会被包含.

   可以往包含代码的首尾添加新行，使用 ``prepend`` 及 ``append`` 选项.  
   这很有用，比如在高亮显示的PHP 代码里不能包含 ``<?php``/``?>`` 标签.

   .. versionadded:: 0.4.3
      选项 ``encoding`` .
   .. versionadded:: 0.6
      选项 ``pyobject``, ``lines``, ``start-after`` 及 ``end-before`` ,
      并支持绝对文件名.
   .. versionadded:: 1.0
      选项 ``prepend`` 、 ``append`` 及 ``tab-width``.
    
    类似linux的diff命令比较两个文件::

        diff2个文件
        ========================================

        .. literalinclude:: test.py
            :diff: test2.py

样例展示
.................

:样例:

.. literalinclude:: /demo/test.py
    :linenos:
    :language: python
    :emphasize-lines: 1-2,5

:样例源码:

::

    .. literalinclude:: /demo/test.py
        :linenos:
        :language: python
        :emphasize-lines: 1-2,3

:说明:

:linenos:   显示行号。
:language:  文件语言(设置python)。
:emphasize-lines:   突出显示(1-2,4-是1-2行和4到末尾)
:lines: 1,3,5-10,20-即把文件的这些行包含进来显示。

.. _include-csv:

csv文件包含
-----------------




.. [1]  http://docutils.sourceforge.net/docs/ref/rst/directives.html#include