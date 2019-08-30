### Nginx流量控制及访问控制

#### 1、Nginx流量控制：

##### 1）、配置基本的限流

```
limit_req_zone $binary_remote_addr zone=mylimit:10m rate=10r/s; //限制一秒请求10次，超过则报503错误
server {
	server_name localhost;
	location / {
	 root /usr/share/nginx/html;
	 index index.html;
	  limit_req zone=mylimit;
	}
}
```

limit_req_zone指令定义了流量限制相关的参数，而limit_req指令在出现的上下文中启用流量限制

limit_req_zone`指令通常在HTTP块中定义，使其可在多个上下文中使用，它需要以下三个参数：

- **Key** - 定义应用限制的请求特性。示例中的 Nginx 变量`$binary_remote_addr`，保存客户端IP地址的二进制形式。这意味着，我们可以将每个不同的IP地址限制到，通过第三个参数设置的请求速率。(使用该变量是因为比字符串形式的客户端IP地址`$remote_addr`，占用更少的空间)
- **Zone** - 定义用于存储每个IP地址状态以及被限制请求URL访问频率的共享内存区域。保存在内存共享区域的信息，意味着可以在Nginx的worker进程之间共享。定义分为两个部分：通过`zone=keyword`标识区域的名字，以及冒号后面跟区域大小。16000个IP地址的状态信息，大约需要1MB，所以示例中区域可以存储160000个IP地址。
- **Rate** - 定义最大请求速率。在示例中，速率不能超过每秒10个请求。Nginx实际上以毫秒的粒度来跟踪请求，所以速率限制相当于每100毫秒1个请求。因为不允许”突发情况”(见下一章节)，这意味着在前一个请求100毫秒内到达的请求将被拒绝。

##### 2）、处理突发

```
location / {
    root /usr/share/nginx/html;
    index index.html;
    limit_req zone=mylimit burst=20;
}
```

burst`参数定义了超出zone指定速率的情况下(示例中的mylimit区域，速率限制在每秒10个请求，或每100毫秒一个请求)，客户端还能发起多少请求。上一个请求100毫秒内到达的请求将会被放入队列，我们将队列大小设置为20。一秒钟处理10个，还有20个等待，超过21个等待则后面的报503错误；

##### 3）、无延迟的排队

配置`burst`参数将会使通讯更流畅，但是可能会不太实用，因为该配置会使站点看起来很慢。在上面的示例中，队列中的第20个包需要等待2秒才能被转发，此时返回给客户端的响应可能不再有用。要解决这个情况，可以在`burst`参数后添加`nodelay`参数：

```
location / {
    root /usr/share/nginx/html;
    index index.html;
    limit_req zone=mylimit burst=20 nodelay;
}
```

**注意：** 对于大部分部署，我们建议使用`burst`和`nodelay`参数来配置`limit_req`指令。 

##### 4)、白名单

​	为了使某些客户端开启的绿色通道，不限流而开启的；

```
geo $limit {
    default          1;
    192.168.78.6     0;
    10.3.138.0/24    0;
}
map $limit $limit_key {
    0     "";
    1 $binary_remote_addr;
}
limit_req_zone $limit_key zone=mylimit:10m rate=10r/s;
server {
    location / {
        root /usr/share/nginx/html;
        index index.html;
        limit_req zone=mylimit burst=20 nodelay;
    }
}
```

192.168.78.6用户和10.3.138.0/24网段不会被限流

##### 5)、指定location拒绝所有请求

如果你想拒绝某个指定URL地址的所有请求，而不是仅仅对其限速，只需要在`location`块中配置`deny` **all**指令：

```
location /foo.php {
    deny all;
}
```

#### 2、Nginx访问控制

##### 1、基于ip的访问控制

```

location / {
    root /usr/share/nginx/html;
    deny 192.168.78.6;
    allow all;
    index index.html;
}
若192.168.78.6访问则会报403错误
```

##### 2、基于用户的信任登录

```
  location / {
        root   /usr/share/nginx/html;
        auth_basic "Auth access test!";
        auth_basic_user_file /etc/nginx/auth_conf;
        index  index.html index.htm;
    }
   建立口令文件
[root@web ~]# htpasswd -cm /etc/nginx/auth_conf user10
[root@web ~]# htpasswd -m /etc/nginx/auth_conf user20
[root@web ~]# cat /etc/nginx/auth_conf 
user10:$apr1$Cw6eF/..$MNBh6rvkvsfH9gDZ/kEhg/
user20:$apr1$tb6B8...$y28sfvudhfb4V8xPlvvi//
访问测试
去浏览器访问网址  则需要输入  user10 或user20的密码
```

