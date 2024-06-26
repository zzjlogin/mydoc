======================================================================================================================================================
reST环境安装及配置
======================================================================================================================================================


.. note::
    首先需要已经安装python并且已经把python路径加入了环境变量。

    其次，应该已经安装了pip。
    
    
Pyhon安装可以参考：




安装第三方库
======================================================================================================================================================

联网安装
------------------------------------------------------------------------------------------------------------------------------------------------------

1. 安装

.. code-block:: python
    :linenos:

    pip install sphinx sphinx-autobuild sphinx_rtd_theme

.. tip::
    可以用指定python库版本号的方法安装上面需要安装的库。
    
    例如： ``pip install sphinx==1.7.9``

2. 检查安装结果

.. code-block:: python
    :linenos:

    C:\Users\Administrator>pip list | grep sphinx
    sphinx-autobuild                   0.7.1
    sphinx-rtd-theme                   0.4.1
    sphinxcontrib-websupport           1.1.0

    C:\Users\Administrator>pip list | grep Sphinx*
    Sphinx                             1.7.9


3. 安装sphinx所有依赖包

    安装指定requirements.txt，其中文件内容：

.. code-block:: python
    :linenos:

    # markdown suport
    recommonmark
    # markdown table suport
    sphinx-markdown-tables
    #emoji
    sphinxemoji

    # theme default rtd

    # crate-docs-theme
    sphinx-rtd-theme
    sphinx-autobuild
    Pygments

    myst-parser
    sphinxcontrib-applehelp
    sphinxcontrib-devhelp
    sphinxcontrib-jsmath
    sphinxcontrib-htmlhelp
    sphinxcontrib-serializinghtml
    sphinxcontrib-qthelp
    Jinja2
    docutils
    snowballstemmer
    babel
    alabaster
    imagesize
    requests
    setuptools
    packaging


安装命令：

.. code-block:: python
    :linenos:

    pip install -r requirements.txt


指定国内源：

.. code-block:: python
    :linenos:

    pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/



创建rst文档项目
======================================================================================================================================================

`sphinx库`_ 提供很方便的rst文档管理方法。可以通过创建文档项目方式管理所有文档。

.. _sphinx库: https://pypi.org/project/Sphinx/

创建文档项目：

1. 创建一个文档的根目录。例如windows系统在g盘创建一个test文件夹。
2. 打开命令行(用快捷键ctrl+r，然后在弹出的运行窗口输入 ``cmd`` )
3. 把命令提示符的工作路径切换到g盘的test目录。
    C:\Users\Administrator>g:
    G:\>cd test
4. 然后输入下面命令：
    .. literalinclude:: /Tools/res//demo/tools/rst/sphinx-quickstart.txt
         :language: text
         :emphasize-lines: 1,12,20-22,30,54
         :linenos:


.. note::
    注意上面的选项:
        - 如果由rst生成html文档挂在github-page上面，就需要勾选第54行。
        - 如果把文档和其他文件目录分开，第12行就要选 ``y``
        - 第20\-22行设置文档名称和文档作者以及文档版本信息。
        - 第30行设置语言。可以参考第29行对应链接文档查看现在支持的语言种类。这是设置简体中文。


5. 查看创建文档结果

.. code-block:: text
    :linenos:

    G:\test>dir
    驱动器 G 中的卷没有标签。
    卷的序列号是 0004-92C1

    G:\test 的目录

    2018/09/06-周四  下午 09:09    <DIR>          .
    2018/09/06-周四  下午 09:09    <DIR>          ..
    2018/09/06-周四  下午 09:09    <DIR>          build
    2018/09/06-周四  下午 09:09               813 make.bat
    2018/09/06-周四  下午 09:09               606 Makefile
    2018/09/06-周四  下午 09:09    <DIR>          source
                2 个文件          1,419 字节
                4 个目录 213,576,433,664 可用字节

6. 生成文档说明


.. list-table::
   :widths: 20 60
   :header-rows: 1
   :align: center

   * - **文件目录**
     - **说明**
   * - build
     - 通过rst源文件生成的html文件或者其他格式文件存放位置。
   * - make.bat
     - make命令批处理文件。这样方便人使用管理文档。
   * - Makefile
     - 一个二进制文件。
   * - source
     - rst源文件及配置文件存放路径。这样存放让文档的目录结构更清楚。




修改文档文档项目配置文件
======================================================================================================================================================

配置文件说明
------------------------------------------------------------------------------------------------------------------------------------------------------

通过上面命令及中间选项配置。最后生成的文档的配置文件在 ``G:\test\source`` 下，文件名 ``conf.py``

配置文件配置说明：
    - http://www.sphinx-doc.org/en/master/usage/configuration.html


常用配置说明
------------------------------------------------------------------------------------------------------------------------------------------------------

以下这些配置都是在 ``conf.py`` 文件中的配置信息。

1. 配置文档主题

修改之前配置信息：

.. code-block:: python
    :linenos:
    
    html_theme = 'alabaster'

修改之后的配置信息：

.. code-block:: python
    :linenos:
    
    #html_theme = 'alabaster'
    html_theme = 'sphinx_rtd_theme'

2. 配置主页右上角显示源码(设置不显示源码)

修改之前配置文件中没有 ``html_show_sourcelink`` 对应的配置，即默认为True。

修改之后的配置信息(即新增一行)：

.. code-block:: python
    :linenos:
    
    html_show_sourcelink = False

3. 配置显示页脚的sphinx版本等信息

默认显示页脚信息。配置中默认没有 ``html_show_sphinx`` 对应配置信息，即默认为True。

修改之后(增加一行)：

.. code-block:: python
    :linenos:
    
    html_show_sphinx = False

4. 配置显示文档版本信息

修改之前配置文件中没有 ``html_show_copyright`` 对应的配置，即默认为False。

修改之后的配置信息(即新增一行)：

.. code-block:: python
    :linenos:
    
    html_show_copyright = True

5. 配置logo信息

修改后logo配置：

.. code-block:: python
    :linenos:
    
    html_logo = './images/logo-wordmark-light.svg'



conf.py 配置详解 [1]_
======================================================================================================================================================

如果指定1.4.8版本 [2]_ 配置也基本类似不变。



生成html文件
======================================================================================================================================================

**生成html文件：**

.. tip::

    下面生成的html文件在 ``test/build/html`` 目录。

.. code-block:: text
    :linenos:

    G:\test>make html
    Running Sphinx v1.7.9
    loading translations [zh_CN]... done
    making output directory...
    loading pickled environment... not yet created
    building [mo]: targets for 0 po files that are out of date
    building [html]: targets for 1 source files that are out of date
    updating environment: 1 added, 0 changed, 0 removed
    reading sources... [100%] index
    looking for now-outdated files... none found
    pickling environment... done
    checking consistency... done
    preparing documents... done
    writing output... [100%] index
    generating indices... genindex
    writing additional pages... search
    copying static files... done
    copying extra files... done
    dumping search index in English (code: en) ... done
    dumping object inventory... done
    build succeeded.

    The HTML pages are in build\html.

.. tip::
    一般生成html文件总会提示一些错误。然后还要需要根据这个错误修改对应的文件。
    所以在window系统的命令提示符界面可以输入 `` make html 2>err.txt``
    这样就可以把所有的错误信息都重定向输出到err.txt文件。然后打开err.txt文件根据这个文件的错误提示信息修改对应的文件即可。
    

make命令详解
======================================================================================================================================================

.. code-block:: text
    :linenos:

    Please use `make target' where target is one of`
    html        to make standalone HTML files，通过源文件生成表中html文件
    dirhtml     to make HTML files named index.html in directories
    singlehtml  to make a single large HTML file，生成一个大的html文件
    pickle      to make pickle files，生成pickle文件
    json        to make JSON files，生成json文件
    htmlhelp    to make HTML files and an HTML help project，生成html文件和一个html帮助工程
    qthelp      to make HTML files and a qthelp project，生成html文件和qt帮助工程
    devhelp     to make HTML files and a Devhelp project，生成html文件和dev帮助工程
    epub        to make an epub，生成epub文档
    latex       to make LaTeX files, you can set PAPER=a4 or PAPER=letter，生成pdf文档
    text        to make text files，生成txt文档
    man         to make manual pages，生成Unix的man格式文档
    texinfo     to make Texinfo files，生成
    gettext     to make PO message catalogs
    changes     to make an overview of all changed/added/deprecated items
    xml         to make Docutils-native XML files
    pseudoxml   to make pseudoxml-XML files for display purposes
    linkcheck   to check all external links for integrity
    doctest     to run all doctests embedded in the documentation (if enabled)
    coverage    to run coverage check of the documentation (if enabled)




.. [1] :http://www.sphinx-doc.org/en/stable/config.html
.. [2] :http://www.sphinx-doc.org/en/1.4.8/config.html#build-config
