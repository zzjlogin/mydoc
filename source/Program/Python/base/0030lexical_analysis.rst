.. _python_lexical_analysis:

======================================================================================================================================================
基本语法结构
======================================================================================================================================================

.. contents::


行结构
======================================================================================================================================================

行末尾结束符
------------------------------------------------------------------------------------------------------------------------------------------------------

在嵌入Python时，应该使用C约定换行符的标准将源代码字符串传递给Python api
(代表ASCII LF的\n字符是行终止符)。

注释
======================================================================================================================================================

行末尾注释
------------------------------------------------------------------------------------------------------------------------------------------------------

字符 ``#`` 后面的字符都是注释。

文档注释
------------------------------------------------------------------------------------------------------------------------------------------------------

在函数/类名下面一行或者模块开始的用三个单引号包裹的字符串信息 ``'''xxx'''`` 。

编码
======================================================================================================================================================

python3时代码文件默认编码是UTF-8。

这是 PEP3120 规定的。可以参考：
    - https://www.python.org/dev/peps/pep-3120/


关键字
======================================================================================================================================================

.. sourcecode:: text

   False      await      else       import     pass
   None       break      except     in         raise
   True       class      finally    is         return
   and        continue   for        lambda     try
   as         def        from       nonlocal   while
   assert     del        global     not        with
   async      elif       if         or         yield


前缀说明
======================================================================================================================================================

字符串前缀
------------------------------------------------------------------------------------------------------------------------------------------------------


下面是创建字符串可以使用的前缀：

.. productionlist::
   stringliteral: [`stringprefix`](`shortstring` | `longstring`)
   stringprefix: "r" | "u" | "R" | "U" | "f" | "F"
               : | "fr" | "Fr" | "fR" | "FR" | "rf" | "rF" | "Rf" | "RF"
   shortstring: "'" `shortstringitem`* "'" | '"' `shortstringitem`* '"'
   longstring: "'''" `longstringitem`* "'''" | '"""' `longstringitem`* '"""'
   shortstringitem: `shortstringchar` | `stringescapeseq`
   longstringitem: `longstringchar` | `stringescapeseq`
   shortstringchar: <any source character except "\" or newline or the quote>
   longstringchar: <any source character except "\">
   stringescapeseq: "\" <any source character>

下面是创建字节类型字符串使用的前缀：

.. productionlist::
   bytesliteral: `bytesprefix`(`shortbytes` | `longbytes`)
   bytesprefix: "b" | "B" | "br" | "Br" | "bR" | "BR" | "rb" | "rB" | "Rb" | "RB"
   shortbytes: "'" `shortbytesitem`* "'" | '"' `shortbytesitem`* '"'
   longbytes: "'''" `longbytesitem`* "'''" | '"""' `longbytesitem`* '"""'
   shortbytesitem: `shortbyteschar` | `bytesescapeseq`
   longbytesitem: `longbyteschar` | `bytesescapeseq`
   shortbyteschar: <any ASCII character except "\" or newline or the quote>
   longbyteschar: <any ASCII character except "\">
   bytesescapeseq: "\" <any ASCII character>

.. note:: 字节类型字符串的内容只能是ASCII码的字符，否则会报错。

数字前缀
------------------------------------------------------------------------------------------------------------------------------------------------------

二进制、八进制、十进制、十六进制的前缀表示：

.. productionlist::
   integer: `decinteger` | `bininteger` | `octinteger` | `hexinteger`
   decinteger: `nonzerodigit` (["_"] `digit`)* | "0"+ (["_"] "0")*
   bininteger: "0" ("b" | "B") (["_"] `bindigit`)+
   octinteger: "0" ("o" | "O") (["_"] `octdigit`)+
   hexinteger: "0" ("x" | "X") (["_"] `hexdigit`)+
   nonzerodigit: "1"..."9"
   digit: "0"..."9"
   bindigit: "0" | "1"
   octdigit: "0"..."7"
   hexdigit: `digit` | "a"..."f" | "A"..."F"

浮点数表示：

.. productionlist::
   floatnumber: `pointfloat` | `exponentfloat`
   pointfloat: [`digitpart`] `fraction` | `digitpart` "."
   exponentfloat: (`digitpart` | `pointfloat`) `exponent`
   digitpart: `digit` (["_"] `digit`)*
   fraction: "." `digitpart`
   exponent: ("e" | "E") ["+" | "-"] `digitpart`

复数虚部表示：

.. productionlist::
   imagnumber: (`floatnumber` | `digitpart`) ("j" | "J")



正则表达式前缀
------------------------------------------------------------------------------------------------------------------------------------------------------

.. versionadded:: 3.6

.. productionlist::
   f_string: (`literal_char` | "{{" | "}}" | `replacement_field`)*
   replacement_field: "{" `f_expression` ["!" `conversion`] [":" `format_spec`] "}"
   f_expression: (`conditional_expression` | "*" `or_expr`)
               :   ("," `conditional_expression` | "," "*" `or_expr`)* [","]
               : | `yield_expression`
   conversion: "s" | "r" | "a"
   format_spec: (`literal_char` | NULL | `replacement_field`)*
   literal_char: <any code point except "{", "}" or NULL>


各种符号
======================================================================================================================================================

操作符
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: none


   +       -       *       **      /       //      %      @
   <<      >>      &       |       ^       ~
   <       >       <=      >=      ==      !=




分隔符
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: none

   (       )       [       ]       {       }
   ,       :       .       ;       @       =       ->
   +=      -=      *=      /=      //=     %=      @=
   &=      |=      ^=      >>=     <<=     **=

特殊符号
------------------------------------------------------------------------------------------------------------------------------------------------------


下列打印ASCII字符作为其他标记的一部分具有特殊意义，或对词法分析器具有其他重要意义:

.. code-block:: none

   '       "       #       \

不会使用的符号
------------------------------------------------------------------------------------------------------------------------------------------------------

使用下面符号会报错

.. code-block:: none

   $       ?    
