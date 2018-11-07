==========
这个文档相关
==========
----

环境准备
--------

**1.Python2.7.13 虚拟环境(virtualenv)**

Windows Python虚拟环境安装：
    pip install virtualenv
Windows Python虚拟环境创建：
    virtualenv venv
进入/启动Python虚拟环境：
    venv/bin/activate
退出Python虚拟环境：
    deactivate

**2.sphinx和所需第三方包安装：**
    pip install sphinx sphinx-autobuild sphinx_rtd_theme

文档创建过程：
-----------

.. code-block:: bash

    (venv) E:\LocalCode\python\mydoc>sphinx-quickstart
    Welcome to the Sphinx 1.7.6 quickstart utility.

    Please enter values for the following settings (just press Enter to
    accept a default value, if one is given in brackets).

    Selected root path: .

    You have two options for placing the build directory for Sphinx output.
    Either, you use a directory "_build" within the root path, or you separate
    "source" and "build" directories within the root path.
    > Separate source and build directories (y/n) [n]: y <--这个选项勾选后可以生成source目录。否则在根目录生成源文件

    Inside the root directory, two more directories will be created; "_templates"
    for custom HTML templates and "_static" for custom stylesheets and other static
    files. You can enter another prefix (such as ".") to replace the underscore.
    > Name prefix for templates and static dir [_]:

    The project name will occur in several places in the built documentation.
    > Project name: mydoc       <----工程名字
    > Author name(s): zzjlogin  <----文档作者名字
    > Project release []: 1.0   <----文档显示版本信息

    If the documents are to be written in a language other than English,
    you can select a language here by its language code. Sphinx will then
    translate text that it generates into that language.

    For a list of supported codes, see
    http://sphinx-doc.org/config.html#confval-language.
    > Project language [en]: zh_CN  <----选择语言。默认英语，设置zh_CN中文。但是现在还不支持。可以这样配置方便以后升级

    The file name suffix for source files. Commonly, this is either ".txt"
    or ".rst".  Only files with this suffix are considered documents.
    > Source file suffix [.rst]:

    One document is special in that it is considered the top node of the
    "contents tree", that is, it is the root of the hierarchical structure
    of the documents. Normally, this is "index", but if your "index"
    document is a custom template, you can also set this to another filename.
    > Name of your master document (without suffix) [index]:

    Sphinx can also add configuration for epub output:
    > Do you want to use the epub builder (y/n) [n]:
    Indicate which of the following Sphinx extensions should be enabled:
    > autodoc: automatically insert docstrings from modules (y/n) [n]:
    > doctest: automatically test code snippets in doctest blocks (y/n) [n]:
    > intersphinx: link between Sphinx documentation of different projects (y/n) [n]
    :
    > todo: write "todo" entries that can be shown or hidden on build (y/n) [n]:
    > coverage: checks for documentation coverage (y/n) [n]:
    > imgmath: include math, rendered as PNG or SVG images (y/n) [n]:
    > mathjax: include math, rendered in the browser by MathJax (y/n) [n]:
    > ifconfig: conditional inclusion of content based on config values (y/n) [n]:
    > viewcode: include links to the source code of documented Python objects (y/n)
    [n]:
    > githubpages: create .nojekyll file to publish the document on GitHub pages (y/
    n) [n]:

    A Makefile and a Windows command file can be generated for you so that you
    only have to run e.g. `make html' instead of invoking sphinx-build`
    directly.
    > Create Makefile? (y/n) [y]:
    > Create Windows command file? (y/n) [y]:

    Creating file .\source\conf.py.
    Creating file .\source\index.rst.
    Creating file .\Makefile.
    Creating file .\make.bat.

    Finished: An initial directory structure has been created.

    You should now populate your master file .\source\index.rst and create other doc
    umentation
    source files. Use the Makefile to build the docs, like so:
       make builder
    where "builder" is one of the supported builders, e.g. html, latex or linkcheck.


----

配置：
-----------

**修改文件source/conf.py，把**

.. code-block:: python

    原来内容：html_theme = 'alabaster'
    换成新的主题：html_theme = 'sphinx_rtd_theme'

----

文档创建和生成html文件：
-------------------

* 创建rst文件
    rst文件即：reStructuredText

    在source目录下创建文件后缀为rst的文件。然后按照对应的rst语法填写内容即可。

* 生成html文件：
    - 在source的上一级目录打开cmd。然后输入命令：``make html``
    - 建议使用 ``make html 2>err.txt``




