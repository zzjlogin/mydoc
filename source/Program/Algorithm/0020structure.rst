
======================================================================================================================================================
数据结构简述
======================================================================================================================================================

:Date: 2018-08-29

.. contents::


数据结构和算法
======================================================================================================================================================

衡量算法好坏的标准：
    - 正确性、可读性、健壮性、时间复杂度、空间复杂度

数据结构与算法关系：
    - 程序=数据结构+算法
    - 数据结构是底层，算法高层
    - 数据结构为算法提供服务
    - 算法围绕数据结构操作

数据结构特点：
    - 每种数据结构都具有自己的特点。
    - 例如：队列：先进先出。栈：先进后出
算法的特性：
    - 算法具有五个基本特征
    - 输入、输出、有穷性、确定性和可行性
存储结构：
    - 逻辑数据结构的实现。存储结构通过计算机语言实现。
    - 例如：堆数据结构，堆是一棵完全二叉树，所以适宜采用顺序存储结构（顺序存储：数组），这样能够充分利用存储空间。
数据结构实现：
    - 数据结构（逻辑数据结构）通过计算机语言来实现数据结构（存储数据结构）。
    - 例如：树型数据结构：通过计算机语言中的数组（节点）和指针（指向父节点）来实现。
算法目的：
    - 算法是为数据结构服务。
    - 例如：数据结构通常伴随有查找算法、排序算法等
解决问题（算法）需要选择正确的数据结构。
    - 例如：算法中经常需要对数据进行增加和删除用链表数据结构效率高，数组数据结构因为增加和删除需要移动数字每个元素所有效率低。


数据逻辑结构和存储结构
======================================================================================================================================================


逻辑结构
------------------------------------------------------------------------------------------------------------------------------------------------------

一般逻辑结构常见的有以下几种：
    - 集合：无序的
    - 线性结构：是一次链接，每个相邻元素是有关系的。(例如：1-2-3，如果把这个看作一个线性结构，关系是1+1=2,2+1=3)
    - 树形结构：类似于族谱的树形结构。
    - 图装(网状)结构：类似于我们的关系网，每个人都与多个人有关系。

存储结构
------------------------------------------------------------------------------------------------------------------------------------------------------

常见的存储结构有：
    - 顺序存储：数据元素依次存储，在物理上相邻，这样的关系是我们最容易理解的。
    - 链式存储：这种结构每个元素需要除了数据块还要有一个类似C语言指针的数据头来保证这个元素和下一个元素的关联性。
    - 索引存储：
    - 哈希(散列)存储：通过特定哈希函数把元素映射到对应地址，这样方便查找和存储。




