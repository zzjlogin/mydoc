.. _nginx-config-advance:

======================================================================================================================================================
nginx高级配置
======================================================================================================================================================

nginx日志记录配置
======================================================================================================================================================


日志模块即配置详解
------------------------------------------------------------------------------------------------------------------------------------------------------

一般nginx日志可以分为：
    错误日志、访问日志。如果是编译安装则默认日志路径为安装目录中的logs目录


错误日志
    记录nginx错误信息，这是调试nginx服务的重要手段。
    
    参考连接：http://nginx.org/en/docs/ngx_core_module.html#error_log
    属于核心功能模块ngx_http_core_module的参数。该参数的名字为error_log，可以放在Main区中全局配置，也可以放置在不同的虚拟主机中单独记录，优先级是：
    
    error_log的语法格式及参数语法说明如下：
        error_log    file    level;
        
        关键字             日志文件    错误日志级别
    其中关键字error_log不能修改，日志文件可以用绝对路径指定任意目录的文件，如果是编译安装则默认日志路径为安装目录中的logs目录。错误日志级别中常见的有[debug|info|notice|warn|error|crit|alert|emerg]，级别越高，记录的信息越少。生产场景一般常用的级别：warn|error|crit三个级别之一。注意：一般不建议配置debug|info较低级别日志，这样会带来很大的磁盘I/O消耗。
    
    error_log默认配置：
        默认级别是：error级别
        
        # default: error_log logs/error.log error
        
        可以放置的标签为：
        
        # context: man,http,server,location

访问日志
    nginx软件会把每个用户访问网站的日志信息记录到指定的日志文件里，方便网站提供者分析用户的浏览行为等。
    这个功能是ngx_http_log_module模块提供的。
    
    对应的官网地址是：http://nginx.org/en/docs/http/ngx_http_log_module.html#access_log


.. tip::
    如果nginx前端没有设置代理服务器，则可以把http_x_forwarded_for替换成remote_addr，这样就可以记录访问网站的客户端IP。



日志自定义格式配置
------------------------------------------------------------------------------------------------------------------------------------------------------



默认日志格式和日志记录内容：

.. code-block:: text
    :linenos:

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

一般建议设置日志：
    日志配置，可以配置在http区域也可以配置在server区域。一般配置在http区域。这样所有的虚拟主机都默认使用这个log格式模版。

.. code-block:: text
    :linenos:

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $request_time $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for" "$connection_requests"';

修改后的主配置文件内容：

.. code-block:: bash
    :linenos:

    [root@zzjlogin nginx]# cat conf/nginx.conf
    worker_processes  1;
    events {
        worker_connections  10240;
    }
    http {
        include       mime.types;
        include       conf.d/*;
        default_type  application/octet-stream;
        sendfile        on;
        keepalive_timeout  65;

        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $request_time $body_bytes_sent '
                          '"$http_referer" "$http_user_agent" "$http_x_forwarded_for"';
        error_page   500 502 503 504  /50x.html;
    }



日志文件切割/定期轮询
------------------------------------------------------------------------------------------------------------------------------------------------------
    
创建切割日志脚本：

.. code-block:: bash
    :linenos:

    [root@zzjlogin nginx]# mkdir /data/scripts/
    [root@zzjlogin nginx]# mkdir /data/scripts/ -p
    [root@zzjlogin nginx]# cat >>/data/scripts/cut_nginx_log.sh<<EOF
    > #!/bin/sh
    > Dateformat=`date +%Y%m%d`
    > Basedir='/usr/local/nginx'
    > Nginxlogdir="$Basedir/logs"
    > Logname='access'
    > [ -d $Nginxlogdir ] && cd $Nginxlogdir || exit 1
    > [ -f ${Logname}.log ]||exit 1
    > /bin/mv ${Logname}.log ${Dateformat}_${Logname}.log
    > $Basedir/sbin/nginx -s reload
    > EOF

创建定时任务：

.. code-block:: bash
    :linenos:

    [root@zzjlogin nginx]# cat >>/var/spool/cron/root <<EOF
    #cut nginx access log
    00 00 * * * /bin/sh /data/scripts/cut_nginx_log.sh >/dev/null 2>&1
    EOF
    
查看定时任务：

.. code-block:: bash
    :linenos:

    [root@zzjlogin nginx]# crontab -l



nginx日志自定义格式、日期定期轮询配置
------------------------------------------------------------------------------------------------------------------------------------------------------


.. code-block:: bash
    :linenos:

    >/usr/local/nginx/conf/nginx.conf

    cat >>/usr/local/nginx/conf/nginx.conf<<EOF
    worker_processes  1;
    events {
        worker_connections  10240;
    }
    http {
        include       mime.types;
        include       conf.d/*;
        default_type  application/octet-stream;
        sendfile        on;
        keepalive_timeout  65;

        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $request_time $body_bytes_sent '
                          '"$http_referer" "$http_user_agent" "$http_x_forwarded_for"';
        error_page   500 502 503 504  /50x.html;
    }
    EOF


    mkdir /data/scripts/
    mkdir /data/scripts/ -p
    cat >>/data/scripts/cut_nginx_log.sh<<EOF
    #!/bin/sh
    Dateformat=`date +%Y%m%d`
    Basedir='/usr/local/nginx'
    Nginxlogdir="$Basedir/logs"
    Logname='access'
    [ -d $Nginxlogdir ] && cd $Nginxlogdir || exit 1
    [ -f ${Logname}.log ]||exit 1
    /bin/mv ${Logname}.log ${Dateformat}_${Logname}.log
    $Basedir/sbin/nginx -s reload
    EOF

    cat >>/var/spool/cron/root <<EOF
    #cut nginx access log
    00 00 * * * /bin/sh /data/scripts/cut_nginx_log.sh >/dev/null 2>&1
    EOF

    /usr/local/nginx/sbin/nginx -t

    /usr/local/nginx/sbin/nginx -s reload


nginx状态信息监控
======================================================================================================================================================


nginx状态模块及配置详解
------------------------------------------------------------------------------------------------------------------------------------------------------

模块ngx_http_stub_status_module提供的功能是：记录nginx的基本访问状态信息，让使用者了解nginx的工作状态。例如：连接数等信息。要使用状态模块，需要编译安装时增加http_stub_status_module模块来支持。
检查nginx是否设置了指定模块 ``/usr/local/nginx/sbin/nginx -V``

.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# /usr/local/nginx/sbin/nginx -V
    nginx version: nginx/1.12.2
    built by gcc 4.4.7 20120313 (Red Hat 4.4.7-11) (GCC) 
    built with OpenSSL 1.0.1e-fips 11 Feb 2013
    TLS SNI support enabled
    configure arguments: --prefix=/usr/local/nginx-1.12.2 --user=nginx --group=nginx --with-http_stub_status_module --with-http_ssl_module



配置nginx状态监控一般需要设置允许的IP。然后用zabbix监控nginx状态。防止其他IP访问。


1. 检查是否有子配置文件的目录，如果没有则创建子目录：

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# pwd
    /usr/local/nginx/conf
    [root@zzjlogin conf]# ll
    total 68
    drwxr-xr-x. 2 root root 4096 Oct 17 00:38 conf.d
    -rw-r--r--. 1 root root 1077 Oct 15 23:47 fastcgi.conf
    -rw-r--r--. 1 root root 1077 Oct 15 23:47 fastcgi.conf.default
    -rw-r--r--. 1 root root 1007 Oct 15 23:47 fastcgi_params
    -rw-r--r--. 1 root root 1007 Oct 15 23:47 fastcgi_params.default
    -rw-r--r--. 1 root root 2837 Oct 15 23:47 koi-utf
    -rw-r--r--. 1 root root 2223 Oct 15 23:47 koi-win
    -rw-r--r--. 1 root root 3957 Oct 15 23:47 mime.types
    -rw-r--r--. 1 root root 3957 Oct 15 23:47 mime.types.default
    -rw-r--r--. 1 root root  274 Oct 17 00:05 nginx.conf
    -rw-r--r--. 1 root root 2656 Oct 16 18:19 nginx.conf.2018-10-16
    -rw-r--r--. 1 root root 2656 Oct 15 23:47 nginx.conf.default
    -rw-r--r--. 1 root root  636 Oct 15 23:47 scgi_params
    -rw-r--r--. 1 root root  636 Oct 15 23:47 scgi_params.default
    -rw-r--r--. 1 root root  664 Oct 15 23:47 uwsgi_params
    -rw-r--r--. 1 root root  664 Oct 15 23:47 uwsgi_params.default
    -rw-r--r--. 1 root root 3610 Oct 15 23:47 win-utf

上面提示已经有子配置文件存放目录 ``conf.d`` ，如果没有这个目录可以手动创建： ``mkdir conf.d``

.. hint::
    conf.d这个目录名，是官方名称，这里也这样使用。也可以自定义一个其他名称。

2. 通过虚拟主机的方式创建状态信息监控的虚拟主机，这个可以用端口/IP或域名。一般用端口即可。

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# cat >>conf.d/status_virtualhost.conf<<EOF
    > ##status
    > server{
    >     listen    8080;
    >     #server_name    status.mysite.com;
    >     location  /  {
    >       stub_status    on;
    >       access_log    off;
    >       allow  192.168.161.0/24;
    >       deny  all;
    >     }
    > }
    > EOF


    [root@zzjlogin conf]# cat nginx.conf
    worker_processes  1;
    events {
        worker_connections  10240;
    }
    http {
        include       mime.types;
        include       conf.d/*;
        default_type  application/octet-stream;
        sendfile        on;
        keepalive_timeout  65;
            error_page   500 502 503 504  /50x.html;
    }

    [root@zzjlogin conf]# ll conf.d/
    total 8
    -rw-r--r--. 1 root root 197 Oct 17 00:02 server.conf
    -rw-r--r--. 1 root root 201 Oct 17 02:13 status_virtualhost.conf

    [root@zzjlogin conf]# cat conf.d/server.conf
    server {
            listen       80;
            #server_name  localhost;
            root   /var/www/html;
            location / {
            #    root   html;
                index  index.html index.htm;
            }
    }


3. 检查主配置。如果没有包含这个子配置，则加入包含这个子配置文件到主配置文件。

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# ../sbin/nginx -t
    nginx: the configuration file /usr/local/nginx-1.12.2/conf/nginx.conf syntax is ok
    nginx: configuration file /usr/local/nginx-1.12.2/conf/nginx.conf test is successful


4. 检查配置语法、重载配置文件。

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# ../sbin/nginx -s reload

5. 检查状态信息监控是否正常

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# curl http://192.168.161.132:8080
    Active connections: 1 
    server accepts handled requests
    53 53 47 
    Reading: 0 Writing: 1 Waiting: 0


上面的状态信息说明：

Active connections:表示nginx正在处理的活动链接数有5个
server:表示nginx启动到现在共处理了11个连接；
accepts:表示nginx启动到现在共成功创建了11次握手，请求丢失数=握手数-连接数
handled requests:表示总共处理了7次请求；
Reading:表示nginx读取到客户端的header信息数
Writing:表示nginx返回给客户端的header信息数；
Waiting:表示nginx已经处理完正在等候下一次请求指令的驻留连接。在开启keep-alive的情况下这个值等于active-（reading+writing）



nginx状态模块配置命令集合
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: bash
    :linenos:

    cd /usr/local/nginx/conf/
    mkdir conf.d
    sed -i "/include       mime.types;/a\    include       conf.d/*;" nginx.conf

    cat >>conf.d/status_virtualhost.conf<<EOF
    worker_processes  1;
    events {
        worker_connections  10240;
    }
    http {
        include       mime.types;
        include       conf.d/*;
        default_type  application/octet-stream;
        sendfile        on;
        keepalive_timeout  65;
            error_page   500 502 503 504  /50x.html;
    }

    EOF

    cd /usr/local/nginx/sbin/
    nginx -s reload




location区块
======================================================================================================================================================

location作用：location指令的作用是根据用户请求的URI来执行不同的应用。
也就是根据用户请求的网站地址URL来进行匹配，匹配成功即进行相应的操作。

location语法：
    ``location [ = | ~ | ~* | ^~ ] uri {…}``


匹配“~”或“~*”区别：“~”用于区分大小写（大小写敏感）的匹配，“~*”用于不区分大小写的匹配。
“~”或“~*”都可以用逻辑操作符“!”对上面匹配取反。此外，“^~”的作用是进行常规的字符串匹配检查，不做正则表达式检查，
即如果最明确的那个字符串匹配的location匹配中有这个前缀，那么不用做正则表达式的检查。






rewrite实现URL重定向
======================================================================================================================================================

rewrite主要功能是实现URL地址重写（和apache等web服务软件类似）。nginx的rewrite规则需要PCRE软件的支持，即通过Perl兼容正则表达式语法进行规则匹配。默认nginx编译安装时会安装支持rewrite模块。

rewrite语法：
    - 指令语法： ``rewrite regex replacement [flag];``
    - 默认值：none
    - 应用位置：server、location、if
    
    rewrite是关键字，regex是正则表达式，replacement是重定向到的目标，flag是标记。
    
    实例：
        ``rewrite ^/(.*) http://192.168.2.104/$1 permanent``

regex正则表达式



==================== ============================================================================
**字符**                **描述**
-------------------- ----------------------------------------------------------------------------
\\                      将后面接着的字符标记为一个特殊字符或一个原义字符或一个向后引用。
                        例如：“\n”匹配换行符“\$”匹配“$”
-------------------- ----------------------------------------------------------------------------
\^                       匹配输入字符串的起始位置。
-------------------- ----------------------------------------------------------------------------
\$                       匹配输入字符串的结束位置。
-------------------- ----------------------------------------------------------------------------
\+                       匹配前面字符串一次或多次
-------------------- ----------------------------------------------------------------------------
\?                      匹配前面字符串0次或1次。例如：do(es)?可以匹配do和does
                        这个字符紧跟任何一个其他限制符（*，+，{n}，{n,m}）
                        的后面时匹配模式是非贪婪模式。
                        如果没有？默认是贪婪模式匹配，即尽可能多的匹配所搜索的字符串。
                        而非贪婪模式是尽可能少的匹配所搜索的字符串。
                        例如：对字符串oooo进行匹配“o+?”匹配结果是o，而匹配“o+”匹配结果是所有o，即oooo
-------------------- ----------------------------------------------------------------------------
\*                       匹配前面字符0次或多次。
-------------------- ----------------------------------------------------------------------------
(pattern)               匹配括号内的pattern，并可以在后面获取匹配的结果。
                        常用$0…$9属性获取小括号内的匹配内容。如果想匹配小括号需要用“\(”和“\)”
==================== ============================================================================
    	
    	
        
    	
    	
    
flag标记说明

==================== ============================================================================
flag标记符号	        说明
-------------------- ----------------------------------------------------------------------------
last	                本条规则匹配完成后，继续向下匹配location URI规则
-------------------- ----------------------------------------------------------------------------
break	                本条规则匹配完成即终止，不再匹配任何后面的规则
-------------------- ----------------------------------------------------------------------------
redirect	            返回302临时重定向，浏览器地址栏会显示跳转后的URL地址
-------------------- ----------------------------------------------------------------------------
permanent	            返回301永久重定向，浏览器地址栏会显示跳转后的URL地址
                        last和break都是服务器端访问程序及路径发生变化，浏览器地址栏的URL不变。
                        但是使用alias指令时必须用last标记，使用proxy_pass指令时要用break标记。
                        redirect和permanent都会使浏览器地址栏的URL发生变化。
==================== ============================================================================

rewrite应用企业应用场景：
    可以调整用户浏览的URL，使其看起来更规范，合乎开发及产品人员的需求。
    为了让搜索引擎收录网站内容，并让用户体验更好，企业会将动态URL伪装成静态地址提供服务。
    网站更新域名后，让就得域名访问跳转到新的域名上。
    
    例如：让京东的360buy换成jd.com
    根据特殊变量、目录、客户端的信息进行URL跳转等。



nginx实现http访问认证
======================================================================================================================================================

请求网站的时候弹出窗口提示需要认证用户名和密码。

主要应用在：企业内部人员访问的地址，例如：企业网站后台、MySQL客户端phpmyadmin、企业内部的CRM、WIKI网站平台等。


主要参数：
    auth_basic
        **语法：** auth_basic string|off;
        **默认：** auth_basic off;
        **作用：** 用于设置认证提示字符串。
    auth_basic_user_file
        **语法：** auth_basic_user_file file;
        
        **默认：** \-
        
        **作用：** 用于设置认证的账号名、密码文件，即用户输入用户名和密码后nginx会到这个文件中对比用户输入信息是否正确，进而决定是否允许用户访问网站。

**以上两个参数使用位置：** http、server、location、limit_except

- 如果只是对特定的链接做认证可以在location位置设置这两个参数
- 如果对一个站点的首页进行认证，可以再server区域设置
- 如果对所有server区域都进行认证，可以在http区域设置。

密码文件中文件内容格式：
    # comment
    name1:password1

    name2:password2\:comment
    
    其中用分号隔开，第一列是用户名，第二列是密码。密码不能是明文。可以通过apache提供的htpasswd命令设置生成用户名和密码。也可以用openssl passwd password123 生成password123对应的密文然后把用户名和这个密文密码添加到htpasswd文件即可。

.. attention::
    密码文件htpasswd文件权限要缩小。默认是644，需要缩小到400，文件所属用户也需要修改为nginx程序所属用户。

通过location测试认证
------------------------------------------------------------------------------------------------------------------------------------------------------


在虚拟主机的location位置添加参数：
    auth_basic "myblog";
    
    auth_basic_user_file /usr/local/nginx/conf/htpasswd;


**添加认证：**
    方法1：
        which htpasswd

        如果发现没有htpasswd命令，则安装：
            yum install httpd -y
        创建文件及用户和密码：
            htpasswd -bc /usr/local/nginx/conf/htpasswd zzj 123
        如果有htpasswd文件以后可以用下面命令增加用户名和密码：
            htpasswd -b /usr/local/nginx/conf/htpasswd abc 123 
        缩小文件权限：

.. code-block:: bash
    :linenos:

    chmod 400 /usr/local/nginx/conf/htpasswd
    chown nginx /usr/local/nginx/conf/htpasswd
        
    方法2：
        生成密码12345的密文：
            openssl passwd 12345
                BOStVVca97Ujw
        编辑密码文件把用户名和上面的密文密码添加到密码文件：
            vi /usr/local/nginx/conf/htpasswd
                zzj:BOStVVca97Ujw
        缩小文件权限：

.. code-block:: bash
    :linenos:

    chmod 400 /usr/local/nginx/conf/htpasswd
    chown nginx /usr/local/nginx/conf/htpasswd

检查配置文件语法，然后重启：

.. code-block:: bash
    :linenos:

    /usr/local/nginx/sbin/nginx -t
    /usr/local/nginx/sbin/nginx -s reload

nginx站点认证命令集合
------------------------------------------------------------------------------------------------------------------------------------------------------





显示站点文件目录结构
======================================================================================================================================================


除非有需求。一般不配置显示目录结构。

配置：
    虚拟主机配置文件的location部分添加下面一行：
        autoindex on;

    然后把根目录：html/myblog下面的index.html删掉或者修改名称即可。否则会出现404错误。





配置反向代理
======================================================================================================================================================
代理模块
    参考：http://nginx.org/en/docs/http/ngx_http_proxy_module.html

    ``ngx_http_proxy_module`` 模块允许将请求传递给另一个服务器。这个模块主要有66个指令。





配置负载均衡
======================================================================================================================================================

nginx负载均衡功能依赖于 ``ngx_http_upstream_module`` 模块，支持的代理方式：
    - proxy_pass
    - fastcgi_pass
    - memcached_pass

配置实现是通过在负载均衡节点nginx配置文件nginx.conf中的http区添加一个upstream区。
然后在server区调用这个upstream区的名字即可。

简单的负载均衡配置如下（轮询算法默认wrr weighted round-robin权重轮询）

代理服务器的nginx配置文件：

.. code-block:: bash
    :linenos:

    cat nginx.conf

    worker_processes  1;
    events {
        worker_connections  1024;
    }
    http {
        include       mime.types;
        default_type  application/octet-stream;
        sendfile        on;
        keepalive_timeout  65;
        upstream server_pools {
            server 192.168.10.220    weight=1;
        }
        server {
            listen       80;
            server_name  localhost;
            location / {
                proxy_pass http://server_pools;
            }
            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   html;
            }
        }
    }


上面upstream定义提供web服务的RIP。然后用户访问这个服务器时会自动调用后端的
RIP的web服务然后返回给用户。

说明：
    - upstream：定义RIP的地址池和权值
    - proxy_pass：定义符合这个规则访问到这个http页面时调用哪个地址池的RIP服务。








配置优化
======================================================================================================================================================

