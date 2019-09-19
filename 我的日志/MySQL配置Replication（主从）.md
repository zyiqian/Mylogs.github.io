#### MySQL配置Replication（主从）

#### 原理：

（如果两台服务器部署了主从的话，在主服务器上面修改内容，则主服务器会将修改的内容保存到一个二进制日志里面，从服务器会开启一个I/O线程，通过配置好的账户和密码连接到主服务器上请求获取二进制日志，然后把读取到的二进制日志写到本地的中继日志里面，同时从服务器还开启一个sql 线程，定时检查中继日志，如果发现有更新的内容则立即更新进去）

配置步骤：

1、在主服务器上编辑主服务器的配置文件**my.cof**，添加以下内容

```
vim /etc/my.cof
[mysqld]
log-bin=/var/log/mysql/mysql-bin  //如果里面有log-big的其他路径，先注释掉
server-id=1
[root@mysql ~]#  mkdir /var/log/mysql    创建日志目录并赋予权限
[root@mysql ~]# chown -R mysql.mysql /var/log/mysql
[root@localhost ~]# ls /var/log/mysql/
mysql-bin.000001  mysql-bin.000002  mysql-bin.index
```



重启服务

```
[root@mysql ~]# systemctl restart mysqld
```

2、创建一个专门用于复制数据的用户

每个从服务器需要使用MySQL 主服务器上的用户名和密码连接到主站。

例如，计划使用用户 `repl` 可以从任何主机上连接到 `master` 上进行复制操作, 并且用户 `repl` 仅可以使用复制的权限。

在 `主服务器` 上执行如下操作

```
mysql> CREATE USER 'repl'@'%' IDENTIFIED BY '123'; 
mysql> GRANT REPLICATION SLAVE ON *.*  TO  'repl'@'%' identified by '123';
```

3.在`从服务器`上使用刚才的用户进行测试连接

```
[root@mysql ~]# mysql -urepl -p'123' -h192.168.78.8
```

##### 主服务器中有数据

- 如果在启动复制之前有现有数据需要与从属设备同步，请保持**客户端正常运行**，以便锁定保持不变。这可以防止进行任何进一步的更改，以便复制到从站的数据与主站同步。

1. 在主服务器中导出先有的数据

如果主数据库包含现有数据，则必须将此**数据复制到每个从站**。有多种方法可以实现:

- 使用[**mysqldump**]**逻辑备份**工具创建要复制的所有数据库的转储。这是推荐的方法，尤其是在使用时 [`InnoDB`](https://links.jianshu.com/go?to=https%3A%2F%2Fdev.mysql.com%2Fdoc%2Frefman%2F5.7%2Fen%2Finnodb-storage-engine.html)。

```
[root@mysql ~]# mysqldump  -uroot  -p'1'  --all-databases  --master-data=1 > dbdump.db

这里的用户是主服务器的用户
```

如果不使用 `--master-data` 参数，则需要手动锁定单独会话中的所有表。

2、从主服务器中使用 `scp` 或 `rsync` 等工具，把备份出来的数据传输到从服务器中。

在主服务中执行如下命令      复制主服务器的dbdump.db到从服务器

```
[root@mysql ~]# scp  dbdump.db root@192.168.78.8:/root/

这里的 mysql-slave1 需要能被主服务器解析出 IP 地址，或者说可以在主服务器中 ping 通。
```

3、配置从服务器，并重启
在`从服务器` 上编辑其配置文件 `my.cnf` 并添加如下内容

```
vim /etc/my.cnf
[mysqld]
server-id=2   //加入这条命
systemctl restart mysqld //重启服务
```

4、导入数据到从服务器，并配置连接到主服务器的相关信息

**登录到从服务器上**，执行如下操作

```
/*导入数据*/
mysql -uroot -p'密码'
mysql> source /root/dbdump.db  //导入数据
```

在从服务器配置连接到主服务器的相关信息

```
mysql> CHANGE MASTER TO
MASTER_HOST='192.168.78.8',  -- 主服务器的主机名(也可以是 IP) 
MASTER_USER='repl',           -- 连接到主服务器的用户
MASTER_PASSWORD='123';        -- 到主服务器的密码
```

5、启动从服务器的复制线程

```
mysql> start slave;
Query OK, 0 rows affected (0.09 sec)
```

检查是否成功

在从服务上执行如下操作，加长从服务器端 IO线程和 SQL 线程是否是  **OK**

```
mysql> show slave status\G
   Slave_IO_Running: Yes    
   Slave_SQL_Running: Yes
   两个都为yes 则为表示连接成功
```

输出结果中应该看到 I/O 线程和 SQL 线程都是 `YES`, 就表示成功。

执行此过程后，在主服务上操作的修改数据的操作都会在从服务器中执行一遍，这样就保证了数据的一致性。

#### 在从站上暂停复制

您可以使用[`STOP SLAVE`](https://links.jianshu.com/go?to=https%3A%2F%2Fdev.mysql.com%2Fdoc%2Frefman%2F5.7%2Fen%2Fstop-slave.html)和 [`START SLAVE`](https://links.jianshu.com/go?to=https%3A%2F%2Fdev.mysql.com%2Fdoc%2Frefman%2F5.7%2Fen%2Fstart-slave.html)语句停止并启动从站上的复制 。

要停止从主服务器处理二进制日志，请使用 [`STOP SLAVE`](https://links.jianshu.com/go?to=https%3A%2F%2Fdev.mysql.com%2Fdoc%2Frefman%2F5.7%2Fen%2Fstop-slave.html)：

```
mysql> STOP SLAVE;
```

当复制停止时，从I / O线程停止从主二进制日志读取事件并将它们写入中继日志，并且SQL线程停止从中继日志读取事件并执行它们。您可以通过指定线程类型单独暂停I / O或SQL线程：

```
mysql> STOP SLAVE IO_THREAD;
mysql> STOP SLAVE SQL_THREAD;
```

要再次开始执行，

```
mysql> START SLAVE;
```

要启动特定线程，请指定线程类型：

```
mysql> START SLAVE IO_THREAD;
mysql> START SLAVE SQL_THREAD;
```

