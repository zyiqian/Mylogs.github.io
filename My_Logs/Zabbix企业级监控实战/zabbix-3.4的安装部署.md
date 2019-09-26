## zabbix-3.4的安装部署

#### 一、安装环境

**1）版本**

- centos 7x
- zabbix3.4
- 5.5.64-MariaDB

**2）根据架构图，实验基本设置如下：**

| 机器名称 | IP配置        | 服务角色      | 备注         |
| -------- | ------------- | ------------- | ------------ |
| server   | 192.168.78.88 | zabbix-server | 开启监控功能 |
| node1    | 192.168.78.15 | zabbix-agent  | 开启         |
| node2    | 192.168.78.13 | zabbix-agent  | 开启         |

### 二、安装zabbix  server端

#### 1、zabbix的安装 

##### **1）所有机器关闭防火墙和selinux**

```
setenforing 0 （修改配置文件关闭）
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config 
systemctl stop firewalld.service
```

##### 2）更新yum仓库

```
wget http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
安装
rpm -ivh zabbix-release-3.4-2.el7.noarch.rpm

而后更新我们的yum仓库：
[root@server ~]# yum repolist 
Loaded plugins: fastestmirror, langpacks  
Loading mirror speeds from cached hostfile
zabbix-non-supported                                                      4/4
repo id                     repo name                                   status
base                        base                                         9,363
epel                        epel                                        11,349
zabbix/x86_64               Zabbix Official Repository - x86_64             80
zabbix-non-supported/x86_64 Zabbix Official Repository non-supported -       4
repolist: 20,796
```

##### **3）安装依赖包：**

```
[root@server ~]# yum -y install zabbix-agent zabbix-get zabbix-sender zabbix-server-mysql zabbix-web zabbix-web-mysql
```

##### 4）安装数据库

这里我们直接用yum 装

```
yum install mariadb-server mariadb-client

修改配置
[root@server ~]# vim /etc/my.cnf.d/server.cnf
    [mysqld]
    skip_name_resolve = ON          #跳过主机名解析
    innodb_file_per_table = ON      #
    innodb_buffer_pool_size = 256M  #缓存池大小
    max_connections = 2000          #最大连接数
    log-bin = master-log            #开启二进制日志
    
 重启我们的数据库服务：
 [root@server ~]# systemctl restart mariadb
[root@server ~]# mysql_secure_installation  #初始化mariadb

创建数据库并授权账号
MariaDB [(none)]> create database zabbix character set 'utf8';  # 创建zabbix数据库
MariaDB [(none)]> grant all on zabbix.* to 'zabbix'@'192.168.78.%' identified by '1';	
MariaDB [(none)]> grant all on zabbix.* to 'zabbix'@'localhost' identified by '1';
                                			   # 注意授权网段 
MariaDB [(none)]> flush privileges;           # 刷新授权

```

##### 5）导入表

首先，我们来查看一下，`zabbix-server-mysql`这个包提供了什么：

```
[root@server ~]# rpm -ql zabbix-server-mysql
/etc/logrotate.d/zabbix-server
/etc/zabbix/zabbix_server.conf
/usr/lib/systemd/system/zabbix-server.service
/usr/lib/tmpfiles.d/zabbix-server.conf
/usr/lib/zabbix/alertscripts
/usr/lib/zabbix/externalscripts
/usr/sbin/zabbix_server_mysql
/usr/share/doc/zabbix-server-mysql-3.2.6
/usr/share/doc/zabbix-server-mysql-3.2.6/AUTHORS
/usr/share/doc/zabbix-server-mysql-3.2.6/COPYING
/usr/share/doc/zabbix-server-mysql-3.2.6/ChangeLog
/usr/share/doc/zabbix-server-mysql-3.2.6/NEWS
/usr/share/doc/zabbix-server-mysql-3.2.6/README
/usr/share/doc/zabbix-server-mysql-3.2.6/create.sql.gz      #生成表的各种脚本
/usr/share/man/man8/zabbix_server.8.gz
/var/log/zabbix
/var/run/zabbix
```

我们来使用这个文件生成我们所需要的表：

```
[root@server ~]# gzip -d create.sql.gz
[root@server ~]# vim create.sql
添加 
USE zabbix；
.....

导入数据库
[root@server ~]# mysql -uzabbix -p1  < create.sql 


如果报如下错误
ERROR 1046 (3D000) at line 1: No database selected
在create.sql添加
USE zabbix;

若报下面错误 则需要重装mariadb，因为版本兼容
[root@localhost zabbix-server-mysql-3.4.15]# mysql -uzabbix -p1 < create.sql
ERROR 1118 (42000) at line 1245: Row size too large (> 8126). Changing some columns to TEXT or BLOB may help. In current row format, BLOB prefix of 0 bytes is stored inline.

导入以后，我们进去数据库查看一下：
[root@server ~]# mysql -uzbxuser -p1
MariaDB [(none)]> show databases;
MariaDB [(none)]> use zabbix;
MariaDB [zabbix]> show tables;  
.....
140 rows in set (0.00 sec)    //140个表数据已经导入成功了。
```

#### 2、配置server端

**我们的数据库准备好了以后，我们要去修改server端的配置文件。**

```
[root@server ~]# cd /etc/zabbix/
[root@server zabbix]# ls
web  zabbix_agentd.conf  zabbix_agentd.d  zabbix_server.conf
#为了方便我们以后恢复，我们把配置文件备份一下
[root@server zabbix]# cp zabbix_server.conf zabbix_server.conf.bak
[root@server zabbix]# vim zabbix_server.conf
ListenPort=10051            #默认监听端口
SourceIP=192.168.78.88    #发采样数据请求的IP

 DBHost=192.168.78.88      #数据库对外的主机
    DBName=zabbix               #数据库名称
    DBUser=zbxuser              #数据库用户
    DBPassword=1             #数据库密码
    DBPort=3306                 #数据库启动端口
```

以上，我们的基本配置已经完成，可以开启服务了

```
[root@server zabbix]# systemctl start zabbix-server.service
```

　开启服务以后，我们一定要去确认一下我们的端口有没有开启：

```
[root@server zabbix]# netstat -nutl |grep 10051
tcp    LISTEN     0      128       *:10051                 *:*                  
tcp    LISTEN     0      128      :::10051                :::*  
```

#### 3、配置web GUI

我们先来查看一下，我们web GUI的配置文件在哪里：

```
[root@server ~]# rpm -ql zabbix-web | less
/etc/httpd/conf.d/zabbix.conf
/etc/zabbix/web
/etc/zabbix/web/maintenance.inc.php
/etc/zabbix/web/zabbix.conf.php
/usr/share/doc/zabbix-web-3.2.6
/usr/share/doc/zabbix-web-3.2.6/AUTHORS
/usr/share/doc/zabbix-web-3.2.6/COPYING
/usr/share/doc/zabbix-web-3.2.6/ChangeLog
/usr/share/doc/zabbix-web-3.2.6/NEWS
/usr/share/doc/zabbix-web-3.2.6/README
……
```

可以看出，有一个`/etc/httpd/conf.d/zabbix.conf`文件，这个配置文件就是帮我们做映射的文件，我们可以去看一看这个文件：

![](https://i.loli.net/2019/09/26/dvn8tMS2TLoPbVI.jpg)

​      时区是一定要设置的，这里被注释掉是因为，我们也可以在php的配置文件中设置时区，如果我们在php配置文件中设置时区，则对所有的php服务均有效，如果我们在zabbix.conf中设置时区，则仅对zabbix服务有效。所以，我们去php配置文件中设置我们的时区：

```
vim /etc/php.ini  +878
    [Date]
    ; Defines the default timezone used by the date functions
    ; http://php.net/date.timezone
    date.timezone = Asia/Shanghai
```

接下来，我们就可以启动我们的`httpd`服务了：

```
systemctl start httpd.service

[root@server zabbix]# netstat -nutl |grep 80
tcp6       0      0 :::80                   :::*                    LISTEN 
```

我们的服务已经开启，接着我们就可以用浏览器来访问了。

#### 4、浏览器访问并进行初始化设置

我们使用浏览器访问`192.168.78.88/zabbix`，第一次访问时需要进行一些初始化的设置，我们按照提示操作即可：

![](https://i.loli.net/2019/09/26/pLIY7gPRWn198KO.jpg)



![](https://i.loli.net/2019/09/26/NwcXHyKuEhk9xtv.jpg)

![](https://i.loli.net/2019/09/26/OBI3DGyjVeLHE1v.jpg)

![](https://i.loli.net/2019/09/26/c1b8JDMd7QiuT9F.jpg)

点击Finish以后，我们就会跳转到登录页面，使用我们的账号密码登录即可：

默认用户名为：admin ，密码为：zabbix 。
　　登陆进来就可以看到我们的仪表盘了：

![](https://i.loli.net/2019/09/26/8XNA5aYcn4oTFKe.jpg)

### 三、安装zabbix  agent端

当我们把监控端配置启动以后，我们需要来设置一下我们的监控端，我们在被监控的主机安装好agent，设置好他的server，并把他添加到server端，就能将其纳入我们的监控系统中去了。

#### 1）安装 zabbix

跟上面安装的差不多

```
[root@node1 ~]# wget http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
[root@node1 ~]# rpm -ivh zabbix-release-3.4-2.el7.noarch.rpm 
[root@node1 ~]# yum install zabbix-agent zabbix-sender -y
```

安装完成以后，我们去修改配置文件。

#### 2）修改配置文件

```
[root@node1 ~]# cd /etc/zabbix/
[root@node1 zabbix]# ls
zabbix_agentd.conf  zabbix_agentd.d
[root@node1 zabbix]# cp zabbix_agentd.conf{,.bak}
[root@node1 zabbix]# vim zabbix_agentd.conf
Server=192.168.78.88        #指明服务器是谁的
ListenPort=10050            #自己监听的端口
ListenIP=0.0.0.0            #自己监听的地址，0.0.0.0表示本机所有地址
StartAgents=3               #优化时使用的

ServerActive=192.168.78.15   #主动监控时的服务器
Hostname=agent1.lion.cn     #自己能被server端识别的名称
```

　修改完成之后，我们保存退出。然后就可以启动服务了：

```
[root@node1 zabbix]# systemctl start zabbix-agent.service
　照例查看端口是否已开启
　[root@node1 zabbix]# ss -ntul |grep 10050
tcp    LISTEN     0      128       *:10050                 *:*  
```

已经开启成功。接着，我们就可以去server端添加了。
　　node2也进行同样的操作，唯一不同的就是配置文件中的`Hostname`要设为`node2.keer.com`。

### 四、监控过程详解

#### 1）创建主机及主机群组

![](https://i.loli.net/2019/09/26/4G5rXNVUyfLTwba.jpg)

![](https://i.loli.net/2019/09/26/GhifoJL4KzZm7YA.jpg)

![](https://i.loli.net/2019/09/26/Q4mIvYdeLOTraPt.jpg)

![](https://i.loli.net/2019/09/26/2ZyGN1Jz5UpxTDk.jpg)





**设置完成后，点击添加。我们就可以看到，我们添加的这个主机已经出现在列表中了：**

![](https://i.loli.net/2019/09/26/3duKIQb6NtVCex8.jpg)



**同样的，我们把node2节点也添加进来：**

![](https://i.loli.net/2019/09/26/Gr59yc831ORqugj.jpg)

#### 2）监控项(items)

![](https://i.loli.net/2019/09/26/7MWwKd5xmsq6QTg.jpg)

![](https://i.loli.net/2019/09/26/BK1jr32NJ48mD6S.jpg)



![](https://i.loli.net/2019/09/26/mM15D4jhHoYrIAz.jpg)



**设置完以后，点击更新，即可加入，并会自动跳转至下图页面：**

变绿则部署好了

![](https://i.loli.net/2019/09/26/VCTfXv49zGBIOyM.jpg)



那么，我们的数据在哪里呢？可以点击`最新数据`，把我们的node1节点添加至主机，应用一下，就可以看到下面的状态了：



![](https://i.loli.net/2019/09/26/HWtSNcV3zJ8QZu1.jpg)



可以看到，我们还有一个图形页面，点进去则可以看图形的分布：

　事实上，我们关注的指标有很多种，我们一一添加进来即可。
　　刚刚我们定义的监控项是很简单的，指定一个`key`即可，但是有些监控项是带有参数的，这样一来，我们的监控项就有更多的灵活性。接下来，我们来简单说明一个需要带参数的监控项：

#### 3）定义一个触发器

![](https://i.loli.net/2019/09/26/WTra46qJMeiUXQh.jpg)

![](https://i.loli.net/2019/09/26/RuBWGegAPSO6Yts.jpg)

![](https://i.loli.net/2019/09/26/H3vGjbA4IWL8YXr.jpg)

![](https://i.loli.net/2019/09/26/iotZNI1lTpBLz6b.jpg)



![](https://i.loli.net/2019/09/26/s7A4FbIK9vdHi3R.jpg)

我们可以看出，这个里面就有了一根线，就是我们刚刚定义的值，超过线的即为异常状态，看起来非常直观。
　　但是，现在即使超过了这根线，也仅仅会产生一个触发器事件而不会做其他任何事。因此，我们就需要去定义一个动作(action)。

