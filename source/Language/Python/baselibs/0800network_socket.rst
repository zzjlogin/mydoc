.. _python_socket:

======================================================================================================================================================
:mod:`socket` --- 低级别网络接口(套接字)
======================================================================================================================================================

.. contents::

简介
======================================================================================================================================================

这个模块允许访问BSD套接字接口（BSD socket interface）。
这个接口可以在Unix、Windows、MacOS系统，或者便携式平台（probably additional platforms）

可以参考对这个模块进行了封装的模块和安全层相关的模块：
    - socketserver
    - ssl




Constants常量及含义
======================================================================================================================================================


family参数指的是host的种类：
    - AF_UNIX
        也叫AF_LOCAL,基于本地文件的
    - AF_NETLINK
        这是linux系统支持的一种套接字
    - AF_INET
        这个套接字是基于网络的，对于IPV4协议的TCP和UDP（常用）
    - AF_INET6
        这个套接字是基于网络的，对于IPV6协议的TCP和UDP

type参数指的是套接字类型：
    - SOCK_STREAM
        流套接字，使用TCP socket（常用）
    - SOCK_DGRAM
        数据包问套接字，使用UDP socket（常用）
    - SOCK_RAW
        raw套接字

创建TCP Socket：
    s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)

创建UDP Socket：
    s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)


模块内置函数
======================================================================================================================================================


创建sockets
''''''''''''''''

The following functions all create :ref:`socket objects <socket-objects>`.


.. function:: socket(family=AF_INET, type=SOCK_STREAM, proto=0, fileno=None)

   创建一个新的socket

   .. versionchanged:: 3.3
      The AF_CAN family was added.
      The AF_RDS family was added.

   .. versionchanged:: 3.4
       The CAN_BCM protocol was added.

   .. versionchanged:: 3.4
      The returned socket is now non-inheritable.

   .. versionchanged:: 3.7
       The CAN_ISOTP protocol was added.

   .. versionchanged:: 3.7
      When :const:`SOCK_NONBLOCK` or :const:`SOCK_CLOEXEC`
      bit flags are applied to *type* they are cleared, and
      :attr:`socket.type` will not reflect them.  They are still passed
      to the underlying system `socket()` call.  Therefore::

          sock = socket.socket(
              socket.AF_INET,
              socket.SOCK_STREAM | socket.SOCK_NONBLOCK)



.. function:: socketpair([family[, type[, proto]]])




   .. versionchanged:: 3.2
      The returned socket objects now support the whole socket API, rather
      than a subset.

   .. versionchanged:: 3.4
      The returned sockets are now non-inheritable.

   .. versionchanged:: 3.5
      Windows support added.


.. function:: create_connection(address[, timeout[, source_address]])

   和*address* (一个二元的元组 ``(host, port)``)建立TCP连接。
   然后返回一个socket对象。这个函数的级别层次比 :meth:`socket.connect` 高。

   .. versionchanged:: 3.2
      *source_address* was added.


.. function:: fromfd(fd, family, type, proto=0)

   

.. function:: fromshare(data)

   从 :meth:`socket.share` 的对象获取数据。

   .. availability:: Windows.

   .. versionadded:: 3.3


.. data:: SocketType

   返回socket对象类型，和 ``type(socket(...))`` 相同。


Other functions
'''''''''''''''

The :mod:`socket` module also offers various network-related services:


.. function:: close(fd)

   Close a socket file descriptor. This is like :func:`os.close`, but for
   sockets. On some platforms (most noticeable Windows) :func:`os.close`
   does not work for socket file descriptors.

   .. versionadded:: 3.7

.. function:: getaddrinfo(host, port, family=0, type=0, proto=0, flags=0)

    将 ``host/port`` 转化为创建一个连接到那个服务的socket所需的一个包含必要参数的5元元祖的序列。
    
    host是一个域名、一个IPv4或IPv6字符串或None。
    
    port是一个字符串服务名类似："http"、数字化的port或None。
    
    对于host/port为None,会转化为底层C中的Null
    
    family、sockettype、proto：是可选参数，用来筛选返回值。默认情况下，它们的值为0。
    意味着全部结果都被选中。
    
    flags：可以决定结果怎样被计算和返回。flags默认值为0.例如：AI_NUMERICHOST将会不支持域名，否则会报错。
    
    result是如以下格式的5元元组：
        (family,socktype,proto,canonname,sockaddr)
    
    family,socktype,proto都是integer。将会被转化为socket()方法。
    如果AI_CANONNAME是flags之一。canonname将会表示主机canonname的字符串。
    否则canonname将会为empty。sockadd是一个描述socket地址的元祖。
    如果是AF_INET则格式为：(address,port)，如果为AF_INET6，则返回(address,port,flow info,scope id)
   
   ::

      >>> socket.getaddrinfo("example.org", 80, proto=socket.IPPROTO_TCP)
      [(<AddressFamily.AF_INET6: 10>, <SocketType.SOCK_STREAM: 1>,
       6, '', ('2606:2800:220:1:248:1893:25c8:1946', 80, 0, 0)),
       (<AddressFamily.AF_INET: 2>, <SocketType.SOCK_STREAM: 1>,
       6, '', ('93.184.216.34', 80))]

   .. versionchanged:: 3.2
      parameters can now be passed using keyword arguments.

   .. versionchanged:: 3.7
      for IPv6 multicast addresses, string representing an address will not
      contain ``%scope`` part.

.. function:: getfqdn([name])

    返回一个name对应的完全合格的域名。如果name被忽略，将会被解释为本地主机。为了找到合格的域名，将会检查gethostbyaddr()返回的主机名称，以及随之而来的别名。
    
    如果可用，第一个名称将会被选中。当没有任何一个合格的域名可用时，将会把gethostname()的返回值作为返回值


.. function:: gethostbyname(hostname)

   将hostname转化为IPv4格式的字符串。例如：100.50.200.5。如果hostname本身就是一个ipv4格式的字符串，则原值返回。

   gethostbyname()不支持IPv6。 getaddrinfo()应该被用来代替ipv4/v6双重支持


.. function:: gethostbyname_ex(hostname)

   将hostname转化为IPV4格式。 是gethostbyname(hostname)的一个扩展接口.

   返回一个三元组(hostname,aliaslist,ipaddrlist) 
   
   hostname是对应ipaddress的给定的原始主机名。

   aliaslist是相同地址可供选择的主机名列表。可能为空。
   
   ipaddrlist是相同主机相同接口对应的ipv4地址列表。


.. function:: gethostname()

   返回正在执行python解释器的主机名的字符串

   如果想要知道当前的主机IP，可以使用：gethostbyname(gethostname())，
   但是windows多个网卡时会返回环回接口IP。



.. function:: gethostbyaddr(ip_address)

   return三元组：(hostname,aliaslist,ipaddrlist)

   gethostbyaddress()对于ipv4和ipv6都支持。


.. function:: getnameinfo(sockaddr, flags)

    将sockaddr转换为2元祖：(host,port)。
    
    由flags决定结果包含全规格的域名还是数字化的指向主机的地址。
    
    port可以包含一个字符串端口名或数字型的端口号。

.. function:: getprotobyname(protocolname)

    将网络协议名称转化为适合传递的常数。
    
    就像socket()函数中的第三个可选的参数。 仅仅会被以SOCK_RAW模式打开的socket需要。
    对于普通的socket模式，如果protocol为0或被忽略时，正确的协议会被自动选择


.. function:: getservbyname(servicename[, protocolname])

    将网络服务名和协议名转化为这个服务对应的端口号。
    
    可选的协议名为：tcp和 udp 或其他可以匹配的任何协议
    
    protocolname是可选参数



.. function:: getservbyport(port[, protocolname])

   将网络端口号和协议名转化为那个服务的服务名。
   
   protocolname为类似："tcp"  upd" 之类的可匹配的协议


.. function:: ntohl(x)

   将网络上的32bit的正整数转化为主机字节顺序。当主机字节顺序和网络字节顺序一致时，
   没有任何操作。否则执行一个4bit的转换操作


.. function:: ntohs(x)

   将网络上的16bit的正整数转化为主机字节顺序。当主机字节顺序和网络字节顺序一致时，
   没有任何操作。否则执行一个2bit的转换操作


.. function:: htonl(x)

   将本机的32bit的正整数转化为网络字节顺序。当主机字节顺序和网络字节顺序一致时，
   没有任何操作。否则执行一个4bit的转换操作


.. function:: htons(x)

   将主机上的16bit的正整数转化为主机字节顺序。当主机字节顺序和网络字节顺序一致时，
   没有任何操作。否则执行一个2bit的转换操作


.. function:: inet_aton(ip_string)

   


.. function:: inet_ntoa(packed_ip)

   

   .. versionchanged:: 3.5
      Writable :term:`bytes-like object` is now accepted.


.. function:: inet_pton(address_family, ip_string)

   

   .. availability:: Unix (maybe not all platforms), Windows.

   .. versionchanged:: 3.4
      Windows support added


.. function:: inet_ntop(address_family, packed_ip)

   

   .. availability:: Unix (maybe not all platforms), Windows.

   .. versionchanged:: 3.4
      Windows support added

   .. versionchanged:: 3.5
      Writable :term:`bytes-like object` is now accepted.




.. function:: CMSG_LEN(length)



   .. availability:: most Unix platforms, possibly others.

   .. versionadded:: 3.3


.. function:: CMSG_SPACE(length)

   返回 :meth:`~socket.recvmsg` 的缓存大小。

   .. availability:: most Unix platforms, possibly others.

   .. versionadded:: 3.3


.. function:: getdefaulttimeout()

   返回默认的超时时间。


.. function:: setdefaulttimeout(timeout)

   设置链接默认的超时时间。


.. function:: sethostname(name)

   设置主机名，如果没有足够的权限会触发错误： :exc:`OSError`

   .. availability:: Unix.

   .. versionadded:: 3.3


.. function:: if_nameindex()

   返回网络接口信息列表， (index int, name string) tuples.
   
   如果系统调用错误，会触发错误：:exc:`OSError` 

   .. availability:: Unix.

   .. versionadded:: 3.3


.. function:: if_nametoindex(if_name)

   返回与接口名称对应的网络接口索引号。如果不存在具有给定名称的接口，
   则触发 :exc:`OSError`

   .. availability:: Unix.

   .. versionadded:: 3.3


.. function:: if_indextoname(if_index)

   返回与接口索引号对应的网络接口名称。如果不存在与给定索引的接口
   则触发 :exc:`OSError`。

   .. availability:: Unix.

   .. versionadded:: 3.3


.. _socket-objects:

Socket Objects
======================================================================================================================================================


socket对象的方法

socket对象的创建方法：
    sk = socket.socket()

下面这些方法除了 ``makefile()`` 以外都适用于Unix系统。


.. versionchanged:: 3.2
   Support for the :term:`context manager` protocol was added.  Exiting the
   context manager is equivalent to calling :meth:`~socket.close`.


.. method:: socket.accept()

   接受连接。套接字必须绑定到一个地址并侦听连接。
   返回值是一对 ``(conn, address)`` ，其中conn是一个新的套接字对象，
   用于在连接上发送和接收数据，address是绑定到连接另一端套接字的地址。

   The newly created socket is :ref:`non-inheritable <fd_inheritance>`.

   .. versionchanged:: 3.4
      The socket is now non-inheritable.

   .. versionchanged:: 3.5
      If the system call is interrupted and the signal handler does not raise
      an exception, the method now retries the system call instead of raising
      an :exc:`InterruptedError` exception (see :pep:`475` for the rationale).


.. method:: socket.bind(address)

   把这个socket绑定到指定 *address* 。套接字必须尚未绑定。在AF_INET下,以元组（host,port）的形式表示地址。


.. method:: socket.close()

   显示的关闭socket链接。关闭后链接的所有后续操作都会失败。

   当套接字被垃圾收集时，套接字会自动关闭，但是建议显式地关闭它们，或者在它们周围使用 ``with`` 语句。

   .. versionchanged:: 3.6
      :exc:`OSError` is now raised if an error occurs when the underlying
      :c:func:`close` call is made.

   .. note::

      ``socket.close()`` 后socket不会立即释放，如果想要立即释放，可以在后面立即执行 ``socket.shutdown()``


.. method:: socket.connect(address)

   和IP地址为： *address* ，的主机建立远程连接。


.. method:: socket.connect_ex(address)

   和 ``socket.connect(address)`` 类似。但是成功返回0，失败返回errno的值。


.. method:: socket.detach()

   将套接字对象置于关闭状态，而不实际关闭底层文件描述符。返回文件描述符，并可重用于其他目的。

   .. versionadded:: 3.2


.. method:: socket.dup()

   重复的套接字。



.. method:: socket.fileno()

   Return the socket's file descriptor (a small integer), or -1 on failure. This
   is useful with :func:`select.select`.

   Under Windows the small integer returned by this method cannot be used where a
   file descriptor can be used (such as :func:`os.fdopen`).  Unix does not have
   this limitation.

.. method:: socket.get_inheritable()

   获取套接字的文件描述符或套接字句柄的可继承标志:
   如果套接字可以在子进程中继承，则为 ``True`` ;如果不能，则为 ``False`` 。

   .. versionadded:: 3.4


.. method:: socket.getpeername()

   返回套接字连接到的远程地址。这对于查找远程IPv4/v6套接字的端口号很有用。
   某些系统这个功能不可用。


.. method:: socket.getsockname()

   返回套接字自己的地址。这对于查找IPv4/v6套接字的端口号很有用。通常是一个元组(ipaddr,port)


.. method:: socket.getsockopt(level, optname[, buflen])

   返回给定套接字选项的值。

.. method:: socket.getblocking()

   如果套接字处于阻塞模式，返回 ``True``;如果非阻塞模式，返回 ``False``。

   This is equivalent to checking ``socket.gettimeout() == 0``.

   .. versionadded:: 3.7


.. method:: socket.gettimeout()

   返回当前超时期的值，单位是秒，如果没有设置超时期，则返回 ``None`` .


.. method:: socket.ioctl(control, option)

   :platform: Windows

   The :meth:`ioctl` method is a limited interface to the WSAIoctl system
   interface.  Please refer to the `Win32 documentation
   <https://msdn.microsoft.com/en-us/library/ms741621%28VS.85%29.aspx>`_ for more
   information.

   On other platforms, the generic :func:`fcntl.fcntl` and :func:`fcntl.ioctl`
   functions may be used; they accept a socket object as their first argument.

   Currently only the following control codes are supported:
   ``SIO_RCVALL``, ``SIO_KEEPALIVE_VALS``, and ``SIO_LOOPBACK_FAST_PATH``.

   .. versionchanged:: 3.6
      ``SIO_LOOPBACK_FAST_PATH`` was added.

.. method:: socket.listen([backlog])

   Enable a server to accept connections.  If *backlog* is specified, it must
   be at least 0 (if it is lower, it is set to 0); it specifies the number of
   unaccepted connections that the system will allow before refusing new
   connections. If not specified, a default reasonable value is chosen.

   .. versionchanged:: 3.5
      The *backlog* parameter is now optional.

.. method:: socket.makefile(mode='r', buffering=None, *, encoding=None, \
                            errors=None, newline=None)



.. method:: socket.recv(bufsize[, flags])

    接受TCP套接字的数据。一次性接收的最大数据量由bufsize指定， 参数flags通常忽略。


.. method:: socket.recvfrom(bufsize[, flags])

    接受UDP套接字的数据。与recv()类似，但返回值是（data,address）。其中data是包含接收数据的字符串，address是发送数据的套接字地址。


.. method:: socket.recvmsg(bufsize[, ancbufsize[, flags]])

   
   ::

      import socket, array

      def recv_fds(sock, msglen, maxfds):
          fds = array.array("i")   # Array of ints
          msg, ancdata, flags, addr = sock.recvmsg(msglen, socket.CMSG_LEN(maxfds * fds.itemsize))
          for cmsg_level, cmsg_type, cmsg_data in ancdata:
              if (cmsg_level == socket.SOL_SOCKET and cmsg_type == socket.SCM_RIGHTS):
                  # Append data, ignoring any truncated integers at the end.
                  fds.fromstring(cmsg_data[:len(cmsg_data) - (len(cmsg_data) % fds.itemsize)])
          return msg, list(fds)

   .. availability:: most Unix platforms, possibly others.

   .. versionadded:: 3.3

   .. versionchanged:: 3.5
      If the system call is interrupted and the signal handler does not raise
      an exception, the method now retries the system call instead of raising
      an :exc:`InterruptedError` exception (see :pep:`475` for the rationale).


.. method:: socket.recvmsg_into(buffers[, ancbufsize[, flags]])

   
   
   Example::

      >>> import socket
      >>> s1, s2 = socket.socketpair()
      >>> b1 = bytearray(b'----')
      >>> b2 = bytearray(b'0123456789')
      >>> b3 = bytearray(b'--------------')
      >>> s1.send(b'Mary had a little lamb')
      22
      >>> s2.recvmsg_into([b1, memoryview(b2)[2:9], b3])
      (22, [], 0, None)
      >>> [b1, b2, b3]
      [bytearray(b'Mary'), bytearray(b'01 had a 9'), bytearray(b'little lamb---')]

   .. availability:: most Unix platforms, possibly others.

   .. versionadded:: 3.3


.. method:: socket.recvfrom_into(buffer[, nbytes[, flags]])

   迭代取出接收到的数据。
   


.. method:: socket.recv_into(buffer[, nbytes[, flags]])

   接收套接字中收到的指定大小的内容。
   


.. method:: socket.send(bytes[, flags])

   将bytes中的数据发送到连接的套接字。返回值是要发送的字节数量，
   该数量可能小于bytes的字节大小。即：可能未将指定内容全部发送。

   .. versionchanged:: 3.5
      If the system call is interrupted and the signal handler does not raise
      an exception, the method now retries the system call instead of raising
      an :exc:`InterruptedError` exception (see :pep:`475` for the rationale).


.. method:: socket.sendall(bytes[, flags])

   迭代的方式发送bytes，内部还是调用 ``socket.send()``，发送完成返回None，否则会
   触发错误。

   .. versionchanged:: 3.5
      The socket timeout is no more reset each time data is sent successfully.
      The socket timeout is now the maximum total duration to send all data.

   .. versionchanged:: 3.5
      If the system call is interrupted and the signal handler does not raise
      an exception, the method now retries the system call instead of raising
      an :exc:`InterruptedError` exception (see :pep:`475` for the rationale).


.. method:: socket.sendto(bytes, address)
            socket.sendto(bytes, flags, address)

   将数据发送到address，其中address一般的格式是：``(ipaddr，port)`` 的元组

   .. versionchanged:: 3.5
      If the system call is interrupted and the signal handler does not raise
      an exception, the method now retries the system call instead of raising
      an :exc:`InterruptedError` exception (see :pep:`475` for the rationale).


.. method:: socket.sendmsg(buffers[, ancdata[, flags[, address]]])

   
   ::

      import socket, array

      def send_fds(sock, msg, fds):
          return sock.sendmsg([msg], [(socket.SOL_SOCKET, socket.SCM_RIGHTS, array.array("i", fds))])

   .. availability:: most Unix platforms, possibly others.

   .. versionadded:: 3.3

   .. versionchanged:: 3.5
      If the system call is interrupted and the signal handler does not raise
      an exception, the method now retries the system call instead of raising
      an :exc:`InterruptedError` exception (see :pep:`475` for the rationale).

.. method:: socket.sendmsg_afalg([msg], *, op[, iv[, assoclen[, flags]]])

   套接字常量为 :const:`AF_ALG` 时，对应的 :meth:`~socket.sendmsg` 方法。
   
   IV, AEAD 与套接字常量 :const:`AF_ALG` 关联数据长度和标志 并设置模式 

   .. availability:: Linux >= 2.6.38.

   .. versionadded:: 3.6

.. method:: socket.sendfile(file, offset=0, count=None)

   发送一个文件，直到使用高性能操作系统到达EOF。并返回已发送的总字节数。
   文件必须是在二进制模式下打开的常规文件对象。
   如果操作系统的 ``sendfile``不可用(例如Windows)或 *file* 不是常规文件,则 ``send()``将被使用。

   .. versionadded:: 3.5

.. method:: socket.set_inheritable(inheritable)

   设置套接字的文件描述符或套接字句柄的可继承标志。

   .. versionadded:: 3.4


.. method:: socket.setblocking(flag)

   设置套接字的阻塞或非阻塞模式:
        - 如果标志为 *false*，套接字设置为非阻塞，否则设置为阻塞模式。
        

   * ``sock.setblocking(True)`` 等价于 ``sock.settimeout(None)``

   * ``sock.setblocking(False)`` 等价于 ``sock.settimeout(0.0)``

   .. versionchanged:: 3.7
      The method no longer applies :const:`SOCK_NONBLOCK` flag on
      :attr:`socket.type`.


.. method:: socket.settimeout(value)

   设置阻塞套接字操作的超时。value值可以设置成非负浮点数或者None。



   .. versionchanged:: 3.7
      The method no longer toggles :const:`SOCK_NONBLOCK` flag on
      :attr:`socket.type`.


.. method:: socket.setsockopt(level, optname, value: int)
.. method:: socket.setsockopt(level, optname, value: buffer)
.. method:: socket.setsockopt(level, optname, None, optlen: int)

   .. index:: module: struct

   设置给定套接字选项的值

   .. versionchanged:: 3.5
      Writable :term:`bytes-like object` is now accepted.

   .. versionchanged:: 3.6
      setsockopt(level, optname, None, optlen: int) form added.


.. method:: socket.shutdown(how)

    关闭这个半连接。

    *how* 可选值：
        - :const:`SHUT_RD`：不会继续接收
        - :const:`SHUT_WR`：不会继续发送
        - :const:`SHUT_RDWR`, 不再继续发送和接收


.. method:: socket.share(process_id)

   和进程 *process_id* 共享socket，共享方法是复制一个socket然后返回字节对象。
   对象交互的方法可通过 :func:`fromshare` 重新创建。

   .. availability:: Windows.

   .. versionadded:: 3.3







.. _socket-example:

Example
-------

Here are four minimal example programs using the TCP/IP protocol: a server that
echoes all data that it receives back (servicing only one client), and a client
using it.  Note that a server must perform the sequence :func:`.socket`,
:meth:`~socket.bind`, :meth:`~socket.listen`, :meth:`~socket.accept` (possibly
repeating the :meth:`~socket.accept` to service more than one client), while a
client only needs the sequence :func:`.socket`, :meth:`~socket.connect`.  Also
note that the server does not :meth:`~socket.sendall`/:meth:`~socket.recv` on
the socket it is listening on but on the new socket returned by
:meth:`~socket.accept`.

The first two examples support IPv4 only. ::

   # Echo server program
   import socket

   HOST = ''                 # Symbolic name meaning all available interfaces
   PORT = 50007              # Arbitrary non-privileged port
   with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
       s.bind((HOST, PORT))
       s.listen(1)
       conn, addr = s.accept()
       with conn:
           print('Connected by', addr)
           while True:
               data = conn.recv(1024)
               if not data: break
               conn.sendall(data)

::

   # Echo client program
   import socket

   HOST = 'daring.cwi.nl'    # The remote host
   PORT = 50007              # The same port as used by the server
   with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
       s.connect((HOST, PORT))
       s.sendall(b'Hello, world')
       data = s.recv(1024)
   print('Received', repr(data))

The next two examples are identical to the above two, but support both IPv4 and
IPv6. The server side will listen to the first address family available (it
should listen to both instead). On most of IPv6-ready systems, IPv6 will take
precedence and the server may not accept IPv4 traffic. The client side will try
to connect to the all addresses returned as a result of the name resolution, and
sends traffic to the first one connected successfully. ::

   # Echo server program
   import socket
   import sys

   HOST = None               # Symbolic name meaning all available interfaces
   PORT = 50007              # Arbitrary non-privileged port
   s = None
   for res in socket.getaddrinfo(HOST, PORT, socket.AF_UNSPEC,
                                 socket.SOCK_STREAM, 0, socket.AI_PASSIVE):
       af, socktype, proto, canonname, sa = res
       try:
           s = socket.socket(af, socktype, proto)
       except OSError as msg:
           s = None
           continue
       try:
           s.bind(sa)
           s.listen(1)
       except OSError as msg:
           s.close()
           s = None
           continue
       break
   if s is None:
       print('could not open socket')
       sys.exit(1)
   conn, addr = s.accept()
   with conn:
       print('Connected by', addr)
       while True:
           data = conn.recv(1024)
           if not data: break
           conn.send(data)

::

   # Echo client program
   import socket
   import sys

   HOST = 'daring.cwi.nl'    # The remote host
   PORT = 50007              # The same port as used by the server
   s = None
   for res in socket.getaddrinfo(HOST, PORT, socket.AF_UNSPEC, socket.SOCK_STREAM):
       af, socktype, proto, canonname, sa = res
       try:
           s = socket.socket(af, socktype, proto)
       except OSError as msg:
           s = None
           continue
       try:
           s.connect(sa)
       except OSError as msg:
           s.close()
           s = None
           continue
       break
   if s is None:
       print('could not open socket')
       sys.exit(1)
   with s:
       s.sendall(b'Hello, world')
       data = s.recv(1024)
   print('Received', repr(data))


The next example shows how to write a very simple network sniffer with raw
sockets on Windows. The example requires administrator privileges to modify
the interface::

   import socket

   # the public network interface
   HOST = socket.gethostbyname(socket.gethostname())

   # create a raw socket and bind it to the public interface
   s = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_IP)
   s.bind((HOST, 0))

   # Include IP headers
   s.setsockopt(socket.IPPROTO_IP, socket.IP_HDRINCL, 1)

   # receive all packages
   s.ioctl(socket.SIO_RCVALL, socket.RCVALL_ON)

   # receive a package
   print(s.recvfrom(65565))

   # disabled promiscuous mode
   s.ioctl(socket.SIO_RCVALL, socket.RCVALL_OFF)

The next example shows how to use the socket interface to communicate to a CAN
network using the raw socket protocol. To use CAN with the broadcast
manager protocol instead, open a socket with::

    socket.socket(socket.AF_CAN, socket.SOCK_DGRAM, socket.CAN_BCM)

After binding (:const:`CAN_RAW`) or connecting (:const:`CAN_BCM`) the socket, you
can use the :meth:`socket.send`, and the :meth:`socket.recv` operations (and
their counterparts) on the socket object as usual.

This last example might require special privileges::

   import socket
   import struct


   # CAN frame packing/unpacking (see 'struct can_frame' in <linux/can.h>)

   can_frame_fmt = "=IB3x8s"
   can_frame_size = struct.calcsize(can_frame_fmt)

   def build_can_frame(can_id, data):
       can_dlc = len(data)
       data = data.ljust(8, b'\x00')
       return struct.pack(can_frame_fmt, can_id, can_dlc, data)

   def dissect_can_frame(frame):
       can_id, can_dlc, data = struct.unpack(can_frame_fmt, frame)
       return (can_id, can_dlc, data[:can_dlc])


   # create a raw socket and bind it to the 'vcan0' interface
   s = socket.socket(socket.AF_CAN, socket.SOCK_RAW, socket.CAN_RAW)
   s.bind(('vcan0',))

   while True:
       cf, addr = s.recvfrom(can_frame_size)

       print('Received: can_id=%x, can_dlc=%x, data=%s' % dissect_can_frame(cf))

       try:
           s.send(cf)
       except OSError:
           print('Error sending CAN frame')

       try:
           s.send(build_can_frame(0x01, b'\x01\x02\x03'))
       except OSError:
           print('Error sending CAN frame')

Running an example several times with too small delay between executions, could
lead to this error::

   OSError: [Errno 98] Address already in use

This is because the previous execution has left the socket in a ``TIME_WAIT``
state, and can't be immediately reused.

There is a :mod:`socket` flag to set, in order to prevent this,
:data:`socket.SO_REUSEADDR`::

   s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
   s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
   s.bind((HOST, PORT))

the :data:`SO_REUSEADDR` flag tells the kernel to reuse a local socket in
``TIME_WAIT`` state, without waiting for its natural timeout to expire.


.. seealso::

   For an introduction to socket programming (in C), see the following papers:

   - *An Introductory 4.3BSD Interprocess Communication Tutorial*, by Stuart Sechrest

   - *An Advanced 4.3BSD Interprocess Communication Tutorial*, by Samuel J.  Leffler et
     al,

   both in the UNIX Programmer's Manual, Supplementary Documents 1 (sections
   PS1:7 and PS1:8).  The platform-specific reference material for the various
   socket-related system calls are also a valuable source of information on the
   details of socket semantics.  For Unix, refer to the manual pages; for Windows,
   see the WinSock (or Winsock 2) specification.  For IPv6-ready APIs, readers may
   want to refer to :rfc:`3493` titled Basic Socket Interface Extensions for IPv6.
