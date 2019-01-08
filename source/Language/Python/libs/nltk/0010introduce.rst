.. _python-nlp-index:

==============================================================
NLTK库简介
==============================================================



:Date: 2018-11

.. contents::


NLP及NLTK说明
==============================================================

NPL
    - Natural Language Processing，简写NPL。即自然语言处理。
    - NPL关注的问题是自然语言和计算机的交互。
    - NPL是人工智能（Artificial Intelligence，AI）和计算语言学的主要分支之一。

NLTK
    - NLTK：由宾夕法尼亚大学计算机和信息科学系的 **Steven Bird** 和 **Edward Loper** 开发。
    - NLTK是一个开源的项目，包含：Python模块，数据集和教程，用于NLP的研究和开发
    - NLTK在用 Python 处理自然语言的工具中处于领先的地位。
    - NLTK提供了 WordNet 这种方便处理词汇资源的接口，还有分类、分词、除茎、标注、语法分析、语义推理等类库。

NLTK及NLP参考资料
==============================================================

NLTK库相关参考：
    - NLTK源码：https://github.com/stevenbird/nltk
    - NLTK文档：http://www.nltk.org/

NLP参考：
    - NPL百度百科：https://baike.baidu.com/item/nlp/25220?fr=aladdin
    - NPL维基百科：https://en.wikipedia.org/wiki/Natural_language_processing


首先介绍一下Python的自然语言处理工具包：
    NLTK工具包
        NLTK 在用 Python 处理自然语言的工具中处于领先的地位。它提供了 WordNet 这种方便处理词汇资源的接口，还有分类、分词、除茎、标注、语法分析、语义推理等类库。

    Jieba工具包

    Pattern工具包
        Pattern 工具包包括词性标注工具(Part-Of-Speech Tagger)，N元搜索(n-gram search)，情感分析(sentiment analysis)，WordNet。同时也支持机器学习的向量空间模型，聚类和支持向量机。

    TextBlob
        TextBlob 是一个处理文本数据的 Python 库。提供了一些简单的api解决一些自然语言处理的任务，例如词性标注、名词短语抽取、情感分析、分类、翻译等等。

    Gensim
        Gensim 提供了对大型语料库的主题建模、文件索引、相似度检索的功能。它可以处理大于RAM内存的数据，作者说它是“实现无干预从纯文本语义建模的最强大、最高效、最无障碍的软件”。

    PyNLPI
        Python自然语言处理库（Python Natural Language Processing Library，音发作: pineapple） 这是一个各种自然语言处理任务的集合，PyNLPI可以用来处理N元搜索，计算频率表和分布，建立语言模型。他还可以处理向优先队列这种更加复杂的数据结构，或者像 Beam 搜索这种更加复杂的算法。

    spaCy
        spaCy是一个商业的开源软件，结合Python和Cython，自然语言处理能力达到了工业强度。是领域内速度最快、最先进的自然语言处理工具。

    Polyglot
        Polyglot 支持对海量文本和多语言的处理。它支持对165种语言的分词，对196种语言的辨识，40种语言的专有名词识别，16种语言的词性标注，136种语言的情感分析，137种语言的嵌入，135种语言的形态分析，以及69中语言的翻译。

    MontyLingua（英文）
        MontyLingua 是一个自由的、训练有素的、端到端的英文处理工具。输入原始英文文本到 MontyLingua ，就会得到这段文本的语义解释。适合用来进行信息检索和提取，问题处理，回答问题等任务。从英文文本中，它能提取出主动宾元组，形容词、名词和动词短语，人名、地名、事件，日期和时间等语义信息。

    BLLIP Parser
        BLLIP Parser（也叫做Charniak-Johnson parser）是一个集成了产生成分分析和最大熵排序的统计自然语言工具。包括 命令行 和 python接口 。

    Quepy
        - Quepy是一个Python框架，提供将自然语言转换成为数据库查询语言，可以轻松地实现不同类型的自然语言和数据库查询语言的转化。所以，通过Quepy，仅仅修改几行代码，就可以实现你自己的自然语言查询数据库系统。 
        - GitHub:https://github.com/machinalis/quepy

    HanNLP
        HanLP是一个致力于向生产环境普及NLP技术的开源Java工具包，支持中文分词（N-最短路分词、CRF分词、索引分词、用户自定义词典、词性标注），命名实体识别（中国人名、音译人名、日本人名、地名、实体机构名识别），关键词提取，自动摘要，短语提取，拼音转换，简繁转换，文本推荐，依存句法分析（MaxEnt依存句法分析、神经网络依存句法分析）。 




NLTK技术
==============================================================

NLTK库安装
    - 查看是否安装nltk库： ``pip list|grep nltk``
    - 安装nltk库： ``pip install nltk`` 或者安装指定版本： ``pip install nltk==3.4``






