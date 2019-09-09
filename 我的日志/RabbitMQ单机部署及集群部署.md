### RabbitMQ集群部署

**准备三台机器：hackerlion:192.168.78.6  \  host1:192.168.78.9  \  host2:192.168.78.10 **

**安装前注意要先一键三连（firewalld、iptables -F、selinux）**

#### 1、要实现集群部署首先就得实现单机安装部署

#####     1、安装 erlang（三台都需要安装）

```
[root@hackerlion src]# cd /usr/local/src/
[root@hackerlion src]# wget http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
[root@hackerlion src]# yum -y install epel-release
[root@hackerlion src]# rpm -ivh erlang-solutions-1.0-1.noarch.rpm   //需要安装一个依赖包 epel-release
[root@hackerlion src]# rpm --import http://packages.erlang-solutions.com/rpm/erlang_solutions.asc
yum -y install erlang
```

#####    2、安装RabbitMQ（三台都需要安装）

  用 rpm 手动安装

```
[root@hackerlion ~]# wget  https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.13/rabbitmq-server-3.7.13-1.el7.noarch.rpm
[root@hackerlion ~]#  yum -y install socat
[root@hackerlion ~]#  rpm -ivh rabbitmq-server-3.7.13-1.el7.noarch.rpm
```

设置配置文件：

```
[root@hackerlion ~]# cp /usr/share/doc/rabbitmq-server-3.7.13/rabbitmq.config.example /etc/rabbitmq/
[root@hackerlion ~]# mv rabbitmq.config.example rabbitmq.config
```

设置用户远程访问：

```
[root@hackerlion ~]# vim /etc/rabbitmq/rabbitmq.config
 把  %% {loopback_users, []},   修改成     {loopback_users, []}
 
 ！！！！注：后面逗号要去掉
```

开启web界面管理工具

```
[root@hackerlion ~]# rabbitmq-plugins enable rabbitmq_management
[root@hackerlion ~]# systemctl start rabbitmq-server   //启动服务
[root@hackerlion ~]# netstat -tunlp |grep 5672    //查看端口:程序需要连接的端口号:5672
```

几个常用命令：

```
service rabbitmq-server start    或  systemctl start rabbitmq-server
service rabbitmq-server stop     或  systemctl stop rabbitmq-server
service rabbitmq-server restart    或  systemctl restart rabbitmq-server
chkconfig rabbitmq-server on　　//设置开机自启    systemctl enable rabbitmq-server
```

命令行添加用户，设置tags

```
rabbitmqctl list_users
rabbitmqctl add_user username password    //添加用户
rabbitmqctl set_user_tags username  administrator   //给权限

关于虚拟主机，Virtual Host，其实是一个虚拟概念，类似于权限控制组，一个Virtual Host里面可以有若干个Exchange和Queue，但是权限控制的最小粒度是Virtual Host
用户角色有下面几种：
1. 超级管理员(administrator)
可登陆管理控制台，可查看所有的信息，并且可以对用户，策略(policy)进行操作。
1. 监控者(monitoring)
可登陆管理控制台，同时可以查看rabbitmq节点的相关信息(进程数，内存使用情况，磁盘使用情况等)
1. 策略制定者(policymaker)
可登陆管理控制台, 同时可以对policy进行管理。但无法查看节点的相关信息(上图红框标识的部分)。
1. 普通管理者(management)
仅可登陆管理控制台，无法看到节点信息，也无法对策略进行管理。
1. 其他
无法登陆管理控制台，通常就是普通的生产者和消费者。
```

###########以上操作可作为单机安装部署########################

#### 2、开始部署集群三台机器都操作: 

#####    1、添加本地域名解析(以下操作三台机器都需要)

```
[root@hackerlion ~]# vim /etc/hosts	
192.168.78.6 hackerlion
192.168.78.9 host1
192.168.78.10 host2
```

##### 2、创建好数据存放目录和日志存放目录: 

```
[root@hackerlion ~]# mkdir -p /opt/rabbitmq/data
[root@hackerlion ~]# mkdir -p /opt/rabbitmq/logs
[root@hackerlion ~]# chmod 777 -R /opt/rabbitmq
[root@hackerlion ~]# chown rabbitmq.rabbitmq /opt/rabbitmq -R
```

##### 3、创建配置文件

```
[root@hackerlion ~]# vim /etc/rabbitmq/rabbitmq-env.conf
RABBITMQ_MNESIA_BASE=/opt/rabbitmq/data
RABBITMQ_LOG_BASE=/opt/rabbitmq/logs
```

##### 4、(重要！！)拷贝cookie

```
拷贝其中一台rabbitmq的cookie到另外两台。被拷贝的rabbitmq为master，在这里将rabbitmq1做为master
Rabbitmq的集群是依附于erlang的集群来工作的,所以必须先构建起erlang的集群景象。Erlang的集群中各节点是经由
过程一个magic cookie来实现的,这个cookie存放在/var/lib/rabbitmq/.erlang.cookie中，文件是400的权
限。所以必须保证各节点cookie一致,不然节点之间就无法通信。
(官方在介绍集群的文档中提到过.erlang.cookie 一般会存在这两个地址：第一个是home/.erlang.cookie；第二个地
方就是/var/lib/rabbitmq/.erlang.cookie。如果我们使用解压缩方式安装部署的rabbitmq，那么这个文件会在{home}
目录下，也就是$home/.erlang.cookie。如果我们使用rpm等安装包方式进行安装的，那么这个文件会在/var/lib/
rabbitmq目录下。)
```

```
先把另外两台的cookie备份一下
我这里主要是以hackerlion那台作为master
[root@host1 ~]# mv /var/lib/rabbitmq/.erlang.cookie /tmp/
[root@host2 ~]# mv /var/lib/rabbitmq/.erlang.cookie /tmp/
[root@hackerlion ~]# cat /var/lib/rabbitmq/.erlang.cookie
RRYEUESUZSAXPPYZANDZ
[root@hackerlion ~]# scp /var/lib/rabbitmq/.erlang.cookie host1:/var/lib/rabbitmq/
[root@hackerlion ~]# scp /var/lib/rabbitmq/.erlang.cookie host2:/var/lib/rabbitmq/
[root@host1 ~]# cat /var/lib/rabbitmq/.erlang.cookie
RRYEUESUZSAXPPYZANDZ
[root@host2 ~]# cat /var/lib/rabbitmq/.erlang.cookie
RRYEUESUZSAXPPYZANDZ
三个cookie必须相同

```

##### 5、分别重启三个节点

```
[root@hackerlion ~]# systemctl restart rabbitmq-server
[root@host1 ~]# systemctl restart rabbitmq-server
[root@host2 ~]# systemctl restart rabbitmq-server
```

##### 6、将host1、host2作为内存节点加入hackerlion节点集群中

​       **在host1、host2分别执行如下命令：**

```
[root@host1 ~]# rabbitmqctl stop_app ---停止节点，切记不是停止服务
Stopping rabbit application on node rabbit@host1...
[root@host1 ~]# rabbitmqctl reset -----如果有数据需要重置一下
Resetting node rabbit@host1 ...
[root@host1 ~]# rabbitmqctl join_cluster rabbit@hackerlion ------添加到那台节点，后面是节点的主机名
Clustering node rabbit@rabbitmq2 with rabbit@hackerlion
[root@host1 ~]# rabbitmqctl start_app -----启动节点
Starting node rabbit@host1 ...
 completed with 0 plugins.
 
 host2 同上操作
```

在三台机器查看集群状态: 

```
[root@hackerlion ~]# rabbitmqctl cluster_status 
 Cluster status of node rabbit@hackerlion ...
 [{nodes,[{disc,[rabbit@hackerlion,rabbit@host1,rabbit@host2]}]},
 {running_nodes,[rabbit@host2,rabbit@host1,rabbit@hackerlion]},
 {cluster_name,<<"rabbit@hackerlion">>},
 {partitions,[]},
 {alarms,[{rabbit@host2,[]},{rabbit@host1,[]},{rabbit@hackerlion,[]}]}]

[root@host1 ~]# rabbitmqctl cluster_status 
Cluster status of node rabbit@host1 ...
[{nodes,[{disc,[rabbit@hackerlion,rabbit@host1,rabbit@host2]}]},
 {running_nodes,[rabbit@host2,rabbit@hackerlion,rabbit@host1]},
 {cluster_name,<<"rabbit@hackerlion">>},
 {partitions,[]},
 {alarms,[{rabbit@host2,[]},{rabbit@hackerlion,[]},{rabbit@host1,[]}]}]
 
 [root@host2 ~]# rabbitmqctl cluster_status
  Cluster status of node rabbit@host2 ...
  [{nodes,[{disc,[rabbit@hackerlion,rabbit@host1,rabbit@host2]}]},
 {running_nodes,[rabbit@hackerlion,rabbit@host1,rabbit@host2]},
 {cluster_name,<<"rabbit@hackerlion">>},
 {partitions,[]},
 {alarms,[{rabbit@hackerlion,[]},{rabbit@host1,[]},{rabbit@host2,[]}]}]
 
每台机器显示出三台节点，表示已经添加成功！
（1）默认rabbitmq启动后是磁盘节点，在这个cluster命令下，mq02和mq03是内存节点，mq01是磁盘节点。
（2）如果要使mq02、mq03都是磁盘节点，去掉--ram参数即可。
（3）如果想要更改节点类型，可以使用命令rabbitmqctl change_cluster_node_type disc(ram),前提是必须停掉
rabbit应用
在RabbitMQ集群集群中，必须至少有一个磁盘节点，否则队列元数据无法写入到集群中，当磁盘节点宕掉时，集群
将无法写入新的队列元数据信息。
=====================
```



##### 7、RabbitMQ镜像集群配置 

RabbitMQ镜像集群配置 上面已经完成RabbitMQ默认集群模式，但并不保证队列的高可用性，尽管交换机、绑定这些可以复制到集群里的任 

何一个节点，但是队列内容不会复制。虽然该模式解决一项目组节点压力，但队列节点宕机直接导致该队列无法应 

用，只能等待重启，所以要想在队列节点宕机或故障也能正常应用，就要复制队列内容到集群里的每个节点，必须 

要创建镜像队列。 

镜像队列是基于普通的集群模式的，然后再添加一些策略，所以你还是得先配置普通集群，然后才能设置镜像队 

列，我们就以上面的集群接着做。 

保证各个节点之间数据同步； 

• Policy(各节点均会同步)

```
创建镜像集群:三台机器相同操作:
[root@hackerlion ~]# rabbitmqctl set_policy ha-all "^" '{"ha-mode":"all"}'
```

安装其他相关插件操作：所有机器相同操作！ 

```
举个栗子：
安装延时插件:
1.登录rabbitmq的官网:
http://www.rabbitmq.com/community-plugins.html 搜索 delayed 关键字

2.选择版本，选这里安装的是3.7固插件选择3.7版本
cd /usr/local/src/
[root@hackerlion src]# wget https://dl.bintray.com/rabbitmq/community-plugins/3.7.x/rabbitmq_delayed_message_exchange/rabbitmq_delayed_message_exchange-20171201-3.7.x.zip
[root@hackerlion src]# unzip rabbitmq_delayed_message_exchange-20171201-3.7.x.zip

3、查找到plugins/目录在哪里。
[root@hackerlion src]# find / -name plugins
/usr/lib/rabbitmq/lib/rabbitmq_server-3.7.13/plugins   //找到这个目录  
这个目录下面都是安装的插件， 以后需要安装什么插件下载下来解压放到里面即可！
[root@hackerlion src]# cp rabbitmq_delayed_message_exchange-20171201-3.7.x.ez /usr/lib/rabbitmq/lib/rabbitmq_server-3.7.7/plugins/
启动插件:
[root@hackerlion src]# rabbitmq-plugins enable rabbitmq_delayed_message_exchange
```

**ok!以上rabbitmq集群部署完成:! **

可以在随便一台机器上面添加一个用户并赋予权限，其他机器都会有,也可以修改

```
[root@host1 ~]# rabbitmqctl add_user zhang 123
[root@host1 ~]# rabbitmqctl set_user_tags zhang administrator
[root@host2 src]# rabbitmqctl list_users
Listing users ...
user    tags
zhang   [administrator]
```



##### rabbitmq使用命令:

```
rabbitmq-plugins list ----查看安装的插件
rabbitmq-server -detached -----------启动RabbitMQ节点
rabbitmqctl start_app ----------启动RabbitMQ应用，而不是节点
rabbitmqctl stop_app ------停止
rabbitmqctl status ------查看状态
rabbitmqctl add_user mq 123456 -------设置用户和密码
rabbitmqctl delete_user mq  --------删除用户
rabbitmqctl change_password 123456 admin123  ----修改密码
rabbitmqctl set_user_tags mq administrator ------------------新增账户并设置为管理员
设置角色：administrator monitoring policymaker management
rabbitmq-plugins enable rabbitmq_management --------------------启用RabbitMQ_Management
rabbitmqctl cluster_status -------------------集群状态
rabbitmqctl forget_cluster_node rabbit@rabbit3 -------------------节点摘除
rabbitmqctl reset application----------------------重置
 rabbitmqctl set_permissions -p "/" soso ".*" ".*" ".*" --------------授权
--------------------- 
查看Connection，Queue，Channel,User
 rabbitmqctl list_connections
 rabbitmqctl list_queues
 rabbitmqctl list_channels
 rabbitmqctl list_users
---------------------
```

