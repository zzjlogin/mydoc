.. _python_datatime:

======================================================================================================================================================
:mod:`datatime` --- 基础日期和时间类型
======================================================================================================================================================

.. contents::


datetime
======================================================================================================================================================


timedelta
------------------------------------------------------------------------------------------------------------------------------------------------------

class datetime.timedelta(days=0, seconds=0, microseconds=0, milliseconds=0, minutes=0, hours=0, weeks=0)

样例： 

.. code-block:: python 

    In [9]: from datetime import timedelta

    In [10]: year = timedelta(days=365,hours=23,minutes=50,seconds=600)

    In [11]: year.total_seconds()
    Out[11]: 31622400.0

    In [12]: year
    Out[12]: datetime.timedelta(366)

    In [13]: print(year)
    366 days, 0:00:00

date
......................................................................................................................................................

样例： 

.. code-block:: python 

    In [15]: from datetime import date

    In [16]: date.min
    Out[16]: datetime.date(1, 1, 1)

    In [17]: date.max
    Out[17]: datetime.date(9999, 12, 31)

    In [21]: today = date.today()

    In [22]: today
    Out[22]: datetime.date(2018, 2, 11)

    # 日期构造
    In [24]: another_day = date(today.year,5,14)

    In [25]: another_day
    Out[25]: datetime.date(2018, 5, 14)

    # 日期差值
    In [26]: times = abs(today - another_day)

    In [27]: type(times)
    Out[27]: datetime.timedelta

    In [28]: times.total_seconds
    Out[28]: <function timedelta.total_seconds>

    In [29]: times.total_seconds()
    Out[29]: 7948800.0

    # 日期转字符串的
    In [30]: today.strftime("%Y-%m-%d")
    Out[30]: '2018-02-11'


datetime
......................................................................................................................................................

样例： 

.. code-block:: python 

    In [33]: d = date(2018,7,14)

    In [34]: d
    Out[34]: datetime.date(2018, 7, 14)

    In [35]: t = time(12,30)

    # 日期和时间构造一个datetime
    In [36]: datetime.combine(d,t)
    Out[36]: datetime.datetime(2018, 7, 14, 12, 30)

    # 当前时间
    In [37]: datetime.now()
    Out[37]: datetime.datetime(2018, 2, 11, 15, 23, 19, 986889)

    # utc时间，北京和utc时区差8个小时
    In [38]: datetime.utcnow()
    Out[38]: datetime.datetime(2018, 2, 11, 7, 23, 26, 978965)

    In [39]: now = datetime.utcnow()

    # 日期转字符串
    In [41]: now.strftime("%Y-%m-%d %H:%M:%S")
    Out[41]: '2018-02-11 07:23:39'

    In [43]: now_str = '2018-02-11 07:23:39'
    
    # 字符串转日期
    In [44]: datetime.strptime(now_str,"%Y-%m-%d %H:%M:%S")
    Out[44]: datetime.datetime(2018, 2, 11, 7, 23, 39)

time
......................................................................................................................................................

样例： 

.. code-block:: python 

    In [46]:  from datetime import time

    In [47]:  dt = time(hour=12, minute=34, second=56, microsecond=0)

    # 指定下显示的精度程度
    In [48]: dt.isoformat(timespec='microseconds')
    Out[48]: '12:34:56.000000'

    # 默认的，只是显示，时分秒
    In [49]: dt.isoformat(timespec='auto')
    Out[49]: '12:34:56'


格式控制
......................................................................................................................................................

日期格式控制符_

.. _日期格式控制符: https://docs.python.org/3/library/datetime.html#strftime-and-strptime-behavior
