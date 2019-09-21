### 搭建keepalived高可用集群

#### 1、Keepalived VRRP介绍

传送门 https://www.cnblogs.com/ywrj/p/9483427.html

Keepalived软件起初是专门为LVS负载均衡软件设计的用来管理并监控LVS集群系统中各个服务节点的状态，后来又加入了可以实现高可用的VRRP功能。因此，Keepalived除了能够管理LVS软件外，还可以作为其他服务的高可用解决方案软件。

Keepalived软件主要是通过**VRRP**协议实现高可用功能的,VRRP是Virtual Router Redundancy Protocol（虚拟路由器冗余协议）的缩写.VRRP出现的目的就是为了解决静态路由**单点故障问题**的

![img](/img/vrrp.jpg)



#### 2、keepalived的三个核心模块

core核心模块 chech健康监测  vrrp虚拟路由冗余协议

#### 3、keepalived搭建

```
yum -y install keepalived　　　　　　　　　　　　　　　　#安装keepalived 
vim /etc/keepalived/keepalived.conf　　　　　　　　　　#修改主keepalived配置文件
scp /etc/keepalived/keepalived.conf 192.168.50.149:/etc/keepalived/　　　　#发从给从
/etc/init.d/keepalived start　　　　　　　　　　　　　　#启动keepalived
```

##### 3.1、Keepalived配置（文件说明）

```
vim /etc/keepalived/keepalived.conf    //配置文件
! Configuration File for keepalived              
global_defs {                        #全局定义部分
   notification_email {              #设置警报邮箱
     acassen@firewall.loc            #邮箱
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   notification_email_from Alexandre.Cassen@firewall.loc      #设置发件人地址
   smtp_server 192.168.50.1        #设置smtp server地址
   smtp_connect_timeout 30          #设置smtp超时连接时间    以上参数可以不配置
   router_id LVS_DEVEL               #是Keepalived服务器的路由标识在一个局域网内，这个标识（router_id）是唯一的
}

vrrp_instance VI_1 {      #VRRP实例定义区块名字是VI_1
    state MASTER          #表示当前实例VI_1的角色状态这个状态只能有MASTER和BACKUP两种状态，并且需要大写这些字符ASTER为正式工作的状态，BACKUP为备用的状态
    interface eth0       
    virtual_router_id 51 #虚拟路由ID标识,这个标识最好是一个数字,在一个keepalived.conf配置中是唯一的, MASTER和BACKUP配置中相同实例的virtual_router_id必须是一致的.
    priority 100                #priority为优先级 越大越优先
    advert_int 1               #为同步通知间隔。MASTER与BACKUP之间通信检查的时间间隔，单位为秒，默认为1.
    authentication {           #authentication为权限认证配置不要改动,同一vrrp实例的MASTER与BACKUP使用相同的密码才能正常通信。
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {         #设置虚拟IP地址
        192.168.50.16         #此格式ip a显示 ifconfig不显示
        192.168.50.17/24 dev eth0 label eth0:1    #绑定接口为eth0，别名为eth0：1
   }
#至此为止以上为实现高可用配置,如只需使用高可用功能下边配置可删除
#以下为虚拟服务器定义部分
virtual_server 192.168.50.16 80 {      #设置虚拟服务器,指定虚拟IP和端口
    delay_loop 6                           #健康检查时间为6秒
    lb_algo rr                               #设置负载调度算法 rr算法
    lb_kind NAT                            #设置负载均衡机制 #有NAT,TUN和DR三种模式可选
    nat_mask 255.255.255.0         #非NAT模式注释掉此行  注释用!号
    persistence_timeout 50           #连接保留时间,50秒无响应则重新分配节点
    protocol TCP                           #指定转发协议为TCP 
    real_server 192.168.5.150 80 {      #RS节点1
        weight 1                #权重
        TCP_CHECK {             #节点健康检查
        connect_timeout 8       #延迟超时时间
        nb_get_retry 3          #重试次数
        delay_before_retry 3    #延迟重试次数
        connect_port 80         #利用80端口检查
    }
    }
    real_server 192.168.50.149 80 {      #RS节点2
        weight 1
        TCP_CHECK {
        connect_timeout 8
        nb_get_retry 3
        delay_before_retry 3
        connect_port 80 
    }
    }
}  
```

##### 3.2、MASTER搭建

```
获取RS的  MD5SUM 
[root@lvs-RS ~]# genhash -s 192.168.78.111 -p 80 -u /test.html
MD5SUM = f5ac8127b3b6b85cdc13f237c6005d80

[root@lvs-RS ~]# genhash -s 192.168.78.8 -p 80 -u /test.html
MD5SUM = f5ac8127b3b6b85cdc13f237c6005d80

vim /etc/keepalived/keepalived.conf
! Configuration File for keepalived
global_defs {
   router_id director1	    //辅助改为director2
}

vrrp_instance VI_1 {
    state MASTER                  //主：MASTER 从 ：BACKUP
    nopreempt				
    interface ens33				//VIP绑定接口
    virtual_router_id 80		//MASTER,BACKUP一致
    priority 100					//辅助改为50
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.122.100           //vip
    }
}

virtual_server 192.168.78.100 80 {   #设置虚拟服务器,指定虚拟IP和端口
    delay_loop 6
    lb_algo rr
    lb_kind DR
    nat_mask 255.255.255.0
    persistence_timeout 50
    protocol TCP

    real_server 192.168.78.111 80 {    #RS节点1
        weight 1
        inhibit_on_failure
        HTTP_GET {
            url {
              path /
              digest 79c6753e5a83bd1051383fcfc0d4f7b6   //MD5SUM 
            }
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }
    }
    real_server 192.168.78.8 80 {      #RS节点2
        weight 1
        inhibit_on_failure
        HTTP_GET {
            url {
              path /
              digest 352394cea577d1ffedb6c2f797f3c7df   //MD5SUM 
            }
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }
    }
}
      
```

##### 3.3、从BACKUP搭建

```
mv /etc/keepalived/keepalived.conf{,.bak}  //把原来的配置文件备份
scp 192.168.78.6:/etc/keepalived/keepalived.conf  /etc/keepalived/keepalived.conf  //拷贝一份主的
vim /etc/keepalived/keepalived.conf
修改 
router_id director1	    //辅助改为director2
 state BACKUP                 //主：MASTER 从 ：BACKUP
priority 50
```

##### 3.4、RS配置

```
实施步骤：
1. RS配置(web1,web2)
配置好网站服务器，测试所有RS														   
[root@web1 ~]# ip addr add dev lo 192.168.122.100/32    //wb1  wb2				
[root@web1 ~]# echo "net.ipv4.conf.all.arp_ignore = 1" >> /etc/sysctl.conf
			  echo "net.ipv4.conf.all.arp_announce = 2" >> /etc/sysctl.conf
[root@web1 ~]# sysctl -p
```

##### 3.5、测试 

```
客户端 client
[root@hackerlion ~]# curl http://192.168.78.100
this is mysql_1
[root@hackerlion ~]# curl http://192.168.78.8
this is a mysql_3
```

配置完成后，启动Keepalived服务  并模拟实验 主从vip漂移(只需开启关闭主 .关闭主,主VIP消失从显示VIP ,开启主 从VIP消失,主VIP显示) 

#### 4、Nginx健康检查

到此：
可以解决心跳故障  keepalived
不能解决Nginx服务故障

4. 扩展对调度器Nginx健康检查（可选）
  思路：
  让Keepalived以一定时间间隔执行一个外部脚本，脚本的功能是当Nginx失败，则关闭本机的Keepalived
  #此脚本的基本思想是若没有80端口存在，就停掉Keepalived服务实现释放本地的VIP。在后台执行上述脚本并检查：

  ```
  a、检测80端口脚本
  [root@master ~]# cat /etc/keepalived/check_nginx_status.sh
  #!/bin/bash											        	
  /usr/bin/curl -I http://localhost &>/dev/null	
  if [ $? -ne 0 ];then									    	
  	/etc/init.d/keepalived stop					    	
  fi
  [root@master ~]# chmod a+x /etc/keepalived/check_nginx_status.sh
  
  b. keepalived使用script
  vim /etc/keepalived/keepalived.conf
  ! Configuration File for keepalived
  
  global_defs {
     router_id director1
  }
  
  vrrp_script check_nginx {                               //添加检测脚本
     script "/etc/keepalived/check_nginx_status.sh"       //
     interval 5
  }
     .
     .
     .
    track_script {                                     //调用
          check_nginx
      }
  ```

  ##### 	!!!!!!!注：必须先启动nginx，再启动keepalived!!!!!!!