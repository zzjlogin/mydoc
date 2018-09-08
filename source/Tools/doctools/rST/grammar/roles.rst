.. _rst-roles:

=======================
角色
=======================

这一部分参考： [角色参考]_


.. _my-advance-ref:

\:ref:
----------------

为了支持对任何文档中的任意位置的交叉引用，使用标准的reST标签。为此，标签名称在整个文档中必须是唯一的。您可以通过两种方式引用标签：

- 如果您在标题标题之前直接放置标签，则可以使用标签:ref\:\`label-name`。例如：

::

    .. _my-reference-label:

    Section to cross-reference
    --------------------------

    This is the text of the section.

It refers to the section itself, see :ref\:\`my-reference-label`.
:ref\:然后，该角色将生成指向该部分的链接，链接标题为“要交叉引用的部分”。当section和reference在不同的源文件中时，这也可以正常工作。

自动标签也适用于数字。例如：

::

    .. _my-figure:

    .. figure:: whatever

        Figure caption

在这种情况下，引用:ref:\`my-figure`将插入带有链接文本“图标题”的图形引用。

对于使用table指令给出显式标题的表，同样适用 。

仍未引用未放置在节标题之前的标签，但您必须使用以下语法为链接指定明确的标题： 。:ref:\`Link title <label-name>`

.. hint::

    参考标签必须以下划线开头。引用标签时，必须省略下划线（参见上面的示例）。

ref建议使用标准reStructuredText链接到部分（例如），因为它跨文件工作，当部分标题更改时，如果不正确则会引发警告，并适用于所有支持交叉引用的构建器。

\:doc:
----------------

链接到指定的文件; 文档名称可以绝对或相对方式指定。例如，如果引用 :doc:\`parrot`发生在文档中sketches/index，则链接引用sketches/parrot。如果引用是:doc:\`/people`或 :doc:\`../people`，则链接引用people。

如果没有给出明确的链接文本（如通常:) ，则链接标题将是给定文档的标题。:doc:\`Monty Python members </people>`

.. hint::

    版本0.6的新功能。

    还有一种方法可以直接链接到文档：


\:download:
----------------

此角色允许您链接到源树中的文件，这些文件不是可以查看的reST文档，而是可以下载的文件。

使用此角色时，引用的文件会在构建时自动标记为包含在输出中（显然，仅适用于HTML输出）。所有可下载的文件都放在_downloads输出目录的子目录中; 处理重复的文件名。

一个例子：::

    See :download:`this example script <../example.py>`.

给定的文件名通常是相对于当前源文件所包含的目录，但如果它是绝对的（以...开头/），则将其视为相对于顶部源目录。

该example.py文件将被复制到输出目录，并生成一个合适的链接。

要不显示不可用的下载链接，您应该包含具有此角色的整个段落：::

    .. only:: builder_html

        See :download:`this example script <../example.py>`.

**实例:**

:download:`myfile </demo/test.py>`

:download:`/demo/test.py` 

\:numref:
----------------

\:envvar:
----------------
参考：[directive-envvar]_

环境变量。生成索引条目。还会生成匹配envvar指令的链接（如果存在）。

.. [directive-envvar] http://www.sphinx-doc.org/en/master/usage/restructuredtext/domains.html#directive-envvar


\:token:
----------------
参考：[directive-productionlist]_
语法标记的名称（用于在productionlist指令之间创建链接 ）。

.. [directive-productionlist] http://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#directive-productionlist


\:keyword:
----------------

Python中关键字的名称。这将创建一个指向具有该名称的引用标签的链接（如果存在）。

\:option:
----------------

\:term:
----------------

\:math:
----------------

内联数学的作用。使用这样：

Since Pythagoras, we know that :math:\`a^2 + b^2 = c^2`.

\:eq:
----------------

与...相同math:numref。

\:abbr:
----------------

0.6版本的新功能。

缩写。如果角色内容包含带括号的说明，则将对其进行特殊处理：它将以HTML格式显示在工具提示中，并在LaTeX中仅输出一次。

示例：。:abbr:\`LIFO (last-in, first-out)`


\:command:
----------------

操作系统级命令的名称，例如rm。

\:file:
----------------

文件或目录的名称。在内容中，您可以使用花括号来表示“变量”部分，例如：

::

    ... is installed in :file:\`/usr/lib/python2.{x}/site-packages` ...

\:guilabel:
----------------

\:kbd:
----------------

\:mailheader:
----------------

RFC 822样式邮件头的名称。此标记并不意味着标题正在电子邮件消息中使用，但可用于引用相同“样式”的任何标题。这也用于各种MIME规范定义的标头。标题名称的输入方式应与通常在实践中找到的方式相同，并且在有多个常用用法的情况下首选camel-casing约定。例如：:mailheader:\`Content-Type`。

\:makevar:
----------------

make变量的名称。

\:manpage:
----------------

对Unix手册页的引用，包括例如 :manpage:\`ls(1)`。创建指向外部站点的超链接，如果manpages_url已定义，则呈现联机帮助页。

.. tip::

    manpage_url定义方法：http://www.sphinx-doc.org/en/master/usage/configuration.html#confval-manpages_url

\:menuselection:
----------------

\:mimetype:
----------------

MIME类型的名称，或MIME类型的组件（主要或次要部分，单独使用）。

\:newsgroup:
----------------

Usenet新闻组的名称。

\:program:
----------------

可执行程序的名称。这可能与某些平台的可执行文件的文件名不同。特别是，.exe对于Windows程序，应省略（或其他）扩展名。

\:regexp:
----------------

正则表达式。不应包括行情。

\:samp:
----------------

一段文字文本，例如代码。在内容中，您可以使用花括号来表示“变量”部分，如file。例如，在中，将强调该部分。:samp:\`print 1+{variable}`variable

如果您不需要“可变部分”指示，请改用标准 ``code``。

在1.8版中更改：允许使用反斜杠转义花括号

\:pep:
----------------

**成外部链接**

对Python Enhancement Proposal的引用。这会生成适当的索引条目。生成文本“PEP 编号 ”; 在HTML输出中，此文本是指向指定PEP的联机副本的超链接。您可以通过说明链接到特定部分:pep:\`number#anchor`。

\:rfc:
----------------

对Internet请求注释的引用。这会生成适当的索引条目。生成文本“RFC 编号 ”; 在HTML输出中，此文本是指向指定RFC的联机副本的超链接。您可以通过说明链接到特定部分:rfc:`number#anchor`。

.. note::
    
    请注意，成外部链接,包含超链接没有特殊角色，因为您可以使用标准reST标记来实现此目的。


.. [角色参考] http://www.sphinx-doc.org/en/master/usage/restructuredtext/roles.html#ref-role