.. _rst-code:

======================================================================================================================================================
代码块 [1]_
======================================================================================================================================================

.. contents::

代码语言设置
======================================================================================================================================================

* 有效的语言:

  * ``none`` (没有高亮显示)
  * ``text``
  * ``python`` (默认， :confval:\`highlight_language` 没有设置时)
  * ``guess`` (让 Pygments 根据内容去决定, 仅支持一些可识别的语言)
  * ``rest``
  * ``c``
  * ``bash``
  * ``json``
  * ... 其他Pygments 支持的语言名.

* 如果选定语言的高亮显示失败，则模块不会以其他方式高亮显示.

* 代码样例：

ruby、python、c、none测试：

    .. code-block:: ruby

        puts "Some Ruby code."

    .. code-block:: python
        
        import os
        print('Some python code.')

    .. code-block:: c

        #include <stdio.h>
        int main(void) {
            int count = printf("This is a test!\n");
            printf("%d\n", count);
            return 0;
        }

    .. code-block:: none
        
        测试none

上面的格式：

::

    .. code-block:: ruby

        puts "Some Ruby code."

    .. code-block:: python
        
        import os
        print('Some python code.')

    .. code-block:: c

        #include <stdio.h>
        int main(void) {
            int count = printf("This is a test!\n");
            printf("%d\n", count);
            return 0;
        }

    .. code-block:: none
        
        测试none


代码块参数
======================================================================================================================================================


\:linenos:
    显示行号
\:emphasize-lines:
    突出显示(可以设置指定行或范围，例如：1-2,4-是1-2行和4到末尾)

\:linenothreshold: 5


代码函数引用
======================================================================================================================================================


样例：

    .. function:: foo(x)
                foo(y, z)
        :module: some.module.name

源码：

::

    .. function:: foo(x)
                foo(y, z)
        :module: some.module.name


        

.. [1]  http://docutils.sourceforge.net/docs/ref/rst/directives.html#code
.. [code] https://zh-sphinx-doc.readthedocs.io/en/latest/markup/code.html