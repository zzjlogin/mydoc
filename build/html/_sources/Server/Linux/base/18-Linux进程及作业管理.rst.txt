Linux进程及作业管理
========================================

进程通信方法： 

同一个主机： 

- signal
- shm
- semerphor

不同主机：

- rpc 

进程分类

守护进程
    在系统引导过程中启动的进程，和终端无关
前台进程
    跟终端有关，通过终端启动的进程

进程的状态

- 运行态
- 就绪态
- 睡眠态
- 僵死态
- 停止态


进程管理
----------------------------------------------------------------

ps
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
用于查看系统当前进程的运行情况

选项和参数

-A      所有进程列出来
-a      和终端无关的所有进程
-u      与用户相关的进程

常用组合方式

- ps -ef 
- ps aux 
- ps axo

样例： 

.. code-block:: bash

    [root@centos-155 backup]# ps aux  |head -n 3
    USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root          1  0.0  0.3 125340  3872 ?        Ss   Feb10   0:00 /usr/lib/systemd/systemd --switched-root --system --deserialize 21
    root          2  0.0  0.0      0     0 ?        S    Feb10   0:00 [kthreadd]

    user: 用户
    pid: 进程id
    %cpu: cpu占比
    %mem: 内存占比
    vsz: 虚拟内存大小
    rss: 固定内存大小
    tty: 终端
    stat: 状态
        R: 运行
        S:可中断睡眠
        D:不可终端睡眠
        T:停止
        Z:僵死
        s:进程领导者
        +:前台进程
        l:多线程
        <:高优先级
        N:低优先级进程
    start time: 启动时间
    command： 命令

pgrep
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

选项

-U	仅仅显示特定用户运行的进程
-G  仅仅显示特定用户组运行的进程
-l  显示pid和进程名字


top
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
ps是相对一个时间点的进程信息，有时候我们需要动态去观察进程状态，就需要top命令了

选项： 

-b          批次处理
-n          显示的次数
-d          指定延迟的时间，单位秒

.. image:: /images/top.png

.. code-block:: text

    第一行： 
            当前时间
            系统启动时间
            已经登陆的用户数
            系统在1，5，15分钟的负载情况

    第二行： 
            任务的总个数
            运行个数
            睡眠个数
            停止个数
            僵死个数

    第三行：
            us:用户空间cpu占比
            sy:系统空间cpu占比
            ni:改变优先级的cpu占比
            id:系统空闲cpu占比
            wa:等待io的cpu占比
            hi:硬件中断的cpu占比
            si:软件终端的cpu占比

    第四行： 
            total:物理内存总量
            free:物理内存空闲大小
            userd:物理内存的使用量
            buff/cache: 物理内存的buffercache大小
            
    第五行： 
            totol:交换内存的总大小
            free:交换分区的空闲大小
            userd: 交换内存的使用大小
            avail: 可用内存

    命令有： 
            P：cpu排序
            M: 内存排序
            T: cpu时间片总占用排序
            q: 退出
            k: 终止特定进程

    表头行： 
            PID: 进程id
            USER:用户所属组
            PR:进程优先级
            NI:nice值
            VIRT:进程需要的虚拟内存大小
            RES:进程当前使用的内存大小，不包括swap
            SHR:进程和其他进程共享的内存大小
            S:进程的状态
            %CPU:cpu占比
            %MEM:内存占比
            TIME+:cpu使用时间累计

htop 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
htop是top的增强版本，系统默认是没有安装，在epel源中。


vmstat
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    [root@centos-155 backup]# vmstat 
    procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
    r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
    2  0      0 495732  15588 292884    0    0    11    20   97  124  0  0 100  0  0

    procs: 
            r: 等待运行的进程个数(队列的长度)
            b: 处理不可中断睡眠状态进程个数(io阻塞队列长度)

    memory: 
            free: 空闲空间大小
            buff: 缓冲空间大小
            cache:缓存空间大小
        
    swap: 
            si: 从swap进入系统的速率
            so: 从系统出去到swap的速率
    io:
            bi: 从磁盘到系统的速率
            bo：从系统到磁盘的速率
        
    system: 
            in： 中断速率
            cs: 进程切换速率
        
    cpu: 
            us: 用户空间cpu占比
            sy： 系统空间cpu占比
            id: 空闲cpu占比
            wa： 等待iocpu占比
            st:  被偷走的cpu占比

glances
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
glances是一款开源命令行系统监控空间，他使用python语言开发，能够监视cpu、负载、内存、
磁盘、网络流量、系统温度等信息。

安装

.. code-block:: bash

    yum install glances 

glances的使用

glances是分客户端和服务端的，

.. code-block:: bash

    # 服务端执行
    glances -s 
    # 客户端执行
    glance -c service-ip

dstat
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
dstat是一个可以拒贷vmstat,iostart,netstat和ifstat这些命令的多功能产品。

常用选项

--top-cpu       显示最占用cpu的进程
--top-bio       显示最占用block io的进程
--top-io        显示最占用io的进程
--top-mem       显示最占用内存的进程
--ipc           显示进程间通信速率
--raw           显示raw套接的相关信息
--tcp           显示tcp套接字相关的数据
--udp           显示udp套接字相关的数据
--unix          显示unixsock接口相关的统计数据
--socket        显示socket信息

kill
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
进程的管理就是给进程发送特定的信息，来完成对进程的管理控制。

查看信号

.. code-block:: bash

    [root@centos-155 backup]# kill -l 
    1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP
    6) SIGABRT	 7) SIGBUS	 8) SIGFPE	 9) SIGKILL	10) SIGUSR1
    11) SIGSEGV	12) SIGUSR2	13) SIGPIPE	14) SIGALRM	15) SIGTERM
    16) SIGSTKFLT	17) SIGCHLD	18) SIGCONT	19) SIGSTOP	20) SIGTSTP
    21) SIGTTIN	22) SIGTTOU	23) SIGURG	24) SIGXCPU	25) SIGXFSZ
    26) SIGVTALRM	27) SIGPROF	28) SIGWINCH	29) SIGIO	30) SIGPWR
    31) SIGSYS	34) SIGRTMIN	35) SIGRTMIN+1	36) SIGRTMIN+2	37) SIGRTMIN+3
    38) SIGRTMIN+4	39) SIGRTMIN+5	40) SIGRTMIN+6	41) SIGRTMIN+7	42) SIGRTMIN+8
    43) SIGRTMIN+9	44) SIGRTMIN+10	45) SIGRTMIN+11	46) SIGRTMIN+12	47) SIGRTMIN+13
    48) SIGRTMIN+14	49) SIGRTMIN+15	50) SIGRTMAX-14	51) SIGRTMAX-13	52) SIGRTMAX-12
    53) SIGRTMAX-11	54) SIGRTMAX-10	55) SIGRTMAX-9	56) SIGRTMAX-8	57) SIGRTMAX-7
    58) SIGRTMAX-6	59) SIGRTMAX-5	60) SIGRTMAX-4	61) SIGRTMAX-3	62) SIGRTMAX-2
    63) SIGRTMAX-1	64) SIGRTMAX	

常用的信号： 

.. csv-table:: 
   :header: "全名","简写","数值","描述"
   :widths: 30,20,10,40

    "SIGHUP","HUP","1","通知进程重读配置文件"
    "SIGINT","INT","2","打断正在运行的进程，相当于ctrl+c"
    "SIGKILL","KILL","9","强行中止正在运行的进程"
    "SIGTERM","TERM","15","安全中止正在运行的进程"
    "SIGSTOP","STOP","19","暂停进程"
    "SIGCONT","CONT","18","继续运行指定的进程"

发送信号样例

.. code-block:: bash

    [root@centos-155 backup]# kill -9 3110

作业管理
--------------------------------------------------------------------------------------

作业的查看
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    [root@centos-155 backup]# jobs 
    [1]+  Stopped                 vim a.txt

作业控制
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- fg jobid        把特定的作业调回到前台
- bg  jobid       把调往后台的指定的作业启动起来
- kill jobid      终止特定作业



