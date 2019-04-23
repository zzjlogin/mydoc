.. _python_hashlib:

======================================================================================================================================================
:mod:`hashlib` --- 安全散列和消息摘要（加密服务）
======================================================================================================================================================

.. contents::

hashlib
======================================================================================================================================================


该模块实现了许多不同安全散列和消息摘要算法的通用接口。

.. code-block:: python
    :linenos:

    # 导入
    In [1]: import hashlib

    # 支持的算法
    In [6]: hashlib.algorithms_available
    Out[6]:
    {'DSA',
    'DSA-SHA',
    'MD4',
    'MD5',
    'RIPEMD160',
    'SHA',
    'SHA1',
    'SHA224',
    'SHA256',
    'SHA384',
    'SHA512',
    'blake2b',
    'blake2s',
    'dsaEncryption',
    'dsaWithSHA',
    'ecdsa-with-SHA1',
    'md4',
    'md5',
    'ripemd160',
    'sha',
    'sha1',
    'sha224',
    'sha256',
    'sha384',
    'sha3_224',
    'sha3_256',
    'sha3_384',
    'sha3_512',
    'sha512',
    'shake_128',
    'shake_256',
    'whirlpool'}

    # 获取数字签名
    In [5]:  hashlib.sha224(b"Nobody inspects the spammish repetition").hexdigest()
    Out[5]: 'a4337bc45a8fc544c03f52dc550cd6e1e87021bc896588bd79e901e2'

    # 使用string构造，并签名数据。
    In [12]: h = hashlib.new("sha224")

    #  m.update(a); m.update(b) 相当于 m.update(a+b).
    In [13]: h.update(b"Nobody inspects the spammish repetition")

    In [15]: h.hexdigest()
    Out[15]: 'a4337bc45a8fc544c03f52dc550cd6e1e87021bc896588bd79e901e2'

    # blake2b数字签名
    In [18]: from hashlib import blake2b

    In [19]: items = [b'hello',b' ',b'world']

    In [20]: h=blake2b()

    In [21]: for item in items:
        ...:     h.update(item)
        ...:

    In [22]: h.hexdigest()
    Out[22]: '021ced8799296ceca557832ab941a50b4a11f83478cf141f51f933f653ab9fbcc05a037cddbed06e309bf334942c4e58cdf1a46e237911ccd7fcf9787cbc7fd0'

