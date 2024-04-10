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








