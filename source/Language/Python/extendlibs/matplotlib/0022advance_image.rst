.. _python_matplotlib_advance:

======================================================================================================================================================
matplotlib高级使用
======================================================================================================================================================

.. contents::

高级图形显示
======================================================================================================================================================

参考链接
------------------------------------------------------------------------------------------------------------------------------------------------------

设置显示图形的宽度：
    - https://matplotlib.org/api/_as_gen/matplotlib.figure.Figure.html?highlight=set_figwidth#matplotlib.figure.Figure.set_figwidth
设置显示图形的高度：
    - https://matplotlib.org/api/_as_gen/matplotlib.figure.Figure.html?highlight=set_figwidth#matplotlib.figure.Figure.set_figheight

注意上面函数的值是英寸。

和坐标轴相关的官方文档：
    - https://matplotlib.org/api/axis_api.html

设置图形离 **Y** 轴的距离：
    - https://matplotlib.org/api/_as_gen/matplotlib.axis.YAxis.set_ticks_position.html#matplotlib.axis.YAxis.set_ticks_position
    - https://matplotlib.org/api/spines_api.html?highlight=spines#matplotlib.spines.Spine.set_position


Y轴沿着X轴左右移动
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: python
    :linenos:

    fig, ax = plt.subplots()
    plt.plot(list(data.index),data)
    plt.yticks(range(0,35000000,2000000))
    #plt.axhspan(2)
    #plt.axhspan(ymin=0, ymax=35000000, xmin=1,)
    fig.set_figwidth(15)
    ax.yaxis.set_ticks_position('left')
    ax.spines['left'].set_position(('data', -1))
    fig.tight_layout()
    plt.show()

Y轴沿着X轴左右移动且Y轴右侧不显示
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: python
    :linenos:

    import pandas as pd
    import matplotlib.pyplot as plt
    data = pd.read_csv('statistic_char.csv',index_col=0)

    fig, ax = plt.subplots()
    #ax = plt.gca()
    plt.plot(list(data.index),data)
    plt.yticks(range(0,35000000,2000000))

    fig.set_figwidth(15)
    fig.tight_layout()
    ax.set_xlim(-1,)
    #ax.yaxis.set_ticks_position('left')
    #ax.spines['left'].set_position(('data', 0))
    plt.show()

X轴沿着Y轴上下移动
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: python
    :linenos:

    fig, ax = plt.subplots()
    plt.plot(list(data.index),data)
    plt.yticks(range(0,35000000,2000000))
    #plt.axhspan(2)
    #plt.axhspan(ymin=0, ymax=35000000, xmin=1,)
    fig.set_figwidth(15)
    ax.xaxis.set_ticks_position('bottom')
    ax.spines['bottom'].set_position(('data', 0))
    fig.tight_layout()
    plt.show()


