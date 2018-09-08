.. _zzjlogin-rst-tab:

==============================
表格 [1]_
==============================

.. contents::

表格主要包括：

1. 简单表格和网格。
2. csv表格
3. 列表表格
#. 还可以通过外部文件引入表格。

正式的表格比 ``reStructuredText`` 语法所提供的需要更多结构。
表格可以使用关键字指令指定标题。
有时reStructuredText表格不方便书写，或表格数据不是随手可得的标准格式。 指令支持CSV数据。

.. _rst-table:

简单表格和网格
==============================

(Docutils 0.3.1 新增)

表格指令用于创建一个带标题的表格，需要将标题关联到表格。

简单表格
-------------------------------

:样例：:

.. table:: Truth table for "not"

    =====  =====
        A    not A
    =====  =====
    False  True
    True   False
    =====  =====

源码格式：

::

    .. table:: Truth table for "not"

       =====  =====
         A    not A
       =====  =====
       False  True
       True   False
       =====  =====

网格
-------------------------------

网格表格：完整的，但复杂、冗长

+------------------------+------------+----------+
| Header row, column 1   | Header 2   | Header 3 |
+========================+============+==========+
| body row 1, column 1   | column 2   | column 3 |
+------------------------+------------+----------+
| body row 2             | Cells may span        |
+------------------------+-----------------------+

源码格式：

::

         +------------------------+------------+----------+
         | Header row, column 1   | Header 2   | Header 3 |
         +========================+============+==========+
         | body row 1, column 1   | column 2   | column 3 |
         +------------------------+------------+----------+
         | body row 2             | Cells may span        |
         +------------------------+-----------------------+

.. _rst-csv-table:

CSV 表格
==============================

.. WARNING::

   一个CSV(逗号分隔的值)表格

.. WARNING::

   "csv-table"指令的 ":file\:" 和 ":url\:" 选项表示一个潜在的安全漏洞。其可以使用运行时设置禁用。

(Docutils 0.3.4 新增)

"csv-table"指令用于通过CSV数据创建一个表格。CSV是一种由电子表格应用程序和树叶数据库生成的通用数据格式。数据可能是内部的(文件的一个组成部分)，也可能是外部的(一个单独的文件)。

CSV 文本数据表格
----------------------------------

:样例:

.. csv-table:: Frozen Delights!
    :header: "Treat", "Quantity", "Description"
    :widths: 50, 50, 30

    "Albatross", 2.99, "On a stick!"
    "Crunchy Frog", 1.49, "If we took the bones out, it wouldn't be
    crunchy, now would it?"
    "Gannet Ripple", 1.99, "On a stick!"

:源码格式:

::

    .. csv-table:: Frozen Delights!
       :header: "Treat", "Quantity", "Description"
       :widths: 50, 50, 60

       "Albatross", 2.99, "On a stick!"
       "Crunchy Frog", 1.49, "If we took the bones out, it wouldn't be
       crunchy, now would it?"
       "Gannet Ripple", 1.99, "On a stick!"

CSV文件表格
----------------------------------

.. attention::
    csv文件如果有中文会报错。

:样例:

.. csv-table:: Frozen Delights!
   :header: "id", "username", "time"
   :widths: 15, 10, 30
   :file: test.csv
   :encoding: utf-8
   :align: left

:源码格式:

::


    .. csv-table:: Frozen Delights!
        :header: "id", "username", "time"
        :widths: 15, 10, 30
        :file: test.csv
        :encoding: utf-8
        :align: left



----





.. _dt-list-table:

列表表格
==============================

(Docutils 0.3.8. 新增。只是一个初始实现。)

"list-table"指令用于从统一的两层无需列表中的数据创建一个表格。"统一"意味着每个子列表(二级列表)必须包含相同数量的列表项。

:例子:

.. list-table:: Frozen Delights!
    :widths: 20 30 60
    :header-rows: 1

    * - Treat
      - Quantity
      - Description
    * - Albatross
      - 2.99
      - On a stick!
    * - Crunchy Frog
      - 1.49
      - If we took the bones out, it wouldn't be
        crunchy, now would it?
    * - Gannet Ripple
      - 1.99
      - On a stick!

:源码格式:

::

    .. list-table:: Frozen Delights!
       :widths: 15 10 30
       :header-rows: 1

       * - Treat
         - Quantity
         - Description
       * - Albatross
         - 2.99
         - On a stick!
       * - Crunchy Frog
         - 1.49
         - If we took the bones out, it wouldn't be
           crunchy, now would it?
       * - Gannet Ripple
         - 1.99
         - On a stick!

.. _rst-tab-options:

表格设置中的选项
==============================


下列选项可以被识别:

``widths`` : 整型 [, 整型...]
    一个逗号或空格分隔的相对列宽列表。默认等分

``header-rows`` : 整型
    表头所使用的CSV数据的行数。默认为0

``stub-columns`` : 整型
    用作行标题的列数。默认为0

``header`` : CSV数据
    为表格标题补充数据，从主CSV数据中添加独立且在其他任何之前的 ``标题行`` 。必须使用与主CSV数据相同的CSV格式。

``file`` : string (newlines removed)
    CSV数据文件的本地文件系统路径

``url`` : string (whitespace removed)
    指向一个CSV数据文件的网络URL引用

``encoding`` : name of text encoding
    扩展CSV数据(文件或URL)的文本编码。默认与文档编码相同(如果指定了)

``delim`` : char | "tab" | "space" [whitespace-delim]_
    一个单字符字符串\ [ASCII-char]_ 用于分隔字段。默认为 ``,`` (逗号)。可以指定为一个Unicode代码点。阅读 xxx 指令以获取语法细节

``keepspace`` : flag
    保留分隔符后的空格。默认忽略

``escape`` : char
    一个单字符字符串\ [ASCII-char]_ 用于转义分隔符或引用字符。
    可以指定为一个Unicode代码点。

    .. 添加另一个可能的值, "double", 以显式表名默认例子.

``align`` : "top", "middle", "bottom", "left", "center", or "right"
    设置表格的位置。默认时居左，可以设置居中。

支持单元格内的块标记和行内标记。单元格内的行结束符能被识别

工作限制:

* 没有提供对各行的列数是否一致的检查。但该指令通过自动添加空条目
  支持不会在短行之后插入空条目的CSV生成器

  .. 添加 "strict" 选项来验证输入。

.. [whitespace-delim] 空白分隔符只对外部CSV文件起效

.. [ASCII-char] 在Python 2中， ``delimiter``、 ``quote`` 
   和 ``escape`` 选项必须为ASCII字符。(csv模块不支持Unicode和所有
   非ASCII字符，即使被编码为utf-8的字符串)。该限制在Python3中不存在。


.. [1]  http://docutils.sourceforge.net/docs/ref/rst/directives.html#tables


