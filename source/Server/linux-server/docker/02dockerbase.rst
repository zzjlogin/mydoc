.. _zzjlogin-docker-base:

======================================================================================================================================================
docker基础
======================================================================================================================================================

docker安装
======================================================================================================================================================

centos7配置docker源并安装docker


.. code-block:: bash
    :linenos:

    [root@centos-151 ~]# cd /etc/yum.repos.d/
    [root@centos-151 yum.repos.d]# ls
    bak  CentOS-Base.repo  epel.repo  mariadb.repo.bak
    [root@centos-151 yum.repos.d]# wget http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

    [root@centos-151 ~]# yum install docker


CentOS6通过 ``epel-release`` 来安装docker

epel-release:
    Enterprise Linux（或EPEL）的额外软件包,企业Linux额外包（EPEL）



RHEL / CentOS 6：
   #yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
RHEL / CentOS 7：
   #yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

.. attention::
    一般可以通过 ``yum install epel-release -y`` 来安装。

安装完 ``epel-release`` 以后，可以查看docker安装信息:


CentOS6安装docker:

.. code-block:: bash
    :linenos:

    yum install docker-io -y


.. code-block:: bash
    :linenos:

    rpm -qa docker-io
    rpm -ql docker-io

配置docker开机自启动
------------------------------------------------------------------------------------------------------------------------------------------------------

CentOS7:

.. code-block:: bash
    :linenos:

    [root@centos-151 ~]# systemctl enable docker
    #启动docker
    [root@centos-151 ~]# systemctl start docker 

CentOS6:

.. code-block:: bash
    :linenos:

    chkconfig docker on
    #启动docker
    /etc/init.d/docker start

docker信息获取
======================================================================================================================================================

获取version

.. attention::
    查看docker版本信息，需要先启动docker。如果没有启动是不能查看的。

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# docker version
    Client version: 1.7.1
    Client API version: 1.19
    Go version (client): go1.4.2
    Git commit (client): 786b29d/1.7.1
    OS/Arch (client): linux/amd64
    Server version: 1.7.1
    Server API version: 1.19
    Go version (server): go1.4.2
    Git commit (server): 786b29d/1.7.1
    OS/Arch (server): linux/amd64


获取info

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# docker info
    Containers: 0
    Images: 0
    Storage Driver: devicemapper
    Pool Name: docker-8:3-40736-pool
    Pool Blocksize: 65.54 kB
    Backing Filesystem: extfs
    Data file: /dev/loop0
    Metadata file: /dev/loop1
    Data Space Used: 305.7 MB
    Data Space Total: 107.4 GB
    Data Space Available: 656.1 MB
    Metadata Space Used: 729.1 kB
    Metadata Space Total: 2.147 GB
    Metadata Space Available: 656.1 MB
    Udev Sync Supported: true
    Deferred Removal Enabled: false
    Data loop file: /var/lib/docker/devicemapper/devicemapper/data
    Metadata loop file: /var/lib/docker/devicemapper/devicemapper/metadata
    Library Version: 1.02.89-RHEL6 (2014-09-01)
    Execution Driver: native-0.2
    Logging Driver: json-file
    Kernel Version: 2.6.32-504.el6.x86_64
    Operating System: <unknown>
    CPUs: 1
    Total Memory: 980.8 MiB
    Name: zzjlogin
    ID: GAII:U77Y:CUAH:NJ7Y:XE6M:SB7I:UD3Z:UHVO:VPDZ:RONM:7VQH:MMZ3


docker常用命令
======================================================================================================================================================

.. code-block:: text
    :linenos: 

    docker run      运行一个容器
    docker create   创建，需要在配合start命令
    docker start    启动一个创建好的容器
    docker stop     停止容器
    docker kill     杀掉容器
    docker restart  重启容器
    docker pause    暂停容器
    docker search   查询registry的相关镜像
    docker pull     从registry拉取镜像
    docker push     推送到registry
    docker save     保存成压缩包
    docker load     从压缩包加载进来
    docker log      查看日志信息
    docker info     查看docker信息
    docker version  查看docker版本
    docker inspect  查看镜像容器信息
    docker images   查看已有镜像信息
    docker rm       删除容器

.. code-block:: bash
    :linenos:

    [root@centos-151 ~]# docker 
    build      diff       history    inspect    logs       port       restart    search     stats      top        wait
    commit     events     image      kill       network    ps         rm         secret     stop       unpause    
    container  exec       images     load       node       pull       rmi        service    swarm      update     
    cp         export     import     login      pause      push       run        stack      system     version    
    create     help       info       logout     plugin     rename     save       start      tag        volume     



docker run常用命令
======================================================================================================================================================

.. code-block:: text
    :linenos: 

    [root@centos-151 ~]# docker help run

    Usage:	docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

    Run a command in a new container

    Options:
        --add-host list                         Add a custom host-to-IP mapping (host:ip) (default [])
    -a, --attach list                           Attach to STDIN, STDOUT or STDERR (default [])
        --blkio-weight uint16                   Block IO (relative weight), between 10 and 1000, or 0 to disable (default 0)
        --blkio-weight-device weighted-device   Block IO weight (relative device weight) (default [])
        --cap-add list                          Add Linux capabilities (default [])
        --cap-drop list                         Drop Linux capabilities (default [])
        --cgroup-parent string                  Optional parent cgroup for the container
        --cidfile string                        Write the container ID to the file
        --cpu-count int                         CPU count (Windows only)
        --cpu-percent int                       CPU percent (Windows only)
        --cpu-period int                        Limit CPU CFS (Completely Fair Scheduler) period
        --cpu-quota int                         Limit CPU CFS (Completely Fair Scheduler) quota
        --cpu-rt-period int                     Limit CPU real-time period in microseconds
        --cpu-rt-runtime int                    Limit CPU real-time runtime in microseconds
    -c, --cpu-shares int                        CPU shares (relative weight)
        --cpus decimal                          Number of CPUs (default 0.000)
        --cpuset-cpus string                    CPUs in which to allow execution (0-3, 0,1)
        --cpuset-mems string                    MEMs in which to allow execution (0-3, 0,1)
        --credentialspec string                 Credential spec for managed service account (Windows only)
    -d, --detach                                Run container in background and print container ID
        --detach-keys string                    Override the key sequence for detaching a container
        --device list                           Add a host device to the container (default [])
        --device-read-bps throttled-device      Limit read rate (bytes per second) from a device (default [])
        --device-read-iops throttled-device     Limit read rate (IO per second) from a device (default [])
        --device-write-bps throttled-device     Limit write rate (bytes per second) to a device (default [])
        --device-write-iops throttled-device    Limit write rate (IO per second) to a device (default [])
        --disable-content-trust                 Skip image verification (default true)
        --dns list                              Set custom DNS servers (default [])
        --dns-option list                       Set DNS options (default [])
        --dns-search list                       Set custom DNS search domains (default [])
        --entrypoint string                     Overwrite the default ENTRYPOINT of the image
    -e, --env list                              Set environment variables (default [])
        --env-file list                         Read in a file of environment variables (default [])
        --expose list                           Expose a port or a range of ports (default [])
        --group-add list                        Add additional groups to join (default [])
        --health-cmd string                     Command to run to check health
        --health-interval duration              Time between running the check (ns|us|ms|s|m|h) (default 0s)
        --health-retries int                    Consecutive failures needed to report unhealthy
        --health-timeout duration               Maximum time to allow one check to run (ns|us|ms|s|m|h) (default 0s)
        --help                                  Print usage
    -h, --hostname string                       Container host name
        --init                                  Run an init inside the container that forwards signals and reaps processes
        --init-path string                      Path to the docker-init binary
    -i, --interactive                           Keep STDIN open even if not attached
        --io-maxbandwidth string                Maximum IO bandwidth limit for the system drive (Windows only)
        --io-maxiops uint                       Maximum IOps limit for the system drive (Windows only)
        --ip string                             Container IPv4 address (e.g. 172.30.100.104)
        --ip6 string                            Container IPv6 address (e.g. 2001:db8::33)
        --ipc string                            IPC namespace to use
        --isolation string                      Container isolation technology
        --kernel-memory string                  Kernel memory limit
    -l, --label list                            Set meta data on a container (default [])
        --label-file list                       Read in a line delimited file of labels (default [])
        --link list                             Add link to another container (default [])
        --link-local-ip list                    Container IPv4/IPv6 link-local addresses (default [])
        --log-driver string                     Logging driver for the container
        --log-opt list                          Log driver options (default [])
        --mac-address string                    Container MAC address (e.g. 92:d0:c6:0a:29:33)
    -m, --memory string                         Memory limit
        --memory-reservation string             Memory soft limit
        --memory-swap string                    Swap limit equal to memory plus swap: '-1' to enable unlimited swap
        --memory-swappiness int                 Tune container memory swappiness (0 to 100) (default -1)
        --name string                           Assign a name to the container
        --network string                        Connect a container to a network (default "default")
        --network-alias list                    Add network-scoped alias for the container (default [])
        --no-healthcheck                        Disable any container-specified HEALTHCHECK
        --oom-kill-disable                      Disable OOM Killer
        --oom-score-adj int                     Tune host's OOM preferences (-1000 to 1000)
        --pid string                            PID namespace to use
        --pids-limit int                        Tune container pids limit (set -1 for unlimited)
        --privileged                            Give extended privileges to this container
    -p, --publish list                          Publish a container's port(s) to the host (default [])
    -P, --publish-all                           Publish all exposed ports to random ports
        --read-only                             Mount the container's root filesystem as read only
        --restart string                        Restart policy to apply when a container exits (default "no")
        --rm                                    Automatically remove the container when it exits
        --runtime string                        Runtime to use for this container
        --security-opt list                     Security Options (default [])
        --shm-size string                       Size of /dev/shm, default value is 64MB
        --sig-proxy                             Proxy received signals to the process (default true)
        --stop-signal string                    Signal to stop a container, SIGTERM by default (default "SIGTERM")
        --stop-timeout int                      Timeout (in seconds) to stop a container
        --storage-opt list                      Storage driver options for the container (default [])
        --sysctl map                            Sysctl options (default map[])
        --tmpfs list                            Mount a tmpfs directory (default [])
    -t, --tty                                   Allocate a pseudo-TTY
        --ulimit ulimit                         Ulimit options (default [])
    -u, --user string                           Username or UID (format: <name|uid>[:<group|gid>])
        --userns string                         User namespace to use
        --uts string                            UTS namespace to use
    -v, --volume list                           Bind mount a volume (default [])
        --volume-driver string                  Optional volume driver for the container
        --volumes-from list                     Mount volumes from the specified container(s) (default [])
    -w, --workdir string                        Working directory inside the container

    # 上面就是获取run子命令的方法， 常用的选项是下面几个
    -i： 交互模式
    -t： 分配终端
    -v： 卷设置
    -p： 端口配置
    -h： 主机名
    -a： 附加
    -e:  环境变量
    --rm: 停掉容器就删除


阿里云使用阿里云docker仓库拉取和分发
======================================================================================================================================================


阿里云ECS
------------------------------------------------------------------------------------------------------------------------------------------------------

在拉取和分发之前需要配置下docker加速,因为默认是从dockerhub上拉取的，比较慢，这个可以根据实际情况修改。

阿里的docker加速配置:
    进入网址:https://dev.aliyun.com/search.html

docker加速器配置
......................................................................................................................................................

具体步骤:
    - 首先是访问:https://dev.aliyun.com/search.html,然后登陆阿里云账号。
    - 根据镜像加速中的操作文档操作。其中加速地址和账号有关联。根据这个操作文档配置 ``ECS`` 的 ``docker``
    - 然后进入 ``管理中心``
    - 初次使用设置 ``Registry登陆密码`` ，这个密码之后从云主机推送或者拉取自建镜像使用。
    - 创建 ``命名空间``
    - 创建 ``镜像仓库``

.. attention::
    创建 ``镜像仓库`` 的时候可以选择

.. note:: 上面的加速地址，是阿里云给我分配的加速地址，如果没有阿里云的账号，可以使用docker中国的加速器，地址为https://registry.docker-cn.com

上面具体步骤重点步骤如下图说明：

- 创建仓库如下图：

.. hint::
    创建仓库需要先有命名空间。

.. image:: /Server/res/images/server/linux/docker/docker-aliyun-create-repo.png
    :align: center
    :height: 500 px
    :width: 800 px

- 如果使用的是代码仓库来创建docker仓库镜像，可以绑定不同的代码平台的账号，具体如下(举例github)：

首先:

.. image:: /Server/res/images/server/linux/docker/docker-aliyun-bind-codeaccount01.png
    :align: center
    :height: 500 px
    :width: 800 px

然后绑定对应的账号:

.. image:: /Server/res/images/server/linux/docker/docker-aliyun-bind-codeaccount02.png
    :align: center
    :height: 500 px
    :width: 800 px


- 根据绑定代码平台账号创建仓库镜像

.. image:: /Server/res/images/server/linux/docker/docker-aliyun-github-createrep.png
    :align: center
    :height: 500 px
    :width: 800 px

- 创建空的仓库，然后推送本地镜像到仓库。

.. image:: /Server/res/images/server/linux/docker/docker-aliyun-create-localrepo.png
    :align: center
    :height: 500 px
    :width: 800 px


准备下阿里云相关的配置:

.. code-block:: text
    :linenos:

    1. 登录阿里云Docker Registry
    $ sudo docker login --username=1530225798@qq.com registry.cn-hongkong.aliyuncs.com
    用于登录的用户名为阿里云账号全名，密码为开通服务时设置的密码。

    您可以在产品控制台首页修改登录密码。

    2. 从Registry中拉取镜像
    $ sudo docker pull registry.cn-hongkong.aliyuncs.com/zzjlogin/ceshi:[镜像版本号]
    3. 将镜像推送到Registry
    $ sudo docker login --username=1530225798@qq.com registry.cn-hongkong.aliyuncs.com
    $ sudo docker tag [ImageId] registry.cn-hongkong.aliyuncs.com/zzjlogin/ceshi:[镜像版本号]
    $ sudo docker push registry.cn-hongkong.aliyuncs.com/zzjlogin/ceshi:[镜像版本号]
    请根据实际镜像信息替换示例中的[ImageId]和[镜像版本号]参数。

    4. 选择合适的镜像仓库地址
    从ECS推送镜像时，可以选择使用镜像仓库内网地址。推送速度将得到提升并且将不会损耗您的公网流量。

    如果您使用的机器位于经典网络，请使用 registry-internal.cn-hongkong.aliyuncs.com 作为Registry的域名登录，并作为镜像命名空间前缀。
    如果您使用的机器位于VPC网络，请使用 registry-vpc.cn-hongkong.aliyuncs.com 作为Registry的域名登录，并作为镜像命名空间前缀。
    5. 示例
    使用"docker tag"命令重命名镜像，并将它通过专有网络地址推送至Registry。

    $ sudo docker images
    REPOSITORY                                                         TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    registry.aliyuncs.com/acs/agent                                    0.7-dfb6816         37bb9c63c8b2        7 days ago          37.89 MB
    $ sudo docker tag 37bb9c63c8b2 registry-vpc.cn-hongkong.aliyuncs.com/acs/agent:0.7-dfb6816
    使用"docker images"命令找到镜像，将该镜像名称中的域名部分变更为Registry专有网络地址。

    $ sudo docker push registry-vpc.cn-hongkong.aliyuncs.com/acs/agent:0.7-dfb6816


普通主机使用docker-hub公共镜像pull下来镜像
======================================================================================================================================================

查找:

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# docker search centos-io
    NAME                                 DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
    centos                               The official build of CentOS.                   4679      [OK]       
    iojs                                 io.js is an npm compatible platform origin...   127       [OK]       
    ansible/centos7-ansible              Ansible on Centos7                              116                  [OK]
    jdeathe/centos-ssh                   CentOS-6 6.10 x86_64 / CentOS-7 7.5.1804 x...   99                   [OK]
    agileek/ionic-framework              Run ionic framework                             87                   [OK]
    openshift/base-centos7               A Centos7 derived base image for Source-To...   33                   
    beevelop/ionic                       Latest Ionic based on the latest Cordova, ...   30                   [OK]
    iotaledger/iri                       IOTA Reference Implementation                   16                   [OK]
    bluedigits/iota-node                 IOTA Full Node                                  9                    [OK]
    mesosphere/iot-demo                  IoT demo Docker image.                          9                    [OK]
    buanet/iobroker                      Docker Image for ioBroker based on Debian ...   9                    [OK]
    pivotaldata/centos-gpdb-dev          CentOS image for GPDB development. Tag nam...   7                    
    asmaps/docker-iodine                 Dockerized iodine server                        6                    [OK]
    marcoturi/ionic                      Ionic image for CI with karma and protract...   5                    [OK]
    microsoft/iot-edge-opc-publisher     Azure IoT Edge OPC Publisher Module             5                    [OK]
    microsoft/iot-gateway-opc-ua-proxy   Azure IoT Edge OPC Proxy Module                 5                    [OK]
    microsoft/iot-edge-opc-proxy         Azure IoT Edge OPC Proxy Module                 4                    [OK]
    iobroker/iobroker                    This is docker version of ioBroker Home-Au...   3                    [OK]
    pivotaldata/centos                   Base centos, freshened up a little with a ...   2                    
    plusrseito/centos-ionic                                                              0                    
    applet/applet-io                     applet-io repository                            0                    
    cubedhost/tools-3h-io                tools-3h-io                                     0                    [OK]
    turistforeningen/ruby-iojs           Docker Image with Ruby and io.js installed      0                    [OK]
    aerogearcatalog/ios-app-apb          APB for creating an iOS App                     0                    [OK]
    oblique/iodined                      Docker image for iodine server                  0                    [OK]

把镜像下载到本地:

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# docker pull centos
    latest: Pulling from centos
    675ac122cafb: Pull complete 
    a4875ffe6057: Pull complete 
    c5507be714a7: Pull complete 
    Digest: sha256:5d91c5535c41fd1bb48d40581a2c8b53d38fc2eb26df774556b53c5a0bd4d44e
    Status: Downloaded newer image for centos:latest
    [root@zzjlogin ~]# docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    centos              latest              c5507be714a7        5 weeks ago         199.7 MB

镜像保存(save)
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-151 yum.repos.d]# docker save busybox alpine | gzip > tree.tgz
    [root@centos-151 yum.repos.d]# scp tree.tgz  192.168.46.152:/root


镜像加载(load)
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-152 ~]# docker help load 
    [root@centos-152 ~]# docker image load -i tree.tgz 
    3e596351c689: Loading layer [==================================================>]  1.36 MB/1.36 MB
    Loaded image: docker.io/busybox:latest
    cd7100a72410: Loading layer [==================================================>] 4.403 MB/4.403 MB
    Loaded image: docker.io/alpine:latest
    [root@centos-152 ~]# docker image ls 
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    docker.io/busybox   latest              2716f21dc1e3        37 hours ago        1.15 MB
    docker.io/alpine    latest              3fd9065eaf02        2 months ago        4.15 MB


docker卷(Volumes)
======================================================================================================================================================

docker的卷分为2种

- bind挂载卷
- docker自管理卷

.. attention::
    可以通过这些参数，映射本地文件到docker，这样可以达到docker和本地文件的共享。

.. code-block:: bash
    :linenos:

    [root@centos-151 ~]# docker run --name nginx03    -v /data:/usr/share/nginx/html -d  nginx:1.12-alpine 
    30a8824241a92439547ac5918f75404d3f9953b987c61e0cbada0efe67ef7463

    [root@centos-151 ~]# mkdir /data
    [root@centos-151 ~]# echo "my page"  > /data/index.html
    [root@centos-151 ~]# docker inspect  nginx03  |grep -i ipa
                "SecondaryIPAddresses": null,
                "IPAddress": "172.17.0.3",
                "IPAMConfig": null,
                "IPAddress": "172.17.0.3",

    [root@centos-151 ~]# curl 172.17.0.3
    my page
    # 查看ip信息还有比较好用的方法，个人不习惯用
    [root@centos-151 ~]# docker inspect -f {{.NetworkSettings.Networks.bridge.IPAddress}} nginx03 
    172.17.0.3

    # 查看bind信息
    [root@centos-151 ~]# docker inspect -f {{.Mounts}} nginx03 
    [{bind  /data /usr/share/nginx/html   true rprivate}]
    # 复制卷信息，去启动
    [root@centos-151 ~]# docker run -d --name nginx04 --volumes-from nginx03 nginx:1.12-alpine
    ab414efa85818929d837c2baeb7a271b042eb46ac8ec40431c3d9b33ab6eee07


docker网络
======================================================================================================================================================

docker的网络分为四种

- closed: 封闭的， 只有lo本地回环网卡
- bridged: 桥接，这是默认的
- joined: 连接的，多个docker公用一个network命名空间
- opened: 开放的，和宿主机一个命名空间

查看网络列表
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-151 ~]# docker network ls 
    NETWORK ID          NAME                DRIVER              SCOPE
    e00b7e276b12        bridge              bridge              local
    42c62865be61        host                host                local
    ccb7572950be        none                null                local

bridge
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-151 ~]# docker run --name busybox10 -it busybox  
    / # ifconfig
    eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:05  
            inet addr:172.17.0.5  Bcast:0.0.0.0  Mask:255.255.0.0
            inet6 addr: fe80::42:acff:fe11:5/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:6 errors:0 dropped:0 overruns:0 frame:0
            TX packets:6 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0 
            RX bytes:508 (508.0 B)  TX bytes:508 (508.0 B)

    lo        Link encap:Local Loopback  
            inet addr:127.0.0.1  Mask:255.0.0.0
            inet6 addr: ::1/128 Scope:Host
            UP LOOPBACK RUNNING  MTU:65536  Metric:1
            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1 
            RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

    / # ^C
    / # exit

closed 
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-151 ~]# docker run --name busybox11 -it --network none busybox  
    / # ifconfig 
    lo        Link encap:Local Loopback  
            inet addr:127.0.0.1  Mask:255.0.0.0
            inet6 addr: ::1/128 Scope:Host
            UP LOOPBACK RUNNING  MTU:65536  Metric:1
            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1 
            RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

    / # exit

joined
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-151 ~]# docker run --name nginx11 -d  --rm nginx:1.12-alpine
    cf5e89cddf175152472d25d51d52ae1e136bc5887682f24203bb178487674103
    [root@centos-151 ~]# docker inspect  nginx11 |grep -i ipa
                "SecondaryIPAddresses": null,
                "IPAddress": "172.17.0.5",
                        "IPAMConfig": null,
                        "IPAddress": "172.17.0.5",
    [root@centos-151 ~]# docker run --name busybox12 --rm -it --network container:nginx11 busybox 
    / # curl localhost
    sh: curl: not found
    / # wget localhost
    Connecting to localhost (127.0.0.1:80)
    index.html           100% |**************************************************************************************************************************************************|   612   0:00:00 ETA
    / # cat index.html 
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
    </style>
    </head>
    <body>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>

    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>

    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>

opened 
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    [root@centos-151 ~]# docker run --name nginx15 -d  --network host nginx:1.12-alpine 
    f0fd0f9069cab8126c53cde3baa8d76a94e89abd709a7864b96bfeb400628677
    [root@centos-151 ~]# docker inspect nginx15 |grep -i ipa
                "SecondaryIPAddresses": null,
                "IPAddress": "",
                        "IPAMConfig": null,
                        "IPAddress": "",
    [root@centos-151 ~]# curl localhost
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
    </style>
    </head>
    <body>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>

    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>

    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>

docker端口映射
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    [root@centos-151 ~]# docker run --name nginx17 -d  -p 80:80 nginx:1.12-alpine 
    dda9ec45687aa71d552a32e65bb7d703a1b2170ea57416543a67e2055e1f5052


    [root@centos-152 ~]# clear
    [root@centos-152 ~]# curl 192.168.46.151
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
    </style>
    </head>
    <body>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>

    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>

    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>

查看映射

.. code-block:: bash
    :linenos:

    [root@centos-151 ~]# docker port nginx17
    80/tcp -> 0.0.0.0:80




