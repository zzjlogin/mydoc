.. _pypinyin-introduce:

======================================================================================================================================================
pypinyin库简介
======================================================================================================================================================



:Date: 2019-3

.. contents::

pypinyin参考
======================================================================================================================================================

源码：
    - https://github.com/mozillazg/python-pinyin
文档：
    - https://pypinyin.readthedocs.io/zh_CN/master/
下载地址：
    - https://pypi.org/project/xpinyin/

pypinyin作用
======================================================================================================================================================


把汉字转换为拼音


样例：

.. code-block:: python
    :linenos:

    >>> import pypinyin
    >>> from pypinyin import pinyin, lazy_pinyin
    >>> lazy_pinyin(u'云浮新兴双线-01')
    [u'yun', u'fu', u'xin', u'xing', u'shuang', u'xian', u'-01']
    >>> ''.join(lazy_pinyin(u'云浮新兴双线-01'))
    u'yunfuxinxingshuangxian-01'
    >>> ''.join(lazy_pinyin(u'云浮新兴双线-01'))+'-'+'61.11.11.11'.split('.')[0]
    u'yunfuxinxingshuangxian-01-61'

.. code-block:: python
    :linenos:

    In [4]: import pypinyin
    In [5]: pypinyin.pinyin(u'重',heteronym=True)
    Out[5]: [['zhòng', 'chóng', 'tóng']]