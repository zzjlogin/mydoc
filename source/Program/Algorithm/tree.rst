
======================================================================================================================================================
树(tree)
======================================================================================================================================================

:Date: 2018-08-29

.. contents::

树是一种常用的数据结构，树是图的一种特殊情况。是一种分层次的结构。

日常生活中的树结构：
    - 家谱
    - 叠放起来的碟子

树的使用：
    - 查找
        - 静态查找:数据不变化，查找其中的一个值。
            - 静态查找方法1：顺序查找。(此时存储可以使线性存储/链式存储)此时时间复杂度是O(N)
            - 方法2:二分查找，这就是一种采用树的思想的方法(判定树)。``需要存储是有序的，并且放在数组中，如果是列表存储则不能采用二分查找``。时间复杂度是O(logN)
                - 判定树一般最大查找次数时logN+1

        - 动态查找:除了查找之外还随时可能插入/删除数据。

树的定义：
    - 根和不相交的有限子集。
    - 除了根结点，每个结点都只有一个父结点。
    - 子树是不相交的。
    - 树是保证结点联通的最小的连接方式。

    1. 结点的度：结点的子树的个数
    #. 树的度：树所有结点中最大的度
    #. 叶结点：Leaf，度为0的结点。
    #. 父结点:Parent，有子树结点的是其子树根结点的父结点。
    #. 子节点:Child，也叫孩子结点，如果A是B的父结点，那么B是A的子结点。
    #. 兄弟结点:Sibling，具有同一父结点的各个结点彼此是兄弟结点。
    #. 路径和路径长度:从n1到nk的路径位一个结点序列n1，n2...nk，路径所包括的边的个数为路径的长度。
    #. 结点的层次:Level，规定根结点在1层，其他任何一结点是其根结点层次数加1.
    #. 树的深度:Depth，树所有节点中最大层次就是树的深度。

树的表示：

    树可以用链表表示，(因为一个父结点可以有多个子节点，所以一般用孩子兄弟表示法)
        即一个结点一部分存数据，然后两个指针分别指向第一个孩子(默认是最左边的孩子)，和相邻的兄弟。

        通过这种儿子-兄弟表示法的结构旋转一下得来的结构。

二叉树

    二叉树一般分左右子树，一般的树是不分左右的。

    二叉树，有满二叉树、完美二叉树、二叉树这三种。

    - 完美二叉树：也叫满二叉树，每层都是最大的节点数。
    - 完全二叉树:除了最底层都是最大节点数，最底层从左向右没有缺的叶子，则为满二叉树。
    - 二叉树：即普通满足二叉树的

二叉树操作

    - 判断是否为空
    - 遍历二叉树
    - 创建二叉树

    二叉树的遍历方法：
        - 先序：PreOrderTraversal，输出结点内容的顺序：根、左子树、右子树。
        - 中序:InOrderTraversal，输出结点顺序：左子树、根、右子树。
        - 后序：PostOrderTraversal，左子树、右子树、根。
        - 层次遍历：从上到下从左到右的依次输出。

.. note::

    通过先序、中序或者中序、后序可以确定一个树的结构，先序和后序是不能确定二叉树的结构的。


二叉树的存储
    
    顺序存储

        - 完全二叉树：特别适合顺序存储。
            普通的二叉树需要把普通二叉树用空补全达到完全二叉树的结构再存储，这样浪费空间。
        - 非根结点：父亲节点的序号是i/2下届取整。i是当前结点序号。
        - 结点的左孩子结点序号:2i(2i<=n，否则没有左孩子)
        - 右孩子，指定结点序号i，右孩子序号是：2i+1。(2i+1<=n，否则没有右孩子)

    链表(单项链表)

二叉树的遍历

    1. 递归。
    #. 非递归，堆栈实现。
    #. 层次遍历实现：
        - 用队列实现。
            1. 把根结点输入队列。
            2. 从队列输出元素。
            #. 然后把输出元素的左右孩子输入队列输出这个元素
            #. 然后重2-3步骤。


二叉搜索树

    也叫做二叉查找树，二叉搜索树的操作:查找元素、插入元素、删除元素。

    二叉搜索树：是左孩子结点比根结点小，右孩子结点比根结点大，每个子树也是二叉搜索树。

平衡二叉树

    平衡因子，左子树高度减去右子树高度，
    平衡二叉树的左子树高度和右子树高度差小于等于1.

    平衡二叉树插入后如果破坏了原来的平衡结构则需要做对应的调整。
    一般调整分四种：LL左左旋转、RR右右旋转、LR、左右旋转、RL、右左旋转。

哈夫曼树

    最优二叉树

    哈夫曼树的构建：
        把所有元素中最小两个构成二叉树，根为两个元素的权值和，然后再循环这个过程。

        哈夫曼编码：
            解决二义性方法：方法1是等长码，方法二是前缀码。
            所有结点都在叶子上就不会有二义性。否则会有二义性。

