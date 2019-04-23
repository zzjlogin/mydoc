.. _python_execute:

======================================================================================================================================================
Python执行环境
======================================================================================================================================================

.. contents::



参考
======================================================================================================================================================

- Python3.7相关参考：https://docs.python.org/zh-cn/3.7/tutorial/interpreter.html
- Python3官方关于解释器选项说明：https://docs.python.org/3/using/cmdline.html#using-on-general

命令行执行python文件/程序
======================================================================================================================================================


Python命令行执行语法::

    python [-bBdEhiIOqsSuvVWx?] [-c command | -m module-name | script | - ] [args]

最常见的执行python脚本的方法::

    python myscript.py




* 执行过程如果要结束，在UNIX用 :kbd:`Ctrl-D` 在windows系统用 :kbd:`Ctrl-Z, Enter` 。
* python解释器读入的文件需要有对应的权限。
* 当使用参数 ``-c command`` 时, 传入一个command字符串作为python执行的语句命令。command包含多个语句时，用空格分隔，测试python3.7不生效
* 当使用参数 ``-m module-name``, 这个模块的名称需要在python的path目录中可以找到。


解释器选项
======================================================================================================================================================


.. cmdoption:: -c <command>

   - 执行python代码传入的参数 *command* 。
   - 如果使用这个参数，会把当前的工作目录传入 ``sys.argv``


.. cmdoption:: -m <module-name>

   - 会在 ``sys.path`` 的路径中查找对应的模块
   - 传入的模块名称，需要在查找的路径中有对应的文件，文件格式为 ``.py``

.. describe:: -

   从命令行作为标准输入。如果运行终端标准输入那么参数 ``-i`` 是隐含输入的。

.. describe:: <script>

   用python解释器质性python的源码文件 **script**

.. cmdoption:: -?
               -h
               --help

   输入python的所有选项


.. cmdoption:: -V
               --version

   输入Python版本号然后退出。例如:

   .. code-block:: none

       Python 3.7.0b2+

   当给两个V时，会输出更详细的信息,例如:

   .. code-block:: none

       Python 3.7.0b2+ (3.7:0c076caaa8, Sep 22 2018, 12:04:24)
       [GCC 6.2.0 20161005]

   .. versionadded:: 3.6
      The ``-VV`` option.



.. cmdoption:: -b

   当比较 ``bytes`` 或 ```bytearray``` 和 ``str`` 或 ``bytes`` 和 ``int`` 提示错误警告 (:option:`!-bb`).

.. cmdoption:: -B

   阻止导入的模块对应的文件生成 ``.pyc`` 文件。 可以参考下面的环境变量中的 ``PYTHONDONTWRITEBYTECODE`` 


.. cmdoption:: --check-hash-based-pycs default|always|never

   校验文件 ``.pyc`` 。当设置 ``default`` 时，根据默认语法校验与不校验二进制代码文件的哈希值。
   当设置为 ``always`` 时，会全部校验 ``.pyc`` 文件。当设置 ``never`` ，不校验 ``.pyc`` 文件。

.. cmdoption:: -d

   打开解释器的调试功能。可以参考环境变量中的 ``PYTHONDEBUG``.

.. cmdoption:: -E

   忽略环境变量中的所有的变量 ``PYTHON*`` 例如：``PYTHONPATH`` 、 ``PYTHONHOME``

.. cmdoption:: -i

   - 在程序执行后进入交互模式。

.. cmdoption:: -I

   隔离模式运行python。可以使用参数 ``-E`` 和 ``-s``

   .. versionadded:: 3.4


.. cmdoption:: -O

   - 优化模式
   - 去掉调试中的assert和代码中条件语句。Remove assert statements and any code conditional on the value of

   .. versionchanged:: 3.5
      Modify ``.pyc`` filenames according to :pep:`488`.


.. cmdoption:: -OO

   和 ``-O`` 参数相同，同时还去掉文档(字符串)

   .. versionchanged:: 3.5
      Modify ``.pyc`` filenames according to :pep:`488`.


.. cmdoption:: -q

   不输出版本信息。

   .. versionadded:: 3.2


.. cmdoption:: -R

   打开哈希随机化。仅在环境变量 ``PYTHONHASHSEED`` 设置为0起作用，默认情况下启用散列随机化。

   .. versionchanged:: 3.7
      The option is no longer ignored.

   .. versionadded:: 3.2.3


.. cmdoption:: -s

   阻止将当前的文件目录传入 ``sys.path`` 路径

.. cmdoption:: -S

   阻止包含的site初始化模块


.. cmdoption:: -u

   强制取消缓冲stdout和stderr数据流。此选项对stdin流没有影响。

   .. versionchanged:: 3.7
      The text layer of the stdout and stderr streams now is unbuffered.


.. cmdoption:: -v

   跟踪导入语句。当使用 ``!-vv`` 会输出更详细的信息

.. cmdoption:: -W arg

   预警控制。Python的警告机制默认情况下会将警告消息打印到 ``sys.stderr`` 。典型的警告信息有以下形式:

   .. code-block:: none

       file:line: category: message

   最简单的设置无条件地对进程发出的所有警告应用特定的操作(即使是那些默认情况下被忽略的警告)::

       -Wdefault  # Warn once per call location
       -Werror    # Convert to exceptions
       -Walways   # Warn every time
       -Wmodule   # Warn once per calling module
       -Wonce     # Warn once per Python process
       -Wignore   # Never warn

   操作名可以按需要缩写，例如： ``-Wi``, ``-Wd``, ``-Wa``, ``-We``

.. cmdoption:: -x

   跳过源码的第一行，允许非unix形式格式 ``#!cmd``。


.. cmdoption:: -X

   设置特定于实现的选项。 CPython 当前定义了下面值：

   * ``-X faulthandler`` 允许 `faulthandler`;
   * ``-X showrefcount`` 在程序完成时或在交互式解释器中的每个语句之后输出总引用计数和已用内存块的数量。这仅适用于调试版本。
   * ``-X tracemalloc`` 要使用tracemalloc模块开始跟踪Python内存分配。默认情况下，只有最近的帧存储在跟踪的回溯中。
     使用 ``-X tracemalloc = NFRAME`` 以NFRAME帧的回溯限制开始跟踪


   .. versionchanged:: 3.2
      增加参数 :option:`-X` 。

   .. versionadded:: 3.3
      增加 ``-X faulthandler`` 。

   .. versionadded:: 3.4
      增加 ``-X showrefcount`` 和 ``-X tracemalloc`` 

   .. versionadded:: 3.6
      增加 ``-X showalloccount`` 

   .. versionadded:: 3.7
      增加 ``-X importtime``, ``-X dev`` 和 ``-X utf8`` 


下面选项不建议使用


.. cmdoption:: -J

   Reserved for use by Jython_.

.. _Jython: http://www.jython.org/



解释器环境变量
======================================================================================================================================================





.. envvar:: PYTHONHOME



.. envvar:: PYTHONPATH



.. envvar:: PYTHONSTARTUP


.. envvar:: PYTHONOPTIMIZE



.. envvar:: PYTHONBREAKPOINT


   .. versionadded:: 3.7

.. envvar:: PYTHONDEBUG



.. envvar:: PYTHONINSPECT



.. envvar:: PYTHONUNBUFFERED


.. envvar:: PYTHONVERBOSE


.. envvar:: PYTHONCASEOK



.. envvar:: PYTHONDONTWRITEBYTECODE


.. envvar:: PYTHONHASHSEED


   .. versionadded:: 3.2.3


.. envvar:: PYTHONIOENCODING


.. envvar:: PYTHONNOUSERSITE

 

.. envvar:: PYTHONUSERBASE



.. envvar:: PYTHONEXECUTABLE


.. envvar:: PYTHONWARNINGS

   The simplest settings apply a particular action unconditionally to all
   warnings emitted by a process (even those that are otherwise ignored by
   default)::

       PYTHONWARNINGS=default  # Warn once per call location
       PYTHONWARNINGS=error    # Convert to exceptions
       PYTHONWARNINGS=always   # Warn every time
       PYTHONWARNINGS=module   # Warn once per calling module
       PYTHONWARNINGS=once     # Warn once per Python process
       PYTHONWARNINGS=ignore   # Never warn


.. envvar:: PYTHONFAULTHANDLER


   .. versionadded:: 3.3


.. envvar:: PYTHONTRACEMALLOC


   .. versionadded:: 3.4


.. envvar:: PYTHONPROFILEIMPORTTIME


   .. versionadded:: 3.7


.. envvar:: PYTHONASYNCIODEBUG


   .. versionadded:: 3.4


.. envvar:: PYTHONMALLOC


   .. versionchanged:: 3.7
      Added the ``"default"`` allocator.

   .. versionadded:: 3.6


.. envvar:: PYTHONMALLOCSTATS


   .. versionchanged:: 3.6
      This variable can now also be used on Python compiled in release mode.
      It now has no effect if set to an empty string.


.. envvar:: PYTHONLEGACYWINDOWSFSENCODING

   .. availability:: Windows.

   .. versionadded:: 3.6
      See :pep:`529` for more details.

.. envvar:: PYTHONLEGACYWINDOWSSTDIO

   .. availability:: Windows.

   .. versionadded:: 3.6


.. envvar:: PYTHONCOERCECLOCALE

   * ``C.UTF-8``
   * ``C.utf8``
   * ``UTF-8``

   .. availability:: \*nix.

   .. versionadded:: 3.7
      See :pep:`538` for more details.


.. envvar:: PYTHONDEVMODE

   .. versionadded:: 3.7

.. envvar:: PYTHONUTF8

   .. availability:: \*nix.

   .. versionadded:: 3.7
      See :pep:`540` for more details.


Debug-mode variables
~~~~~~~~~~~~~~~~~~~~


.. envvar:: PYTHONTHREADDEBUG

   If set, Python will print threading debug info.


.. envvar:: PYTHONDUMPREFS

   If set, Python will dump objects and reference counts still alive after
   shutting down the interpreter.








