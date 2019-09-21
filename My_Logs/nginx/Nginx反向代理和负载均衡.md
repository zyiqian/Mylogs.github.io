### Nginx反向代理和负载均衡

#### 1、反向代理：

- 反向代理产生的背景：
  在计算机世界里，由于单个服务器的处理客户端（用户）请求能力有一个极限，当用户的接入请求蜂拥而入时，会造成服务器忙不过来的局面，可以使用多个服务器来共同分担成千上万的用户请求，这些服务器提供相同的服务，对于用户来说，根本感觉不到任何差别。

- 反向代理服务的实现：
  需要有一个负载均衡设备（即反向代理服务器）来分发用户请求，将用户请求分发到空闲的服务器上。
  服务器返回自己的服务到负载均衡设备。
  负载均衡设备将服务器的服务返回用户

  ![](https://i.loli.net/2019/08/29/sN1xiXCZmMjQpUR.jpg)

1、代理配置

a、web-1 启动网站(内容)

b、web-2 启动网站(内容)

c、nginx proxy 代理机

代理机nginx配置

```
    upstream lion {
        server 192.168.78.8;
        server 192.168.78.4;
        }
    server {
        listen 80;
        server_name 192.168.78.6;
        location  / {
           proxy_pass http://lion;
        }
   }
```

#### 2、负载均衡算法

upstream 支持4种负载均衡调度算法:

A、轮询(默认):每个请求按时间顺序逐一分配到不同的后端服务器;

B、ip_hash:每个请求按访问IP的hash结果分配，同一个IP客户端固定访问一个后端服务器。可以保证来自同一ip的请求被打到固定的机器上，可以解决session问题。

C、url_hash:按访问url的hash结果来分配请求，使每个url定向到同一个后端服务器。后台服务器为缓存的时候效率。

D、fair:这是比上面两个更加智能的负载均衡算法。此种算法可以依据页面大小和加载时间长短智能地进行负载均衡，也就是根据后端服务器的响应时间来分配请求，响应时间短的优先分配。Nginx本身是不支持 fair的，如果需要使用这种调度算法，必须下载Nginx的 upstream_fair模块。

##### 实例：

1、热备：如果你有2台服务器，当一台服务器发生事故时，才启用第二台服务器给提供服务。服务器处理请求的顺序：AAAAAA突然A挂啦，BBBBBBBBBBBBBB.....

```
upstream myweb { 
      server 172.17.14.2:8080; 
      server 172.17.14.3:8080 backup;  #热备     
    }
```

2、轮询：nginx默认就是轮询其权重都默认为1，服务器处理请求的顺序：ABABABABAB

```
upstream myweb { 
      server 172.17.14.2:8080; 
      server 172.17.14.3:8080;      
    }
```

3、加权轮询：跟据配置的权重的大小而分发给不同服务器不同数量的请求。如果不设置，则默认为1。下面服务器的请求顺序为：ABBABBABBABBABB....

```
 upstream myweb { 
      server 172.17.14.2:8080 weight=1;
      server 172.17.14.3:8080 weight=2;
}
```

4、ip_hash:nginx会让相同的客户端ip请求相同的服务器。

```
upstream myweb { 
      server 172.17.14.2:8080; 
      server 172.17.14.3:8080;
      ip_hash;
    }
```

5、nginx负载均衡配置状态参数

- down，表示当前的server暂时不参与负载均衡。
- backup，预留的备份机器。当其他所有的非backup机器出现故障或者忙的时候，才会请求backup机器，因此这台机器的压力最轻。
- max_fails，允许请求失败的次数，默认为1。当超过最大次数时，返回proxy_next_upstream 模块定义的错误。
- fail_timeout，在经历了max_fails次失败后，暂停服务的时间。max_fails可以和fail_timeout一起使用

```
 upstream myweb { 
      server 172.17.14.2:8080 weight=2 max_fails=2 fail_timeout=2;
      server 172.17.14.3:8080 weight=1 max_fails=2 fail_timeout=1;    
    }
```

