.. _python_threading:

======================================================================================================================================================
:mod:`threading` --- 多线程并行执行
======================================================================================================================================================

.. module:: threading


.. contents::

threading
======================================================================================================================================================

这个库是python2/3都自带的标准库，即安装python后即可使用的模块。

官方参考：
    - Python2：https://docs.python.org/2/library/threading.html
    - Python3：https://docs.python.org/3/library/threading.html

模块功能：
    - 提供基础的并行操作
    - 这个模块引入的是多线程操作，不是多进程。
    - 提供高性能并行操作
    - 官方建议可以参考 `queue <https://docs.python.org/3/library/queue.html#module-queue>`__ 模块

.. note::
    这个模块python2和python3中有些区别。

Python2中这个模块常用方法： 

.. code-block:: text
    :linenos:

    threading.active_count: 活动个数
    therading.current_thread: 当前线程
    threading.get_ident: 获取线程的identifier
    threading.enumerate：线程遍历
    threading.main_thread: 主进程
    threading.settrace: 设置trace函数
    threading.setprofile: 设置profile函数
    threading.stack_size: 设置stack大小
    threading.TIMEOUT_MAX: 线程超时最大值

threading.Thread模块
======================================================================================================================================================

一般python3常用这个模块来实现异步的线程处理。

.. code-block:: python
    :linenos:

    t = threading.Thread(target=myfun, args=(arg1,arg2))
    t.start

这样来执行函数myfun，myfun的参数是arg1和arg2，也可以有更多的参数。这样执行后不用等返回结果可以继续往下执行。
从而实现多线程。

.. code-block:: text
    :linenos:

    start: 启动一个线程
    run: 运行线程
    join: 等待线程中断
    name: 名字
    getName: 获取名字
    setName: 设置名字
    ident: 进程唯一标识符
    is_alive: 是否存活的
    daemon: 是否是守护进程
    isDaemon: 是否是守护进程
    setDaemon: 设置为守护进程


--------------

这个模块是基于底层模块 :mod:`_thread` 构建的高层次的线程接口。
也可以查看相关模块 :mod:`queue` .

.. versionchanged:: 3.7
   This module used to be optional, it is now always available.



模块定义的函数
======================================================================================================================================================


.. function:: active_count()

   返回 *Thread* 对象现在存活的数量。 返回的值等于函数 :func:`.enumerate` 的值。

.. function:: current_thread()

   Return the current :class:`Thread` object, corresponding to the caller's thread
   of control.  If the caller's thread of control was not created through the
   :mod:`threading` module, a dummy thread object with limited functionality is
   returned.


.. function:: get_ident()

   返回当前线程的线程号（ 'thread identifier' ）。这是非0整数。

   .. versionadded:: 3.3


.. function:: enumerate()

   返回一个当前存活的线程对象的列表。这个列表包括通过函数 :func:`current_thread` 创建的：
   守护线程、虚拟线程、主线程。


.. function:: main_thread()

   返回主线程对象。正常情况这个主线程是通过Python解释器启动的。

   .. versionadded:: 3.4


.. function:: settrace(func)

   .. index:: single: trace function

   为所有从threading模块启动的线程设置一个trace函数。在每个线程的run()方法被调用前，
   函数将为每个线程被传递到sys.settrace()。

.. function:: setprofile(func)

   .. index:: single: profile function

   为所有从threading模块启动的线程设置一个profile函数。在每个线程的run()方法被调用前，
   函数将为每个线程被传递到sys.setprofile() 。


.. function:: stack_size([size])

   返回当创建一个新线程是使用的线程栈大小，0表示使用平台或配置的默认值。

该模块还定义了以下常量:

.. data:: TIMEOUT_MAX

   阻塞函数（Lock.acquire()、RLock.acquire()、Condition.wait()等）的超时参数允许的最大值。
   指定的值超过该值将抛出OverflowError。
   该模块也定义了一些类，在下面会讲到。该模块的设计是仿照Java的线程模型。
   然而，Java使lock和condition变量成为每个对象的基本行为，在Python中则是分离的对象。
   Python的Thread类支持Java的线程类的行为的一个子集；当前，没有优先级，没有线程组，
   并且线程不能被销毁、停止、暂停、恢复、或者中断。当实现时，Java的线程类的静态方法被对应到模块级函数。
   形容在下面的所有方法都被原子地执行。



线程本地数据
======================================================================================================================================================


线程本地数据是那些值和特定线程相关的数据。为了管理线程本地数据，
创建一个local类（或者一个子类）的实例，然后存储属性在它里面::

  mydata = threading.local()
  mydata.x = 1

不同线程实例的值将是不同的。


.. class:: local()

   表示线程本地数据的类。
   
   更多的细节参考_threading_local的文档字符串。


.. _thread-objects:

线程对象
======================================================================================================================================================

Thread类表示一个运行在一个独立的控制线程中的行为。
有两个方法指定这个行为：通过传递一个callable对象给构造函数，或者通过在子类中重载run()方法，
在子类中没有其他方法（除了构造函数）应该被重载，换句话说，仅重载这个类的 __init__()和run()方法。
一旦一个线程对象被创建，他的行为必须通过线程的start()方法启动，这将在一个独立的控制线程中调用run()方法。
一旦线程的行为被启动，这个线程被认为是'活跃的'。正常情况下，当它的run()终止时它推出活跃状态，或者出现为处理的异常。
is_alive()方法可用于测试线程是否活跃。
其它线程能调用一个线程的join()方法。
这将阻塞调用线程直到join()方法被调用的线程终止。
一个线程有一个名称，名称能被传递给构造器，并可以通过name属性读取或者改变。
一个线程能被标注为“精灵线程”。
这个标志的意义是当今有精灵线程遗留时，Python程序将退出。初始值从创建的线程继承，
这个标志可以通过daemon属性设置，或者通过构造器的daemon参数传入。
注意，精灵线程在关闭时会突然地停止，他们的资源（例如打开的文件、数据库事务等）不能被正确的释放。
如果你想你的线程优雅地停止，应该使它们是非精灵线程并且使用一个适当的信号机制，例如Event（后面讲解）。

有一个“主线程”对象，这对应到Python程序的初始控制线程，它不是精灵线程。
有可能“虚拟线程对象”被创建，则会存在线程对象对应到“外星人线程”，其控制线程在threading模块之外启动，
例如直接从C代码启动。虚拟线程对象的功能是受限的，它们总是被认为是活跃的精灵线程，不能被join()。
他们不能被删除，由于探测外星人线程的终止是不可能的。

下面是Thread类的构造方法：

.. class:: Thread(group=None, target=None, name=None, args=(), kwargs={}, *, \
                  daemon=None)

   This constructor should always be called with keyword arguments.  Arguments
   are:

   *group* 应该是 ``None`` ，保留为未来的扩展，当一个ThreadGroup类被实现的时候需要；

   *target* i一个callable对象，被run()方法调用，默认为 ``None``，意味着什么都不做；

   *name* 线程名，默认情况下，一个形式为“Thread-N”的唯一名被构造，N是一个小的十进制数；

   *args* 调用target的参数元组，默认为()；

   *kwargs* 为target调用的参数字典，默认为{}；

   *daemon* 如果不为None，则设置该线程是否为守护线程。如果为None，则从当前线程继承；



   .. versionchanged:: 3.3
      Added the *daemon* argument.

线程的常用方法
------------------------------------------------------------------------------------------------------------------------------------------------------

   .. method:: start()

      启动线程。
      
      每个线程最多只能调用一次。它会导致对象的run()方法在独立的控制线程中被调用。
      
      如果在同一个线程对象上调用超过一次将抛出RuntimeError。

   .. method:: run()

      表示线程行为的方法。
      
      可以在子类中重载该方法。标准的run()方法调用传入到构造器中callable对象（对应target参数），
      使用对应的args或者kwargs参数。

   .. method:: join(timeout=None)

      等待直到线程结束。这将阻塞当前线程直到join()方法被调用的线程终止或者抛出一个未处理的异常，
      或者设置的溢出时间到达。如果timeout参数指定且为非None，则它应该是一个浮点数，
      用于指定操作的溢出时间，单位为秒。由于join()总是返回None，
      因此在join()结束后你必须调用is_alive()来判断线程是否结束，如果线程任然是活跃的，
      join()调用则是时间溢出。当timeout不被指定，或者指定为None时，操作将阻塞直到线程终止。
      一个线程能被join()多次。如果一个join当前线程的尝试将导致一个死锁，join()将抛出RuntimeError。
      在一个线程启动之前对该线程做join()操作也将导致同样的异常

   .. attribute:: name

      线程名，仅用于标识一个线程，没有语义，多个线程可以被给同样的名字，初始的名称被构造器设置。

   .. method:: getName()
               setName()

      name的旧的getter/setter API，现在直接使用name属性代替。

   .. attribute:: ident

      这个线程的“线程标识符”，如果线程没有启动，则为None。这是一个非0整数。
      线程标识符可以被循环使用，一个线程退出后它的线程标识符可以被其它线程使用。

   .. method:: is_alive()

      返回线程是否活跃，如果线程存活则返回True。
      
      该方法只有在run()启动后并且在终止之前才返回True。模块函数enumerate()返回所有活跃线程的一个列表。

   .. attribute:: daemon

      一个布尔值，用于表示该线程是否精灵线程。该值必须在start()方法调用之前设置，
      否则RuntimeError被抛出。它的初始值从创建的线程继承。主线程不是一个精灵线程，
      因此所有在主线程中创建的线程daemon默认为False。
      当没有活跃的非精灵线程运行时，整个Python程序退出。

   .. method:: isDaemon()
               setDaemon()

      老的getter/setter API，现在直接使用daemon属性代替。



.. _lock-objects:

Lock对象
======================================================================================================================================================

基元锁是不被特定线程拥有的同步基元。在Python中，它是当前可用的最低级别的同步基元，通过_thread扩展模块直接实现。
一个基元锁存在两种状态，“锁”或者“未锁”，初始创建时处于未锁状态。

有两个基本方法：
    - acquire()和release()。
    - 当状态是未锁时，acquire()将改变其状态到锁并且立即返回；
    - 当状态是锁时，acquire()阻塞直到另一个线程调用release()释放了锁，然后acquire()获取锁并重设锁的状态到锁并且返回。
    - release()应该只在锁处理锁状态时才调用，它改变锁的状态到未锁并且立即返回。如果尝试释放一个未锁的锁，一个RuntimeError将被抛出。

锁也支持上下文管理协议。当超过一个线程被锁阻塞，当锁被释放后仅有一个线程能获取到锁，获取到锁的线程不确定，依赖具体的实现。

相关类如下：


.. class:: Lock()

   该类实现了基元锁对象。线程可以通过acquire请求该锁，如果已经存在其它线程获取了锁，则线程阻塞，直到其它线程释放锁。


   .. method:: acquire(blocking=True, timeout=-1)

      请求一个锁，阻塞或者非阻塞。
      
      当blocking参数为True（默认），将阻塞直到锁被释放，然后获取锁并返回True。
      
      当blocking参数为False，将不阻塞。如果已经存在线程获取了锁，调用将立即返回False；否则，将获取锁并返回True。
      
      当timeout参数大于0时，最多阻塞timeout指定的秒值。timeout为-1（默认）表示一直等待。当blocking为False时不允许指定timeout参数。
      
      如果锁请求成功，则返回True，否则返回False（例如超时）。

      .. versionchanged:: 3.2
         The *timeout* parameter is new.

      .. versionchanged:: 3.2
         Lock acquisition can now be interrupted by signals on POSIX if the
         underlying threading implementation supports it.


   .. method:: release()

      释放一个锁。这能在任何线程中调用，不仅在获取锁的线程中。
      
      当锁处于锁状态时，重设它为未锁，并返回，其它阻塞等待该锁的线程中将有一个线程能获取到锁。
      
      在一个未锁的锁上调用该方法，将抛出RuntimeError。
      
      无返回值。


.. _rlock-objects:

RLock对象
======================================================================================================================================================

一个可重入锁可以被同一个线程请求多次。和Lock类似，但是也有区别。

这两种琐的主要区别是：
    - RLock允许在同一线程中被多次acquire。
    - 而Lock却不允许这种情况。

.. tip:: 如果使用RLock，那么acquire和release必须成对出现，即调用了n次acquire，必须调用n次的release才能真正释放所占用的琐。

.. class:: RLock()

   RLock类。实现了可重入锁对象。一个可重入锁必须被请求它的线程释放，
   一旦一个线程拥有了一个可重入锁，该线程可以再次请求它，注意请求锁的次数必须和释放锁的次数对应。


   .. method:: acquire(blocking=True, timeout=-1)

      请求一个锁，阻塞或者非阻塞方式。

      当blocking为True时，和没有参数的场景相同，并返回True。
      
      当blocking为False时，将不阻塞。如果锁处于锁状态，则立即返回False；否则，和没有参数的场景相同，并返回True。
      
      当timeout参数大于0时，最多阻塞timeout秒。如果在timeout秒内获取了锁，则返回True，否则超时返回False。
      
      .. versionchanged:: 3.2
         The *timeout* parameter is new.


   .. method:: release()

      不返回任何值，释放线程锁。

      仅当调用者线程拥有锁时才调用该方法，否则抛出RuntimeError。




.. _condition-objects:

Condition对象
======================================================================================================================================================


可以把Condiftion理解为一把高级的琐，它提供了比Lock, RLock更高级的功能，
允许我们能够控制复杂的线程同步问题。threadiong.Condition在内部维护一个琐对象（默认是RLock）::




.. class:: Condition(lock=None)

    
   Condition还提供了如下方法(特别要注意：这些方法只有在占用琐(acquire)之后才能调用，否则将会报RuntimeError异常。)
   
   .. versionchanged:: 3.3
      changed from a factory function to a class.

   .. method:: acquire(*args)

      请求一个隐含锁，这个方法会调用隐含锁的对应方法，返回值即为隐含锁的方法的返回值。

   .. method:: release()

      释放隐含锁。这个方法调用隐含锁的对应方法，没有返回值。

   .. method:: wait(timeout=None)

      等待直到被唤醒，或者超时。如果调用线程没有请求锁，RuntimeError被抛出。
      
      该方法会释放隐含锁，然后阻塞直到它被另一个线程调用同一个condition对象的notify()或者notify_all()方法唤醒，或者直到指定的timeout时间溢出。一旦唤醒或者超时，它重新请求锁并返回。
      
      当timeout参数被指定并不为None，则指定了一个秒级的超时时间。
      
      当隐含锁是一个RLock锁，它不通过release()方法释放锁，因为如果线程请求了多次锁，使用release()方法不能解锁（必须调用和lock方法相同的次数才能解锁）。一个RLock类的内部接口被使用，该接口能释放锁，不管锁请求了多少次。当锁被请求时，另一个内部接口被用于还原锁的递归层级。
      
      方法返回True，如果超时则返回False。

      .. versionchanged:: 3.2
         Previously, the method always returned ``None``.

   .. method:: wait_for(predicate, timeout=None)

      等待直到条件为True。predicate应该是一个callable，返回值为布尔值。timeout用于指定超时时间。
      
      该方法相当于反复调用wait()直到条件为真，或者超时。返回值是最后的predicate的返回值，或者超时返回Flase。
      
      忽略超时特性，调用这个方法相当于::

        while not predicate():
            cv.wait()

      .. versionadded:: 3.2

   .. method:: notify(n=1)

      默认情况下，唤醒一个等待线程。如果调用该方法的线程没有获取锁，则RuntimeError被抛出。
      
      这个方法子多唤醒n（默认为1）个等待线程；如果没有线程等待，则没有操作。
      
      如果至少n个线程正在等待，当前的实现是刚好唤醒n个线程。然而，依赖这个行为是不安全的，因为，未来某些优化后的实现可能会唤醒超过n个线程。

.. tip:: 一个唤醒的线程只有当请求到锁后才会从wait()调用中返回。由于notify()不释放锁，所以它的调用者应该释放锁。

   .. method:: notify_all()

      唤醒所有等待线程。这个方法的行为类似于notify()，但是唤醒所有等待线程。如果调用线程未获取锁，则RuntimeError被抛出。


.. _semaphore-objects:

Semaphore对象
======================================================================================================================================================

这是计算机科学历史上最早的同步基元中的一个，被荷兰的计算机科学家Edsger W. Dijkstra发明（他使用P()和V()而不是acquire()和release()）。

semaphore管理一个内部计数，每次调用acquire()时该计数减一，每次调用release()时计数加一。计数不会小于0，当acquire()发现计数为0时，则阻塞，等待直到其它线程调用release()。

semaphore也支持上下文管理协议。


.. class:: Semaphore(value=1)

   该类实现semaphore对象。一个semaphore管理一个表示计数表示能并行进入的线程数量。
   
   如果计数为0，则acquire()阻塞直到计数大于0。
   
   value给出了内部计数的初始值，默认为1，如果传入的value小于0，则抛出ValueError。

   .. versionchanged:: 3.3
      changed from a factory function to a class.

   .. method:: acquire(blocking=True, timeout=None)

      请求semaphore。
      
      当没有参数时：如果内部计数大于0，将计数减1并立即返回。如果计数为0，阻塞，等待直到另一个线程调用了release()。这使用互锁机制实现，保证了如果有多个线程调用acquire()阻塞，则release()将只会唤醒一个线程。唤醒的线程是随机选择一个，不依赖阻塞的顺序。成功返回True（或者无限阻塞）。
      
      如果blocking为False，将不阻塞。如果无法获取semaphore，则立即返回False；否则，同没有参数时的操作，并返回True。
      
      当设置了timeout并且不是None，它将阻塞最多timeout秒。如果在该时间内没有成功获取semaphore，则返回False；否则返回True。


      .. versionchanged:: 3.2
         The *timeout* parameter is new.

   .. method:: release()

      释放一个semaphore，计数加1。如果计数初始为0，则需要唤醒等待队列中的一个线程。


.. class:: BoundedSemaphore(value=1)

   该类实现了有界的semaphore对象。一个有界的semaphore会确保它的当前值没有溢出他的初始值，
   如果溢出，则ValueError被抛出。在大部分场景下，semaphore被用于限制资源的使用。
   如果semaphore被释放太多次，往往表示出现了bug。

   .. versionchanged:: 3.3
      changed from a factory function to a class.


.. _semaphore-examples:

:class:`Semaphore` Example
^^^^^^^^^^^^^^^^^^^^^^^^^^

Semaphore通常被用于控制资源的使用，例如，一个数据库服务器。在一些情况下，资源的大小被固定，
你应该使用一个有界的Semaphore。在启动其他工作线程之前，你的主线程首先初始化Semaphore::

   maxconnections = 5
   # ...
   pool_sema = BoundedSemaphore(value=maxconnections)

其它工作线程则在需要连接到服务器时调用Semaphore的请求和释放方法::

   with pool_sema:
       conn = connectdb()
       try:
           # ... use connection ...
       finally:
           conn.close()

.. _event-objects:

Event对象
======================================================================================================================================================


这是在线程间最简单的通信机制之一：一个线程通知一个事件，另一个线程等待通知并作出处理。

一个Event对象管理一个内部标志，使用set()方法可以将其设置为True，使用clear()方法可以将其重设为False。

wait()方法将阻塞直到标志为True。


.. class:: Event()

   该类实现事件对象。一个事件管理一个标志，可以通过set()方法将其设置为True，
   通过clear()方法将其重设为False。
   
   wait()方法阻塞直到标志为True。标志初始为False。

   .. versionchanged:: 3.3
      changed from a factory function to a class.

   .. method:: is_set()

      当且仅当内部标志为True时返回True。

   .. method:: set()

      设置标志为True。所有等待的线程都将被唤醒。一旦标志为True，调用wait()的线程将不再阻塞。

   .. method:: clear()

      重设标志为False。接下来，所有调用wait()的线程将阻塞直到set()被调用。

   .. method:: wait(timeout=None)

      阻塞直到标志被设置为True。如果标志已经为True，则立即返回；否则，阻塞直到另一个线程调用set()，或者直到超时。
      
      当timeout参数被指定且不为None，线程将仅等待timeout的秒数。
      
      该方法当标志为True时返回True，当超时时返回False。

      .. versionchanged:: 3.1
         Previously, the method always returned ``None``.


.. _timer-objects:

Timer对象
======================================================================================================================================================


该类表示了一个定时器，表示一个行为在多少时间后被执行。Timer是Thread的子类，可以作为创建自定义线程的一个实例。

Timer通过调用start()方法启动，通过调用cancel()方法停止（必须在行为被执行之前）。

Timer执行指定行为之间的等待时间并不是精确的，也就是说可能与用户指定的间隔存在差异。

For example::

   def hello():
       print("hello, world")

   t = Timer(30.0, hello)
   t.start()  # after 30 seconds, "hello, world" will be printed


.. class:: Timer(interval, function, args=None, kwargs=None)

   创建一个Timer，在interval秒之后，将使用参数args和kwargs作为参数执行function。
   
   如果args为None（默认），将使用空list。如果kwargs是None（默认），则使用空字典。
   
   .. versionchanged:: 3.3
      changed from a factory function to a class.

   .. method:: cancel()

      停止定时器，并且取消定时器的行为的执行。这仅当定时器任然处理等待状态时才有效。


Barrier对象
======================================================================================================================================================


.. versionadded:: 3.2

Barrier提供了一个简单的同步基元，用于固定数量的线程需要等待彼此的场景。

尝试通过Barrier的每个线程都会调用wait()方法，然后阻塞直到所有的线程都调用了该方法，然后，所有线程同时被释放。

Barrier能被重复使用任意多次，但必须是同等数量的线程。

下面是一个例子，一个同步客户端和服务端线程的简单方法：

下面实例::

   b = Barrier(2, timeout=5)

   def server():
       start_server()
       b.wait()
       while True:
           connection = accept_connection()
           process_server_connection(connection)

   def client():
       b.wait()
       while True:
           connection = make_connection()
           process_client_connection(connection)


.. class:: Barrier(parties, action=None, timeout=None)

   为parties个线程创建一个Barrier对象，如果提供了action，则当线程被释放时，它将被线程中的一个调用。
   timeout表示wait()方法的默认超时时间值。

   .. method:: wait(timeout=None)

      当所有使用栅栏的线程都调用了该方法后，他们将被同时释放。如果timeout被提供，他优先于类构造器提供的timeout参数。
      返回值是0到parties的整数，每个线程都不同。这能用于选择某个特定的线程做一些特定的操作，例如

      例如::

         i = barrier.wait()
         if i == 0:
             # Only one thread needs to print this
             print("passed the barrier")

      

   .. method:: reset()

      恢复栅栏到默认状态。任何处于等待中的线程将收到BrokenBarrierError异常。
      
      注意这里需要额外的同步。如果一个栅栏被损坏，创建一个新的栅栏也许是更好的选择。

   .. method:: abort()

      放置栅栏到损坏状态。这导致当前处于等待的线程和未来对wait()的调用都会抛出BrokenBarrierError。通常使用该方法是为了避免死锁。
      
      使用一个超时时间应该是更好的选择。

   .. attribute:: parties

      要求通过栅栏的线程的数量。

   .. attribute:: n_waiting

      当前处于等待中的线程数量。

   .. attribute:: broken

      栅栏是否处于损坏状态，如果是则为True。



