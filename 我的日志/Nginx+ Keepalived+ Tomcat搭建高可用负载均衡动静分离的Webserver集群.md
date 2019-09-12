### Nginx+ Keepalived+ Tomcat搭建高可用/负载均衡/动静分离的Webserver集群

#### 一、准备机器

##### 1、四台机器

LB1：192.168.78.9 （MASTER）              LB2:  192.168.78.10 （BACKUP）

RS1:   192.168.78.11（部署tomcat多实例）             RS2:   192.168.78.12  （nginx虚拟机）

##### 2、环境介绍

- 机器均是：Centos7.3版本
- nginx版本为：nginx/1.16.1
- Tomcat版本为：tomcat-7.0.85
- JKD版本为：jdk-7u67-linux

#### 二、开始部署

先部署server端

##### **RS1（部署Tomcat多实例）：192.168.78.11**

```
1、使用脚本配置yum，更新yum源，一键三连等
[root@192v168v78v11 ~]# sh hackerlion_1.5.sh
2、使用脚本安装Tomcat和配置java环境（此脚本只是配置单机java环境）
[root@192v168v78v11 ~]# sh hackerlion_1.5.sh
[root@192v168v78v11 ~]# /usr/local/tomcat_7/bin/startup.sh   //停止是shutdown.sh 
3、去浏览器访问192.168.78.11:8080 显示Tomcat默认页面即可
4、配置Tomcat多实例
复制程序文件
[root@192v168v78v11 ~]# cd /usr/local/
[root@192v168v78v11 local]# cp -a tomcat_7 /usr/local/tomcat_7_1
[root@192v168v78v11 local]# cp -a tomcat_7 /usr/local/tomcat_7_2
修改端口，以启动多实例。多实例之间端口不能一致
sed -i 's#8005#8011#;s#8080#8081#' /usr/local/tomcat_7_1/conf/server.xml
sed -i 's#8005#8012#;s#8080#8082#' /usr/local/tomcat_7_2/conf/server.xml
比较
diff /usr/local/tomcat_7_1/conf/server.xml /usr/local/tomcat_7_2/conf/server.xml
修改环境变量 改为局部变量，修改catalina.sh 
Tomcat2
[root@192v168v78v11 local]# vim /usr/local/tomcat_7_2/bin/catalina.sh 
CATALINA_HOME=/usr/local/tomcat_7_2
Tomcat1
[root@192v168v78v11 local]# vim /usr/local/tomcat_7_1/bin/catalina.sh 
CATALINA_HOME=/usr/local/tomcat_7_1
Tomcat
[root@192v168v78v11 local]# vim /usr/local/tomcat_7/bin/catalina.sh 
CATALINA_HOME=/usr/local/tomcat_7
修改原来java配置文件
[root@192v168v78v11 local]# vim /etc/profile.d/java_7.sh
export CATALINA_HOME=/usr/local/tomcat_7   //把这句去掉，是脚本安装的

修改原本默认的显示网页
Tomcat
[root@192v168v78v11 local]# cd /usr/local/tomcat_7/webapps/ROOT
[root@192v168v78v11 local]# mkdir web1
[root@192v168v78v11 local]# vim index.html
tomcat_web1

Tomcat1
[root@192v168v78v11 local]# cd /usr/local/tomcat_7_1/webapps/ROOT
[root@192v168v78v11 local]# mkdir web2
[root@192v168v78v11 local]# vim index.html
tomcat_web2

Tomcat2
[root@192v168v78v11 local]# cd /usr/local/tomcat_7_2/webapps/ROOT
[root@192v168v78v11 local]# mkdir web3
[root@192v168v78v11 local]# vim index.html
tomcat_web3

启动Tomcat,三个均启动
[root@192v168v78v11 ~]# /usr/local/tomcat_7/bin/startup.sh
[root@192v168v78v11 ~]# /usr/local/tomcat_7_1/bin/startup.sh
[root@192v168v78v11 ~]# /usr/local/tomcat_7_2/bin/startup.sh
去浏览器测试
192.168.78.11:8080/web1
192.168.78.11:8080/web2
192.168.78.11:8080/web3

```

##### **RS2（nginx虚拟主机）：192.168.78.12**

```
1、使用脚本配置yum，更新yum源，一键三连等
[root@192v168v78v12 ~]# sh hackerlion_1.5.sh
2、使用脚本安装nginx
[root@192v168v78v12 ~]# sh hackerlion_1.5.sh
查看启动状态：
[root@192v168v78v12 ~]# ps -ef|grep nginx 
进程没问题去网页测试192.168.78.12
显示nginx默认则安装成功
修改nginx配置
[root@192v168v78v12 ~]# vim /etc/nginx/nginx.conf
  server {
        server_name localhost;
    location /nginx1 {
        root /usr/share/nginx/html;
        index index.html;
    }
    location /nginx2 {
        root /usr/share/nginx/html;
        index index.html;
    }
     location /nginx3 {
        root /usr/share/nginx/html;
        index index.html;
    }
  }
[root@192v168v78v12 ~]# nginx -t  //检查
[root@192v168v78v12 ~]# nginx -s quit  //退出
[root@192v168v78v12 ~]# nginx         //启动
去网页逐个测试
192.168.78.12/nginx1
192.168.78.12/nginx2
192.168.78.12/nginx3
```

##### **LB1（master）：192.168.78.9**

```
1、使用脚本配置yum，更新yum源，一键三连等
[root@192v168v78v9 ~]# sh hackerlion_1.5.sh
2、使用脚本安装nginx
[root@192v168v78v9 ~]# sh hackerlion_1.5.sh
3、手动安装所需软件 ipvsadm keepalived 
[root@192v168v78v9 ~]# yum -y install ipvsadm keepalived 
4、安装完成后修改keepalived配置
[root@192v168v78v9 ~]# vim /etc/keepalived/keepalived.conf
! Configuration File for keepalived
global_defs {
  router_id director1
}
vrrp_instance VI_1 {
    state MASTER
    interface ens33
    virtual_router_id 80
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass lion
    }
    virtual_ipaddress {
        192.168.78.123
    }
}
启动keepalived
[root@192v168v78v9 ~]# systemctl start keepalived
然后查看ip 看看vip 是否添加上了
[root@192v168v78v9 ~]# ip a
 inet 192.168.78.123/32 scope global ens33

5、修改nginx配置
[root@192v168v78v9 ~]# vim /etc/nginx/nginx.conf 
http {
  server {
   server_name 192.168.78.123;               //vip
   location /web1 {
    proxy_pass http://192.168.78.11:8080/;
  }
     location /web2 {
        proxy_pass http://192.168.78.11:8081/;
     }
    location /web3 {
        proxy_pass http://192.168.78.11:8082/;
     }
     location /nginx1 {
        proxy_pass http://192.168.78.12/nginx1/;
     }
     location /nginx2 {
        proxy_pass http://192.168.78.12/nginx2/;
     }
      location /nginx3 {
        proxy_pass http://192.168.78.12/nginx3/;
     }
  }
}

```

##### **LB2（BACKUP）：192.168.78.10**

**部署keepalived的高可用**

```
1、使用脚本配置yum，更新yum源，一键三连等
[root@192v168v78v10 ~]# sh hackerlion_1.5.sh
2、使用脚本安装nginx
[root@192v168v78v10 ~]# sh hackerlion_1.5.sh
3、手动安装所需软件 ipvsadm keepalived 
[root@192v168v78v10 ~]# yum -y install ipvsadm keepalived 
4、安装完成后修改keepalived配置
复制一份master的配置
[root@192v168v78v10 ~]# cd /etc/keepalived/
备份原来的
[root@192v168v78v10 keepalived]# mv keepalived.conf keepalived.conf.bak
[root@192v168v78v10 keepalived]# scp 192.168.78.9:/etc/keepalived/keepalived.conf .
[root@192v168v78v10 ~]# vim /etc/keepalived/keepalived.conf
! Configuration File for keepalived

global_defs {
  router_id director2   //修改1
}

vrrp_instance VI_1 {
    state BACKUP            //修改2
    interface ens33
    virtual_router_id 80
    priority 50              //修改3
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass lion
    }
    virtual_ipaddress {
        192.168.78.123
    }
}
启动keepalived
[root@192v168v78v10 ~]# systemctl start keepalived
测试BACKUP是否成功运行
关闭MASTER的keepalived
[root@192v168v78v9 ~]# systemctl stop keepalived

注意我的主机名
[root@192v168v78v10 keepalived]# ip a
 inet 192.168.78.123/32 scope global ens33   //如果主的停了ip飘过去则配置成功

接下来修改nginx
[root@192v168v78v9 ~]# cd /etc/nginx/
[root@192v168v78v10 nginx]#  scp 192.168.78.9:/etc/nginx/nginx.conf .
[root@192v168v78v10 nginx]#  nginx -t 
[root@192v168v78v10 nginx]#  nginx -s quit
[root@192v168v78v10 nginx]#  nginx 

```

##### **Nginx健康检查**

到此： 可以解决心跳故障 keepalived 不能解决Nginx服务故障

扩展对调度器Nginx健康检查（可选） 思路： 让Keepalived以一定时间间隔执行一个外部脚本，脚本的功能是当Nginx失败，则关闭本机的Keepalived #此脚本的基本思想是若没有80端口存在，就停掉Keepalived服务实现释放本地的VIP。在后台执行上述脚本并检查：

```
a、检测80端口脚本
[root@92v168v78v9 ~]# vim /etc/keepalived/check_nginx_status.sh
#!/bin/bash											        	
/usr/bin/curl -I http://localhost &>/dev/null	
if [ $? -ne 0 ];then									    	
	/etc/init.d/keepalived stop					    	
fi
[root@192v168v78v9 ~]# vim /etc/keepalived/keepalived.conf
.....
global_defs {
  router_id director2   //修改1
}
vrrp_script check_nginx {                               //添加检测脚本
   script "/etc/keepalived/check_nginx_status.sh"       //
   interval 5
}
vrrp_instance VI_1 {
....
....

  track_script {                                     //调用
        check_nginx
    }
}
```



**完成以上全部操作后去网页测试**

<http://192.168.78.123/web1>   ------>tomcat_web1 

<http://192.168.78.123/web2>   ------>tomcat_web2 

<http://192.168.78.123/web3>   ------>tomcat_web3 

<http://192.168.78.123/nginx1>   ------>nginx_web1 

<http://192.168.78.123/nginx2>   ------>nginx_web2

<http://192.168.78.123/nginx3>   ------>nginx_web3

#### 附录 ：部署过程使用的shell

hackerlion_1.5.sh  

```

```



