.. _rst-hyperlinks:

========================
超链接 [1]_
========================

总体来说链接可以为：`外部链接`、`内部链接 <https://zh-sphinx-doc.readthedocs.io/en/latest/markup/inline.html>`_

这些链接还可以分为：`显示链接`、`隐示链接`、`扩展链接`等。

显示链接
========================

**样例展示：**

----

:样例1:

显示链接测试百度链接：baidu_biaoqian_。

.. _baidu_biaoqian: https://www.baidu.com

:样例2:

显示链接测试：`百度 <https://www.baidu.com>`_.

**上面换行功能实现方法，以下是rST源码显示样例**::

    :样例1:

    显示链接测试百度链接：baidu_biaoqian_。

    .. _baidu_biaoqian: https://www.baidu.com

    :样例2:

    显示链接测试：`百度 <https://www.baidu.com>`_.

    实际等效于HTML的：
    显示链接测试百度链接：<a href="https://www.baidu.com">baidu_biaoqian</a>。

想要学习 `我最喜欢的编程语言`_ ?

.. _我最喜欢的编程语言: http://www.python.org


- `A HYPERLINK`_
- `a   hyperlink`_

.. _A HYPERLINK:

隐式链接
========================

.. __: anonymous-hyperlink-target-link-block

上面是隐式超链接


内部链接
========================

**样例展示：**

----

.. _my1-reference-label:

这是标题(后面会索引上面的标记然后找到这个标题)
========================================================================

This is the text of the section.

It refers to the section itself, see :ref:`my1-reference-label`.

**上面换行功能实现方法，以下是rST源码显示样例**::

    .. _my1-reference-label:

    这是标题(后面会索引上面的标记然后找到这个标题)
    ================================================

    This is the text of the section.

    It refers to the section itself, see :ref:`my1-reference-label`.

.. [1]  http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#hyperlink-references