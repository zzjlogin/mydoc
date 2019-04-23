.. _python_random:

======================================================================================================================================================
:mod:`random` --- 生成伪随机数
======================================================================================================================================================

.. contents::

简介及说明
======================================================================================================================================================

这个模块用来生成的随机数一般不用于安全中。

下面是Python3的函数详解

记账函数
======================================================================================================================================================

.. function:: seed(a=None, version=2)

   初始化随机数生成器。

   如果省略了参数 *a* 或者设置为 ``None``，那么会使用当前的系统时间。

   如果 *a* 是整数，则直接使用这个整数a

   version设置为 **2**（默认值）时，如果参数 *a* 是str，bytes或bytearray对象，会将参数a转换为int并使用其所有位。


.. function:: getstate()

    返回捕获生成器当前内部状态的对象。可以传递此对象 :func:`setstate` 用来恢复状态。


.. function:: setstate(state)

    状态应该已经从以前的调用 :func:`getstate` 获取到。*state* 应该是获取到的那个值。

.. function:: getrandbits(k)

    返回一个带有k个随机位的Python整数。


整数函数
======================================================================================================================================================


.. function:: randrange(stop)
              randrange(start, stop[, step])

    随机选取一个值。

    如果只有一个stop，则可以理解为从0到stop（不包括stop）的整数随机选取一个。

    如果有start、stop，则默认增加1的方式从start（包括start）到stop（不包括stop）的整数随机选取一个整数。

    如果有三个参数。则表示从start以step为步长到stop，所有整数随机选取一个。

.. function:: randint(a, b)

    返回一个随机整数 *N* 。这个N的范围： ``a <= N <= b``

    是 ``randrange(a, b+1)`` 的一个别名。


序列的功能
======================================================================================================================================================

.. function:: choice(seq)

    从非空序列 *seq* 随机返回一个元素。如果seq为空，则触发错误：IndexError。


.. function:: choices(population, weights=None, *, cum_weights=None, k=1)

    从列表/集合 *population* 中随机选取 *k* 个元素组成子序列作为返回值。

    如果设置了weights，则说明 *population* 中元素随机选择时的权重不同。weights需要是一个队列，和
    队列 *population* 中元素一一对应。weights队列中的元素是整数，这个整数值并没有打小范围要求。


.. function:: shuffle(x[, random])

    将序列 *x* 打乱。


.. function:: sample(population, k)

    从列表/集合 *population* 中随机选取不重复的k个元素构成一个子列表返回。



实数分布
======================================================================================================================================================





.. function:: random()

   返回一个在 [0.0, 1.0) 的随机值。


.. function:: uniform(a, b)

   返回一个随机的浮点型数字 *N* ，这个N的取值范围是： ``a <= N <= b``

   如果 ``a > b`` ,则 ``b <= N <= a``


   对于 ``b`` 是否包含在这个随机值中，这取依赖函数 ``a + (b-a) * random()``
   的取值。


.. function:: triangular(low, high, mode)

   返回一个随机的浮点型数字 *N* ，它满足 ``low <= N <= high`` 同时
   参数 *mode* 在这两个值之间。参数 *low* 和 *high* 默认是0和1


.. function:: betavariate(alpha, beta)

   Beta 分布。 参数需要满足 ``alpha > 0`` and
   ``beta > 0``. 返回0到1之间的数。


.. function:: expovariate(lambd)

   指数分布。


.. function:: gammavariate(alpha, beta)

   Gamma分布。
   参数需要满足 ``alpha > 0`` and ``beta > 0``.

   概率分布函数是::

                 x ** (alpha - 1) * math.exp(-x / beta)
       pdf(x) =  --------------------------------------
                   math.gamma(alpha) * beta ** alpha


.. function:: gauss(mu, sigma)

   高斯分布。 mu是平均值，*sigma* 是标准偏差。这比 :func:`normalvariate` 下面定义的函数略快

.. function:: lognormvariate(mu, sigma)

   对数自然分布。如果选择自然对数的分布，那么将获得具有平均μ和标准差sigma的正态分布。
   mu可以有任何值，sigma必须大于零。


.. function:: normalvariate(mu, sigma)

   正态分布.  *mu* 是平均值, *sigma* 是标准差.


.. function:: vonmisesvariate(mu, kappa)

   *mu* 是角度值，取值在 0 到 2\*\ *pi*, 参数 *kappa* 必须大于等于0，如果这个参数等于0，
   则会在 0 到 2\*\ *pi* 之间均匀的取出一个值。


.. function:: paretovariate(alpha)

   帕累托分布。 *alpha* 是形状参数。 


.. function:: weibullvariate(alpha, beta)

   威布尔分布。 *alpha* 是scale参数， *beta* 是shape参数 。






