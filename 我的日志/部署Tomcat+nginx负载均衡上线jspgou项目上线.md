## 部署Tomcat+jdk上线jspgou项目上线

#### 1、Tomcat简介

Tomcat服务器是一个免费的开放源代码的Web应用服务器，属于轻量级应用服务器，在中小型系统和并发访问用户不是很多的场合下被普遍使用，是开发和调试JSP程序的首选。

Tomcat和Nginx、Apache(httpd)、lighttpd等Web服务器一样，具有处理HTML页面的功能，另外它还是一个Servlet和JSP容器，独立的Servlet容器是Tomcat的默认模式。不过，Tomcat处理静态HTML的能力不如Nginx/Apache服务器。

##### 配置jkd环境

JDK是整个java开发的核心，它包含了JAVA的运行环境（JVM+Java系统类库）和JAVA工具。
http://openjdk.java.net/ //jdk官网

http://tomcat.apache.org //tomcat官网 

```
把下载好的jdk上传到/usr/local/src 目录下
[root@localhost ~]# cd /usr/local/src/
[root@localhost ~]# tar xf apache-tomcat-7.0.85.tar.gz -C /usr/local/ 
[root@localhost ~]# tar xf jdk-7u67-linux-x64.tar.gz -C /usr/local 
[root@localhost ~]# mv jdk1.7.0_67/ java 
[root@localhost ~]# mv apache-tomcat-7.0.82/ tomcat
配置java环境变量
[root@youngfit ~]# vim /etc/profile
添加
export JAVA_HOME=/usr/local/java 
export PATH=$JAVA_HOME/bin:$PATH 
export CATALINA_HOME=/usr/local/tomcat
配置好后检测一下
[root@youngfit ~]# source /etc/profile 
[root@youngfit ~]# java -version 
java version "1.7.0_67" Java(TM) SE Runtime Environment (build 1.7.0_67-b01)
Java HotSpot(TM) 64-Bit Server VM (build 24.65-b04, mixed mode) 
启动Tomcat
[root@youngfit ~]# /usr/local/tomcat/bin/startup.sh 
[root@youngfit ~]# /usr/local/tomcat/bin/shutdown.sh（停止）
.检查是否启动成功 
[root@youngfit ~]# netstat -tnlp | grep java tcp 0 0 ::ffff:127.0.0.1:8005 :::* LISTEN 6191/java tcp 0 0 :::8009 :::* LISTEN 6191/java tcp 0 0 :::8080 :::* LISTEN 6191/java
去网站测试
http://192.168.87.66:8080
若出现Tomcat猫咪就可以了
```

##### 数据库导入

```
1、使用mysql
[root@youngfit ~]# mysql -uroot -p 
create database jspgou default charset=utf8;    //在数据库中操作，创建数据库并指定字符集 
flush privileges;
```

##### 部署jspgou项目

```
上传项目到/usr/local/src
[root@youngfit ~]# yum -y install unzip     //安装解压工具
[root@youngfit ~]# cd /usr/local/src
[root@youngfit src]# unzip +包名 
先把Tomcat的原网站目录加个后缀备份掉，或者删掉
[root@youngfit ~]# mv /usr/local/tomcat/webapps/ROOT  /usr/local/tomcat/webapps/ROOT_bak
[root@youngfit ~]# cp -r /usr/local/src/ROOT/ /usr/local/tomcat/webapps/
```

##### 更新数据库链接

```
[root@youngfit ~]# vim /usr/local/tomcat/webapps/ROOT/WEB-INF/config/jdbc.properties
jdbc.url=jdbc:mysql://127.0.0.1:3306/(创建好的数据库名)?characterEncoding=UTF-8 
jdbc.username=root  （数据库用户）
jdbc.password=1    (数据库密码)
```

##### 导入数据库

```
[root@youngfit ~]# mysql -u root -p -D jspgou < /usr/loacal/src/DB/jspgou.sql
```

##### 再次启动Tomcat服务

```
[root@youngfit ~]#/usr/local/tomcat/bin/startup.sh
```

##### 测试

首页 ：http://公网IP地址:8080

系统管理后台登录：http://公网IP地址:8080/jeeadmin/jspgou/index.do

##### ！！！！注意！！！！

jdk环境为1.7的
Tomcat多实例配置

多虚拟主机：nginx 多个Server标签（域名，ip，端口） 进程数量固定 master+worker

多实例（多进程）：同一个程序启动多次，分为两种情况:

第一种：一台机器跑多个站点； 

第二种：一个机器跑一个站点多个实例，配合负载均衡

    1、复制程序文件
    [root@hackerlion ~]# cp -a /usr/local/tomcat /usr/local/tomcat1  -a 是保持跟原目录一样包括权限
    [root@hackerlion ~]# cp -a /usr/local/tomcat /usr/local/tomcat2
    
    2、修改端口，以启动多实例。多实例之间端口不能一致
    sed -i 's#8005#8011#;s#8080#8081#' /usr/local/tomcat1/conf/server.xml
    sed -i 's#8005#8012#;s#8080#8082#' /usr/local/tomcat2/conf/server.xml
    比较
    diff /usr/local/tomcat1/conf/server.xml /usr/local/tomcat2/conf/server.xml
    3、修改环境变量 改为局部变量，修改catalina.sh 
    
    [root@hackerlion ~]# vim /usr/local/tomcat2/bin/catalina.sh 
    CATALINA_HOME=/usr/local/tomcat2
    [root@hackerlion ~]# vim /usr/local/tomcat1/bin/catalina.sh 
    CATALINA_HOME=/usr/local/tomcat1
    
    4、配置nginx负载均衡
    [root@hackerlion ~]# vim /etc/nginx/nginx.conf
    upstream lion {
        server 192.168.78.123:8080;
        server 192.168.78.123:8081;
        server 192.168.78.123:8082;
    }
    location / {
        server_name 192.168.78.123;
        root html;
        index index.html;
        proxy_pass http://lion;
    }
    
    启动Tomcat
    [root@hackerlion ~]# /usr/local/tomcat/bin/startup.sh
    [root@hackerlion ~]# /usr/local/tomcat1/bin/startup.sh
    [root@hackerlion ~]# /usr/local/tomcat2/bin/startup.sh



