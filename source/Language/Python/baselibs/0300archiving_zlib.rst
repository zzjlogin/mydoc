.. _python_zlib:

======================================================================================================================================================
:mod:`zlib` --- 与gzip兼容的压缩
======================================================================================================================================================

.. contents::

zlib实例
======================================================================================================================================================

字符串压缩解压
------------------------------------------------------------------------------------------------------------------------------------------------------

::

    import zlib
    message = 'abcd1234'
    compressed = zlib.compress(message)
    decompressed = zlib.decompress(compressed)

    print('original:', repr(message))
    print('compressed:', repr(compressed))
    print('decompressed:', repr(decompressed))

文件压缩解压
------------------------------------------------------------------------------------------------------------------------------------------------------

::

    import zlib
    
    def compress(infile, dst, level=9):
        infile = open(infile, 'rb')
        dst = open(dst, 'wb')
        compress = zlib.compressobj(level)
        data = infile.read(1024)
        while data:
            dst.write(compress.compress(data))
            data = infile.read(1024)
        dst.write(compress.flush())

    def decompress(infile, dst):
        infile = open(infile, 'rb')
        dst = open(dst, 'wb')
        decompress = zlib.decompressobj()
        data = infile.read(1024)
        while data:
            dst.write(decompress.decompress(data))
            data = infile.read(1024)
        dst.write(decompress.flush())

    if __name__ == "__main__":
        compress('in.txt', 'out.txt')
        decompress('out.txt', 'out_decompress.txt')


zlib详解
======================================================================================================================================================

zlib压缩使用gzip工具解压缩的。
    - zlib参考：http://www.zlib.net.
    - zlib手册：http://www.zlib.net/manual.html 


.. exception:: error

   压缩/解压缩错误引发的错误。


.. function:: adler32(data[, value])



.. function:: compress(data, level=-1)

   压缩 *data*,压缩级别默认是1，可以设置的范围``0`` to ``9`` or ``-1``
   

   .. versionchanged:: 3.6
      *level* can now be used as a keyword parameter.


.. function:: compressobj(level=-1, method=DEFLATED, wbits=MAX_WBITS, memLevel=DEF_MEM_LEVEL, strategy=Z_DEFAULT_STRATEGY[, zdict])

   返回一个压缩对象，不会一次把内存数据都压缩。



.. function:: crc32(data[, value])

   .. index::
      single: Cyclic Redundancy Check
      single: checksum; Cyclic Redundancy Check


.. function:: decompress(data, wbits=MAX_WBITS, bufsize=DEF_BUF_SIZE)


.. function:: decompressobj(wbits=MAX_WBITS[, zdict])



.. method:: Compress.compress(data)


.. method:: Compress.flush([mode])


.. method:: Compress.copy()


.. attribute:: Decompress.unused_data



.. attribute:: Decompress.unconsumed_tail


.. attribute:: Decompress.eof

   .. versionadded:: 3.3


.. method:: Decompress.decompress(data, max_length=0)


   .. versionchanged:: 3.6
      *max_length* can be used as a keyword argument.


.. method:: Decompress.flush([length])


.. method:: Decompress.copy()


.. data:: ZLIB_VERSION


.. data:: ZLIB_RUNTIME_VERSION


   .. versionadded:: 3.3




