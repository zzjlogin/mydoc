2017-11-10-练习-wc-useradd
===================================

练习1-编写统计行数脚本
-------------------------

1、编写一个脚本，脚本可以接受一个以上的文件路径作为参数，显示每个文件所拥有的行数，本次工统计了多少个文件执行了行数统计 

.. code-block:: bash

	#!/bin/bash

	for file in $* ; do 
		line=$(wc -l /etc/issue |cut -d " " -f 1)
		echo $file has $line lines.
	done
	echo has $# files

练习2-创建用户并统计个数 
-------------------------------------

1、 编写一个脚本传递2个以上的字符串当作用户名创建这些用户，且密码同用户名总结说明创建了多少用户  

.. code-block:: bash

	#!/bin/bash
	let cnt=0
	for user in $*; do 
		echo $user
		if id $user >/dev/null 2>&1;then
			echo $user exist.
		else
			if useradd $user >/dev/null 2>&1;then
				let cnt++
				echo $user | passwd --stdin $user >/dev/null 2>&1
				echo $user created success.
			else
				echo $user created failed.
			fi
		fi

	done

	if [ $cnt -eq $# ] ; then
		echo create $cnt users.
	else	
		echo $# users ,but create $cnt users.
	fi
