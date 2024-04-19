
======================================================================================================================================================
JVM参数
======================================================================================================================================================




不管是YGC还是Full GC,GC过程中都会对导致程序运行中中断,正确的选择不同的GC策略,调整JVM、GC的参数，可以极大的减少由于GC工作，而导致的程序运行中断方面的问题，进而适当的提高Java程序的工作效率。但是调整GC是以个极为复杂的过程，由于各个程序具备不同的特点，如：web和GUI程序就有很大区别（Web可以适当的停顿，但GUI停顿是客户无法接受的），而且由于跑在各个机器上的配置不同（主要cup个数，内存不同），所以使用的GC种类也会不同(如何选择见GC种类及如何选择)。本文将注重介绍JVM、GC的一些重要参数的设置来提高系统的性能。

       MaxRAMPercentage、InitialRAMPercentage、MinRAMPercentage。这三个参数是JDK8U191为适配Docker容器新增的几个参数，类比Xmx、Xms，至于-XX:InitialRAMFraction、-XX:MaxRAMFraction、-XX:MinRAMFraction已经被标记为deprecated 。这几个参数的好处是什么呢？Docker容器模式下，我们可以给每个JVM实例所属的POD分配任意大小的内存上限。比如，给每个账户服务分配4G，给每个支付服务分配8G。如此一来，启动脚本就不好写成通用的了，指定3G也不是，指定6G也不是。但是，有了这三个新增参数，我们就可以在通用的启动脚本中指定75%（-XX:MaxRAMPercentage=75 -XX:InitialRAMPercentage=75 -XX:MinRAMPercentage=75）。那么，账户服务就相当于设置了-Xmx3g -Xms3g。而支付服务相当于设置了-Xmx6g -Xms6g。

生产参数：
::

	JAVA_OPTS="${JAVA_OPTS} -XX:InitialRAMPercentage=50.0 -XX:MinRAMPercentage=50.0 -XX:MaxRAMPercentage=75.0"
	JAVA_OPTS="${JAVA_OPTS} -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=256m"
	JAVA_OPTS="${JAVA_OPTS} -XX:MaxDirectMemorySize=1g"
	JAVA_OPTS="${JAVA_OPTS} -XX:SurvivorRatio=10"
	JAVA_OPTS="${JAVA_OPTS} -XX:+UseConcMarkSweepGC -XX:CMSMaxAbortablePrecleanTime=5000"
	JAVA_OPTS="${JAVA_OPTS} -XX:+CMSClassUnloadingEnabled -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly"
	JAVA_OPTS="${JAVA_OPTS} -XX:+ExplicitGCInvokesConcurrent -Dsun.rmi.dgc.server.gcInterval=2592000000 -Dsun.rmi.dgc.client.gcInterval=2592000000"
	JAVA_OPTS="${JAVA_OPTS} -Xloggc:${MIDDLEWARE_LOGS}/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps"
	JAVA_OPTS="${JAVA_OPTS} -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${MIDDLEWARE_LOGS}/java.hprof"
	JAVA_OPTS="${JAVA_OPTS} -Djava.awt.headless=true"
	JAVA_OPTS="${JAVA_OPTS} -Dsun.net.client.defaultConnectTimeout=10000"
	JAVA_OPTS="${JAVA_OPTS} -Dsun.net.client.defaultReadTimeout=30000"
	JAVA_OPTS="${JAVA_OPTS} -Dfile.encoding=UTF-8"
	JAVA_OPTS="${JAVA_OPTS} -Dproject.name=${APP_NAME}"


关键参数
::

	-XX:InitialRAMPercentage=50.0 -XX:MinRAMPercentage=50.0 -XX:MaxRAMPercentage=75.0

	-XX:InitialRAMPercentage：将初始堆大小设置为总内存的百分比。-XX:MinRAMPercentage：将最小堆大小设置为总内存的百分比。-XX:MaxRAMPercentage：将最大堆大小设置为总内存的百分比。

	用于在未设置InitialHeapSize / -Xms时计算初始堆大小。当未设置MaxHeapSize / -Xmx时，-XX：MaxRAMPercentage和-XX：MinRAMPercentage都用于计算最大堆大小：对于物理内存较小的系统，MaxHeapSize估计为：phys_mem * MinRAMPercentage / 100（如果此值小于96M）；否则（非小物理内存）MaxHeapSize估计为：MAX（phys_mem * MaxRAMPercentage / 100，96M）

	-XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=256m

	-XX:MetaspaceSize：表示metaspace首次使用不够而触发FGC的阈值，只对触发起作用。-XX:MaxMetaspaceSize：用于设置metaspace区域的最大值

	-XX:MaxDirectMemorySize=1g：设置java堆外内存的峰值。
	-XX:SurvivorRatio=10：Eden区与Survivor区的大小比值。
	-XX:+UseConcMarkSweepGC -XX:CMSMaxAbortablePrecleanTime=5000：
	-XX:+UseConcMarkSweepGC :使用CMS内存收集。

	-XX:CMSMaxAbortablePrecleanTime=5000：默认为5S。只要到了5S，不管发没发生Minor GC，有没有到CMSScheduleRemardEdenPenetration都会中止此阶段，进入remark。

	-XX:+CMSClassUnloadingEnabled -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly：
	这个参数表示在使用CMS垃圾回收机制的时候是否启用类卸载功能。默认这个是设置为不启用的，所以你想启用这个功能你需要在Java参数中明确的设置下面的参数：

	-XX:+CMSClassUnloadingEnabled ；如果你启用了CMSClassUnloadingEnabled ，垃圾回收会清理持久代，移除不再使用的classes。这个参数只有在 UseConcMarkSweepGC 也启用的情况下才有用。参数如下：-XX:+UseConcMarkSweepGC。

	-XX:CMSInitiatingOccupancyFraction=80：使用cms作为垃圾回收使用80％后开始CMS收集。

	-XX:+UseCMSInitiatingOccupancyOnly：使用手动定义初始化定义开始CMS收集。

	-XX:+ExplicitGCInvokesConcurrent -Dsun.rmi.dgc.server.gcInterval=2592000000 -Dsun.rmi.dgc.client.gcInterval=2592000000：
	ExplicitGCInvokesConcurrent :使用并发方式处理显式GC

如果系统中大量使用了DirectByteBuffer，需要定期地对native堆做清理，清理时可以使用Full gc，也可以使用CMS,视QPS情况而定；

可以使用-Dsun.rmi.dgc.server.gcInterval=7200000与-Dsun.rmi.dgc.client.gcInterval=7200000 选项控制Full gc时间间隔；

可以使用-XX:DisableExplicitGC选项禁用显示调用Full gc；

如果希望Full gc有更少的停机时间，可以启用-XX:+ExplicitGCInvokesConcurrent或-XX:+ExplicitGCInvokesConcurrentAndUnloadsClasses选项。

-Dsun.rmi.dgc.server.gcInterval=2592000000 -Dsun.rmi.dgc.client.gcInterval=2592000000：定时触发的时间间隔，单位是毫秒，可适当延长触发FGC的定时时间间隔。

-Xloggc:${MIDDLEWARE_LOGS}/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps ：

指定GC log的位置，以文件输出

-XX:+PrintGCDetails：打印GC详细信息

-XX:+PrintGCDateStamps：输出GC的时间戳（以日期的形式，如 2013-05-04T21:53:59.234+0800）

-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${MIDDLEWARE_LOGS}/java.hprof：当JVM发生OOM时，自动生成DUMP文件

-Djava.awt.headless=true：Headless模式是在缺少显示屏、键盘或者鼠标是的系统配置。在java.awt.toolkit和java.awt.graphicsenvironment类中有许多方法，除了对字体、图形和打印的操作外还可以调用显示器、键盘和鼠标的方法。但是有一些类中，比如Canvas和Panel，可以在headless模式下执行。

-Dsun.net.client.defaultConnectTimeout=10000：socket连接超时时间，ms

-Dsun.net.client.defaultReadTimeout=30000：http获取连接超时时间，ms

-Dfile.encoding=UTF-8：强行设置系统文件编码格式为utf-8，解决中文乱码。

-Dproject.name=${APP_NAME}：应用名参数


元空间相关参数

MetaspaceSize：初始化的Metaspace大小，控制元空间发生GC的阈值。GC后，动态增加或降低MetaspaceSize。在默认情况下，这个值大小根据不同的平台在12M到20M浮动。使用Java -XX:+PrintFlagsInitial命令查看本机的初始化参数

MaxMetaspaceSize：限制Metaspace增长的上限，防止因为某些情况导致Metaspace无限的使用本地内存，影响到其他程序。在本机上该参数的默认值为4294967295B（大约4096MB）。

MinMetaspaceFreeRatio：当进行过Metaspace GC之后，会计算当前Metaspace的空闲空间比，如果空闲比小于这个参数（即实际非空闲占比过大，内存不够用），那么虚拟机将增长Metaspace的大小。默认值为40，也就是40%。设置该参数可以控制Metaspace的增长的速度，太小的值会导致Metaspace增长的缓慢，Metaspace的使用逐渐趋于饱和，可能会影响之后类的加载。而太大的值会导致Metaspace增长的过快，浪费内存。

MaxMetasaceFreeRatio：当进行过Metaspace GC之后， 会计算当前Metaspace的空闲空间比，如果空闲比大于这个参数，那么虚拟机会释放Metaspace的部分空间。默认值为70，也就是70%。

MaxMetaspaceExpansion：Metaspace增长时的最大幅度。在本机上该参数的默认值为5452592B（大约为5MB）。

MinMetaspaceExpansion：Metaspace增长时的最小幅度。在本机上该参数的默认值为340784B（大约330KB为）。

堆相关参数

-Xms：初始堆大小，默认（物理内存的1/64(<1GB)），默认(MinHeapFreeRatio参数可以调整)空余堆内存小于40%时，JVM就会增大堆直到-Xmx的最大限制。

-Xmx：最大堆大小，物理内存的1/4(<1GB)，默认(MaxHeapFreeRatio参数可以调整)空余堆内存大于70%时，JVM会减少堆直到 -Xms的最小限制。

-Xmn：年轻代大小(1.4or lator) ，注意：此处的大小是（eden+ 2 survivor space).与jmap -heap中显示的New gen是不同的。整个堆大小=年轻代大小 + 年老代大小 + 

持久代大小.增大年轻代后,将会减小年老代大小.此值对系统性能影响较大,Sun官方推荐配置为整个堆的3/8。

-XX:NewSize：设置年轻代大小(for 1.3/1.4)

-XX:MaxNewSize：年轻代最大值(for 1.3/1.4)

-XX:NewRatio：年轻代(包括Eden和两个Survivor区)与年老代的比值(除去持久代),-XX:NewRatio=4表示年轻代与年老代所占比值为1:4,年轻代占整个堆栈的1/5。

Xms=Xmx并且设置了Xmn的情况下，该参数不需要进行设置。

-XX:SurvivorRatio：Eden区与Survivor区的大小比值，设置为8,则两个Survivor区与一个Eden区的比值为2:8,一个Survivor区占整个年轻代的1/10

-XX:LargePageSizeInBytes：内存页的大小不可设置过大， 会影响Perm的大小 ， =128m

-XX:+UseFastAccessorMethods：原始类型的快速优化

-XX:+DisableExplicitGC：关闭System.gc() ，这个参数需要严格的测试

-XX:MaxTenuringThreshold：垃圾最大年龄,如果设置为0的话,则年轻代对象不经过Survivor区,直接进入年老代. 

对于老年代比较多的应用,可以提高效率.如果将此值设置为一个较大值,则年轻代对象会在Survivor区进行多次复制,这样可以增加对象再年轻代的存活时间,增加在年轻代即被回收的概率.
该参数只有在串行GC时才有效.

-Xnoclassgc：禁用垃圾回收 。

-XX:SoftRefLRUPolicyMSPerMB： 每兆堆空闲空间中SoftReference的存活时间, 默认1s， softly reachable objects will remain alive for some amount of time after the last time they were referenced. The default value is one second of lifetime per free megabyte in the heap

-XX:PretenureSizeThreshold：对象超过多大是直接在老年代分配 0 单位字节 新生代采用Parallel Scavenge GC时无效
另一种直接在旧生代分配的情况是大的数组对象,且数组中无外部引用对象.

-XX:TLABWasteTargetPercent ：TLAB占eden区的百分比 ，默认1% 。

-XX:+CollectGen0First ：FullGC时是否先YGC ，默认false



性能调优

-XX:LargePageSizeInBytes=4m 设置用于Java堆的大页面尺寸

-XX:MaxHeapFreeRatio=70 GC后java堆中空闲量占的最大比例

-XX:MaxNewSize=size 新生成对象能占用内存的最大值

-XX:MaxPermSize=64m 老生代对象能占用内存的最大值

-XX:MinHeapFreeRatio=40 GC后java堆中空闲量占的最小比例

-XX:NewRatio=2 新生代内存容量与老生代内存容量的比例

-XX:NewSize=2.125m 新生代对象生成时占用内存的默认值

-XX:ReservedCodeCacheSize=32m 保留代码占用的内存容量

-XX:ThreadStackSize=512 设置线程栈大小，若为0则使用系统默认值

-XX:+UseLargePages 使用大页面内存 调试参数

-XX:-CITime 打印消耗在JIT编译的时间

-XX:ErrorFile=./hs_err_pid<pid>.log 保存错误日志或者数据到文件中

-XX:-ExtendedDTraceProbes 开启solaris特有的dtrace探针

-XX:HeapDumpPath=./java_pid<pid>.hprof 指定导出堆信息时的路径或文件名

-XX:-HeapDumpOnOutOfMemoryError 当首次遭遇OOM时导出此时堆中相关信息

-XX:OnError="<cmd args>;<cmd args>" 出现致命ERROR之后运行自定义命令

-XX:OnOutOfMemoryError="<cmd args>;<cmd args>" 当首次遭遇OOM时执行自定义命令

-XX:-PrintClassHistogram 遇到Ctrl-Break后打印类实例的柱状信息，与jmap -histo功能相同

-XX:-PrintConcurrentLocks 遇到Ctrl-Break后打印并发锁的相关信息，与jstack -l功能相同

-XX:-PrintCommandLineFlags 打印在命令行中出现过的标记

-XX:-PrintCompilation 当一个方法被编译时打印相关信息

-XX:-PrintGC 每次GC时打印相关信息

-XX:-PrintGC Details 每次GC时打印详细信息

-XX:-PrintGCTimeStamps 打印每次GC的时间戳

-XX:-TraceClassLoading 跟踪类的加载信息

-XX:-TraceClassLoadingPreorder 跟踪被引用到的所有类的加载信息

-XX:-TraceClassResolution 跟踪常量池

-XX:-TraceClassUnloading 跟踪类的卸载信息

-XX:-TraceLoaderConstraints 跟踪类加载器约束的相关信息





辅助信息

-XX:+PrintGC

输出形式:

[GC 118250K->113543K(130112K), 0.0094143 secs]
[Full GC 121376K->10414K(130112K), 0.0650971 secs]

-XX:+PrintGCDetails	 	 	

输出形式:

[GC [DefNew: 8614K->781K(9088K), 0.0123035 secs] 118250K->113543K(130112K), 0.0124633 secs]
[GC [DefNew: 8614K->8614K(9088K), 0.0000665 secs][Tenured: 112761K->10414K(121024K), 0.0433488 secs] 121376K->10414K(130112K), 0.0436268 secs]

-XX:+PrintGCTimeStamps	 	 	 
-XX:+PrintGC:PrintGCTimeStamps

可与-XX:+PrintGC -XX:+PrintGCDetails混合使用输出形式:11.851: [GC 98328K->93620K(130112K), 0.0082960 secs]


-XX:+PrintGCApplicationStoppedTime

打印垃圾回收期间程序暂停的时间.可与上面混合使用

输出形式:

Total time for which application threads were stopped: 0.0468229 seconds

-XX:+PrintGCApplicationConcurrentTime

打印每次垃圾回收前,程序未中断的执行时间.可与上面混合使用

输出形式:

Application time: 0.5291524 seconds


-XX:+PrintHeapAtGC

打印GC前后的详细堆栈信息	 	 


-Xloggc:filename

把相关日志信息记录到文件以便分析.与上面几个配合使用	 	 

-XX:+PrintClassHistogram

garbage collects before printing the histogram.	 	 

-XX:+PrintTLAB

查看TLAB空间的使用情况	 	 


XX:+PrintTenuringDistribution

查看每次minor GC后新的存活周期的阈值	 	

Desired survivor size 1048576 bytes, new threshold 7 (max 15)
new threshold 7即标识新的存活周期的阈值为7。




