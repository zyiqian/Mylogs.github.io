### 源码方式安装nginx

1、安装编译环境

yum -y install gcc gcc-c++

2、安装pcre软件包（使nginx支持http rewrite模块）

yum install -y pcre pcre-devel

3、安装openssl-devel（使nginx支持ssl）

yum install -y openssl openssl-devel 

4、安装zlib

yum install -y zlib zlib-devel

总 ： yum -y install gcc gcc-c++ pcre pcre-devel openssl openssl-devel zlib zlib-devel

5、创建用户nginx

useradd nginx 

创建所需文件

 mkdir /tmp/nginx/
 touch /tmp/nginx/client_body
 chown -R nginx.nginx /tmp/nginx

6、安装nginx

```
[root@localhost ~]# wget http://nginx.org/download/nginx-1.16.1.tar.gz
 [root@localhost ~]# mv nginx-1.16.1.tar.gz /usr/local/src
 [root@localhost ~]# cd /usr/local/src
[root@localhost ~]#  tar xzvf nginx-1.16.1.tar.gz -C /usr/local
[root@localhost ~]# mv /usr/local/nginx-1.16.1 /usr/local/nginx
[root@localhost ~]# cd /usr/local/nginx
[root@localhost ~]# ./configure \--group=nginx \--user=nginx \--prefix=/usr/local/nginx \--sbin-path=/usr/sbin/nginx \--conf-path=/etc/nginx/nginx.conf \--error-log-path=/var/log/nginx/error.log \--http-log-path=/var/log/nginx/access.log \--http-client-body-temp-path=/tmp/nginx/client_body \--http-proxy-temp-path=/tmp/nginx/proxy \--http-fastcgi-temp-path=/tmp/nginx/fastcgi \--pid-path=/var/run/nginx.pid \--lock-path=/var/lock/nginx \--with-http_stub_status_module \--with-http_ssl_module \--with-http_gzip_static_module \--with-pcre
[root@localhost ~]# make &&make install
```

7、启动nginx

```
查看nginx安装的模块
[root@localhost ~]#  nginx -V
启动nginx
 [root@localhost ~]# /usr/sbin/nginx
 查看进程
 [root@localhost ~]# ps -ef |grep 'nginx'
```

