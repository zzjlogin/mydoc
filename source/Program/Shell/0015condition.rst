

======================================================================================================================================================
Shell各种条件判断
======================================================================================================================================================

.. contents::






分支(if)
======================================================================================================================================================

.. rubric:: 分支语句语法：



.. literalinclude:: /Program/res/demo/program/shell/shell-demo.sh
    :linenos:
    :lines: 110-131

- 作用

控制Shell脚本执行的过程。并通过条件来控制哪些命令在哪些情况执行。

这样可以使shell脚本的逻辑更清楚。

- 样例

.. literalinclude:: /Program/res/demo/program/shell/shell-demo.sh
    :linenos:
    :lines: 212-250
    :language: bash

.. _cmd-compare:

參考比较方法
------------------------------------------------------------------------------------------------------------------------------------------------------

.. literalinclude:: /Program/res/demo/program/shell/shell-demo.sh
    :linenos:
    :lines: 135-208
    :language: bash

for循环
======================================================================================================================================================


for的命令使用

.. code-block:: bash
    :linenos:
    :emphasize-lines: 2,3

    [root@centos6-zzjlogin ~]# help for
    for: for NAME [in WORDS ... ] ; do COMMANDS; done
        Execute commands for each member in a list.
        
        The 'for' loop executes a sequence of commands for each member in a
        list of items.  If `in WORDS ...;' is not present, then `in "$@"' is
        assumed.  For each element in WORDS, NAME is set to that element, and
        the COMMANDS are executed.
        
        Exit Status:
        Returns the status of the last command executed.
    for ((: for (( exp1; exp2; exp3 )); do COMMANDS; done
        Arithmetic for loop.
        
        Equivalent to
            (( EXP1 ))
            while (( EXP2 )); do
                COMMANDS
                (( EXP3 ))
            done
        EXP1, EXP2, and EXP3 are arithmetic expressions.  If any expression is
        omitted, it behaves as if it evaluates to 1.
        
        Exit Status:
        Returns the status of the last command executed.


bash风格： 

.. code-block:: bash
    :linenos:

    #!/bin/bash 
    declare -i sum=0
    for i in `seq 1 10` ; do 
        sum+=$i
    done
    echo $sum

.. attention:: 这个方案是bash风格的for语句，变量的引用都要使用$的。

c风格:

.. code-block:: bash
    :linenos:

    #!/bin/bash 
    declare -i sum=0
    for ((i=0; i<=10; i++)); do  
        sum+=i
    done
    echo $sum

.. attention:: 这个风格是c语句风格的，变量不需要$的。


常用实例：

循环制定次数(例如10)，输出指定内容：

.. code-block:: bash
    :linenos:

    [root@centos6 ~]# for((i=1;i<10;i++));do echo $i;done
    1
    2
    3
    4
    5
    6
    7
    8
    9

    [root@centos6 ~]# for i in `seq 1 10`;do echo $i;done                     
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10



while循环
======================================================================================================================================================

while的命令使用

.. code-block:: bash
    :linenos:
    :emphasize-lines: 2,3

    [root@centos6-zzjlogin ~]# help while
    while: while COMMANDS; do COMMANDS; done
        Execute commands as long as a test succeeds.
        
        Expand and execute COMMANDS as long as the final command in the
        'while' COMMANDS has an exit status of zero.
        
        Exit Status:
        Returns the status of the last command executed.



样例1： 

.. code-block:: bash
    :linenos:

    #!/bin/bash 
    declare -i sum=0
    declare -i i=0
    while [ $i -le 10 ]  ; do
            sum+=$i
            i=$[i+1]
    done
    echo $sum

样例2： 

.. code-block:: bash
    :linenos:

    [root@centos6-zzjlogin test]$ vim person.txt 
    [root@centos6-zzjlogin test]$ cat person.txt 
    zhaojiedi 23 
    liming 24
    xiaojia 18
    [root@centos6-zzjlogin test]$ cat while2.sh 
    #!/bin/bash 


    while read name age ; do 
        echo "name is $name, age is $age"
    done < person.txt
    [root@centos6-zzjlogin test]$ bash while2.sh 
    name is zhaojiedi, age is 23
    name is liming, age is 24
    name is xiaojia, age is 18

until
======================================================================================================================================================

until 的命令使用

.. code-block:: bash
    :linenos:

    [root@centos6-zzjlogin test]$ help until
    until: until COMMANDS; do COMMANDS; done

样例： 

.. code-block:: bash
    :linenos:

    #!/bin/bash 
    declare -i sum=0
    declare -i i=10
    until [ $i -lt 0 ]  ; do
            sum+=$i
            i=$[i-1]
    done
    echo $sum

.. attention:: while是判断条件为true才继续。而until相反。

case条件判断
======================================================================================================================================================


case的命令使用

.. code-block:: bash
    :linenos:

    [root@centos6-zzjlogin etc]$ help case
    case: case WORD in [PATTERN [| PATTERN]...) COMMANDS ;;]... esac

样例： 

.. code-block:: bash
    :linenos:

    [root@centos6-zzjlogin test]$ cat case.sh 
    #!/bin/bash

    case $1 in 

    a|b|c)
        echo "you enter (a|b|c)" 
        ;;
    d|e|f)
        echo "you enter (d|e|f)" 
        ;;
    *)
        echo " other char"
        ;;
    esac

调用

.. code-block:: bash
    :linenos:

    [root@centos6-zzjlogin test]$ ./case.sh 2
    other char
    [root@centos6-zzjlogin test]$ ./case.sh a
    you enter (a|b|c)
    [root@centos6-zzjlogin test]$ ./case.sh d
    you enter (d|e|f)


select
======================================================================================================================================================


select的命令使用

.. code-block:: bash
    :linenos:

    [root@centos6-zzjlogin test]$ help select
    select: select NAME [in WORDS ... ;] do COMMANDS; done

样例： 

.. code-block:: bash
    :linenos:

    select c in yes no ; do
            echo " you enter is $c"
            case $c in
                    yes)
                            echo "yes";;
                    no)
                            echo "no";;
                    *)
                            echo "other";;
            esac
    done

.. attention:: select是不同与case的，内置有死循环的。

