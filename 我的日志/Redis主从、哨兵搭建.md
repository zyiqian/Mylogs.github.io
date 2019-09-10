### Redis主从、哨兵搭建

摘自 <http://www.liuwq.com/views/%E6%95%B0%E6%8D%AE%E5%BA%93/redis%E4%B8%BB%E4%BB%8E.html#redis-%E4%B8%BB%E4%BB%8E> 

#### 什么是redis

REmote DIctionary Server(Redis) 是一个由Salvatore Sanfilippo写的key-value存储系统。

####  1. Redis的特性

1. 速度快，最快可达到 `10w QPS`（基于 **内存**，`C` 语言，**单线程** 架构）；
2. 基于 **键值对** (`key/value`) 的数据结构服务器。全称 `Remote Dictionary Server`。包括 `string`(**字符串**)、`hash`(**哈希**)、`list`(**列表**)、`set`(**集合**)、`zset`(**有序集合**)、`bitmap`(**位图**)。同时在 **字符串** 的基础上演变出 **位图**（`BitMaps`）和 `HyperLogLog` 两种数据结构。`3.2` 版本中加入 `GEO`（**地理信息位置**）。
3. 丰富的功能。例如：**键过期**（缓存），**发布订阅**（消息队列）， `Lua` 脚本（自己实现 `Redis` 命令），**事务**，**流水线**（`Pipeline`，用于减少网络开销）。
4. 简单稳定。无外部库依赖，单线程模型。
5. 客户端语言多。
6. **持久化**（支持两种 **持久化** 方式 `RDB` 和 `AOF`）。
7. **主从复制**（分布式的基础）。
8. **高可用**（`Redis Sentinel`），**分布式**（`Redis Cluster`）和 **水平扩容**。

#### 2、Redis的应用场景

1、缓存、排行榜、计数器、社交网络、消息队列.....



#### 3、Redis的单机安装

##### 1、下载安装Redis

```
下载地址http://redis.io/download，下载最新稳定版本。
cd /usr/local/src
wget http://download.redis.io/releases/redis-4.0.9.tar.gz
tar xzf redis-4.0.9.tar.gz -C /usr/local
cd ../redis-4.0.9
yum install -y make gcc
make
```

##### 2、Redis简单配置

```
cp redis.conf redis.conf.bak  //备份一份
vim redis.conf     ---修改如下

/bind  ----这样一个个查找修改

bind 127.0.0.1　　#只监听内网IP  
daemonize yes　　　　　#开启后台模式将on改为yes
timeout 300　　　　　　#连接超时时间
port 6379                      #端口号
databases 0                 存储Session的Redis库编号 16
dir ./　　#本地数据库存放目录该目录需要存在
pidfile /var/run/redis_6379.pid　　#定义pid文件
logfile /var/log/redis_6379.log　　#定义log文件
#requirepass tiger     # 设置密码
```

##### 3、配置Redis为systemctl启动

```
默认是找不到 systemctl stop\start\restart redis 的命令的
所以需要配置一个
vim /lib/systemd/system/redis.service

[Unit]
Description=Redis
After=network.target

[Service]
ExecStart=/usr/local/redis-4.0.9/src/redis-server /usr/local/redis-4.0.9/redis.conf  --daemonize no
ExecStop=/usr/local/redis-4.0.9/src/redis-cli -h 127.0.0.1 -p 6379 shutdown

[Install]
WantedBy=multi-user.target
______________________________________
参数详解:
• [Unit] 表示这是基础信息 
• Description 是描述
• After 是在那个服务后面启动，一般是网络服务启动后启动

• [Service] 表示这里是服务信息 
• ExecStart 是启动服务的命令
• ExecStop 是停止服务的指令

• [Install] 表示这是是安装相关信息 
• WantedBy 是以哪种方式启动：multi-user.target表明当系统以多用户方式（默认的运行级别）启动时，这个服务需要被自动运行。
```

##### 4、启动Redis

```
cd /usr/local/redis-4.0.9/
./src/redis-server   ----启动
systemctl start Redis
systemctl status redis  //

redis客户端测试
src/redis-cli
127.0.0.1:6379> set 1901 GZ
OK
127.0.0.1:6379> get 1901
"GZ"
127.0.0.1:6379> ping
PONG
```

##### 5、redis数据备份和恢复

```
Redis SAVE 命令用于创建当前数据库的备份。

语法
redis Save 命令基本语法如下：
127.0.0.1:6379> save
OK

该命令会在redis安装目录下创建dump.rdb文件


恢复数据
如果需要恢复数据，只需将备份文件 (dump.rdb) 移动到 redis 安装目录并启动服务即可。获取 redis 目录可以使用 CONFIG 命令，如下所示：
127.0.0.1:6379> config get dir
1) "dir"
2) "/usr/local/redis/src"
以上命令 CONFIG GET dir 输出的 redis 安装目录为/usr/local/redis/src

Bgsave
创建 redis 备份文件也可以使用命令 BGSAVE，该命令在后台执行。

127.0.0.1:6379> BGSAVE
Background saving started
```

**#########到这里 单机部署安装已完成#########**

#### 4、主从同步部署

```
测试环境:centos7.4
redis-master:192.168.19.129   vm1
redis-slave1:192.168.19.136   vm4  按照以上安装方法安装Redis
redis-slave2:192.168.19.135   vm3  按照以上安装方法安装Redis  
1.首先三台服务器将redis单机部署完成。
编辑master的redis配置文件:
[root@redis-master ~]# cd /usr/local/redis-4.0.9
[root@redis-master redis-4.0.9]# vim redis.conf
修改一下内容
bind 0.0.0.0
protected-mode no

2.修改slave1的配置文件：

[root@redis-slave1 ~]# mv /usr/local/redis-4.0.9/redis.conf{,.bak}
[root@redis-slave1 ~]# scp 192.168.19.129:/usr/local/redis-4.0.9/redis.conf /usr/local/redis-4.0.9/
[root@redis-slave1 ~]# cd /usr/local/redis-4.0.9/
[root@redis-slave1 redis]# vim redis.conf      ---修改如下：
slaveof 192.168.19.129 6379 

3.配置slave2的配置文件:
[root@redis-slave2 ~]# mv /usr/local/redis-4.0.9/redis.conf{,.bak}
[root@redis-slave2 ~]# scp 192.168.19.136:/usr/local/redis-4.0.9/redis.conf /usr/local/redis-4.0.9/

4.重启三台redis
systemctl stop redis
systemctl start redis

5.测试主从
在master机器上
cd /usr/local/redis-4.0.9/
./src/redis-cli
set name zhong

在其他两台slave机器上查看
cd /usr/local/redis-4.0.9/
./src/redis-cli
get name
zhong
```

三台均测试无误，主从同步部署完成

#### 5、配置哨兵模式

下面操作是三台机器同时操作

```
1.每台机器上修改redis主配置文件redis.conf文件设置：bind 0.0.0.0       ---配置主从时已经完成
2.每台机器上修改sentinel.conf配置文件：修改如下配置
[root@redis-master src]# cd ..
[root@redis-master redis]# vim sentinel.conf
        sentinel monitor mymaster 192.168.19.129 6379 2 (slave上面写的是master的ip，master写自己ip)
        sentinel down-after-milliseconds mymaster 3000
        sentinel failover-timeout mymaster 10000
        protected-mode no
——————————————————————
参数详解:
关闭加密
protected-mode no
构成master客观下线的前提，至少有两个sentinel(哨兵)主观认为master已经下线
sentinel monitor mymaster 192.168.19.129 6379 2 
sentinel每隔一定时间向其已知的master发送ping指令，在设置的这个时间内如果没有收master返回的数据包，就会把master标记为主观下线。单位为毫秒
sentinel down-after-milliseconds mymaster 3000
在这个时间内如果主从切换没有完成就停止切换。单位毫秒
sentinel failover-timeout mymaster 10000
```

```
3.每台机器启动哨兵服务：
        # ./src/redis-sentinel sentinel.conf
        
注意:在生产环境下将哨兵模式启动放到后台执行:  实验可直接执行./src/redis-sentinel sentinel.conf &
在master上面执行
这是启动成功的！
```

<img src="https://i.loli.net/2019/05/07/5cd1a228086b6.jpg" />

<img src="https://i.loli.net/2019/05/07/5cd1a2797a3e7.jpg" />

将master的哨兵模式退出，再将redis服务stop了，在两台slave上面查看其中一台是否切换为master:(没有优先级，为随机切换)

master 192.168.19.129

<img src="https://i.loli.net/2019/05/07/5cd1a2ef82487.jpg" />



 

主从+哨兵模式测试部署完成！

==========================================================