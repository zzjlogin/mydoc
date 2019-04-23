.. _python.queue:

======================================================================================================================================================
:mod:`queue` --- 同步队列
======================================================================================================================================================

.. module:: queue


.. contents::


简介
======================================================================================================================================================

队列模块实现多生产者、多消费者队列。当信息必须在多个线程之间安全地交换时，它在线程编程中特别有用。
此模块中的Queue类实现所有必需的锁定语义。这取决于Python中线程支持的可用性。

模块实现了三种类型的队列，它们只是在检索条目的顺序上有所不同。
   - FIFO队列先进先出，即第一个进入队列的任务第一个弹出。
   - LIFO队列后进先出，即堆栈的后进入队列的任务先弹出。
   - 使用优先级队列，条目将保持排序（使用heapq模块），并首先检索最低值的条目。


使用实例
======================================================================================================================================================









参考详解
======================================================================================================================================================


.. class:: Queue(maxsize=0)

   FIFO（先进先出）队列。队列大小默认是0。

.. class:: LifoQueue(maxsize=0)

   :abbr:`LIFO (last-in, first-out)` （后进先出）队列。  *maxsize* 是一个整数，默认是0。


.. class:: PriorityQueue(maxsize=0)

   优先级队列::

        from dataclasses import dataclass, field
        from typing import Any

        @dataclass(order=True)
        class PrioritizedItem:
            priority: int
            item: Any=field(compare=False)

.. class:: SimpleQueue()

   Constructor for an unbounded :abbr:`FIFO (first-in, first-out)` queue.
   Simple queues lack advanced functionality such as task tracking.

   .. versionadded:: 3.7




.. _queueobjects:

Queue Objects
------------------------------------------------------------------------------------------------------------------------------------------------------


Queue objects (:class:`Queue`, :class:`LifoQueue`, or :class:`PriorityQueue`)
provide the public methods described below.


.. method:: Queue.qsize()

   返回队列的大小。


.. method:: Queue.empty()

   如果队列为空则返回 ``True`` ，否则返回 ``False`` 


.. method:: Queue.full()

   如果队列已经满则返回 ``True`` 否则返回 ``False`` 


.. method:: Queue.put(item, block=True, timeout=None)

   把 *item* 压入队列。往队列里放数据。如果满了或者blocking = False直接报 Full异常。
   如果blocking = True，就是等一会，timeout必须为 0 或正数。None为一直等下去，0为不等，正数n为等待n秒还不能存入，报Full异常。


.. method:: Queue.put_nowait(item)

   等价于 ``put(item, False)``.


.. method:: Queue.get(block=True, timeout=None)

   从队列中删除一个元素，并把这个删除的元素作为返回值返回。


.. method:: Queue.get_nowait()

   等价于 ``get(False)``.


.. method:: Queue.task_done()

   


.. method:: Queue.join()

   

Example of how to wait for enqueued tasks to be completed::

    def worker():
        while True:
            item = q.get()
            if item is None:
                break
            do_work(item)
            q.task_done()

    q = queue.Queue()
    threads = []
    for i in range(num_worker_threads):
        t = threading.Thread(target=worker)
        t.start()
        threads.append(t)

    for item in source():
        q.put(item)

    # block until all tasks are done
    q.join()

    # stop workers
    for i in range(num_worker_threads):
        q.put(None)
    for t in threads:
        t.join()


SimpleQueue 对象
------------------------------------------------------------------------------------------------------------------------------------------------------


:class:`SimpleQueue` 对象提供的方法：

.. method:: SimpleQueue.qsize()

   返回队列的大小。


.. method:: SimpleQueue.empty()

   如果队列为空，则返回 ``True`` 否则返回 ``False`` 。


.. method:: SimpleQueue.put(item, block=True, timeout=None)

   把元素 *item* 存入队列.

.. method:: SimpleQueue.put_nowait(item)

   等价于 ``put(item)``。

.. method:: SimpleQueue.get(block=True, timeout=None)

   从队列中取出一个元素作为返回值。

.. method:: SimpleQueue.get_nowait()

   等价于 ``get(False)``.


