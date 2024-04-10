
======================================================================
MySql用户相关
======================================================================

MySQL的sql语句中保留字
======================================================================

官方链接:
	https://mysql.net.cn/doc/refman/8.0/en/keywords.html


创建MySQL用户
======================================================================


MySQL 8.0版本
----------------------------------------------------------------------

::

	use mysql;

	CREATE user 'test'@'%' IDENTIFIED WITH mysql_native_password BY '123456';

	GRANT ALL PRIVILEGES ON *.* TO 'test'@'%';

	FLUSH PRIVILEGES;

mysql_native_password
	- 认证方式，MySQL8以前默认认证方式，MySQL8默认认证方式caching_sha2_password
	- 官方参考：https://dev.mysql.com/doc/refman/8.0/en/caching-sha2-pluggable-authentication.html
	
Qt链接MySQL默认认证mysql_native_password，认证caching_sha2_password方式登陆MySQL报错。



修改MySQL登陆密码
======================================================================


MySQL 8.0以前版本
----------------------------------------------------------------------

::

	mysql> use mysql;

	mysql> update user set password=password('新密码') where user='用户名';
	或者
	mysql> update mysql.user set authentication_string=password('新密码') where user='用户名';

	mysql> flush privileges;   --刷新MySQL的系统权限相关表



MySQL 8.0及以后版本修改密码
----------------------------------------------------------------------

MySQL 8.0后修改密码的官网连接

MySQL 8.0修改密码步骤:


以 root 用户登录MySQL。
进入MySQL系统自带数据库： mysql 数据库中。
执行更改密码语句。
退出MySQL后，使用新的密码重新登陆。
具体语句如下：

::

	[root@localhost ~]# ./bin/mysql -u root -p '原来的密码'   

	mysql> show databases;

	mysql> use mysql;

	mysql> ALTER USER '用户名'@'localhost' IDENTIFIED WITH mysql_native_password BY '新密码';

	mysql> flush privileges;   --刷新MySQL的系统权限相关表

	mysql> exit;





