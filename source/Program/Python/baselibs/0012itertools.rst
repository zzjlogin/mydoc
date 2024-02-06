
.. _python_itertools:

======================================================================================================================================================
:mod:`itertools` --- 创建迭代器
======================================================================================================================================================



.. contents::

itertools
======================================================================================================================================================


该模块标准化了一套核心的快速、内存有效的工具，它们本身或组合使用都是有用的。

创建迭代器以提高效率(函数式编程模块)

**无限迭代器:**

==================  =================       =================================================               =========================================
Iterator            Arguments               Results                                                         Example
==================  =================       =================================================               =========================================
:func:`count`       start, [step]           start, start+step, start+2*step, ...                            ``count(10) --> 10 11 12 13 14 ...``
:func:`cycle`       p                       p0, p1, ... plast, p0, p1, ...                                  ``cycle('ABCD') --> A B C D A B C D ...``
:func:`repeat`      elem [,n]               elem, elem, elem, ... endlessly or up to n times                ``repeat(10, 3) --> 10 10 10``
==================  =================       =================================================               =========================================

**迭代器终止于最短的输入序列:**

============================    ============================    =================================================   =============================================================
Iterator                        Arguments                       Results                                             Example
============================    ============================    =================================================   =============================================================
:func:`accumulate`              p [,func]                       p0, p0+p1, p0+p1+p2, ...                            ``accumulate([1,2,3,4,5]) --> 1 3 6 10 15``
:func:`chain`                   p, q, ...                       p0, p1, ... plast, q0, q1, ...                      ``chain('ABC', 'DEF') --> A B C D E F``
:func:`chain.from_iterable`     iterable                        p0, p1, ... plast, q0, q1, ...                      ``chain.from_iterable(['ABC', 'DEF']) --> A B C D E F``
:func:`compress`                data, selectors                 (d[0] if s[0]), (d[1] if s[1]), ...                 ``compress('ABCDEF', [1,0,1,0,1,1]) --> A C E F``
:func:`dropwhile`               pred, seq                       seq[n], seq[n+1], starting when pred fails          ``dropwhile(lambda x: x<5, [1,4,6,4,1]) --> 6 4 1``
:func:`filterfalse`             pred, seq                       elements of seq where pred(elem) is false           ``filterfalse(lambda x: x%2, range(10)) --> 0 2 4 6 8``
:func:`groupby`                 iterable[, key]                 sub-iterators grouped by value of key(v)
:func:`islice`                  seq, [start,] stop [, step]     elements from seq[start:stop:step]                  ``islice('ABCDEFG', 2, None) --> C D E F G``
:func:`starmap`                 func, seq                       func(\*seq[0]), func(\*seq[1]), ...                 ``starmap(pow, [(2,5), (3,2), (10,3)]) --> 32 9 1000``
:func:`takewhile`               pred, seq                       seq[0], seq[1], until pred fails                    ``takewhile(lambda x: x<5, [1,4,6,4,1]) --> 1 4``
:func:`tee`                     it, n                           it1, it2, ... itn  splits one iterator into n
:func:`zip_longest`             p, q, ...                       (p[0], q[0]), (p[1], q[1]), ...                     ``zip_longest('ABCD', 'xy', fillvalue='-') --> Ax By C- D-``
============================    ============================    =================================================   =============================================================

**迭代器组合使用:**

==============================================   ====================       =============================================================
Iterator                                         Arguments                  Results
==============================================   ====================       =============================================================
:func:`product`                                  p, q, ... [repeat=1]       cartesian product, equivalent to a nested for-loop
:func:`permutations`                             p[, r]                     r-length tuples, all possible orderings, no repeated elements
:func:`combinations`                             p, r                       r-length tuples, in sorted order, no repeated elements
:func:`combinations_with_replacement`            p, r                       r-length tuples, in sorted order, with repeated elements
``product('ABCD', repeat=2)``                                               ``AA AB AC AD BA BB BC BD CA CB CC CD DA DB DC DD``
``permutations('ABCD', 2)``                                                 ``AB AC AD BA BC BD CA CB CD DA DB DC``
``combinations('ABCD', 2)``                                                 ``AB AC AD BC BD CD``
``combinations_with_replacement('ABCD', 2)``                                ``AA AB AC AD BB BC BD CC CD DD``
==============================================   ====================       =============================================================





