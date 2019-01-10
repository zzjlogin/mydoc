.. _zzjlogin-nginx-config-virtualhost:

======================================================================================================================================================
nginx虚拟主机配置
======================================================================================================================================================

nginx虚拟主机类型：
    - 基于域名的虚拟主机
    - 基于端口的虚拟主机
    - 基于IP的虚拟主机

.. tip:: nginx的虚拟主机功能不如apache强。


nginx配置虚拟机，一般通过子配置文件，然后包含进主配置文件的方式配置。这样的优点：1、配置文件结构清晰简单；2、便于维护；3、复用性高。



nginx虚拟主机配置实例
======================================================================================================================================================

nginx默认配置的server区域分离
------------------------------------------------------------------------------------------------------------------------------------------------------

创建子配置文件的目录：


.. code-block:: bash
    :linenos:

    [root@zzjlogin ~]# cd /usr/local/nginx/conf/
    [root@zzjlogin conf]# mkdir conf.d

把主配置文件的server区域分离出

修改后的主配置文件如下：

.. code-block:: bash
    :linenos:
    
    [root@zzjlogin conf]# vi nginx.conf

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

在conf.d目录创建文件testserver.conf，然后输入server区域内容，具体如下：

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# cat >>conf.d/testserver.conf<<EOF
    > server {
    >         listen       80;
    >         #server_name  localhost;
    >         root   /var/www/html;
    >         location / {
    >         #    root   html;
    >             index  index.html index.htm;
    >         }
    > }
    > EOF
    [root@zzjlogin conf]# cat conf.d/testserver.conf
    server {
            listen       80;
            #server_name  localhost;
            root   /var/www/html;
            location / {
            #    root   html;
                index  index.html index.htm;
            }
    }

以上配置的webserver，就是监听在服务器本地的80端口的虚拟主机。可以通过多个conf.d目录下的配置文件来配置多个虚拟主机。

每个虚拟主机又可以是基于IP的或者基于域名的或者端口的。

.. attention::
    多个虚拟主机不能同时监听同一个本地端口。

添加基于端口的虚拟主机
------------------------------------------------------------------------------------------------------------------------------------------------------

添加基于端口的虚拟主机：

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# cat >>conf.d/porthost1.conf<<EOF
    > server {
    >         listen       8080;
    >         #server_name  localhost;
    >         root   /var/www/html/port/;
    >         location / {
    >         #    root   html;
    >             index  index.html index.htm;
    >         }
    > }
    > EOF
    [root@zzjlogin conf]# cat conf.d/porthost1.conf
    server {
            listen       8080;
            #server_name  localhost;
            root   /var/www/html/port/;
            location / {
            #    root   html;
                index  index.html index.htm;
            }
    }

创建端口虚拟主机的站点测试文件及目录：

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# mkdir /var/www/html/port -p
    [root@zzjlogin conf]# echo "port host test">/var/www/html/port/index.html


检查配置：

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# ../sbin/nginx -t
    nginx: the configuration file /usr/local/nginx-1.12.2/conf/nginx.conf syntax is ok
    nginx: configuration file /usr/local/nginx-1.12.2/conf/nginx.conf test is successful

重载nginx配置文件：

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# ../sbin/nginx -s reload


检查监听服务：

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# ss -lntup|grep 'nginx'
    tcp    LISTEN     0      128                    *:8080                  *:*      users:(("nginx",4109,10),("nginx",13222,10))
    tcp    LISTEN     0      128                    *:80                    *:*      users:(("nginx",4109,6),("nginx",13222,6))

测试：

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# curl http://192.168.161.132
    test
    [root@zzjlogin conf]# curl -I http://192.168.161.132
    HTTP/1.1 200 OK
    Server: nginx/1.12.2
    Date: Tue, 16 Oct 2018 16:12:50 GMT
    Content-Type: text/html
    Content-Length: 5
    Last-Modified: Tue, 16 Oct 2018 10:22:58 GMT
    Connection: keep-alive
    ETag: "5bc5bc02-5"
    Accept-Ranges: bytes

    [root@zzjlogin conf]# curl http://192.168.161.132:8080
    port host test
    [root@zzjlogin conf]# curl -I http://192.168.161.132:8080
    HTTP/1.1 200 OK
    Server: nginx/1.12.2
    Date: Tue, 16 Oct 2018 16:13:07 GMT
    Content-Type: text/html
    Content-Length: 15
    Last-Modified: Tue, 16 Oct 2018 16:09:34 GMT
    Connection: keep-alive
    ETag: "5bc60d3e-f"
    Accept-Ranges: bytes


添加基于域名的虚拟主机
------------------------------------------------------------------------------------------------------------------------------------------------------

.. attention::
    基于域名的虚拟主机的配置中的 ``server_name`` 指定的域名需要在DNS有对应的A记录，或者通过本地主机的hosts文件指定这个域名和IP的映射关系。

    本实例就是通过hosts文件测试。linux是/etc/hosts文件。windows系统是C:\Windows\System32\drivers\etc\hosts，windows10需要新建一个hosts文件。

    hosts文件添加一条内容：``192.168.161.132      www.mysite.com``

    windows如果清空本地DNS缓存需要运行CMD，然后输入命令： ``ipconfig /flushdns``

增加域名的虚拟主机配置文件：

.. tip::
    现在是一个nginx程序监听多个端口。
    这个80是默认配置的站点主机配置端口。
    8080是端口虚拟主机的端口。

    **域名虚拟主机还可以继续复用这些端口。但是不同的域名虚拟主机之间不能使用相同的端口。**

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# cat >>conf.d/mysite.conf<<EOF
    > server {
    >         listen       80;
    >         server_name  www.mysite.com;
    >         root   /var/www/html/port/;
    >         location / {
    >         #    root   html;
    >             index  index.html index.htm;
    >         }
    > }
    > EOF
    [root@zzjlogin conf]# cat conf.d/porthost1.conf
    server {
            listen       80;
            server_name  www.mysite.com;
            root   /var/www/html/mysite/;
            location / {
            #    root   html;
                index  index.html index.htm;
            }
    }

创建域名虚拟主机的测试站点文件：

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# mkdir /var/www/html/mysite -p
    [root@zzjlogin conf]# echo "www.mysite.com">/var/www/html/mysite/index.html


检查配置并重新加载配置：

.. code-block:: bash
    :linenos:

    [root@zzjlogin conf]# ../sbin/nginx -t
    nginx: the configuration file /usr/local/nginx-1.12.2/conf/nginx.conf syntax is ok
    nginx: configuration file /usr/local/nginx-1.12.2/conf/nginx.conf test is successful
    [root@zzjlogin conf]# ../sbin/nginx -s reload


此时本地电脑因为配置了hosts文件中的域名和IP的映射。所以通过浏览器浏览www.mysite.com这个网站就看到前面的测试indext.html页面内容。




