
.. _security.googlehacking:

======================================================================================================================================================
GoogleHacking
======================================================================================================================================================


:Date: 2019-3

.. contents::

Google高级搜索
======================================================================================================================================================

关键词搜索方法
------------------------------------------------------------------------------------------------------------------------------------------------------

默认模糊搜索
    - 谷歌默认进行模糊搜索，并能对长短语或语句进行自动拆分成小的词进行搜索。

短语精确搜索
    - 给关键词加上半角引号实现精确搜索，不进行分词。
    - 例如： **"渗透测试"**

通配符
    - 谷歌的通配符是星号 ``*``
    - 必须在精确搜索符双引号内部使用。
    -用通配符代替关键词或短语中无法确定的字词。
    - 示例： ``"kali * web渗透测试"``

点号匹配任意字符
    - 与通配符星号 ``*`` 不一样的是，点号 ``.`` 匹配的是字符，不是字、短语等内容。
    - 保留的字符有 ``[`` 、 ``(`` 、 ``-`` 等。
    - 示例： **"黑客.渗透测试"**

逻辑与
    - 多个词间的逻辑关系默认的是逻辑与（空格）。当用逻辑算符的时候，词与逻辑算符之间用需要空格分隔，包括后面讲的各种语法，均要有空格。
    - 示例： **渗透测试 AND XX的博客**
逻辑或
    - 示例： **XX的博客" (kali | node)**
逻辑非
    - 逻辑非用 ``-`` 表示。
    - 示例： **"XX的博客" -kali**
约束条件精确搜索
    - 加号 ``+`` 用于强制搜索，即必须包含加号后的内容。一般与精确搜索符一起应用。
    - 示例： **"博客" +"愚蠢的人类"**
数字范围
    - 用两个点号 ``..`` 表示一个数字范围。
    - 一般应用于日期、货币、尺寸、重量、高度等范围的搜索。用作范围时最好给一定的含义。
    - 示例： **kali linux 2010年..2014年**
括号分组
    - 逻辑组配时分组，避免逻辑混乱。括号“()”是分组符号。




内置关键词使用
------------------------------------------------------------------------------------------------------------------------------------------------------


intitle
    - 表示搜索在网页标题中出现第一个关键词的网页。
    - 例如：“intitle:黑客技术”将返回在标题中出现”黑客技术 “的所有链接。
    - 用“allintitle: 黑客技术 Google”则会返回网页标题中同时含有 “黑客技术” 和 “Google” 的链接。
intext
    - 返回网页的文本中出现关键词的网页。
    - 用allintext:搜索多个关键字。

inurl
    返回的网页链接中包含第一个关键字的网页。

site
    在某个限定的网站中搜索。

filetype
    - 搜索特定扩展名的文件（如.doc .pdf .ppt）。黑客们往往会关注特定的文件
    - 例如：.pwl口令文件、.tmp临时文件、.cfg配置文件、.ini系统文件、.hlp帮助文件、.dat数据文件、.log日志文件、.par交换文件等。

link
    表示返回所有链接到某个地址的网页。

related
    返回连接到类似于指定网站的网页。

cache
    搜索Google缓存中的网页。

info
    表示搜索网站的摘要。例如”info:whu.edu.cn”仅得到一个结果：

phonebook
    - 搜索电话号码簿，将会返回美国街道地址和电话号码列表,这无疑给挖掘个人信息的黑客带来极大的便利。同时还可以得到住宅的全面信息，
    - 结合Google earth将会得到更详细的信息。
    - 相应的还有更小的分类搜索：
        - rphonebook:仅搜索住宅用户电话号码簿；
        - bphonebook:仅搜索商业的电话号码簿。

author
    搜索新闻组帖子的作者。

group
    搜索Google组搜索词汇帖子的题目。

msgid
    搜索识别新闻组帖子的Google组信息标识符和字符串。

insubject
    搜索Google组的标题行。

stocks
    搜索有关一家公司的股票市场信息。

define
    返回一个搜索词汇的定义。

inanchor
    搜索一个HTML标记中的一个链接的文本表现形式。

daterange
    搜索某个日期范围内Google做索引的网页。


Googl Hacking常见的攻击规律
======================================================================================================================================================

Index of
------------------------------------------------------------------------------------------------------------------------------------------------------

``Index of`` 语法检索出站点的活动索引目录
    - Index 就是主页服务器所进行操作的一个索引目录。黑客们常利用目录获取密码文件和其他安全文件。常用的攻击语法如下：
    - Index of /admin 可以挖掘到安全意识不强的管理员的机密文件：
    - 黑客往往可以快速地提取他所要的信息其他Index of 语法列表如下：

.. code-block:: text
    :linenos:
    
    Index of /passwd
    Index of /password
    Index of /mail
    Index of / +passwd
    Index of / +password.txt
    Index of / +.htaccess
    Index of /secret
    Index of /confidential
    Index of /root
    Index of /cgi-bin
    Index of /credit-card
    Index of /logs
    Index of /config

inurl
------------------------------------------------------------------------------------------------------------------------------------------------------


利用 ``inurl:`` 寻找易攻击的站点和服务器

allinurl:winnt/system32/
    寻找受限目录 **system32** ，一旦具备 **cmd.exe** 执行权限，就可以控制远程的服务器。

allinurl:wwwboard/passwd.txt
    搜寻易受攻击的服务器。

inurl:.bash_history
    搜寻服务器的 **.bash_history** 文件。这个文件包括超级管理员的执行命令，甚至一些敏感信息，如管理员口令序列等。例如：

inurl:config.txt
    搜寻服务器的 **config.txt** 文件，这个文件包括管理员密码和数据认证签名的hash值。

- 其他语法的搜索
    * ``inurl:admin filetype:txt``
    * ``inurl:admin filetype:db``
    * ``inurl:admin filetype:cfg``
    * ``inurl:mysql filetype:cfg``
    * ``inurl:passwd filetype:txt``
    * ``inurl:iisadmin``
    * ``allinurl:/scripts/cart32.exe``
    * ``allinurl:/CuteNews/show_archives.php``
    * ``allinurl:/phpinfo.php``
    * ``allinurl:/privmsg.php``
    * ``allinurl:/privmsg.php``
    * ``inurl:auth_user_file.txt``
    * ``inurl:orders.txt``
    * ``inurl:”wwwroot/*.”``
    * ``inurl:adpassword.txt``
    * ``inurl:webeditor.php``
    * ``inurl:file_upload.php``
    * ``inurl:gov filetype:xls “restricted”``
    * ``index of ftp +.mdb allinurl:/cgi-bin/ +mailto``




intitle
------------------------------------------------------------------------------------------------------------------------------------------------------

``intitle:`` 寻找易攻击的站点或服务器

``intitle:"php shell*" "Enable stderr" filetype:php``
    查找安装了 **php webshell** 后门的主机，并测试是否有能够直接在机器上执行命令的web shell。（http://worldispnetwork.com/phpinfo.php）

``allintitle:"index of /admin"``
    - 搜寻服务器的受限目录入口 **admin** 。

