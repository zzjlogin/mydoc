---------------------------------------------
Quote by Program/Shell/base
---------------------------------------------
[root@centos6-zzjlogin ~]# echo '#!/bin/bash'> helloworld.sh
[root@centos6-zzjlogin ~]# echo 'echo "Hello Word!"'>> helloworld.sh
[root@centos6-zzjlogin ~]# cat helloworld.sh
#!/bin/bash
echo "Hello Word!"
[root@centos6-zzjlogin ~]# chmod +x helloworld.sh
[root@centos6-zzjlogin ~]# ./helloworld.sh
Hello Word!
---------------------------------------------
Quote by Program/Shell/base line 128
---------------------------------------------
[root@centos6-zzjlogin ~]# ls -l > ls-redirect.txt
[root@centos6-zzjlogin ~]# cat ls-redirect.txt
total 72
-rw-------.  1 root root  1040 Mar 30 17:41 anaconda-ks.cfg
drwxr-xr-x. 13 root root  4096 Aug  3 21:52 ceshi
-rwxr-xr-x.  1 root root    31 Aug  5 21:04 helloworld.sh
-rw-r--r--.  1 root root 21684 Aug  3 22:03 install.log
-rw-r--r--.  1 root root  5890 Mar 30 17:39 install.log.syslog
-rw-r--r--.  1 root root     0 Aug  5 22:07 ls-redirect.txt
-rw-r--r--.  1 root root   143 Aug  3 19:27 pf
-rw-r--r--.  1 root root   239 Aug  3 22:11 snapshot
-rw-r--r--.  1 root root 15231 Jul 20 06:56 tar.txt
drwxr-xr-x.  3 root root  4096 Aug  3 22:45 test
---------------------------------------------
Quote by Program/Shell/base line 128
---------------------------------------------
[root@centos6-zzjlogin ~]# ifconfig 1>/dev/null 2>&1
[root@centos6-zzjlogin ~]# ifconfig &>/dev/null

[root@centos6-zzjlogin ~]# wc -l < /etc/init.d/network
245

[root@centos6-zzjlogin ~]# ls -l | wc -l
7











