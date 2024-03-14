

.. _program_openproject_build:

======================================================================================================================================================
编译C++开源库
======================================================================================================================================================


libxml2
======================================================================================================================================================


1. libxml2 下载路径：https://gitlab.gnome.org/GNOME/libxml2/

2. 开始菜单运行cmd

3. 找到当前vs2017环境的 ``vcvars32.bat`` ,一般目录：C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build

4. 切换目录,执行脚本

::

    cd /d C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build
    
    vcvars32.bat


5.返回代码路径执行(默认D盘根目录解压)

6.编译，编译release版，如果编译debug版修改命令中 ``debug=no`` 改成 ``debug=yes``

::

    cscript configure.js compiler=msvc iconv=no prefix=D:\libxml2 include=D:\libxml2\include lib=D:\libxml2\lib debug=no

    nmake /f Makefile.msvc install


