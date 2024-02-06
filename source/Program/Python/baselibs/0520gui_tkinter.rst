.. _python_tkinter:

======================================================================================================================================================
:mod:`tkinter` --- python的Tcl/Tk接口（图形显示）
======================================================================================================================================================

.. module:: tkinter

.. contents::



tkinter实例
======================================================================================================================================================


tkinter常用模块详解
======================================================================================================================================================

.. toctree::
   :maxdepth: 1

   tkinter/*


tkinter官方详解
======================================================================================================================================================

这个Python包，在Python2中名字是Tkinter，在python3中改成了小写的tkinter。

:mod:`tkinter` ："Tk interface"，是Python的图形界面标准接口。
Tk和 :mod:`tkinter` 在多数Unix平台和Windows平台都可以使用。
Tk 不是Python的一部分; it is maintained at ActiveState.


.. seealso::

   Tkinter 相关文档:

   `Python Tkinter Resources <https://wiki.python.org/moin/TkInter>`_
      The Python Tkinter Topic Guide provides a great deal of information on using Tk
      from Python and links to other sources of information on Tk.

   `TKDocs <http://www.tkdocs.com/>`_
      Extensive tutorial plus friendlier widget pages for some of the widgets.

   `Tkinter reference: a GUI for Python <https://infohost.nmt.edu/tcc/help/pubs/tkinter/web/index.html>`_
      On-line reference material.

   `Tkinter docs from effbot <http://effbot.org/tkinterbook/>`_
      Online reference for tkinter supported by effbot.org.

   `Programming Python <http://learning-python.com/about-pp4e.html>`_
      Book by Mark Lutz, has excellent coverage of Tkinter.

   `Modern Tkinter for Busy Python Developers <https://www.amazon.com/Modern-Tkinter-Python-Developers-ebook/dp/B0071QDNLO/>`_
      Book by Mark Rozerman about building attractive and modern graphical user interfaces with Python and Tkinter.

   `Python and Tkinter Programming <https://www.manning.com/books/python-and-tkinter-programming>`_
      Book by John Grayson (ISBN 1-884777-81-3).

   Tcl/Tk documentation:

   `Tk commands <https://www.tcl.tk/man/tcl8.6/TkCmd/contents.htm>`_
      Most commands are available as :mod:`tkinter` or :mod:`tkinter.ttk` classes.
      Change '8.6' to match the version of your Tcl/Tk installation.

   `Tcl/Tk recent man pages <https://www.tcl.tk/doc/>`_
      Recent Tcl/Tk manuals on www.tcl.tk.

   `ActiveState Tcl Home Page <http://tcl.activestate.com/>`_
      The Tk/Tcl development is largely taking place at ActiveState.

   `Tcl and the Tk Toolkit <https://www.amazon.com/exec/obidos/ASIN/020163337X>`_
      Book by John Ousterhout, the inventor of Tcl.

   `Practical Programming in Tcl and Tk <http://www.beedub.com/book/>`_
      Brent Welch's encyclopedic book.


Tkinter Modules
---------------

这个模块的使用方法::

   import tkinter

或者使用下面方法导入，这个方法更常用::

   from tkinter import *


.. class:: Tk(screenName=None, baseName=None, className='Tk', useTk=1)

   在没有参数的情况下实例化 :class:`Tk` 类。创建的Tk通常是应用程序的主窗口，
   而且是窗口的主。每个实例都有自己关联的Tcl解释器


.. function:: Tcl(screenName=None, baseName=None, className='Tk', useTk=0)

   :func:`Tcl` 函数是 :class:`Tk` class 创建的工厂函数


提供Tk支持的其他模块包括:

:mod:`tkinter.scrolledtext`
   内置垂直滚动条的文本小部件，Text widget with a vertical scroll bar built in.

:mod:`tkinter.colorchooser`
   对话框，让用户选择颜色，Dialog to let the user choose a color.

:mod:`tkinter.commondialog`
   这里列出的其他模块中定义的对话框的基类，Base class for the dialogs defined in the other modules listed here.

:mod:`tkinter.filedialog`
   公共对话框，允许用户指定要打开或保存的文件，Common dialogs to allow the user to specify a file to open or save.

:mod:`tkinter.font`
   帮助处理字体的实用程序，Utilities to help work with fonts.

:mod:`tkinter.messagebox`
   访问标准Tk对话框，Access to standard Tk dialog boxes.

:mod:`tkinter.simpledialog`
   基本对话框和方便的功能，Basic dialogs and convenience functions.

:mod:`tkinter.dnd`
   Drag-and-drop support for :mod:`tkinter`. 
   这是实验性的，当它被替换为Tk DND时应该被弃用。

:mod:`turtle`
   乌龟图形在Tk窗口。


Tkinter Life Preserver
----------------------



本节不是关于Tk或Tkinter的详尽教程。相反，它的目的是作为一个权宜之计，提供一些关于系统的入门介绍。



简单的HelloWorld程序
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    import tkinter as tk

    class Application(tk.Frame):
        def __init__(self, master=None):
            super().__init__(master)
            self.master = master
            self.pack()
            self.create_widgets()

        def create_widgets(self):
            self.hi_there = tk.Button(self)
            self.hi_there["text"] = "Hello World\n(click me)"
            self.hi_there["command"] = self.say_hi
            self.hi_there.pack(side="top")

            self.quit = tk.Button(self, text="QUIT", fg="red",
                                  command=self.master.destroy)
            self.quit.pack(side="bottom")

        def say_hi(self):
            print("hi there, everyone!")

    root = tk.Tk()
    app = Application(master=root)
    app.mainloop()


Tcl/Tk的快速使用
-----------------------------

类层次结构看起来很复杂，但在实际应用中，应用程序程序员几乎总是引用层次结构最底层的类。


Notes:

* 提供这些类的目的是在一个名称空间下组织某些函数。它们不应该单独实例化。

* :class:`Tk` 类只在应用程序中实例化一次。应用程序程序员不需要显式
  地实例化一个类，只要实例化了其他类，系统就会创建一个类。

* :class:`Widget` 类并不意味着要被实例化，它只意味着子类化以生成“真正的”Widget
  (在 C++中这叫做抽象类).



要在 Tk 中创建一个控件，命令总是以下形式::

   classCommand newPathname options

*classCommand*
   表示要创建控件的类型（按钮，标签，菜单...）

.. index:: single: . (dot); in Tkinter

*newPathname*
   窗体部件的一个新的名称，这个名称在Tk内是独一无二的。
   为了帮助实现这一点，Tk中的窗体部件使用 *pathnames*名来命名，就像文件系统中的文件一样。
   最高级别的窗体部件 *root*被叫做 ``.`` (period) and
   子元素被更多的句号分隔。例如：
   ``.myApp.controlPanel.okButton`` 可能是窗体部件的名称.

*options*
   配置窗体部件的显示特点。这些配置项通过标志和值组成。标志的开始是'-'，类似Unix Shell的命令选项。


例如::

   button   .fred   -fg red -text "hi there"
      ^       ^     \______________________/
      |       |                |
    class    new            options
   command  widget  (-opt val -opt val ...)



.. _tkinter-basic-mapping:

映射基本Tk 到 Tkinter
-----------------------------

Tk 中的类命令对应于 Tkinter 中的类结构。 ::

   button .fred                =====>  fred = Button()

Tk 控件所属主体在创建时就已经包含于名称中。在 Tkinter 中，要明确指定主体。 ::

   button .panel.fred          =====>  fred = Button(panel)
Tk 配置选项是连字符加标签，后跟值的列表。在 Tkinter 中，
在实例构造中，选项被指定为关键字参数，对于已建立的实例，在字典样式中作为索引，或者设置方法的参数。
:ref:`tkinter-setting-options` on setting options. ::

   button .fred -fg red        =====>  fred = Button(panel, fg="red")
   .fred configure -fg red     =====>  fred["fg"] = red
                               OR ==>  fred.config(fg="red")

在 Tk 中，要对控件执行一个 action，使用控件名称作为命令，并跟随一个 action 名称，
可能带有参数（选项）。在 Tkinter 中，用实例调用方法的形式来调用控件的 actions。
已定义可执行的 actions (methods) 。可以在文件
:file:`tkinter/__init__.py`. ::

   .fred invoke                =====>  fred.invoke()

To give a widget to the packer (geometry manager), you call pack with optional
arguments.  In Tkinter, the Pack class holds all this functionality, and the
various forms of the pack command are implemented as methods.  All widgets in
:mod:`tkinter` are subclassed from the Packer, and so inherit all the packing
methods. See the :mod:`tkinter.tix` module documentation for additional
information on the Form geometry manager. ::

   pack .fred -side left       =====>  fred.pack(side="left")


Tk 和 Tkinter 的关系
------------------------------

From the top down:

Your App Here (Python)
   A Python application makes a :mod:`tkinter` call.

tkinter (Python Package)
   This call (say, for example, creating a button widget), is implemented in
   the :mod:`tkinter` package, which is written in Python.  This Python
   function will parse the commands and the arguments and convert them into a
   form that makes them look as if they had come from a Tk script instead of
   a Python script.

_tkinter (C)
   These commands and their arguments will be passed to a C function in the
   :mod:`_tkinter` - note the underscore - extension module.

Tk Widgets (C and Tcl)
   This C function is able to make calls into other C modules, including the C
   functions that make up the Tk library.  Tk is implemented in C and some Tcl.
   The Tcl part of the Tk widgets is used to bind certain default behaviors to
   widgets, and is executed once at the point where the Python :mod:`tkinter`
   package is imported. (The user never sees this stage).

Tk (C)
   The Tk part of the Tk Widgets implement the final mapping to ...

Xlib (C)
   the Xlib library to draw graphics on the screen.


Handy Reference
---------------


.. _tkinter-setting-options:

设置选项
^^^^^^^^^^^^^^^

Options control things like the color and border width of a widget. Options can
be set in three ways:

At object creation time, using keyword arguments
   ::

      fred = Button(self, fg="red", bg="blue")

After object creation, treating the option name like a dictionary index
   ::

      fred["fg"] = "red"
      fred["bg"] = "blue"

Use the config() method to update multiple attrs subsequent to object creation
   ::

      fred.config(fg="red", bg="blue")

For a complete explanation of a given option and its behavior, see the Tk man
pages for the widget in question.

Note that the man pages list "STANDARD OPTIONS" and "WIDGET SPECIFIC OPTIONS"
for each widget.  The former is a list of options that are common to many
widgets, the latter are the options that are idiosyncratic to that particular
widget.  The Standard Options are documented on the :manpage:`options(3)` man
page.

No distinction between standard and widget-specific options is made in this
document.  Some options don't apply to some kinds of widgets. Whether a given
widget responds to a particular option depends on the class of the widget;
buttons have a ``command`` option, labels do not.

The options supported by a given widget are listed in that widget's man page, or
can be queried at runtime by calling the :meth:`config` method without
arguments, or by calling the :meth:`keys` method on that widget.  The return
value of these calls is a dictionary whose key is the name of the option as a
string (for example, ``'relief'``) and whose values are 5-tuples.

Some options, like ``bg`` are synonyms for common options with long names
(``bg`` is shorthand for "background"). Passing the ``config()`` method the name
of a shorthand option will return a 2-tuple, not 5-tuple. The 2-tuple passed
back will contain the name of the synonym and the "real" option (such as
``('bg', 'background')``).

+-------+---------------------------------+--------------+
| Index | Meaning                         | Example      |
+=======+=================================+==============+
| 0     | option name                     | ``'relief'`` |
+-------+---------------------------------+--------------+
| 1     | option name for database lookup | ``'relief'`` |
+-------+---------------------------------+--------------+
| 2     | option class for database       | ``'Relief'`` |
|       | lookup                          |              |
+-------+---------------------------------+--------------+
| 3     | default value                   | ``'raised'`` |
+-------+---------------------------------+--------------+
| 4     | current value                   | ``'groove'`` |
+-------+---------------------------------+--------------+

Example::

   >>> print(fred.config())
   {'relief': ('relief', 'relief', 'Relief', 'raised', 'groove')}

Of course, the dictionary printed will include all the options available and
their values.  This is meant only as an example.


The Packer
^^^^^^^^^^

.. index:: single: packing (widgets)

The packer is one of Tk's geometry-management mechanisms.    Geometry managers
are used to specify the relative positioning of the positioning of widgets
within their container - their mutual *master*.  In contrast to the more
cumbersome *placer* (which is used less commonly, and we do not cover here), the
packer takes qualitative relationship specification - *above*, *to the left of*,
*filling*, etc - and works everything out to determine the exact placement
coordinates for you.

The size of any *master* widget is determined by the size of the "slave widgets"
inside.  The packer is used to control where slave widgets appear inside the
master into which they are packed.  You can pack widgets into frames, and frames
into other frames, in order to achieve the kind of layout you desire.
Additionally, the arrangement is dynamically adjusted to accommodate incremental
changes to the configuration, once it is packed.

Note that widgets do not appear until they have had their geometry specified
with a geometry manager.  It's a common early mistake to leave out the geometry
specification, and then be surprised when the widget is created but nothing
appears.  A widget will appear only after it has had, for example, the packer's
:meth:`pack` method applied to it.

The pack() method can be called with keyword-option/value pairs that control
where the widget is to appear within its container, and how it is to behave when
the main application window is resized.  Here are some examples::

   fred.pack()                     # defaults to side = "top"
   fred.pack(side="left")
   fred.pack(expand=1)


Packer 选项
^^^^^^^^^^^^^^


anchor（锚）
   Anchor 类型。标示放在 packer 中每个从控件的位置。

expand（可拉伸）
   Boolean, ``0`` or ``1``.

fill（填充）
   有效值：  ``'x'``, ``'y'``, ``'both'``, ``'none'``.

ipadx and ipady
   距离 - 在从属控件的每一侧指定内边距。

padx and pady
   距离 - 在从属控件的每一侧指定外边距。

side
   有效值为： ``'left'``, ``'right'``, ``'top'``, ``'bottom'``.


窗体变量耦合
^^^^^^^^^^^^^^^^^^^^^^^^^


For example::

   class App(Frame):
       def __init__(self, master=None):
           super().__init__(master)
           self.pack()

           self.entrythingy = Entry()
           self.entrythingy.pack()

           # here is the application variable
           self.contents = StringVar()
           # set it to some value
           self.contents.set("this is a variable")
           # tell the entry widget to watch this variable
           self.entrythingy["textvariable"] = self.contents

           # and here we get a callback when the user hits return.
           # we will have the program print out the value of the
           # application variable when the user hits return
           self.entrythingy.bind('<Key-Return>',
                                 self.print_contents)

       def print_contents(self, event):
           print("hi. contents of entry is now ---->",
                 self.contents.get())


窗口管理
^^^^^^^^^^^^^^^^^^

.. index:: single: window manager (widgets)


Here are some examples of typical usage::

   import tkinter as tk

   class App(tk.Frame):
       def __init__(self, master=None):
           super().__init__(master)
           self.pack()

   # create the application
   myapp = App()

   #
   # here are method calls to the window manager class
   #
   myapp.master.title("My Do-Nothing Application")
   myapp.master.maxsize(1000, 400)

   # start the program
   myapp.mainloop()


Tk选项和数据类型
^^^^^^^^^^^^^^^^^^^^

.. index:: single: Tk Option Data Types

anchor（锚）
   有效值是位置点： ``"n"``, ``"ne"``, ``"e"``, ``"se"``,
   ``"s"``, ``"sw"``, ``"w"``, ``"nw"``, and also ``"center"``.

bitmap（位图）
   有八个内置的已命名位图： ``'error'``, ``'gray25'``,
   ``'gray50'``, ``'hourglass'``, ``'info'``, ``'questhead'``, ``'question'``,
   ``'warning'``.  To specify an X bitmap filename, give the full path to the file,
   preceded with an ``@``, as in ``"@/usr/contrib/bitmap/gumby.bit"``.

boolean（布尔）
   You can pass integers 0 or 1 or the strings ``"yes"`` or ``"no"``.

callback（回调）
   回调函数可以是任何的没有参数的函数。例如：::

      def print_it():
          print("hi there")
      fred["command"] = print_it

color（颜色）
   Colors can be given as the names of X colors in the rgb.txt file, or as strings
   representing RGB values in 4 bit: ``"#RGB"``, 8 bit: ``"#RRGGBB"``, 12 bit"
   ``"#RRRGGGBBB"``, or 16 bit ``"#RRRRGGGGBBBB"`` ranges, where R,G,B here
   represent any legal hex digit.  See page 160 of Ousterhout's book for details.

cursor（光标）
   可以使用cursorfont.h的标准X游标名称，而不使用XC_前缀。例如，要获取手形光标（XC_hand2），
   请使用字符串"hand2"。您还可以指定自己的位图和掩码文件。参见Ousterhout的书的第179页。

distance（距离）
   屏幕距离可以指定像素或绝对距离。像素以数字和绝对距离作为字符串，尾随字符表示单位：
   ``c`` 表示厘米， ``i`` 表示英寸， ``m`` 表示毫米， ``p`` 表示打印的点
   例如： 3.5英寸的表达： ``"3.5i"``.

font（字体）
   Tk使用列表字体名称格式，例如 ``{courier 10 bold}`` 。具有正数的字体大小以点数测量；
   具有负数的尺寸以像素测量。

geometry（几何大小）
   这是一种形式为 ``widthxheight`` 的字符串，其中对于大多数小部件（以显示文本的小部件的字符为单位），
   宽度和高度以像素为单位。例如： ``fred["geometry"] = "200x100"``.

justify（对齐方式）
   有效值是： ``"left"``, ``"center"``, ``"right"``, and
   ``"fill"``.

region（区域）
   这是一个具有四个空格分隔元素的字符串，每个元素都是一个合法距离（见上文）。例如：
   ``"2 3 4 5"`` and ``"3i 2i 4.5i 2i"`` and ``"3c 2c 4c 10.43c"``  are all legal regions.

relief
   确定窗口小部件的边框样式。有效的值有:
   ``"raised"``, ``"sunken"``, ``"flat"``, ``"groove"``, and ``"ridge"``.

scrollcommand
   这几乎总是一些滚动条小部件的 :meth:`!set` 方法，但可以是任何接受单个参数的widget方法。


wrap:
   必须为以下之一： ``"none"``, ``"char"``, or ``"word"``.


绑定和事件
^^^^^^^^^^^^^^^^^^^

.. index::
   single: bind (widgets)
   single: events (widgets)

widget命令的bind方法允许您监视某些事件，并在发生事件类型时触发回调函数。绑定方法的形式是::

   def bind(self, sequence, func, add=''):

参数依次为:

sequence
   是表示事件的目标类型的字符串。（有关详细信息，请参阅John Ousterhout的书的bind手册页和第201页）

func
   是一个Python函数，使用一个参数，在事件发生时调用。事件实例将作为参数传递。
   （以这种方式部署的函数通常称为回调函数*callbacks*。）


add
   可选参数， ``''`` 或 ``'+'`` 。传递空字符串表示此绑定将替换此事件关联的任何其他绑定。
   传递 ``'+'`` 意味着此函数将添加到绑定到此事件类型的函数列表。

For example::

   def turn_red(self, event):
       event.widget["activeforeground"] = "red"

   self.button.bind("<Enter>", self.turn_red)

注意如何在turn_red()回调中访问事件的窗口部件字段。此字段包含捕获X事件的窗口小部件。
下表列出了您可以访问的其他事件字段及其在Tk中的表示方式，这在引用Tk手册页时很有用。

+----+---------------------+----+---------------------+
| Tk | Tkinter Event Field | Tk | Tkinter Event Field |
+====+=====================+====+=====================+
| %f | focus               | %A | char                |
+----+---------------------+----+---------------------+
| %h | height              | %E | send_event          |
+----+---------------------+----+---------------------+
| %k | keycode             | %K | keysym              |
+----+---------------------+----+---------------------+
| %s | state               | %N | keysym_num          |
+----+---------------------+----+---------------------+
| %t | time                | %T | type                |
+----+---------------------+----+---------------------+
| %w | width               | %W | widget              |
+----+---------------------+----+---------------------+
| %x | x                   | %X | x_root              |
+----+---------------------+----+---------------------+
| %y | y                   | %Y | y_root              |
+----+---------------------+----+---------------------+


