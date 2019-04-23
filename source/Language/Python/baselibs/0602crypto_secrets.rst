
.. _python_secrets:

======================================================================================================================================================
:mod:`secrets` --- 生成用于管理秘密的安全随机数（加密服务）
======================================================================================================================================================


.. contents::

secrets
======================================================================================================================================================

用于生成适合于管理密码，账户认证，安全令牌和相关机密等数据的密码强的随机数。

.. code-block:: python 

    # 生成令牌数
    In [23]: import secrets

    In [24]: secrets.token_hex(8)
    Out[24]: 'fc7a82326d332952'

    # 生成8位的字母数字密码

    In [27]: import random

    In [28]: import string
        ...: alphabet = string.ascii_letters + string.digits
        ...: password = ''.join(random.choice(alphabet) for i in range(8))
        ...:

    In [29]: password
    Out[29]: 'U4M4K62h'

    # 生成指定复杂度的密码
    import string
    alphabet = string.ascii_letters + string.digits
    while True:
        password = ''.join(choice(alphabet) for i in range(10))
        if (any(c.islower() for c in password)
                and any(c.isupper() for c in password)
                and sum(c.isdigit() for c in password) >= 3):
            break