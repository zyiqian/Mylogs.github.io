### Nginx配置文件的介绍

**Nginx配置文件主要是由三部分组成：基本配置、events、http(基本配置、多个server配置)**

```
#==========================基本配置=================================
# 全局参数设置 
user nginx;                 #配置worker进程运行用户
worker_processes  2;     #设置nginx启动进程的数量，一般设置成与逻辑cpu数量相同 8核CPU  配8或16
error_log  /var/log/nginx/error.log;    #指定错误日志 
worker_rlimit_nofile 102400;  #设置一个nginx进程能打开的最大文件数 
pid        /var/run/nginx.pid;    #配置进程pid文件
#=========================events====================================
events { 
    #use epoll; #优化参数 （高并发配置）
    worker_connections  1024; #设置一个进程的最大并发连接数 worker_processes * worker_connections                               # 2*1024
} 

#==================================http配置=============================

# http 服务相关设置，利用它的反向代理功能提供负载均衡支持 

http {
#================================http：基本配置===================================
    include      mime.types;   #配置nginx支持的多媒体类型，可以在/etc/nginx/mime.types查看支持的所                                 有类型；无法解析jsp文件的
                                 
    default_type  application/octet-stream;   #默认文件类型 
    
    log_format  main  'remote_addr - remote_user [time_local] "request" '
                      'status body_bytes_sent "$http_referer" '
                      '"http_user_agent" "http_x_forwarded_for"'; 
    access_log  /var/log/nginx/access.log  main; #设置访问日志的位置和格式 使用上面定义的min日志格式
    sendfile          on; #是否调用sendfile函数输出文件，一般设置为on，若nginx是用来进行磁盘IO负载应用时，可以设置为off，降低系统负载 ，开启高效文件传输模式
    #tcp_nopush     on;  #防止网络阻塞
    gzip              on;      #是否开启gzip压缩 
    keepalive_timeout  65;     #设置长连接的超时时间 单位是秒
    
# 虚拟服务器的相关设置 
#=================================server配置=========================================
    server { 
        listen      80;        #设置监听的端口 
        server_name  localhost;  #设置绑定的主机名、域名或ip地址 
        charset koi8-r;        # 设置编码字符 默认的是俄罗斯字符集  可以改成gbk utf8的
        
        #默认的匹配斜杠"/"的请求，当访问路径中有"/"，会被location匹配到并进行处理
        #例如：访问 http://(域名.端口)/  后面‘/’就会被location匹配到
        location / { 
            root  html;      #设置服务器默认网站的根目录位置,默认为nginx安装主目录下的html
                               /usr/local/nginx/html
            index  index.html index.htm;    #设置默认打开的文档 
            } 
         #基本流程：开启nginx-->访问本机IP：192.168.78.123/ ("/"在地址栏中默认是加的)-->"/"被location匹配到-->访问root的HTML目录-->打开index.html
         
        #error_page  500 502 503 504  /50x.html; #设置错误信息返回页面 
        #精确匹配
        location = /50x.html { 
            root  html;        #这里的绝对位置是/var/www/nginx/html 
        } 
    }
    
    #配置另一个虚拟主机
    #server {
    #    listen 8000;
    #    server_name localhost;
    #    location / {
    #        root html;
    #        index index.html;
    #    }
    #}
    
    #配置https服务,安全的网络传输协议，加密传输,默认端口443
    #server {
    #    listen 443 ssl;
    #    server_name localhost;
        
    #    ssl_certificate  cert.pem;      //CA证书
    #    ssl_certificate_key cert.key;
         
    #    ssl_session_cache  share:SSL:1m;
    #    ssl_session_timeout  5m;
        
    #    ssl_ciphers HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;
        
    #    location / {
    #        root html;
    #        index index.html index.htm;
    #    }
        
    #}
 }
```

