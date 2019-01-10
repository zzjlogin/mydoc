.. _centos-cobbler-faq:

======================================================================================================================================================
cobbler常见问题总结
======================================================================================================================================================

:Date: 2018-09

.. contents::


cobbler软件包依赖问题
======================================================================================================================================================

参考：
  https://centos.pkgs.org/6/nux-misc-i386/cobbler-2.2.1-2.el6.nux.noarch.rpm.html

参考上面网址安装对应的依赖包。


cobbler-web如有问题参考网址
======================================================================================================================================================


http://rpmfind.net/linux/rpm2html/search.php?query=cobbler-web



syslinux配置导致的问题
======================================================================================================================================================

**问题现象**

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cobbler get-loaders                                       
    task started: 2018-09-06_220531_get_loaders
    task started (id=Download Bootloader Content, time=Thu Sep  6 22:05:31 2018)
    path /var/lib/cobbler/loaders/README already exists, not overwriting existing content, use --force if you wish to update
    downloading http://cobbler.github.io/loaders/COPYING.elilo to /var/lib/cobbler/loaders/COPYING.elilo
    Exception occured: <class 'urlgrabber.grabber.URLGrabError'>
    Exception value: [Errno 14] PYCURL ERROR 56 - "Failure when receiving data from the peer"
    Exception Info:
      File "/usr/lib/python2.6/site-packages/cobbler/remote.py", line 87, in run
        rc = self._run(self)
      File "/usr/lib/python2.6/site-packages/cobbler/remote.py", line 181, in runner
        return self.remote.api.dlcontent(self.options.get("force",False), self.logger)
      File "/usr/lib/python2.6/site-packages/cobbler/api.py", line 751, in dlcontent
        return grabber.run(force)
      File "/usr/lib/python2.6/site-packages/cobbler/action_dlcontent.py", line 73, in run
        urlgrabber.grabber.urlgrab(src, filename=dst, proxies=proxies)
      File "/usr/lib/python2.6/site-packages/urlgrabber/grabber.py", line 625, in urlgrab
        return default_grabber.urlgrab(url, filename, **kwargs)
      File "/usr/lib/python2.6/site-packages/urlgrabber/grabber.py", line 993, in urlgrab
        return self._retry(opts, retryfunc, url, filename)
      File "/usr/lib/python2.6/site-packages/urlgrabber/grabber.py", line 894, in _retry
        r = apply(func, (opts,) + args, {})
      File "/usr/lib/python2.6/site-packages/urlgrabber/grabber.py", line 979, in retryfunc
        fo = PyCurlFileObject(url, filename, opts)
      File "/usr/lib/python2.6/site-packages/urlgrabber/grabber.py", line 1074, in __init__
        self._do_open()
      File "/usr/lib/python2.6/site-packages/urlgrabber/grabber.py", line 1376, in _do_open
        self._do_grab()
      File "/usr/lib/python2.6/site-packages/urlgrabber/grabber.py", line 1506, in _do_grab
        self._do_perform()
      File "/usr/lib/python2.6/site-packages/urlgrabber/grabber.py", line 1363, in _do_perform
        raise err

    !!! TASK FAILED !!!

**解决办法**

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cp /usr/share/syslinux/pxelinux.0 /var/lib/cobbler/loaders
    [root@centos-cobbler ~]# cp /usr/share/syslinux/menu.c32 /var/lib/cobbler/loaders/

    [root@centos-cobbler ~]# cobbler get-loaders
    task started: 2018-09-06_220550_get_loaders
    task started (id=Download Bootloader Content, time=Thu Sep  6 22:05:50 2018)
    path /var/lib/cobbler/loaders/README already exists, not overwriting existing content, use --force if you wish to update
    path /var/lib/cobbler/loaders/COPYING.elilo already exists, not overwriting existing content, use --force if you wish to update
    downloading http://cobbler.github.io/loaders/COPYING.yaboot to /var/lib/cobbler/loaders/COPYING.yaboot
    downloading http://cobbler.github.io/loaders/COPYING.syslinux to /var/lib/cobbler/loaders/COPYING.syslinux
    downloading http://cobbler.github.io/loaders/elilo-3.8-ia64.efi to /var/lib/cobbler/loaders/elilo-ia64.efi
    downloading http://cobbler.github.io/loaders/yaboot-1.3.17 to /var/lib/cobbler/loaders/yaboot
    path /var/lib/cobbler/loaders/pxelinux.0 already exists, not overwriting existing content, use --force if you wish to update
    path /var/lib/cobbler/loaders/menu.c32 already exists, not overwriting existing content, use --force if you wish to update
    downloading http://cobbler.github.io/loaders/grub-0.97-x86.efi to /var/lib/cobbler/loaders/grub-x86.efi
    downloading http://cobbler.github.io/loaders/grub-0.97-x86_64.efi to /var/lib/cobbler/loaders/grub-x86_64.efi
    *** TASK COMPLETE ***


cobbler依赖包没有安装
======================================================================================================================================================

CentOS6.6安装会提示错误：

.. code-block:: none
    :linenos:

    Package: cobbler-web-2.6.11-7.git95749a6.el6.noarch (epel)
        Requires: Django >= 1.4
    You could try using --skip-broken to work around the problem

解决办法：

.. code-block:: bash
    :linenos:

    rpm -ivh http://mirrors.aliyun.com/epel/epel-release-latest-6.noarch.rpm
  
    yum -y install mod_ssl python-cheetah createrepo python-netaddr genisoimage mod_wsgi syslinux libpthread.so.0 libpython2.6.so.1.0 python-libs python-simplejson
    rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/libyaml-0.1.3-4.el6_6.x86_64.rpm
    rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/PyYAML-3.10-3.1.el6.x86_64.rpm
    rpm -ivh https://kojipkgs.fedoraproject.org//packages/Django14/1.4.14/1.el6/noarch/Django14-1.4.14-1.el6.noarch.rpm
   


重启httpd和cobbler服务就正常
======================================================================================================================================================

.. code-block:: bash
    :linenos:

    [root@centos-cobbler ~]# cobbler check
    Traceback (most recent call last):
    File "/usr/bin/cobbler", line 36, in <module>
        sys.exit(app.main())
    File "/usr/lib/python2.6/site-packages/cobbler/cli.py", line 657, in main
        rc = cli.run(sys.argv)
    File "/usr/lib/python2.6/site-packages/cobbler/cli.py", line 270, in run
        self.token         = self.remote.login("", self.shared_secret)
    File "/usr/lib64/python2.6/xmlrpclib.py", line 1199, in __call__
        return self.__send(self.__name, args)
    File "/usr/lib64/python2.6/xmlrpclib.py", line 1489, in __request
        verbose=self.__verbose
    File "/usr/lib64/python2.6/xmlrpclib.py", line 1253, in request
        return self._parse_response(h.getfile(), sock)
    File "/usr/lib64/python2.6/xmlrpclib.py", line 1392, in _parse_response
        return u.close()
    File "/usr/lib64/python2.6/xmlrpclib.py", line 838, in close
        raise Fault(**self._stack[0])
    xmlrpclib.Fault: <Fault 1: "<class 'cobbler.cexceptions.CX'>:'login failed'">


