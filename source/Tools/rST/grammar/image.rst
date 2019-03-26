.. _rst.image:

======================================================================================================================================================
图片 [1]_
======================================================================================================================================================

有两个图片指令: "image"和"figure"

.. contents::

图片
======================================================================================================================================================

.. _dt-image:


:Directive Type: "image"
:Doctree Element: :ref\:\`图片 <dtr-image>`
:Directive Arguments: One, required (image URI).
:Directive Options: Possible.
:Directive Content: None.

一个"image"是一个简单的图片::

    .. image:: picture.png

.. hint::

    一般上面图片的“.. image:: picture.png”中的“picture.png”如果不在同一路径，都需要用绝对路径。即在图片名前面加一个“/”。


行内图片可以在 :re\:\`替代定义 <rst-substitution-definitions>` 中使用"image"指令来定义。

图片源文件的URI在指令参数中确定。因为有超链接目标，图片URI可以与显式标记开始字符和目标名称在同一行开始，也可以在紧跟的缩进文本块中(中间没有空行)开始。如果连接块有多行，它们会被删除开始和结束的空格并合并到一起。

.. _dt-image-options:

可选的，图片链接块可以包含一个平面字段列表，图片选项。例如::

    .. image:: picture.jpeg
       :height: 100px
       :width: 200 px
       :scale: 50 %
       :alt: alternate text
       :align: right

下列选项可以被识别:

``alt`` : 文本
    替换文本: 当应用无法显示图片时，会显示图片的一个简短的描述或
    由应用为视觉受损的用户读出。

``height`` : :ref:\`长度 <rst-length-units>`
    图片所需要的高。用于存储空间或比例尺图片的纵向。当"scale"也被
    指定了，它们会组合到一起。例如，一个高位200px且比例尺为50等
    价于高位100px且没有比例尺。

``width`` : 当前行宽度的 
    
::

    :ref:`长度 <rst-length-units>` 或 :ref:`百分比 <rst-percentage-units>`
    图片的宽度。用于存储空间或比例尺图片的横向类似"height"，当指定
    "scale"选项，则会被组合。

``scale`` : 整数百分比("%"符号是可选的)
    图片的统一缩放因子。默认"100%"，即无缩放。

    如果未指定高度和宽度选项，如果安装了 `Python图片库` (PIL)且图片有效，则其会被会用于决定它们。

``align`` : "top", "middle", "bottom", "left", "center", or "right"
    图片的对齐方式，等价于HTML的 ``<img>`` 标签的"align"属性。
    值"顶端"、"居中"、"底部"用于控制图片的纵向对齐(与文本基线关联)。它们只对行内图片(替代)有用。
    值"左"、"中"、"右"用于控制图片的横向对齐，允许图片漂浮，文字围绕
    图片。具体的行为取决于浏览器或用于渲染的软件。

``target`` : 文本(URI或引用名称)

::

    将图片变为超链接引用("可点击")。可选参数是一个URI(相对或绝对)，或一个包含下划线前缀的 :ref:`引用名称 <rst-reference-names>` 。


以及通用选项 `:class:` and `:name:`.

.. _dt-figure:

figure
======================================================================================================================================================

::

    :Directive Type: "figure"
    :Doctree Elements: :ref:`dtr-figure`, :ref:`图片 <dtr-image>`, :ref:`标题 <dtr-caption>`, :ref:`铭文 <dtr-legend>`
    :Directive Arguments: One, required (image URI).
    :Directive Options: Possible.
    :Directive Content: Interpreted as the figure caption and an optional
                        legend.

一个"figure"指令由 :ref:\`图片 <dtr-image>` 数据(包含 :ref:\`图片选项 <dt-image-options>`)和一个可选的标题(一个单行段落)和一个可选的铭文(任意正文元素)组成。对于基于页面输出的媒体，如果这对页面布局有帮助，figures可以浮动到一个不同的位置::

    .. figure:: picture.png
       :scale: 50 %
       :alt: map to buried treasure

       这是figure的标题(一个简单的段落)。

       铭文由标题后的所有元素组成。在本例中，其由本段和之后的表格组成:

       +-----------------------+-----------------------+
       | Symbol                | Meaning               |
       +=======================+=======================+
       | .. image:: tent.png   | Campground            |
       +-----------------------+-----------------------+
       | .. image:: waves.png  | Lake                  |
       +-----------------------+-----------------------+
       | .. image:: peak.png   | Mountain              |
       +-----------------------+-----------------------+

标题段落之前和铭文段落之前必须有空行。指定一个没有标题的铭文，在标题
的位置使用空注释("..")。

::

    "figure"指令支持"image"指令的所有选项(见上述 :ref:`图片选项 <dt-image-options>` )。这些选项(除了"对齐")会被传递给图片。

``align`` : "left", "center", or "right"
    figure的横向对齐，允许图片浮动及文字围绕它。具体行为取决于浏览器
    或渲染它的软件。

另外，下列选项可以被识别:

``figwidth`` : 

::

    "image", 当前行宽度的 :ref:`长度 <rst-length-units>` 或 :ref:`百分比 <rst-percentage-units>`
    figure的宽度。限制figure使用的横向空间。允许使用一个特殊的值
    "image"，此时使用所包含的图片的实际宽度(需要 `Python图片库`)。如果图片文件无法找到或需要的软件无法使用，该选项
    会被忽略。

    设置"figure"文档树元素的"width"属性。

    该选项不缩放包含的图片，需要使用"width"图片选项来缩放::

        +---------------------------+
        |        figure             |
        |                           |
        |<------ figwidth --------->|
        |                           |
        |  +---------------------+  |
        |  |     image           |  |
        |  |                     |  |
        |  |<--- width --------->|  |
        |  +---------------------+  |
        |                           |
        |The figure's caption should|
        |wrap at this width.        |
        +---------------------------+

``figclass`` : 文本

::

    在figure元素上设置一个 :ref:`"类" <dtr-classes>` 属性值。详见下面的 :ref:`类 <dt-class>` 指令。




.. [1]  http://docutils.sourceforge.net/docs/ref/rst/directives.html#images

