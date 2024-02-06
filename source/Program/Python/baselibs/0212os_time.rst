.. _python_time:

======================================================================================================================================================
:mod:`time` --- 时间访问和转换
======================================================================================================================================================


.. contents::

时间模块简介
======================================================================================================================================================

该模块提供于时间相关的模块。

建议使用datetime下的time包，而不是这个。


time模块中时间表现的格式主要有三种：
    - timestamp时间戳：时间戳表示的是从1970年1月1日00:00:00开始按秒计算的偏移量
    - struct_time时间元组：共有九个元素组。
    - format time 格式化时间：已格式化的结构使时间更具可读性。包括自定义格式和固定格式。

这三种时间格式数据转换方法：

.. image:: /images/language/python/baselibs/timeformat_convert.png
    :align: center
    :height: 350 px
    :width: 400 px

.. image:: /images/language/python/baselibs/timeformat_convert_1.png
    :align: center
    :height: 350 px
    :width: 400 px


使用实例
======================================================================================================================================================


等待20秒，样例

.. code-block:: python 

    # 导入包
    In [12]: import time
    # 睡眠20s
    In [13]: time.sleep(20)



参考详解
======================================================================================================================================================

和时间相关的模块还可以参考 :mod:`datetime` 和 :mod:`calendar` 。


* 时间格式转换使用的函数：


  +-------------------------+-------------------------+-------------------------+
  | From                    | To                      | Use                     |
  +=========================+=========================+=========================+
  | seconds since the epoch | :class:`struct_time` in | :func:`gmtime`          |
  |                         | UTC                     |                         |
  +-------------------------+-------------------------+-------------------------+
  | seconds since the epoch | :class:`struct_time` in | :func:`localtime`       |
  |                         | local time              |                         |
  +-------------------------+-------------------------+-------------------------+
  | :class:`struct_time` in | seconds since the epoch | :func:`calendar.timegm` |
  | UTC                     |                         |                         |
  +-------------------------+-------------------------+-------------------------+
  | :class:`struct_time` in | seconds since the epoch | :func:`mktime`          |
  | local time              |                         |                         |
  +-------------------------+-------------------------+-------------------------+


.. _time-functions:

模块包括的函数
------------------------------------------------------------------------------------------------------------------------------------------------------


.. function:: asctime([t])

   把一个表示时间的元组或者 :class:`struct_time` 表示为这种形式：
   'Sun Jun 20 23:21:05 1993'。如果没有参数，将会将 :func:`localtime` 作为参数传入。

   .. note::

      Unlike the C function of the same name, :func:`asctime` does not add a
      trailing newline.


.. function:: clock()

   .. index::
      single: CPU time
      single: processor time
      single: benchmarking

   在UNIX系统上，它返回的是“进程时间”，它是用秒表示的浮点数（时间戳）。
   
   而在WINDOWS中，第一次调用，返回的是进程运行的实际时间。
   而第二次之后的调用是自第一次调用以后到现在的运行时间。
   （实际上是以WIN32上QueryPerformanceCounter()为基础，它比毫秒表示更为精确）


.. function:: pthread_getcpuclockid(thread_id)

   返回指定 *thread_id* 的特定于线程的cpu时间时钟的 *clk_id* 。

   .. availability:: Unix (see the man page for :manpage:`pthread_getcpuclockid(3)` for
      further information).

   .. versionadded:: 3.7

.. function:: clock_getres(clk_id)

   Return the resolution (precision) of the specified clock *clk_id*.  Refer to
   :ref:`time-clock-id-constants` for a list of accepted values for *clk_id*.

   .. availability:: Unix.

   .. versionadded:: 3.3


.. function:: clock_gettime(clk_id) -> float


   .. availability:: Unix.

   .. versionadded:: 3.3


.. function:: clock_gettime_ns(clk_id) -> int


   .. availability:: Unix.

   .. versionadded:: 3.7


.. function:: clock_settime(clk_id, time: float)


   .. availability:: Unix.

   .. versionadded:: 3.3


.. function:: clock_settime_ns(clk_id, time: int)


   .. availability:: Unix.

   .. versionadded:: 3.7


.. function:: ctime([secs])

   把一个时间戳（按秒计算的浮点数 *secs* ）转化为time.asctime()的形式。
   如果参数未给或者为 :const:`None` 的时候，将会默认time.time()为参数。它的作用相当于
   time.asctime(time.localtime(secs))



.. function:: get_clock_info(name)

   .. versionadded:: 3.3


.. function:: gmtime([secs])

   和localtime()方法类似，gmtime()方法是将一个时间戳转换为UTC时区（0时区）的struct_time


.. function:: localtime([secs])

   
   和 :func:`gmtime` 类似。将一个时间戳转换为当前时区的struct_time。secs参数未提供，则以当前时间为准。


.. function:: mktime(t)


.. function:: monotonic() -> float


   .. versionadded:: 3.3
   .. versionchanged:: 3.5
      The function is now always available and always system-wide.


.. function:: monotonic_ns() -> int

   Similar to :func:`monotonic`, but return time as nanoseconds.

   .. versionadded:: 3.7

.. function:: perf_counter() -> float

   .. versionadded:: 3.3

.. function:: perf_counter_ns() -> int

   Similar to :func:`perf_counter`, but return time as nanoseconds.

   .. versionadded:: 3.7


.. function:: process_time() -> float


   .. versionadded:: 3.3

.. function:: process_time_ns() -> int

   Similar to :func:`process_time` but return time as nanoseconds.

   .. versionadded:: 3.7

.. function:: sleep(secs)

   等待 *secs* 秒继续执行下面的代码。

   .. versionchanged:: 3.5
      The function now sleeps at least *secs* even if the sleep is interrupted
      by a signal, except if the signal handler raises an exception (see
      :pep:`475` for the rationale).


.. index::
   single: % (percent); datetime format

.. function:: strftime(format[, t])

   把一个元组或者 :class:`struct_time` 转化为格式化的时间字符串。
   如果t未指定，将传入 :func:`localtime` 。
   如果元组中任何一个元素越界， :exc:`ValueError` 的错误将会被抛出

   format必须是字符串

   *format* 字符串定义时间格式的方式，下面是说明:

   +-----------+------------------------------------------------+-------+
   | Directive | Meaning                                        | Notes |
   +===========+================================================+=======+
   | ``%a``    | 本地（locale）简化星期名称                       |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%A``    | 本地完整星期名称                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%b``    | 本地简化月份名称                                |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%B``    | 本地完整月份名称                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%c``    | 本地相应的日期和时间表示                         |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%d``    | 一个月中的第几天（01 - 31）                      |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%H``    | 一天中的第几个小时（24小时制）                   |       |
   |           | [00,23].                                       |       |
   +-----------+------------------------------------------------+-------+
   | ``%I``    | 第几个小时（12小时制）                           |       |
   |           | [01,12].                                       |       |
   +-----------+------------------------------------------------+-------+
   | ``%j``    | 一年中的第几天（001 - 366）                      |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%m``    | 月份 [01,12].                                   |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%M``    | 分钟 [00,59].                                   |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%p``    | 本地上午还是下午 AM or PM.                       | \(1)  |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%S``    | 秒 [00,61].                                    | \(2)  |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%U``    | 一年中的星期数 [00,53]                          |       |
   |           | 第一个星期天之前的所有天数都放在第0周。           |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%w``    | 一个星期中的第几天 [0(Sunday),6].                |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%W``    | 和%U基本相同，不同的是%W以星期一为一个星期的开始。 | \(3)  |
   |           |                                                |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%x``    | 本地相应日期                                    |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%X``    | 本地相应时间                                    |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%y``    | 去掉世纪的年份                                  |       |
   |           | [00,99].                                       |       |
   +-----------+------------------------------------------------+-------+
   | ``%Y``    | 完整的年份                                      |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%z``    | 时区的名字                                      |       |
   |           |                                                |       |
   |           |                                                |       |
   |           |                                                |       |
   |           |                                                |       |
   +-----------+------------------------------------------------+-------+
   | ``%Z``    | Time zone name (no characters if no time zone  |       |
   |           | exists).                                       |       |
   +-----------+------------------------------------------------+-------+
   | ``%%``    | 字符 ``'%'``                                   |       |
   +-----------+------------------------------------------------+-------+

   ::

      >>> from time import gmtime, strftime
      >>> strftime("%a, %d %b %Y %H:%M:%S +0000", gmtime())
      'Thu, 28 Jun 2001 14:17:15 +0000'



.. index::
   single: % (percent); datetime format

.. function:: strptime(string[, format])

   把一个格式化时间字符串转化为 :class:`struct_time` 。实际上它和strftime()是逆操作。
   is a  as returned by :func:`gmtime` or

   For example:

      >>> import time
      >>> time.strptime("30 Nov 00", "%d %b %y")   # doctest: +NORMALIZE_WHITESPACE
      time.struct_time(tm_year=2000, tm_mon=11, tm_mday=30, tm_hour=0, tm_min=0,
                       tm_sec=0, tm_wday=3, tm_yday=335, tm_isdst=-1)



.. class:: struct_time



   +-------+-------------------+---------------------------------+
   | Index | Attribute         | Values                          |
   +=======+===================+=================================+
   | 0     | :attr:`tm_year`   | (for example, 1993)             |
   +-------+-------------------+---------------------------------+
   | 1     | :attr:`tm_mon`    | range [1, 12]                   |
   +-------+-------------------+---------------------------------+
   | 2     | :attr:`tm_mday`   | range [1, 31]                   |
   +-------+-------------------+---------------------------------+
   | 3     | :attr:`tm_hour`   | range [0, 23]                   |
   +-------+-------------------+---------------------------------+
   | 4     | :attr:`tm_min`    | range [0, 59]                   |
   +-------+-------------------+---------------------------------+
   | 5     | :attr:`tm_sec`    | range [0, 61]; see **(2)** in   |
   |       |                   | :func:`strftime` description    |
   +-------+-------------------+---------------------------------+
   | 6     | :attr:`tm_wday`   | range [0, 6], Monday is 0       |
   +-------+-------------------+---------------------------------+
   | 7     | :attr:`tm_yday`   | range [1, 366]                  |
   +-------+-------------------+---------------------------------+
   | 8     | :attr:`tm_isdst`  | 0, 1 or -1; see below           |
   +-------+-------------------+---------------------------------+
   | N/A   | :attr:`tm_zone`   | abbreviation of timezone name   |
   +-------+-------------------+---------------------------------+
   | N/A   | :attr:`tm_gmtoff` | offset east of UTC in seconds   |
   +-------+-------------------+---------------------------------+



.. function:: time() -> float

   返回以秒计时的浮点数。


.. function:: thread_time() -> float

   .. index::
      single: CPU time
      single: processor time
      single: benchmarking

   .. availability::  Windows, Linux, Unix systems supporting
      ``CLOCK_THREAD_CPUTIME_ID``.

   .. versionadded:: 3.7


.. function:: thread_time_ns() -> int

   Similar to :func:`thread_time` but return time as nanoseconds.

   .. versionadded:: 3.7


.. function:: time_ns() -> int

   .. versionadded:: 3.7

.. function:: tzset()

   .. availability:: Unix.

   .. note::

      Although in many cases, changing the :envvar:`TZ` environment variable may
      affect the output of functions like :func:`localtime` without calling
      :func:`tzset`, this behavior should not be relied on.

      The :envvar:`TZ` environment variable should contain no whitespace.

   The standard format of the :envvar:`TZ` environment variable is (whitespace
   added for clarity)::

      std offset [dst [offset [,start[/time], end[/time]]]]

   Where the components are:

   ``std`` and ``dst``
      Three or more alphanumerics giving the timezone abbreviations. These will be
      propagated into time.tzname

   ``offset``
      The offset has the form: ``± hh[:mm[:ss]]``. This indicates the value
      added the local time to arrive at UTC.  If preceded by a '-', the timezone
      is east of the Prime Meridian; otherwise, it is west. If no offset follows
      dst, summer time is assumed to be one hour ahead of standard time.

   ``start[/time], end[/time]``
      Indicates when to change to and back from DST. The format of the
      start and end dates are one of the following:

      :samp:`J{n}`
         The Julian day *n* (1 <= *n* <= 365). Leap days are not counted, so in
         all years February 28 is day 59 and March 1 is day 60.

      :samp:`{n}`
         The zero-based Julian day (0 <= *n* <= 365). Leap days are counted, and
         it is possible to refer to February 29.

      :samp:`M{m}.{n}.{d}`
         The *d*'th day (0 <= *d* <= 6) of week *n* of month *m* of the year (1
         <= *n* <= 5, 1 <= *m* <= 12, where week 5 means "the last *d* day in
         month *m*" which may occur in either the fourth or the fifth
         week). Week 1 is the first week in which the *d*'th day occurs. Day
         zero is a Sunday.

      ``time`` has the same format as ``offset`` except that no leading sign
      ('-' or '+') is allowed. The default, if time is not given, is 02:00:00.

   ::

      >>> os.environ['TZ'] = 'EST+05EDT,M4.1.0,M10.5.0'
      >>> time.tzset()
      >>> time.strftime('%X %x %Z')
      '02:07:36 05/08/03 EDT'
      >>> os.environ['TZ'] = 'AEST-10AEDT-11,M10.5.0,M3.5.0'
      >>> time.tzset()
      >>> time.strftime('%X %x %Z')
      '16:08:12 05/08/03 AEST'

   On many Unix systems (including \*BSD, Linux, Solaris, and Darwin), it is more
   convenient to use the system's zoneinfo (:manpage:`tzfile(5)`)  database to
   specify the timezone rules. To do this, set the  :envvar:`TZ` environment
   variable to the path of the required timezone  datafile, relative to the root of
   the systems 'zoneinfo' timezone database, usually located at
   :file:`/usr/share/zoneinfo`. For example,  ``'US/Eastern'``,
   ``'Australia/Melbourne'``, ``'Egypt'`` or  ``'Europe/Amsterdam'``. ::

      >>> os.environ['TZ'] = 'US/Eastern'
      >>> time.tzset()
      >>> time.tzname
      ('EST', 'EDT')
      >>> os.environ['TZ'] = 'Egypt'
      >>> time.tzset()
      >>> time.tzname
      ('EET', 'EEST')


.. _time-clock-id-constants:

Clock ID 常量
------------------



.. data:: CLOCK_BOOTTIME


   .. availability:: Linux 2.6.39 or later.

   .. versionadded:: 3.7


.. data:: CLOCK_HIGHRES



   .. availability:: Solaris.

   .. versionadded:: 3.3


.. data:: CLOCK_MONOTONIC


   .. availability:: Unix.

   .. versionadded:: 3.3


.. data:: CLOCK_MONOTONIC_RAW


   .. availability:: Linux 2.6.28 and newer, macOS 10.12 and newer.

   .. versionadded:: 3.3


.. data:: CLOCK_PROCESS_CPUTIME_ID

   来自CPU的高解析度的每个进程计时器。

   .. availability:: Unix.

   .. versionadded:: 3.3


.. data:: CLOCK_PROF

   来自CPU的高解析度的每个进程计时器。

   .. availability:: FreeBSD, NetBSD 7 or later, OpenBSD.

   .. versionadded:: 3.7


.. data:: CLOCK_THREAD_CPUTIME_ID

   特定线程的CPU时钟。

   .. availability::  Unix.

   .. versionadded:: 3.3


.. data:: CLOCK_UPTIME

   绝对值是系统运行且未暂停的时间，提供准确的正常运行时间测量，包括绝对值和间隔值。

   .. availability:: FreeBSD, OpenBSD 5.5 or later.

   .. versionadded:: 3.7


The following constant is the only parameter that can be sent to
:func:`clock_settime`.

.. data:: CLOCK_REALTIME

   System-wide real-time clock.  Setting this clock requires appropriate
   privileges.

   .. availability:: Unix.

   .. versionadded:: 3.3


.. _time-timezone-constants:

Timezone Constants
-------------------

.. data:: altzone

   定义了本地DST时区的偏移量，以西部UTC秒为单位。
   如果当地的DST时区位于UTC以东(如西欧，包括英国)，则为负。只有在日光不为零时才使用这个。

.. data:: daylight

   如果定义了DST时区，则非零。

.. data:: timezone

   本地(非夏令时)时区的偏移量，以西部UTC的秒为单位(西欧大部分地区为负，美国为正，英国为零)。
   
.. data:: tzname

   返回一个包含两个字符串的元组。
   第一个是本地非DST时区的名称，第二个是本地DST时区的名称。
   如果没有定义DST时区，则不应使用第二个字符串。




