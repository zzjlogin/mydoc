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

[root@centos6-zzjlogin ~]# cat hello.sh
#!/bin/bash
STR="hello zzjlogin!"
echo $STR
[root@centos6-zzjlogin ~]# chmod +x hello.sh
[root@centos6-zzjlogin ~]# ./hello.sh
hello zzjlogin!

[root@centos6-zzjlogin ~]# echo $PATH
/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
[root@centos6-zzjlogin ~]# PATH='/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin/:/root/'
[root@centos6-zzjlogin ~]# echo $PATH
/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin/:/root/
[root@centos6-zzjlogin ~]# cd /home/
[root@centos6-zzjlogin home]# hello.sh
hello zzjlogin!

[root@centos6-zzjlogin ~]# cat hello.sh
#!/bin/bash
STR="hello zzjlogin!"
echo $0
echo "$0 print"
echo $1
echo "$1 print"
echo $!
echo "$! print"
echo "ending"
[root@centos6-zzjlogin ~]# ./hello.sh test
./hello.sh
./hello.sh print
test
test print

 print
ending


cat /etc/sysconfig/i18n
cp /etc/sysconfig/i18n /etc/sysconfig/i18n.backup


echo 'LANG="zh_CN.UTF-8"' >/etc/sysconfig/i18n
cat /etc/sysconfig/i18n


source /etc/sysconfig/i18n


[root@centos6-zzjlogin ~]# cp /etc/profile /etc/profile.`date +%Y%m%d`


[root@centos6-zzjlogin ~]# echo "PATH=$PATH:/home/">> /etc/profile
[root@centos6-zzjlogin ~]# echo $PATH
/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin/:/root/:/home/
[root@centos6-zzjlogin ~]# tail -10 /etc/profile
            . "$i"
        else
            . "$i" >/dev/null 2>&1
        fi
    fi
done

unset i
unset -f pathmunge
PATH=$PATH:/home/


source /etc/profile


[root@centos6-zzjlogin ~]# help if
if: if COMMANDS; then COMMANDS; [ elif COMMANDS; then COMMANDS; ]... [ else COMMANDS; ] fi
    Execute commands based on conditional.
    
    The `if COMMANDS' list is executed.  If its exit status is zero, then the
    `then COMMANDS' list is executed.  Otherwise, each `elif COMMANDS' list is
    executed in turn, and if its exit status is zero, the corresponding
    `then COMMANDS' list is executed and the if command completes.  Otherwise,
    the `else COMMANDS' list is executed, if present.  The exit status of the
    entire construct is the exit status of the last command executed, or zero
    if no condition tested true.
    
    Exit Status:
    Returns the status of the last command executed.

    也就是if的命令格式是：
        if COMMANDS; then COMMANDS; [ elif COMMANDS; then COMMANDS; ]... [ else COMMANDS; ] fi
    if的执行基于返回条件。
        if COMMANDS的COMMANDS返回状态是0则执行then COMMANDS。
        否则执行elif COMMANDS，这个COMMANDS如果是0就执行这个后面对应的then COMMANDS。
        否则执行else COMMANDS。
        最后fi结尾。上面的elif/else判断执行部分可以省略。但是这最后的fi不能省略。



[ -f "somefile" ]       判断是否是一个文件
[ -x "/bin/ls" ]        判断/bin/ls是否存在并有可执行权限
[ -n "$var" ]           判断$var变量是否有值
[ "$a" = "$b" ]         判断$a和$b是否相等
-r file                 用户可读为真
-w file                 用户可写为真
-x file                 用户可执行为真
-f file                 文件为正规文件为真
-d file                 文件为目录为真
-c file                 文件为字符特殊文件为真
-b file                 文件为块特殊文件为真
-s file                 文件大小非0时为真
-t file                 当文件描述符(默认为1)指定的设备为终端时为真

-ne     比较两个参数是否不相等
-lt     参数1是否小于参数2
-le     参数1是否小于等于参数2
-gt     参数1是否大于参数2
-ge     参数1是否大于等于参数2
-f      检查某文件是否存在（例如，if [ -f "filename" ]）
-d      检查目录是否存在

补充：文件测试操作：
返回true，如果：
-e file                     文件存在
-a file                     文件存在（已被弃用）
-f file                     被测文件是一个regular文件（正常文件，非目录或设备）
-s file                     文件长度不为0
-d dir                      被测对象是目录
-b file                     被测对象是块设备
-c file                     被测对象是字符设备
-p file                     被测对象是管道
-h file                     被测文件是符号连接
-L file                     被测文件是符号连接
-S(大写) file               被测文件是一个socket
-t                          关联到一个终端设备的文件描述符。用来检测脚本的stdin[-t0]或[-t1]是一个终端
-r                          文件具有读权限，针对运行脚本的用户
-w                          文件具有写权限，针对运行脚本的用户
-x                          文件具有执行权限，针对运行脚本的用户
-u                          set-user-id(suid)标志到文件，即普通用户可以使用的root权限文件，通过chmod +s file实现
-k                          设置粘贴位
-O                          运行脚本的用户是文件的所有者
-G                          文件的group-id和运行脚本的用户相同
-N                          从文件最后被阅读到现在，是否被修改
f1 -nt f2                   文件f1是否比f2新
f1 -ot f2                   文件f1是否比f2旧
f1 -ef f2                   文件f1和f2是否硬连接到同一个文件

二元比较操作符，比较变量或比较数字

整数比较：
-eq             等于            if [ "$a" -eq "$b" ]
-ne             不等于          if [ "$a" -ne "$b" ]
-gt             大于            if [ "$a" -gt "$b" ]
-ge             大于等于        if [ "$a" -ge "$b" ]
-lt             小于            if [ "$a" -lt "$b" ]
-le             小于等于        if [ "$a" -le "$b" ]

<               小于（需要双括号）           (( "$a" < "$b" ))
<=              小于等于(...)                 (( "$a" <= "$b" ))
>               大于(...)                     (( "$a" > "$b" ))
>=              大于等于(...)                 (( "$a" >= "$b" ))

字符串比较：
=               等于           if [ "$a" = "$b" ]
==              与=等价
!=              不等于         if [ "$a" = "$b" ]
<               小于，在ASCII字母中的顺序：
                if [[ "$a" < "$b" ]]
                if [ "$a" \< "$b" ]         #需要对<进行转义
>               大于

-z               字符串为null，即长度为0
-n               字符串不为null，即长度不为0



没有else和elif的判断：
#!/bin/bash
score=65
if [ "$score" -gt 60 ] ; then
    echo "$score >60"
fi

有else的if语句：
#!/bin/bash
score=65
if [ "$score" -gt 60 ] ; then
    echo "$score >60"
else
    echo "$score <=60"
fi

完整语句：
#!/bin/bash
score=41
if [ "$score" -gt 60 ] ; then
    echo "$score >60"
elif [ "$score" -gt 40 ] ; then
    echo "$score <=60 , $score >40"
else
    echo "$score <=40"
fi


#!/bin/bash
score=41
if [ "$score" -gt 60 ] ; then
    echo "$score >60"
else
    if [ "$score" -gt 40 ] ; then
        echo "$score <=60 , $score >40"
    else
        echo "$score <=40"
    fi
fi
    
    
    
    
    

