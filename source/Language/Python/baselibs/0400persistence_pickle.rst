
======================================================================================================================================================
数据持久化
======================================================================================================================================================

pickle
======================================================================================================================================================

提供二进制级别的序列化和反序列化。

和json比较

- pickle协议和JSON（JavaScript Object Notation）之间有着根本的区别：
- JSON是一种文本序列化格式（它输出unicode文本，虽然大多数时候它被编码为utf-8），而pickle是一种二进制序列化格式。
- JSON是人类可读的，而pickle不是;
- JSON可以在Python生态系统之外互操作并广泛使用，而pickle则是Python特有的;
- 默认情况下，JSON只能表示Python内置类型的一个子集，并且不包含自定义类; pickle可以代表大量的Python类型。

序列化和反序列号样例： 

.. code-block:: python
    :linenos:

    # 使用dump来将python对象直接dump到文件中去

    import pickle

    # 构造一个python对象
    data = {
        'a': [1, 2.0, 3, 4+6j],
        'b': ("character string", b"byte string"),
        'c': {None, True, False}
    }
    with open('data.pickle', 'wb') as f:
        pickle.dump(data, f, pickle.HIGHEST_PROTOCOL)

    # 使用load来将文件直接load成python对象   
    import pickle
    with open('data.pickle', 'rb') as f:
        # 这个地方就不能在指定版本了，会自动识别的，指定了反而不好。
        data = pickle.load(f)

load接受的是文件描述符，loads接受的是文件的内容，dump接受文件描述符，dumps默认返回str



