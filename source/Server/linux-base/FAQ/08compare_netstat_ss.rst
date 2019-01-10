.. _linux-faq-compare-netstat-ss:

======================================================================================================================================================
netstat和ss性能比较
======================================================================================================================================================

两个工具简介
======================================================================================================================================================

netstat命令是net-tools工具集中的一员，这个工具一般linux系统会默认安装的；

ss命令是iproute工具集中的一员；

net-tools是一套标准的Unix网络工具，用于配置网络接口、设置路由表信息、管理ARP表、显示和统计各类网络信息等等，但是遗憾的是，这个工具自2001年起便不再更新和维护了。

iproute，这是一套可以支持IPv4/IPv6网络的用于管理TCP/UDP/IP网络的工具集

net-tools下载地址: https://sourceforge.net/projects/net-tools/
iproute下载地址: https://pkgs.org/download/iproute

如果没有ss命令，可以如下安装：

.. code-block:: bash
    :linenos:

    [root@wang ~]# yum install iproute iproute-doc


netstat效率比ss高的原因
======================================================================================================================================================


1. 当服务器的socket连接数量变得非常大时，无论是使用 ``netstat`` 命令还是直接 ``cat /proc/net/tcp`` ，执行速度都会很慢。可能你不会有切身的感受，但请相信我，当服务器维持的连接达到上万个的时候，使用 ``netstat`` 等于浪费 生命，而用ss才是节省时间。
2. ss快的秘诀在于它利用到了TCP协议栈中tcp_diag。tcp_diag是一个用于分析统计的模块，可以获得Linux内核中第一手的信息，这就确保了ss的快捷高效。当然，如果你的系统中没有tcp_diag，ss也可以正常运行，只是效率会变得稍慢（但仍然比 netstat要快）。


netstat和ss效率对比
======================================================================================================================================================

ss命令常用参数：

-a 查看机器的socket连接数
-l 查看机器的端口情况
-s 查看机器的网络连接数

常用组合:

-pl 列出具体的程序名称
-ta 只查看TCP sockets
-ua 只查看UDP sockets
-wa 只查看RAW sockets
-xa 只查看UNIX sockets



netstat各种状态：

.. code-block:: text
    :linenos:

    CLOSED         初始（无连接）状态。
    LISTEN         侦听状态，等待远程机器的连接请求。
    SYN_SEND       在TCP三次握手期间，主动连接端发送了SYN包后，进入SYN_SEND状态，等待对方的ACK包。
    SYN_RECV       在TCP三次握手期间，主动连接端收到SYN包后，进入SYN_RECV状态。
    ESTABLISHED    完成TCP三次握手后，主动连接端进入ESTABLISHED状态。此时，TCP连接已经建立，可以进行通信。
    FIN_WAIT_1     在TCP四次挥手时，主动关闭端发送FIN包后，进入FIN_WAIT_1状态。
    FIN_WAIT_2     在TCP四次挥手时，主动关闭端收到ACK包后，进入FIN_WAIT_2状态。
    TIME_WAIT      在TCP四次挥手时，主动关闭端发送了ACK包之后，进入TIME_WAIT状态，等待最多MSL时间，让被动关闭端收到ACK包。
    CLOSING        在TCP四次挥手期间，主动关闭端发送了FIN包后，没有收到对应的ACK包，却收到对方的FIN包，此时，进入CLOSING状态。
    CLOSE_WAIT     在TCP四次挥手期间，被动关闭端收到FIN包后，进入CLOSE_WAIT状态。
    LAST_ACK       在TCP四次挥手时，被动关闭端发送FIN包后，进入LAST_ACK状态，等待对方的ACK包。
    
    主动连接端可能的状态有：    CLOSED        SYN_SEND        ESTABLISHED
    主动关闭端可能的状态有：    FIN_WAIT_1    FIN_WAIT_2      TIME_WAIT
    被动连接端可能的状态有：    LISTEN        SYN_RECV        ESTABLISHED
    被动关闭端可能的状态有：    CLOSE_WAIT    LAST_ACK        CLOSED


