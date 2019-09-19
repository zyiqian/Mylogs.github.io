### Elasticsearch集群部署+Kibana部署

#### 一、环境介绍：

- 系统类型：Centos7.3以上
- 节点IP：192.168.78.6、192.168.78.10、192.168.78.12
- 软件版本：jdk-8u211-linux-x64.tar.gz、elasticsearch-6.5.4.tar.gz、kibana-6.5.4-linux-x86_64.tar.gz

- 所需软件官网地址:

​         ES:<https://www.elastic.co/downloads/past-releases> 

​        JDK:https://www.oracle.com/technetwork/java/javase/overview/index.html

#### 二、首先部署单机ES

**ES运行依赖jdk8**

##### 1、配置java环境

```
上传所需包或到官网下载；
tar zxvf /usr/local/src/jdk-8u211-linux-x64.tar.gz -C /usr/local/
cd /usr/local/
mv jdk-8u121-linux-x64 java_8

vim /etc/profile.d/java_8.sh
JAVA_HOME=/usr/local/java_8
PATH=$JAVA_HOME/bin:$PATH
export JAVA_HOME PATH

校验
source /etc/profile.d/java_8.sh
java -version
```

##### 2、安装配置ES

```
创建运行ES的普通用户
useradd es       (useradd ela)
echo "1" | passwd --stdin "es"

安装ES
cd /usr/local/src
tar xzvf  elasticsearch-6.5.4.tar.gz -C /usr/local/ 
cd ..
vim /usr/local/elasticsearch-6.5.4/config/elasticsearch.yml
添加以下配置
cluster.name: hackerlion-elk
node.name: elk01
node.master: true
node.data: true
path.data: /data/elasticsearch/data
path.logs: /data/elasticsearch/logs
bootstrap.memory_lock: false
bootstrap.system_call_filter: false
network.host: 0.0.0.0
http.port: 9200
#discovery.zen.ping.unicast.hosts: ["192.168.78.10", "192.168.78.11"]
#discovery.zen.minimum_master_nodes: 2
#discovery.zen.ping_timeout: 150s
#discovery.zen.fd.ping_retries: 10
#client.transport.ping_timeout: 60s
http.cors.enabled: true                     //直接复制注意这两句会被注释掉
http.cors.allow-origin: "*" 

配置项详解：
cluster.name        集群名称，各节点配成相同的集群名称。
node.name       节点名称，各节点配置不同。
node.master     指示某个节点是否符合成为主节点的条件。
node.data       指示节点是否为数据节点。数据节点包含并管理索引的一部分。
path.data       数据存储目录。
path.logs       日志存储目录。
bootstrap.memory_lock       内存锁定，是否禁用交换。
bootstrap.system_call_filter    系统调用过滤器。
network.host    绑定节点IP。
http.port       rest api端口。
discovery.zen.ping.unicast.hosts    提供其他 Elasticsearch 服务节点的单点广播发现功能。
discovery.zen.minimum_master_nodes  集群中可工作的具有Master节点资格的最小数量，官方的推荐值是(N/2)+1，其中N是具有master资格的节点的数量。
discovery.zen.ping_timeout      节点在发现过程中的等待时间。
discovery.zen.fd.ping_retries        节点发现重试次数。
http.cors.enabled               是否允许跨源 REST 请求，用于允许head插件访问ES。
http.cors.allow-origin              允许的源地址。
```

##### 3、设置JVM堆大小

```
sed -i 's/-Xms1g/-Xms4g/' /usr/local/elasticsearch-6.5.4/config/jvm.options
sed -i 's/-Xmx1g/-Xmx4g/' /usr/local/elasticsearch-6.5.4/config/jvm.options

注意：
确保堆内存最小值（Xms）与最大值（Xmx）的大小相同，防止程序在运行时改变堆内存大小。
如果系统内存足够大，将堆内存最大和最小值设置为31G，因为有一个32G性能瓶颈问题。
堆内存大小不要超过系统内存的50%
例如：我的内存是8G 所以就它分配 4G就可以了
```

##### 4、创建ES数据及日志存储目录

```
mkdir -p /data/elasticsearch/{data,logs}       (/data/elasticsearch)
```

##### 5、修改安装目录及存储目录权限

```
chown -R es:es /data/elasticsearch
chown -R es:es /usr/local/elasticsearch-6.5.4
```

##### 6、系统优化

###### 1）、增加最大文件打开数

```
永久生效方法：
echo"* - nofile 65536" >> /etc/security/limits.conf
```

###### 2）、增加最大进程数

```
vim /etc/security/limits.conf
* - nofile 65536
* soft nofile 65536
* hard nofile 131072
* soft nproc 31717
* hard nproc 4096
更多的参数调整可以直接用这个
```

###### 3）、增加最大内存映射数

```
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
vm.swappiness=0
sysctl -p
```

###### 4)、配置下系统信息

```
echo "vm.swappiness=0" >>/etc/sysctl.conf
sysctl -p
```

##### 7、启动ES

```
su - es
cd /usr/local/elasticsearch-6.5.4
./bin/elasticsearch  //先在前台执行看看有没有错误再放后台
nohup bin/elasticsearch & //放后台
```

测试：浏览器访问http://192.168.78.6:9200

```
出现以下配置则配置成功
{
  "name" : "elk01",
  "cluster_name" : "hackerlion-elk",
  "cluster_uuid" : "Trsrz3pKR8KUycMIWVoejQ",
  "version" : {
    "number" : "6.5.4",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "d2ef93d",
    "build_date" : "2018-12-17T21:17:40.758843Z",
    "build_snapshot" : false,
    "lucene_version" : "7.5.0",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

##### 8、常见错误：

```
错误1：Exception in thread "main" org.elasticsearch.bootstrap.BootstrapException: java.nio.file.AccessDeniedException: /usr/local/elasticsearch-6.5.4/config/elasticsearch.keystore

查找原因，elasticsearch.keystore的宿主是root
ll /usr/local/elasticsearch-6.5.4/config/elasticsearch.keystore
-rw-rw---- 1 root root 207 Sep 16 14:38 /usr/local/elasticsearch-6.5.4/config/elasticsearch.keystore
添加权限
[root@hackerlion ~]# chown es.es /usr/local/elasticsearch-6.5.4/config/elasticsearch.keystore

错误2：memory locking requested for elasticsearch process but memory is not locked
elasticsearch.yml文件
bootstrap.memory_lock : false
/etc/sysctl.conf文件
vm.swappiness=0

错误3:
max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]

意思是elasticsearch用户拥有的客串建文件描述的权限太低，知道需要65536个

解决：
切换到root用户下面，
vim   /etc/security/limits.conf

在最后添加
* hard nofile 65536
* hard nofile 65536
重新启动elasticsearch，还是无效？
必须重新登录启动elasticsearch的账户才可以，例如我的账户名是elasticsearch，退出重新登录。
另外*也可以换为启动elasticsearch的账户也可以，* 代表所有，其实比较不合适

启动还会遇到另外一个问题，就是
max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
意思是：elasticsearch用户拥有的内存权限太小了，至少需要262114。这个比较简单，也不需要重启，直接执行
sysctl -w vm.max_map_count=262144
就可以了


```

##### 2）、ES重大错误： all shards failed 

错误4：
org.elasticsearch.action.search.SearchPhaseExecutionException: all shards failed 

```
[root@hackerlion ~]# curl http://192.168.78.6:9200/_cluster/health?pretty
{
  "cluster_name" : "hackerlion-elk",
  "status" : "red",           # 为 green 则代表健康没问题，如果是 yellow 或者 red 则是集群有问题
  "timed_out" : false,        # 是否有超时
  "number_of_nodes" : 1,      # 集群中的节点数量
  "number_of_data_nodes" : 1,    # 集群中data节点的数量
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 3,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 25.0
}

```



**解决方法：**

删除日志

rm -rf /data/elasticsearch/data/*

rm -rf /data/elasticsearch/logs/*

```
[root@hackerlion elasticsearch]# curl http://192.168.78.6:9200/_cluster/health?pretty
{
  "cluster_name" : "hackerlion-elk",
  "status" : "green",                    //green则成功
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 0,
  "active_shards" : 0,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}

```



#### 三、安装配置head监控插件

##### 1、安装node

```
cd /usr/local/src
wget https://npm.taobao.org/mirrors/node/latest-v4.x/node-v4.4.7-linux-x64.tar.gz
tar xzvf node-v4.4.7-linux-x64.tar.gz -C /usr/local/
mv node-v4.4.7-linux-x64 node

配置node环境
vim /etc/profile.d/node.sh
NODE_HOME=/usr/local/node
PATH=$NODE_HOME/bin:$PATH
export NODE_HOME PATH
source /etc/profile.d/node.sh
node --version   #检查node版本号
v4.4.7
```

##### 2、下载head插件

```
cd /usr/local/src
wget https://github.com/mobz/elasticsearch-head/archive/master.zip
unzip -d /usr/local master.zip

```

##### 3、安装grunt

```
cd /usr/local/elasticsearch-head-master
npm install -g grunt-cli
grunt -version  #检查grunt版本号
```

##### 4、修改head源码

```
vim /usr/local/elasticsearch-head-master/Gruntfile.js  +95   //直接跳到95行

      options: {
                                        port: 9100,
                                        base: '.',
                                        keepalive: true,
                                        hostname: '*'
                                }

```

![](https://i.loli.net/2019/09/16/1BDFMeT8mgvOzQA.jpg)

**！！！添加hostname，注意在上一行末尾添加逗号,hostname 不需要添加逗号**

```
vim /usr/local/elasticsearch-head-master/_site/app.js    +4374    //(4360行左右)

原本是http://localhost:9200 ，如果head和ES不在同一个节点，注意修改成ES的IP地址（在同一台主机上则不需要修改）
```

##### 5、下载head必要的文件

```
cd /usr/local/src
wget https://github.com/Medium/phantomjs/releases/download/v2.1.1/phantomjs-2.1.1-linux-x86_64.tar.bz2
yum -y install bzip2
tar -jxvf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /tmp/
```

##### 6、运行head

```
cd /usr/local/elasticsearch-head-master/
npm install
nohup grunt server &
```

##### 7、测试

```
访问http://172.16.244.25:9100
```

**如果测试单机部署成功了那就开始集群部署**

#### 四、ES集群部署

##### 1、下载安装配置ES

##### 2、修改配置文件

**三台主机都需要把配置文件discovery....前面的注释去掉**

```
host1主机：192.168.78.6 

只需要把discovery....前面的注释去掉 
添加其他两个IP   ["192.168.78.10", "192.168.78.12"]

host2主机：192.168.78.10

vim /usr/local/elasticsearch-6.5.4/config/elasticsearch.yml
添加以下配置
cluster.name: hackerlion-elk
node.name: elk02                          //与master不同
node.master: true
node.data: true
path.data: /data/elasticsearch/data
path.logs: /data/elasticsearch/logs
bootstrap.memory_lock: false
bootstrap.system_call_filter: false
network.host: 0.0.0.0
http.port: 9200
#discovery.zen.ping.unicast.hosts: ["192.168.78.6", "192.168.78.12"] //添加其他两个
#discovery.zen.minimum_master_nodes: 2
#discovery.zen.ping_timeout: 150s
#discovery.zen.fd.ping_retries: 10
#client.transport.ping_timeout: 60s
http.cors.enabled: true                     //直接复制注意这两句会被注释掉
http.cors.allow-origin: "*" 

host3主机：192.168.78.12 配置与host2差不多

vim /usr/local/elasticsearch-6.5.4/config/elasticsearch.yml
添加以下配置
cluster.name: hackerlion-elk
node.name: elk03                          //与master不同
node.master: true
node.data: true
path.data: /data/elasticsearch/data
path.logs: /data/elasticsearch/logs
bootstrap.memory_lock: false
bootstrap.system_call_filter: false
network.host: 0.0.0.0
http.port: 9200
#discovery.zen.ping.unicast.hosts: ["192.168.78.6", "192.168.78.10"] //添加其他两个
#discovery.zen.minimum_master_nodes: 2
#discovery.zen.ping_timeout: 150s
#discovery.zen.fd.ping_retries: 10
#client.transport.ping_timeout: 60s
http.cors.enabled: true                     //直接复制注意这两句会被注释掉
http.cors.allow-origin: "*" 
```

如果启动后连接不上则分别重启ES 和head

**访问http://192.168.78.6:9100**

![](https://i.loli.net/2019/09/16/8yT1e4YRJPGXdn7.jpg)

#### 五、 Kibana部署

节点IPhost1：192.168.78.6

##### 1、安装配置Kibana	

###### 1）安装

```
cd /usr/local/src
tar xzvf kibana-6.5.4-linux-x86_64.tar.gz -C /usr/local/

```

###### 2）配置

```
vim /usr/local/kibana-6.5.4-linux-x86_64/config/kibana.yml
server.port: 5601
server.host: "192.168.78.6"
elasticsearch.url: "http://192.168.78.6:9200"
kibana.index: ".kibana"

配置项含义：
server.port kibana服务端口，默认5601
server.host kibana主机IP地址，默认localhost
elasticsearch.url   用来做查询的ES节点的URL，默认http://localhost:9200
kibana.index        kibana在Elasticsearch中使用索引来存储保存的searches, visualizations和dashboards，默认.kibana
```

其他配置项可参考：
<https://www.elastic.co/guide/en/kibana/6.5/settings.html>

###### 3）启动

```
cd /usr/local/kibana-6.5.4-linux-x86_64/
nohup ./bin/kibana &
```

##### 2、配置Nginx反向代理

###### 1）安装nginx（步骤省略）

###### 2）配置反向代理

```
vim /etc/nginx/nginx.conf

user  nginx;
worker_processes  4;
error_log  /var/log/nginx/error.log;
pid        /var/run/nginx.pid;
worker_rlimit_nofile 65535;

events {
    worker_connections  65535;
    use epoll;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;
    server_names_hash_bucket_size 128;
    autoindex on;

    sendfile        on;
    tcp_nopush     on;
    tcp_nodelay on;

    keepalive_timeout  120;
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;

    #gzip   		   		 #模块设置
    gzip on;                  #开启gzip压缩输出
    gzip_min_length 1k;       #最小压缩文件大小
    gzip_buffers 4 16k;       #压缩缓冲区
    gzip_http_version 1.0;    #压缩版本（默认1.1，前端如果是squid2.5请使用1.0）
    gzip_comp_level 2;        #压缩等级
    gzip_types text/plain application/x-javascript text/css application/xml;    #压缩类型，默认就已经包含textml，所以下面就不用再写了，写上去也不会有问题，但是会有一个warn。
    gzip_vary on;
    #开启限制IP连接数的时候需要使用
    #limit_zone crawler $binary_remote_addr 10m;
    #tips:
    #upstream bakend{#定义负载均衡设备的Ip及设备状态}{
    #    ip_hash;
    #    server 127.0.0.1:9090 down;
    #    server 127.0.0.1:8080 weight=2;
    #    server 127.0.0.1:6060;
    #    server 127.0.0.1:7070 backup;
    #}
    #在需要使用负载均衡的server中增加 proxy_pass http://bakend/;
    server {
        listen       80;
        server_name  192.168.78.6;

        #charset koi8-r;

       # access_log  /var/log/nginx/host.access.log  main;
        access_log off;

         location / {  
             auth_basic "Kibana";   #可以是string或off，任意string表示开启认证，off表示关闭认证。
             auth_basic_user_file /etc/nginx/passwd.db;   #指定存储用户名和密码的认证文件。
             proxy_pass http://192.168.78.6:5601;
             proxy_set_header Host $host:5601;  
             proxy_set_header X-Real-IP $remote_addr;  
             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  
             proxy_set_header Via "nginx";  
                     }
         location /status { 
             stub_status on; #开启网站监控状态 
             access_log /var/log/nginx/kibana_status.log; #监控日志 
             auth_basic "NginxStatus"; } 

         location /head/{
             auth_basic "head";
             auth_basic_user_file /etc/nginx/passwd.db;
             proxy_pass http://192.168.78.6:9100;
             proxy_set_header Host $host:9100;
             proxy_set_header X-Real-IP $remote_addr;
             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
             proxy_set_header Via "nginx";
                         }  

        # redirect server error pages to the static page /50x.html
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}
```

###### 3) 配置授权用户和密码

```
yum install -y  httpd-tools
注意：httpd-tools用于生成nginx认证访问的用户密码文件
htpasswd -cm /etc/nginx/passwd.db lion
1
1

```

**启动nginx**

```
nginx -t
nginx -s quit 
nignx
```

浏览器访问http://192.168.78.6 刚开始没有任何数据，会提示你创建新的索引。

先启动kibana再启动nginx

![](https://i.loli.net/2019/09/16/NKHpvBVOUQXr9S7.jpg)



### 六、单机部署logstash

节点IP host2:192.168.78.10

软件版本：jdk-8u121-linux-x64.tar.gz、logstash-6.5.4.tar.gz

##### 1）安装

tar xzvf /usr/local/src/logstash-6.5.4.tar.gz -C /usr/local/

##### 2）配置

创建目录，我们将所有input、filter、output配置文件全部放到该目录中。

安装nginx，目的是让logstash读取里面的日志（安装步骤略）

```
cd /usr/local/src/logstash-6.5.4/
mkdir –p ect/conf.d
vim etc/conf.d/input.conf
logstash直接从文件读取数据
input{
    file{
   path => ["/var/log/nginx/access.log"]
        type => "host_nginx_log"
    }
}

输出到ES
vim etc/conf.d/output.conf
output{
    elasticsearch {
	hosts => ["192.168.78.9:9200"]
	index => ["%{type}-%{+YYYY.MM.dd}"]
    }
}
```



##### 3)、启动

```
cd /usr/local/logstash-6.5.4
nohup bin/logstash -f etc/conf.d/  --config.reload.automatic &
```

##### 4）、测试

要保证前面的ES ，kibana，head服务都需要开启

访问192.168.78.10

刷新head页面  这时会有数据添加进去，然后可以去kibana查看

### ++到这里简单的ELK就部署完了++

### 七、filebeat部署

为什么用 Filebeat ，而不用原来的 Logstash

原因很简单，资源消耗比较大。

由于 Logstash 是跑在 JVM 上面，资源消耗比较大，后来作者用 GO 写了一个功能较少但是资源消耗也小的轻量级的 Agent 叫 Logstash-forwarder。

Filebeat 需要部署在每台应用服务器上，可以通过 Salt 来推送并安装配置

##### 1）下载

```
 cd /usr/local/src
 wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.5.4-darwin-x86_64.tar.gz
```

##### 2）解压

```
tar -zxvf filebeat-6.5.4-darwin-x86_64.tar.gz -C /usr/local/
mv filebeat-6.5.4-darwin-x86_64 filebeat
cd filebeat
```

##### 3）修改配置

修改 Filebeat 配置，支持收集本地目录日志，并输出ES集群中

```
mv filebeat.yml filebeat.yml.bak
filebeat.prospectors:
- type: log
  enable: true
  paths:
    -  /var/log/nginx/access.log
output.elasticsearch:
  hosts: ["192.168.78.9:9200","192.168.78.10:9200","192.168.78.11:9200"]
```

##### 4）启动

注意！！！：启动前先检查 access.log 文件下是否会产生日志

tailf  /var/log/nginx/access.log 

```
nohup ./filebeat -e -c filebeat.yml &
```

