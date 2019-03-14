.. _python_threading:

======================================================================================================================================================
threading并发执行(多线程)
======================================================================================================================================================

:Date: 2018-10

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

threading.Lock
======================================================================================================================================================

.. code-block:: text
    :linenos:

    acqure: 请求一个锁
    release: 释放锁

threading.RLock
======================================================================================================================================================

.. code-block:: text
    :linenos:

    acqure: 请求一个锁
    release: 释放锁

threading.Condition
======================================================================================================================================================

.. code-block:: text
    :linenos:

    acqure: 请求一个锁
    release: 释放锁
    wait: 等待一直到一个通知或者超时 
    wait_for: 等待到一个条件为true
    notify： 通知
    notify_all: 通知所有

threading.Event
======================================================================================================================================================

.. code-block:: text
    :linenos:

    is_set:只有内部标记为true返回true
    set： 设置内部标记
    clear: 清空时间
    wait: 阻塞一直到内部标记为true

threading.Timer
======================================================================================================================================================

.. code-block:: text
    :linenos:

    cancel: 取消

threading.Barrier
======================================================================================================================================================

.. code-block:: text
    :linenos:

    wait： 等待
    reset: 重置
    abort: 中断
    parties: 需要pass的线程个数
    n_waiting: 当前等待个数
    broken: 是否是broken状态

multiprocessing
======================================================================================================================================================

类似线程的多处理模块

Pool样例使用

.. code-block:: python
    :linenos:

    from multiprocessing import Pool

    def f(x):
        return x*x

    if __name__ == '__main__':
        with Pool(5) as p:
            print(p.map(f, [1, 2, 3]))

Process样例使用

.. code-block:: python
    :linenos:

    from multiprocessing import Process

    def f(name):
        print('hello', name)

    if __name__ == '__main__':
        p = Process(target=f, args=('bob',))
        p.start()
        p.join()

两个进程通信样例

.. code-block:: python
    :linenos:

    from multiprocessing import Process, Pipe

    def f(conn):
        conn.send([42, None, 'hello'])
        conn.close()

    if __name__ == '__main__':
        parent_conn, child_conn = Pipe()
        p = Process(target=f, args=(child_conn,))
        p.start()
        print(parent_conn.recv())   # prints "[42, None, 'hello']"
        p.join()

进程同步样例

.. code-block:: python
    :linenos:

    from multiprocessing import Process, Lock

    def f(l, i):
        l.acquire()
        try:
            print('hello world', i)
        finally:
            l.release()

    if __name__ == '__main__':
        lock = Lock()

        for num in range(10):
            Process(target=f, args=(lock, num)).start()

共享内存样例

.. code-block:: python
    :linenos:

    from multiprocessing import Process, Value, Array

    def f(n, a):
        n.value = 3.1415927
        for i in range(len(a)):
            a[i] = -a[i]

    if __name__ == '__main__':
        num = Value('d', 0.0)
        arr = Array('i', range(10))

        p = Process(target=f, args=(num, arr))
        p.start()
        p.join()

        print(num.value)
        print(arr[:])
             
multiprocessing.Process
======================================================================================================================================================

主要方法

.. code-block:: none
    :linenos:

    run: 运行
    start:启动
    join: 等待
    name:名字
    is_alive： 是否存活
    daemon: 是否是守护进程
    pid： 进程id
    exitcode: 退出码
    authkey: 认证key
    sentinel: 系统对象数字句柄
    terminate: 中断进程

multiprocessing.Process
======================================================================================================================================================

返回一个（conn1,conn2）的连接对象。

multiprocessing.Queue
======================================================================================================================================================

主要方法

.. code-block:: none
    :linenos:

    qsize: 队列大小
    empty: 是否为空
    full: 是否满了
    put: 添加对象
    put_nowait: 不等待添加
    get: 移除并返回一个对象
    get_noewait: 不等待移除对象
    close: 关闭
    join_thread: 等待后台进程
    cancel_join_thread: 取消join进程

multiprocessing.Queue
======================================================================================================================================================

multiprocessing.JoinableQueue
======================================================================================================================================================



multiprocessing.connection.Connection
======================================================================================================================================================

主要方法

.. code-block:: text 
    :linenos:

    send： 发送对象
    recv:  接受对象
    fileno： 文件描述符
    close:   关闭
    poll:   返回是否有数据可读
    send_bytes: 发送字节对象
    recv_bytes: 接受字节对象
    recv_bytes_into: 接受字节到一个buffer

共享对象
======================================================================================================================================================

.. code-block:: text
    :linenos:

    multiprocessing.Value
    multiprocessing.Array
    multiprocessing.sharedctypes.RawArray
    multiprocessing.sharedctypes.RawValue
    multiprocessing.sharedctypes.Array
    multiprocessing.sharedctypes.Value
    multiprocessing.sharedctypes.copy
    multiprocessing.sharedctypes.synchronized

进程管理者
======================================================================================================================================================

multiprocessing.managers.BaseManager

主要方法

.. code-block:: text
    :linenos:

    start： 启动
    get_server:获取server对象
    connect: 连接
    shutdown: 关闭
    register: 注册
    address: 管理者使用地址

multiprocessing.managers.SyncManager

主要方法

.. code-block:: text
    :linenos:

    Barrier： 创建一个共享的屏障对象
    Bounded:  创建一个有界信号量
    Event:  创建一个事件对象
    Lock: 创建一个共享锁对象
    Namespace: 创建一个共享的namespace
    Queue： 创建一个共享的队列
    Rlock: 创建一个共享锁
    Semaphore: 创建一个信号量
    Array: 创建一个数组
    Value: 创建一个数值
    dict: 字典
    list: 列表

multiprocessing.pool.Pool

主要方法： 

.. code-block:: text
    :linenos:

    apply: 给定的函数和参数去调用
    apply_async: 异步调用
    map: 并行操作
    map_async: 异步操作
    imap: lazier版本的map
    imap_unordered:类似imap，结果是乱的
    starmap: 和map类似
    startmap_async: 
    close: 关闭
    terminate: 中断
    join: 等待进程去退出

multiprocessing.pool.AsyncResult

主要方法： 

.. code-block:: text
    :linenos:

    get: 返回结果如果结果到达
    wait: 等待数秒等结果到来
    ready: 返回是否调用完毕
    successful: 返回是否完成且没有异常

日志

.. code-block:: text
    :linenos:

    multiprocessing.get_logger()获取日志
    multiprocessing.log_to_stderr() 日志输出到标准错误去。
