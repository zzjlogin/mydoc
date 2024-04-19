.. _cpp_call_java:

======================================================================================================================================================
C++调用java
======================================================================================================================================================



JNI
======================================================================================================================================================


java:
    - https://jdk.java.net/archive/
    - https://docs.oracle.com/en/java/javase/
	- https://docs.oracle.com/en/java/javase/index.html
	- https://docs.oracle.com/en/java/javase/18/docs/specs/jni/index.html
	- https://docs.oracle.com/en/java/javase/18/docs/specs/jni/types.html
	

java数据类型及整数值关系
	
	- https://docs.oracle.com/javase/8/docs/api/constant-values.html#java.sql.Types.ARRAY

参考：
	-https://docs.oracle.com/javase/8/docs/technotes/guides/jni/spec/invocation.html


JNI（Java Native Interface，Java本地接口），是Java平台中的一个强大特性。应用程序可以通过JNI把C/C++代码集成进Java程序中。

通过JNI，开发者在利用Java平台强大功能的同时，又不必放弃对原有代码的投资；因为JNI是Java平台定义的规范接口，当程序员向Java代码集成本地库时，只要在一个平台中解决了语言互操作问题，就可以把该解决方案比较容易的移植到其他Java平台中。

Java平台和主机环境
--------------------------------------------------------------------------------


Java平台(Java Platform)的组成：Java VM和Java API。

Java应用程序使用Java语言开发，然后编译成与平台无关的字节码(.class文件)。

Java API由一组预定义的类组成。任何组织实现的Java平台都要支持：Java编程语言，虚拟机，和API。

平台环境: 操作系统，一组本机库，和CPU指令集。本地应用程序，通常依赖于一个特定的平台环境，用 C、C++等语言开发，并被编译成平台相关的二进制指令，目标二进制代码在不同OS间一般不具有可移植性。

Java平台(Java VM和Java API)一般在某个平台下开发。比如，Sun 的Java Runtime Environment(JRE)支持类Unix和Windows平台。Java平台做的所有努力，都为了使程序更具可移植性。

JNI的角色
--------------------------------------------------------------------------------

当Java平台部署到本地系统中，有必要做到让Java程序与本地代码协同工作。 部分是由于遗留代码(保护原有的投资)的问题(一些效率敏感的代码用C实现，但现在Java VM的执行效率完全可信赖)，工程师们很早就开始以C/C++为基础构建Java应用，所以，C/C++代码将长时间的与 Java 应用共存。JNI 让你在利用强大 Java 平台的同时，使你仍然可以用其他语言写程序。作为Java VM 的一部分，JNI是一套双向的接口，允许Java与本地代码间的互操作。

作为双向接口，JNI支持两种类型本地代码：本地库和本地应用。

用本地代码实现Java中定义的native method接口，使Java调用本地代码；

通过JNI你可以把Java VM嵌到一个应用程序中，此时Java平台作为应用程序的增强，使其可以调用Java类库。

JNI不只是一套接口，还是一套使用规则。Java语言有"native"关键字，声明哪些方法是用本地代码实现的。翻译的时候，对于"native method"，根据上下文意思做了不同处理，当native method指代Java中用"native"关键字修饰的那些方法时，不翻译；而当代码用C/C++实现的部分翻译成了本地代码。

在应用中嵌入Java VM的方法，是用最少的力量，为应用做最强扩展的不二选择，这时你的应用程序可以自由使用Java API的所有功能。

JNI的影响
--------------------------------------------------------------------------------

当Java程序集成了本地代码，它将丢掉Java的一些好处。

首先，脱离Java后，可移植性问题你要自己解决，且需重新在其他平台编译链接本地库。

第二，要小心处理JNI编程中各方面问题和来自C/C++语言本身的细节性问题，处理不当，应用将崩溃。

一般性原则：做好应用程序架构，使native methods定义在尽可能少的几个类里。

JNI的使用场景
--------------------------------------------------------------------------------

一典型的解决方案是，Java程序与本地代码分别运行在不同的进程中。采用进程分置最大的好处是：一个进程的崩溃，不会立即影响到另一个进程。

但是，把Java代码与本地代码置于一个进程有时是必要的。 如下：

Java API可能不支某些平台相关的功能。比如，应用程序执行中要使用Java API不支持的文件类型，而如果使用跨进程操作方式，即繁琐又低效；

避免进程间低效的数据拷贝操作；

多进程的派生：耗时、耗资源(内存)；

用本地代码或汇编代码重写Java中低效方法。

总之，如果Java必须与驻留同进程的本地代码交互，请使用JNI。



Java demo
======================================================================================================================================================

Test.java 文件

::

    package com.cynhard.test;

    public class Test {

        public int add(int num1, int num2) {
            return num1 + num2;
        }

        public String toUpperCase(String str) {
            return str.toUpperCase();
        }

            public String getStr() {
            return "hello world!";
        }

    }



编译：

::

    javac -encoding utf8 Test.java


编译输出到指定目录：

::

    javac -encoding utf8 Test.java -d bin

编译文件打包jar

::

    jar -cvf test.jar Test.class


查看类签名：

::

    javap -v -classpath /root/java/test.jar Test


::

    Classfile jar:file:/root/java/test.jar!/Test.class
    Last modified Apr 6, 2024; size 459 bytes
    MD5 checksum 097ca8035688e97d4224c5e366eae4b7
    Compiled from "Test.java"
    public class Test
    minor version: 0
    major version: 52
    flags: ACC_PUBLIC, ACC_SUPER
    Constant pool:
    #1 = Methodref          #5.#18         // java/lang/Object."<init>":()V
    #2 = Methodref          #19.#20        // java/lang/String.toUpperCase:()Ljava/lang/String;
    #3 = String             #21            // hello world!
    #4 = Class              #22            // Test
    #5 = Class              #23            // java/lang/Object
    #6 = Utf8               <init>
    #7 = Utf8               ()V
    #8 = Utf8               Code
    #9 = Utf8               LineNumberTable
    #10 = Utf8               add
    #11 = Utf8               (II)I
    #12 = Utf8               toUpperCase
    #13 = Utf8               (Ljava/lang/String;)Ljava/lang/String;
    #14 = Utf8               getStr
    #15 = Utf8               ()Ljava/lang/String;
    #16 = Utf8               SourceFile
    #17 = Utf8               Test.java
    #18 = NameAndType        #6:#7          // "<init>":()V
    #19 = Class              #24            // java/lang/String
    #20 = NameAndType        #12:#15        // toUpperCase:()Ljava/lang/String;
    #21 = Utf8               hello world!
    #22 = Utf8               Test
    #23 = Utf8               java/lang/Object
    #24 = Utf8               java/lang/String
    {
    public Test();
        descriptor: ()V
        flags: ACC_PUBLIC
        Code:
        stack=1, locals=1, args_size=1
            0: aload_0
            1: invokespecial #1                  // Method java/lang/Object."<init>":()V
            4: return
        LineNumberTable:
            line 1: 0

    public int add(int, int);
        descriptor: (II)I
        flags: ACC_PUBLIC
        Code:
        stack=2, locals=3, args_size=3
            0: iload_1
            1: iload_2
            2: iadd
            3: ireturn
        LineNumberTable:
            line 4: 0

    public java.lang.String toUpperCase(java.lang.String);
        descriptor: (Ljava/lang/String;)Ljava/lang/String;
        flags: ACC_PUBLIC
        Code:
        stack=1, locals=2, args_size=2
            0: aload_1
            1: invokevirtual #2                  // Method java/lang/String.toUpperCase:()Ljava/lang/String;
            4: areturn
        LineNumberTable:
            line 8: 0

    public java.lang.String getStr();
        descriptor: ()Ljava/lang/String;
        flags: ACC_PUBLIC
        Code:
        stack=1, locals=1, args_size=1
            0: ldc           #3                  // String hello world!
            2: areturn
        LineNumberTable:
            line 12: 0
    }
    SourceFile: "Test.java"



JVM内存问题排查
======================================================================


jcmd
----------------------------------------------------------------------

1. 查看哪些java程序在运行

::

	jcmd

	18240 
	22896 sun.tools.jstat.Jstat -gc 18240 3000
	21494 org.apache.zookeeper.server.quorum.QuorumPeerMain /usr/local/zookeeper/bin/../conf/zoo.cfg
	24088 sun.tools.jcmd.JCmd
	21614 kafka.Kafka /usr/local/kafka/config/server.properties



查看指定进程

::

	jcmd 18240 help
	
	18240:
	The following commands are available:
	JFR.stop
	JFR.start
	JFR.dump
	JFR.check
	VM.native_memory
	VM.check_commercial_features
	VM.unlock_commercial_features
	ManagementAgent.stop
	ManagementAgent.start_local
	ManagementAgent.start
	VM.classloader_stats
	GC.rotate_log
	Thread.print
	GC.class_stats
	GC.class_histogram
	GC.heap_dump
	GC.finalizer_info
	GC.heap_info
	GC.run_finalization
	GC.run
	VM.uptime
	VM.dynlibs
	VM.flags
	VM.system_properties
	VM.command_line
	VM.version
	help

	For more information about a specific command use 'help <command>'.


查看进程统计信息


::

	jcmd 21614 PerfCounter.print



统计结果信息

::

	21614:
	java.ci.totalTime=56072159711
	java.cls.loadedClasses=5868
	java.cls.sharedLoadedClasses=0
	java.cls.sharedUnloadedClasses=0
	java.cls.unloadedClasses=46
	java.property.java.class.path=".:/usr/local/jdk1.8_32bit/jdk1.8.0_202/lib/dt.jar:/usr/local/jdk1.8_32bit/jdk1.8.0_202/lib/tools.jar:/usr/local/kafka/bin/../libs/activation-1.1.1.jar:/usr/local/kafka/bin/../libs/aopalliance-repackaged-2.5.0.jar:/usr/local/kafka/bin/../libs/argparse4j-0.7.0.jar:/usr/local/kafka/bin/../libs/audience-annotations-0.5.0.jar:/usr/local/kafka/bin/../libs/commons-cli-1.4.jar:/usr/local/kafka/bin/../libs/commons-lang3-3.8.1.jar:/usr/local/kafka/bin/../libs/connect-api-2.6.0.jar:/usr/local/kafka/bin/../libs/connect-basic-auth-extension-2.6.0.jar:/usr/local/kafka/bin/../libs/connect-file-2.6.0.jar:/usr/local/kafka/bin/../libs/connect-json-2.6.0.jar:/usr/local/kafka/bin/../libs/connect-mirror-2.6.0.jar:/usr/local/kafka/bin/../libs/connect-mirror-client-2.6.0.jar:/usr/local/kafka/bin/../libs/connect-runtime-2.6.0.jar:/usr/local/kafka/bin/../libs/connect-transforms-2.6.0.jar:/usr/local/kafka/bin/../libs/hk2-api-2.5.0.jar:/usr/local/kafka/bin/../libs/hk2-locator-2.5.0.jar:/usr/local/kafka/bin/../libs/hk2-utils-2.5.0.jar:/"
	java.property.java.endorsed.dirs="/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/lib/endorsed"
	java.property.java.ext.dirs="/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/lib/ext:/usr/java/packages/lib/ext"
	java.property.java.home="/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre"
	java.property.java.library.path="/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/lib/i386/server:/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/lib/i386:/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/../lib/i386::/usr/local/lib:/usr/dt/lib:/usr/sfw/lib:/usr/Charging_Pile_Platform/prog:/usr/local/mysql/lib:/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/lib/i386/server:/usr/local/Qt5.10/5.10.1/gcc_64/lib:/usr/local/corba/omniORB-4.1.3/lib:/usr/local/corba/Python-2.7.2/Lib:/usr/local/ekho/ekho-5.2/lib:/usr/local/xerces/xerces-c-redhat_AS4-gcc_343/lib:/usr/local/Qscintilla/QScintilla-2.7.2/Qt4Qt5::/usr/java/packages/lib/i386:/lib:/usr/lib"
	java.property.java.version="1.8.0_202"
	java.property.java.vm.info="mixed mode"
	java.property.java.vm.name="Java HotSpot(TM) Server VM"
	java.property.java.vm.specification.name="Java Virtual Machine Specification"
	java.property.java.vm.specification.vendor="Oracle Corporation"
	java.property.java.vm.specification.version="1.8"
	java.property.java.vm.vendor="Oracle Corporation"
	java.property.java.vm.version="25.202-b08"
	java.rt.vmArgs="-Xmx1G -Xms1G -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:+ExplicitGCInvokesConcurrent -XX:MaxInlineLevel=15 -Djava.awt.headless=true -Xloggc:/usr/local/kafka/bin/../logs/kafkaServer-gc.log -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=100M -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dkafka.logs.dir=/usr/local/kafka/bin/../logs -Dlog4j.configuration=file:/usr/local/kafka/bin/../config/log4j.properties"
	java.rt.vmFlags=""
	java.threads.daemon=31
	java.threads.live=54
	java.threads.livePeak=54
	java.threads.started=55
	sun.ci.compilerThread.0.compiles=571
	sun.ci.compilerThread.0.method=""
	sun.ci.compilerThread.0.time=9561011
	sun.ci.compilerThread.0.type=1
	sun.ci.compilerThread.1.compiles=574
	sun.ci.compilerThread.1.method=""
	sun.ci.compilerThread.1.time=7887322
	sun.ci.compilerThread.1.type=1
	sun.ci.compilerThread.2.compiles=592
	sun.ci.compilerThread.2.method=""
	sun.ci.compilerThread.2.time=8238506
	sun.ci.compilerThread.2.type=1
	sun.ci.compilerThread.3.compiles=6282
	sun.ci.compilerThread.3.method=""
	sun.ci.compilerThread.3.time=28779645
	sun.ci.compilerThread.3.type=1
	sun.ci.lastFailedMethod=""
	sun.ci.lastFailedType=0
	sun.ci.lastInvalidatedMethod=""
	sun.ci.lastInvalidatedType=0
	sun.ci.lastMethod="java/text/SimpleDateFormat subFormat"
	sun.ci.lastSize=6492
	sun.ci.lastType=1
	sun.ci.nmethodCodeSize=11017184
	sun.ci.nmethodSize=20019156
	sun.ci.osrBytes=28119
	sun.ci.osrCompiles=49
	sun.ci.osrTime=1565032206
	sun.ci.standardBytes=1313445
	sun.ci.standardCompiles=7970
	sun.ci.standardTime=54507127505
	sun.ci.threads=4
	sun.ci.totalBailouts=0
	sun.ci.totalCompiles=8019
	sun.ci.totalInvalidates=0
	sun.classloader.findClassTime=3713736996
	sun.classloader.findClasses=2805
	sun.classloader.parentDelegationTime=243617217
	sun.cls.appClassBytes=19646441
	sun.cls.appClassLoadCount=3156
	sun.cls.appClassLoadTime=3121065712
	sun.cls.appClassLoadTime.self=1232572225
	sun.cls.classInitTime=22642544161
	sun.cls.classInitTime.self=20695084798
	sun.cls.classLinkedTime=2420114364
	sun.cls.classLinkedTime.self=310820253
	sun.cls.classVerifyTime=2088522084
	sun.cls.classVerifyTime.self=842566430
	sun.cls.defineAppClassTime=1642404469
	sun.cls.defineAppClassTime.self=75419003
	sun.cls.defineAppClasses=2813
	sun.cls.initializedClasses=4835
	sun.cls.isUnsyncloadClassSet=0
	sun.cls.jniDefineClassNoLockCalls=2
	sun.cls.jvmDefineClassNoLockCalls=2808
	sun.cls.jvmFindLoadedClassNoLockCalls=6544
	sun.cls.linkedClasses=5214
	sun.cls.loadInstanceClassFailRate=0
	sun.cls.loadedBytes=7089644
	sun.cls.lookupSysClassTime=175264584
	sun.cls.methodBytes=4347430
	sun.cls.nonSystemLoaderLockContentionRate=0
	sun.cls.parseClassTime=1960658927
	sun.cls.parseClassTime.self=1701052192
	sun.cls.sharedClassLoadTime=11171082
	sun.cls.sharedLoadedBytes=0
	sun.cls.sharedUnloadedBytes=0
	sun.cls.sysClassBytes=6200373
	sun.cls.sysClassLoadTime=536282380
	sun.cls.systemLoaderLockContentionRate=0
	sun.cls.time=25387638662
	sun.cls.unloadedBytes=29944
	sun.cls.unsafeDefineClassCalls=1298
	sun.cls.verifiedClasses=5211
	sun.gc.cause="No GC"
	sun.gc.collector.0.invocations=504
	sun.gc.collector.0.lastEntryTime=2588281369299757
	sun.gc.collector.0.lastExitTime=2588281391391803
	sun.gc.collector.0.name="G1 incremental collections"
	sun.gc.collector.0.time=14252005515
	sun.gc.collector.1.invocations=0
	sun.gc.collector.1.lastEntryTime=0
	sun.gc.collector.1.lastExitTime=0
	sun.gc.collector.1.name="G1 stop-the-world full collections"
	sun.gc.collector.1.time=0
	sun.gc.compressedclassspace.capacity=0
	sun.gc.compressedclassspace.maxCapacity=0
	sun.gc.compressedclassspace.minCapacity=0
	sun.gc.compressedclassspace.used=0
	sun.gc.generation.0.agetable.bytes.00=0
	sun.gc.generation.0.agetable.bytes.01=98056
	sun.gc.generation.0.agetable.bytes.02=536
	sun.gc.generation.0.agetable.bytes.03=288
	sun.gc.generation.0.agetable.bytes.04=472
	sun.gc.generation.0.agetable.bytes.05=416
	sun.gc.generation.0.agetable.bytes.06=448
	sun.gc.generation.0.agetable.bytes.07=288
	sun.gc.generation.0.agetable.bytes.08=0
	sun.gc.generation.0.agetable.bytes.09=0
	sun.gc.generation.0.agetable.bytes.10=0
	sun.gc.generation.0.agetable.bytes.11=0
	sun.gc.generation.0.agetable.bytes.12=0
	sun.gc.generation.0.agetable.bytes.13=0
	sun.gc.generation.0.agetable.bytes.14=0
	sun.gc.generation.0.agetable.bytes.15=0
	sun.gc.generation.0.agetable.size=16
	sun.gc.generation.0.capacity=468713496
	sun.gc.generation.0.maxCapacity=1073741848
	sun.gc.generation.0.minCapacity=24
	sun.gc.generation.0.name="young"
	sun.gc.generation.0.space.0.capacity=467664904
	sun.gc.generation.0.space.0.initCapacity=56623112
	sun.gc.generation.0.space.0.maxCapacity=1073741832
	sun.gc.generation.0.space.0.name="eden"
	sun.gc.generation.0.space.0.used=161480704
	sun.gc.generation.0.space.1.capacity=8
	sun.gc.generation.0.space.1.initCapacity=8
	sun.gc.generation.0.space.1.maxCapacity=8
	sun.gc.generation.0.space.1.name="s0"
	sun.gc.generation.0.space.1.used=0
	sun.gc.generation.0.space.2.capacity=1048584
	sun.gc.generation.0.space.2.initCapacity=8
	sun.gc.generation.0.space.2.maxCapacity=1073741832
	sun.gc.generation.0.space.2.name="s1"
	sun.gc.generation.0.space.2.used=1048576
	sun.gc.generation.0.spaces=3
	sun.gc.generation.1.capacity=605028360
	sun.gc.generation.1.maxCapacity=1073741832
	sun.gc.generation.1.minCapacity=8
	sun.gc.generation.1.name="old"
	sun.gc.generation.1.space.0.capacity=605028360
	sun.gc.generation.1.space.0.initCapacity=1017118728
	sun.gc.generation.1.space.0.maxCapacity=1073741832
	sun.gc.generation.1.space.0.name="space"
	sun.gc.generation.1.space.0.used=292805968
	sun.gc.generation.1.spaces=1
	sun.gc.lastCause="G1 Evacuation Pause"
	sun.gc.metaspace.capacity=30064640
	sun.gc.metaspace.maxCapacity=30720000
	sun.gc.metaspace.minCapacity=0
	sun.gc.metaspace.used=28507304
	sun.gc.policy.collectors=1
	sun.gc.policy.desiredSurvivorSize=21495808
	sun.gc.policy.generations=3
	sun.gc.policy.maxTenuringThreshold=15
	sun.gc.policy.name="GarbageFirst"
	sun.gc.policy.tenuringThreshold=15
	sun.gc.tlab.alloc=119052340
	sun.gc.tlab.allocThreads=42
	sun.gc.tlab.fastWaste=0
	sun.gc.tlab.fills=2582
	sun.gc.tlab.gcWaste=498542
	sun.gc.tlab.maxFastWaste=0
	sun.gc.tlab.maxFills=268
	sun.gc.tlab.maxGcWaste=79730
	sun.gc.tlab.maxSlowAlloc=16
	sun.gc.tlab.maxSlowWaste=29030
	sun.gc.tlab.slowAlloc=125
	sun.gc.tlab.slowWaste=110160
	sun.management.JMXConnectorServer.address="service:jmx:rmi://127.0.0.1/stub/rO0ABXN9AAAAAQAlamF2YXgubWFuYWdlbWVudC5yZW1vdGUucm1pLlJNSVNlcnZlcnhyABdqYXZhLmxhbmcucmVmbGVjdC5Qcm94eeEn2iDMEEPLAgABTAABaHQAJUxqYXZhL2xhbmcvcmVmbGVjdC9JbnZvY2F0aW9uSGFuZGxlcjt4cHNyAC1qYXZhLnJtaS5zZXJ2ZXIuUmVtb3RlT2JqZWN0SW52b2NhdGlvbkhhbmRsZXIAAAAAAAAAAgIAAHhyABxqYXZhLnJtaS5zZXJ2ZXIuUmVtb3RlT2JqZWN002G0kQxhMx4DAAB4cHcrAAtVbmljYXN0UmVmMgAAAAAAoGkMT1YrJvViS1KOIdgAAAGOV18Um4ABAHg="
	sun.os.hrt.frequency=1000000000
	sun.os.hrt.ticks=2592508579796130
	sun.perfdata.majorVersion=2
	sun.perfdata.minorVersion=0
	sun.perfdata.overflow=0
	sun.perfdata.size=32768
	sun.perfdata.timestamp=11222073486
	sun.perfdata.used=18312
	sun.property.sun.boot.class.path="/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/lib/resources.jar:/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/lib/rt.jar:/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/lib/sunrsasign.jar:/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/lib/jsse.jar:/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/lib/jce.jar:/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/lib/charsets.jar:/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/lib/jfr.jar:/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/classes"
	sun.property.sun.boot.library.path="/usr/local/jdk1.8_32bit/jdk1.8.0_202/jre/lib/i386"
	sun.rt._sync_ContendedLockAttempts=66525
	sun.rt._sync_Deflations=115
	sun.rt._sync_EmptyNotifications=0
	sun.rt._sync_FailedSpins=0
	sun.rt._sync_FutileWakeups=50093
	sun.rt._sync_Inflations=117
	sun.rt._sync_MonExtant=256
	sun.rt._sync_MonInCirculation=0
	sun.rt._sync_MonScavenged=0
	sun.rt._sync_Notifications=1141
	sun.rt._sync_Parks=56387
	sun.rt._sync_PrivateA=0
	sun.rt._sync_PrivateB=0
	sun.rt._sync_SlowEnter=0
	sun.rt._sync_SlowExit=0
	sun.rt._sync_SlowNotify=0
	sun.rt._sync_SlowNotifyAll=0
	sun.rt._sync_SuccessfulSpins=0
	sun.rt.applicationTime=2591870925662723
	sun.rt.createVmBeginTime=1710862831804
	sun.rt.createVmEndTime=1710862843026
	sun.rt.internalVersion="Java HotSpot(TM) Server VM (25.202-b08) for linux-x86 JRE (1.8.0_202-b08), built on Dec 15 2018 11:54:58 by "java_re" with gcc 7.3.0"
	sun.rt.interruptedBeforeIO=0
	sun.rt.interruptedDuringIO=0
	sun.rt.javaCommand="kafka.Kafka /usr/local/kafka/config/server.properties"
	sun.rt.jvmCapabilities="1100000000000000000000000000000000000000000000000000000000000000"
	sun.rt.jvmVersion=432668680
	sun.rt.safepointSyncTime=769541440
	sun.rt.safepointTime=18866743841
	sun.rt.safepoints=1484
	sun.rt.threadInterruptSignaled=0
	sun.rt.vmInitDoneTime=1710862831953
	sun.threads.vmOperationTime=17428424664
	sun.urlClassLoader.readClassBytesTime=752487355
	sun.zip.zipFile.openTime=523711627
sun.zip.zipFiles=97



jmap
----------------------------------------------------------------------


打印java堆对象统计信息

::

	jmap -histo  18240


查看堆简述信息

::

	jmap -heap  21614
	
	Attaching to process ID 21614, please wait...
	Debugger attached successfully.
	Server compiler detected.
	JVM version is 25.202-b08

	using thread-local object allocation.
	Garbage-First (G1) GC with 8 thread(s)

	Heap Configuration:
	   MinHeapFreeRatio         = 40
	   MaxHeapFreeRatio         = 70
	   MaxHeapSize              = 1073741824 (1024.0MB)
	   NewSize                  = 1048576 (1.0MB)
	   MaxNewSize               = 643825664 (614.0MB)
	   OldSize                  = 4194304 (4.0MB)
	   NewRatio                 = 2
	   SurvivorRatio            = 8
	   MetaspaceSize            = 16777216 (16.0MB)
	   CompressedClassSpaceSize = 1073741824 (1024.0MB)
	   MaxMetaspaceSize         = 4294963200 (4095.99609375MB)
	   G1HeapRegionSize         = 1048576 (1.0MB)

	Heap Usage:
	G1 Heap:
	   regions  = 1024
	   capacity = 1073741824 (1024.0MB)
	   used     = 458480976 (437.2415313720703MB)
	   free     = 615260848 (586.7584686279297MB)
	   42.69936829805374% used
	G1 Young Generation:
	Eden Space:
	   regions  = 157
	   capacity = 467664896 (446.0MB)
	   used     = 164626432 (157.0MB)
	   free     = 303038464 (289.0MB)
	   35.2017937219731% used
	Survivor Space:
	   regions  = 1
	   capacity = 1048576 (1.0MB)
	   used     = 1048576 (1.0MB)
	   free     = 0 (0.0MB)
	   100.0% used
	G1 Old Generation:
	   regions  = 281
	   capacity = 605028352 (577.0MB)
	   used     = 292805968 (279.2415313720703MB)
	   free     = 312222384 (297.7584686279297MB)
	   48.39541271613004% used

	12461 interned Strings occupying 1217608 bytes.


jstat
----------------------------------------------------------------------

监控Java虚拟机JVM统计信息

查看堆垃圾回收(gc)统计信息

::

	jstat -gc 21614 3000

查看垃圾回收统计

-gcutil


查看新生代统计信息

-gccause


查看引起gc的原因：

-gccause




