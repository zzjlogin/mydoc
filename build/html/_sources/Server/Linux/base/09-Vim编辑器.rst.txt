
=================================================
Vim编辑器
=================================================

:Date: 2018-09-02

.. contents::

Vim有3种模式

- 编辑模式
- 输入模式
- 末行模式



模式转化
=================================================

.. code-block:: bash
    :linenos:

    输入模式--> 末行模式： ESC
    编辑模式--> 输入模式： 
                            a
                            A
                            o
                            O
                            i
                            I
    编辑模式--> 末行模式：ESC
    末行模式--> 编辑模式：ESC

退出文件
=================================================

.. code-block:: bash
    :linenos:

    :q                  退出
    :w                  保存
    :wq                 保存退出
    :x                  保存退出
    :wq!                保存退出
    :w new_file_path    保存到指定的文件

光标移动
=================================================

.. code-block:: bash
    :linenos:

    字符间移动
    h               
    l
    j
    k

    单词之间移动
    w
    e
    b

    行内移动
    ^
    0
    $

    句子内移动
    (
    )

    段落内移动
    {
    }

    行间移动
    #G
    G
    gg

Vim的编辑命令
=================================================

.. code-block:: bash
    :linenos:

    x               删除所在位置字符
    #x              删除后续几个字符
    d               删除命令，配合移动字符
    dd              删除行
    p               粘贴
    y               复制
    Y               复制当前行
    c               修改，配合移动字符
    u               撤销之前操作

Vim可视化模式
=================================================

.. code-block:: bash
    :linenos:

    v               光标走过的字符
    V               光标走过的行

翻屏操作
=================================================

.. code-block:: bash
    :linenos:

    ctrl+f              文件尾部翻一屏
    ctrl+b              文件首部翻1屏
    ctrl+d              文件尾部翻半屏
    ctrl+u              文件首部翻半屏

Vim末行模式
=================================================

内容定界
-------------------------------------------------------------------------------------

startpos,endpos

.. code-block:: bash
    :linenos:

    #               第#行
    #,#             第#到第#行
    .               当前行
    $               最后一行
    %               全文

查找
-------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    /pathern           正向查找
    ?                  反向查找

查找并替换
-------------------------------------------------------------------------------------

s/查找模式/要替换的内容/修饰符

修饰符：

- i         忽略大小写
- g         全局替换

多文件模式
=================================================

.. code-block:: bash
    :linenos:

    :next               下一个文档
    :previous           前一个文档
    :last               最后一个文档
    :first              第一个文档
    :waall              保存所有

窗口属性设置
=================================================

.. code-block:: bash
    :linenos:

    :set nu             显示行号
    :set nonu           关闭行号显示
    :set ai             打开智能提示
    :set noai           关闭智能提示
    :set ic             忽略大小写       
    :set noic           关闭忽略大小写
    :set sm             括号匹配
    :set nosm           关闭括号匹配
    :syntax on          语法高亮
    :syntax off         语法高亮关闭
    :set hlsearch       高亮搜索
    :set nohlsearch     关闭高亮搜索


vi打开文件即显示行号
=================================================

CentOS6在用户家目录创建一个.vimrc文件，然后把``set nu``追加到这个文件即可。然后打开文件就会自动添加行号，
如果不想显示行号，在命令模式输入:set nonu

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# ll .vimrc
    ls: cannot access .vimrc: No such file or directory
    [root@zzjlogin ~]# echo 'set nu'>> .vimrc
    [root@zzjlogin ~]# ll .vimrc             
    -rw-r--r--. 1 root root 7 Apr 18 19:13 .vimrc


vi打开文件tab用4个空格替换
=================================================

在用户家目录的.vimrc文件添加内容：

set ts=4
set expandtab

则可以在vi打开文件后插入模式下输入tab键，会用4个空格代替这个制表符。

对于已保存的文件，可以使用下面的方法进行空格和TAB的替换：

TAB替换为空格：
    :set ts=4
    :set expandtab
    :%retab!

空格替换为TAB：
    :set ts=4
    :set noexpandtab
    :%retab!

[root@zzjlogin ~]# echo "set ts=4">>.vimrc
[root@zzjlogin ~]# echo "set expandtab">>.vimrc 

