

.. _zzjlogin-nginx-baseconfig:

======================================================================================================================================================
nginx基础配置
======================================================================================================================================================


nginx配置文件结构
======================================================================================================================================================

nginx主配置文件是： ``nginx.conf`` ，也可以类似apache通过不同的子配置文件配置，然后包含到主配置文件中。

nginx主配置文件简单说明：
    - 主配置文件中配置参数的行需要以 ``;`` 结尾。
    - 主配置文件通过关键字和 ``{}`` 来分割每个配置区域，即可以理解成字典类型的配置方法。

过滤所有注释后的nginx默认配置内容：

过滤命令：

.. code-block:: bash
    :linenos:
    
    egrep -v "#|^$" /usr/local/nginx/conf/nginx.conf

nginx默认配置解释：

.. code-block:: text
    :linenos:

    worker_processes  1;                            worker进程的数量
    events {                                        Events区块开始
        worker_connections  1024;                   每个worker进程支持的最大连接数
    }                                               Events区块结束
    http {                                          http区块开始
        include       mime.types;                   nginx支持的媒体类型库文件
        default_type  application/octet-stream;     默认的媒体类型
        sendfile        on;                         开启高效传输模式
        keepalive_timeout  65;                      连接超时时间65秒
        server {                                    第一个server区块，表示一个独立的虚拟主机站点。可以设置多个
            listen       80;                        监听端口，即为这个站点提供服务的端口
            server_name  localhost;                 提供服务的域名主机
            location / {                            第一个location区块开始，可以有多个location
                root   html;                        站点根目录，相当于nginx的安装目录，html目录需要755权限
                index  index.html index.htm;        默认首页文件，多个文件时用空格隔开
            }                                       location区块结束
            error_page   500 502 503 504  /50x.html;    出现对应http状态码时返回50x.html页面
            location = /50x.html {                  location区块开始，访问50x.html
                root   html;                        指定这个节点的目录
            }                                       location区块结束
        }                                           server区块结束
    }                                               http区块结束


重点区域说明：
    - worker_processes设置为CPU个数的两倍比较好。
    - worker_connections是每个worker进程最大链接数，实际能打开的最大连接数应该是worker_processes值和worker_connections的值相乘，然后和文件描述符的大小比较，取最小值。( ``ulimit -n`` 来查看系统文件描述符大小，默认1024)
    - include是包含其他文件进这个配置。一般可以在同级目录创建一个conf.d目录来存放子配置文件。然后通过 include conf.d/*; 来包含进这个主配置文件。
    - keepalive_timeout，这个超时时间也可以有效节约资源。
    - 可以通过不同的server区域配置不同的虚拟主机。这个虚拟主机区域可以定义站点位置/端口/域名/允许/拒绝的IP或者IP地址段
    - listen，监听的本地端口。默认时80端口，一个server区域只可以设置一个端口。
    - server_name，用来设置域名访问。这个域名需要同时在DNS有对应的A记录。
    - localtion，默认是 ``/`` 这就是访问时的浏览器访问除了IP以后输入的内容。可以进行匹配然后从而匹配不同的链接进入不同的location操作匹配。
    - localtion区域的root，定义站点的根目录。如果是编译安装，默认站点是安装目录的html目录。如果rpm/yum安装则默认是/var/www/html目录。如果自定义根目录。需要注意输入绝对路径，并且根目录权限755。
    - localtion区域的index，定义默认的首页文件，即不输入文件名时，访问的目录的主页文件时哪些名称和后缀。
    - error_page，用来做异常处理，定义500、502、503、504这三种错误状态码会返回哪个页面。
    - location = /50x.html，即如果匹配上面的异常则访问/50x.html这个页面。这个页面又是匹配本条location。然后继续进入匹配并操作返回。









