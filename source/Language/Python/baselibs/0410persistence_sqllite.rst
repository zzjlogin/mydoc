
======================================================================================================================================================
数据持久化
======================================================================================================================================================


sqllite
======================================================================================================================================================

SQLite是一个C库，它提供了一个轻量级的基于磁盘的数据库，它不需要单独的服务器进程，并允许
使用SQL查询语言的非标准变体访问数据库。 一些应用程序可以使用SQLite进行内部数据存储。
也可以使用SQLite对应用程序进行原型设计，然后将代码移植到更大的数据库，如PostgreSQL或Oracle。

这个模块使用起来像我们使用大型数据一样，只是这个数据库比较low而已，没有进程和复杂的数据库管理功能。


样例： 

.. code-block:: python
    :linenos:

    # 导入
    In [2]: import sqlite3

    # 创建一个连接，example.db可以存在，可以不存在
    In [3]: conn = sqlite3.connect("example.db")

    # 获取cursor
    In [4]: c = conn.cursor()

    # 执行创建表语句
    In [5]: c.execute('''CREATE TABLE stocks
    ...:              (date text, trans text, symbol text, qty real, price real)''')
    Out[5]: <sqlite3.Cursor at 0x1d2ea658650>

    # 插入单条数据
    In [6]: c.execute("INSERT INTO stocks VALUES ('2006-01-05','BUY','RHAT',100,35.14)")
    Out[6]: <sqlite3.Cursor at 0x1d2ea658650>

    # 批量插入
    In [11]: example_date = [('2007-01-05','BUY','RHAT',100,35.14),('2008-01-05','BUY','RHAT',100,35.14)]

    In [12]: c.executemany('insert into stocks values(?,?,?,?,?)',example_data)

    # 提交到数据库
    In [7]: conn.commit()

    # 查询，遍历cursor
    In [16]: c.execute("select * from stocks")
    Out[16]: <sqlite3.Cursor at 0x1d2ea6588f0>

    In [17]: for row in c:
        ...:     print(row)
        ...:
    ('2006-01-05', 'BUY', 'RHAT', 100.0, 35.14)
    ('2007-01-05', 'BUY', 'RHAT', 100.0, 35.14)
    ('2008-01-05', 'BUY', 'RHAT', 100.0, 35.14)
    # 查询后直接获取所有结果
    In [19]: c.execute("select * from stocks")
    Out[19]: <sqlite3.Cursor at 0x1d2ea6588f0>
    In [20]: c.fetchall()
    Out[20]:
    [('2006-01-05', 'BUY', 'RHAT', 100.0, 35.14),
    ('2007-01-05', 'BUY', 'RHAT', 100.0, 35.14),
    ('2008-01-05', 'BUY', 'RHAT', 100.0, 35.14)]

    # 查询，一个一个查询
    In [21]: c.execute("select * from stocks")
    Out[21]: <sqlite3.Cursor at 0x1d2ea6588f0>

    In [22]: c.fetchone()
    Out[22]: ('2006-01-05', 'BUY', 'RHAT', 100.0, 35.14)

    In [23]: c.fetchone()
    Out[23]: ('2007-01-05', 'BUY', 'RHAT', 100.0, 35.14)

    In [24]: c.fetchone()
    Out[24]: ('2008-01-05', 'BUY', 'RHAT', 100.0, 35.14)

    In [25]: c.fetchone()

    # 特定条件查询

    In [29]: c.execute("select * from stocks where date=:date and trans=:trans",{"date":'2006-01-05',"trans":'BUY'})
    Out[29]: <sqlite3.Cursor at 0x1d2ea6588f0>

    In [30]: c.fetchall()
    Out[30]: [('2006-01-05', 'BUY', 'RHAT', 100.0, 35.14)]

    # 关闭连接
    In [8]: conn.close()


