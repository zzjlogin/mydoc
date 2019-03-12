.. _python-introduction:

====================================================================
Python 简介
====================================================================


:Date: 2018-11

.. contents::


Python是动态类型的高级语言、强类型语言、解释型语言、面向对象语言

具体语言类型学习参考： :ref:`lang-class`

.. _python-versions:

Python版本
====================================================================

CPython
-----------------------------------------

标准的Python，解释型编译器。

Python：标准的CPython版本，即``官方发布版本``。

IPython：基于CPython的一个交互式解释器，也就是说，IPython只是在交互方式上有所增强，但是执行Python代码的功能和CPython是完全一样的。

相关链接：

    Python官方下载地址：https://www.python.org/downloads/

    IPython下载安装：http://ipython.org/install.html

    Python维基百科：https://zh.wikipedia.org/wiki/Python

    IPython维基百科：https://en.wikipedia.org/wiki/IPython

Jython
-----------------------------------------

使用Java模块可以和Java无缝集成。Jython可以被动态或静态地编译成Java字节码。解释型编译器。

相关链接：

    Jython下载地址：http://www.jython.org/archive/21/download.html

    Jython下载地址会掉转到：https://sourceforge.net/projects/jython/files/

    Jython维基百科：https://zh.wikipedia.org/wiki/Jython

    Jython百度百科：https://baike.baidu.com/item/Jython/8376458

PyPy
-----------------------------------------

基于Python编译器子集rPytho实现的python，然后可以再转换位C/CIL…。动态变异型编译器。

PyPy：
    是Python发展的趋势。
    而且PyPy也经历了pypy2到pypy3的转变。
    但是现在并不是所有的库都能完美的运行再PyPy编译器上(PyTest就已经放弃了对PyPy3的支持)。
    PyPy利用了JIT技术(参考wiki：https://en.wikipedia.org/wiki/Just-in-time_compilation)。

PyPy运行速度也并不是所有函数比CPython2.x/3.x都快，而是一部分函数功能运行快(PyPy在计算浮点数运算时效率有明显提升)。

PyPy和CPython的不同点(官方说明)：http://pypy.readthedocs.io/en/latest/cpython_differences.html

相关链接：

    PyPy下载地址：http://pypy.org/download.html

    PyPy官方文档：http://doc.pypy.org/en/latest/

    PyPy官方文档下载：http://readthedocs.org/projects/pypy/downloads/

    PyPy性能说明：http://speed.pypy.org/和https://speed.python.org/

    PyPy维基百科：https://zh.wikipedia.org/wiki/PyPy

IronPython
-----------------------------------------

IronPython和Jython类似。只不过IronPython是运行在微软.Net平台上的Python解释器，可以直接把Python代码编译成.Net的字节码。

相关链接：

    IronPython下载地址：http://ironpython.net/download/

    IronPython的github：https://github.com/IronLanguages/main和https://github.com/IronLanguages/main/releases

    IronPython官方文档：http://ironpython.net/documentation/

    IronPython维基百科：https://zh.wikipedia.org/wiki/IronPython

常用Python版本
-----------------------------------------

以下是平时经常用的Python发行版本：

CPython，一般我们所说的python默认是指这个发行版本的python现在一般用2.7/3.6。这个版本只提供标准库，第三方库需要自己用pip命令安装。(pip命令参考：https://pypi.org/project/pip/及https://pip.pypa.io/en/stable/user_guide/)
Anaconda，这个发行版的Python是科学计算及研究中经常使用到的发行版Python，这个发行版Python会自动集成很多方便易用和常用的第三方库。
安装了Anaconda，就安装了Python+NumPy+SciPy+Matplotlib+IPython+IPython Notebook。IPython Notebook是比较常见结合PyCharm开发使用的工具。

相关链接：

    Anaconda官网：https://www.anaconda.com/

    Anaconda下载地址：https://www.anaconda.com/download/

    清华源下载：https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/


Python相关链接
====================================================================

Python官方文档：

    Python3:https://docs.python.org/release/3.7.0/
    Python2:https://docs.python.org/release/2.7.15/
    Python文档全部:https://www.python.org/doc/versions/

Python第三方库集合:

    Python库列表:https://pypi.org/
    

Python学习网站：
    
    廖雪峰的官方网站_
    菜鸟教程_

.. _菜鸟教程: http://www.runoob.com/python/python-tutorial.html
.. _廖雪峰的官方网站: https://www.liaoxuefeng.com/wiki/001374738125095c955c1e6d8bb493182103fac9270762a000

Python开发工具
====================================================================

PyCharm、notepad++、eclipse、sublime text、Wing、Vim、Emacs、Komodo Edit、Wingware、PyScripter、The Eric Python IDE、
Interactive Editor for Python






