
======================================================================================================================================================
数据压缩和归档
======================================================================================================================================================




gzip
======================================================================================================================================================

gzip提供简单的即可去压缩和解压缩。

样例

.. code-block:: python 

    # 读取压缩文件
    import gzip
    with gzip.open("/home/joe/file.txt.gz", "rb") as f:
        file_content = f.read()

    # 创建压缩文件
    import gzip
    content = b"Lots of content here"
    with gzip.open("/home/joe/file.txt.gz", "wb") as f:
        f.write(content)

    # 压缩一个存储的文件
    import gzip
    import shutil
    with open("/home/joe/file.txt", "rb") as f_in:
        with gzip.open("/home/joe/file.txt.gz", "wb") as f_out:
            shutil.copyfileobj(f_in, f_out)
            
    # 压缩二进制字符串
    import gzip
    s_in = b"Lots of content here"
    s_out = gzip.compress(s_in)

