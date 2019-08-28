### Nginx----动态分离配置

本次是开启三台虚拟机

为了加快网站的解析速度，可以把动态页面和静态页面由不同的服务器来解析，加快解析速度。降低原来单个服务器的压力。 在动静分离的tomcat的时候比较明显，因为tomcat解析静态很慢，其实这些原理的话都很好理解，简单来说，就是使用正则表达式匹配过滤，然后交个不同的服务器。

##### 1、代理配置

```
[root@mysql_3 html]# vim /etc/nginx/nginx.conf   
   upstream lion {
        server 192.168.78.4:80;   
        server 192.168.78.6:80;
   }
   server {
        server_name 192.168.78.3;
   location ~ .*\.html$ {
        proxy_pass http://192.168.78.4:80;
        }
   location ~ \.jpg$ {
        proxy_pass http://192.168.78.6:80;
        }
     }
```

##### 2、静态服务器端

```
 location ~ .*\.html$ {
            root   /usr/local/nginx/static;
            index  index.html index.htm;
        }
注： 若报403则需要修改目录的权限
 chown -R nginx.nginx /usr/local/nginx
```

##### 3、动态服务器端

```
 location ~ \.php$ {
            root   /usr/local/nginx/move;
            index  index.php;
        }
```

**location /  的作用**

定义了请求代理的时候nginx去/var/www/html/upload  下寻找index.php 当他找到index.php的时候匹配了下面的正则  location ~ \.php$。

**location ~ \.php$   的作用**

以php结尾的都以代理的方式转发给web1（172.17.14.2）,http1 去处理，这里http1要去看自己的配置文件 在自己的配置文件中定义网站根目录 /var/www/html/upload  找.index.php  然后处理解析返回给nginx 。

 **location ~ .*\.(html|gif|jpg|png|bmp|swf|jpeg)$  的作用**

以html等等的静态页面都交给web2（172.17.14.3）来处理 ，web2 去找自己的网站目录 然后返回给nginx 。

两个 web 放的肯定是一样的目录，只不过每个服务器的任务不一样。

代理本身要有网站的目录，因为最上面的 location / 先生效   如果没有目录 会直接提示找不到目录 不会再往下匹配。