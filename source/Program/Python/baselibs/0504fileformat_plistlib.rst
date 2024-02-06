.. _python_plistlib:

======================================================================================================================================================
:mod:`plistlib` --- 文件生成和解析
======================================================================================================================================================

.. contents::

plistlib实例
======================================================================================================================================================




plistlib详解
======================================================================================================================================================


用于读写主要由Mac OS X使用的“属性列表”文件，并支持二进制文件和XML plist文件。

主要的方法是dumps,dump,load,loads,writePlist,readPlist方法。

.. code-block:: python
    :linenos:

    pl = dict(
        aString = "Doodah",
        aList = ["A", "B", 12, 32.1, [1, 2, 3]],
        aFloat = 0.1,
        anInt = 728,
        aDict = dict(
            anotherString = "<hello & hi there!>",
            aThirdString = "M\xe4ssig, Ma\xdf",
            aTrueValue = True,
            aFalseValue = False,
        ),
        someData = b"<binary gunk>",
        someMoreData = b"<lots of binary gunk>" * 10,
        aDate = datetime.datetime.fromtimestamp(time.mktime(time.gmtime())),
    )
    with open(fileName, 'wb') as fp:
        dump(pl, fp)
