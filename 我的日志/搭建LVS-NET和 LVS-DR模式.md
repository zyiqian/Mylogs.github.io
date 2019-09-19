### 搭建LVS-NET和 LVS-DR模式

#### LVS-NET模式

流程（需要在不同网段）

Client：   CIP:  192.168.78.6

Director：     VIP：10.3.138.224

​		        DIP：192.168.78.7                                      							

Real Server： RIP：	192.168.78.8     192.168.78.9	

​		         gw：	  192.168.78.7

测试         Client： curl http:// 10.3.138.224

 

#### LVS-DR模式

##### 工作流程

Client：       	CIP： 192.168.78.6

Director：     VIP：10.3.138.200

​		        DIP：10.3.138.176                                      							

Real Server： RIP：	10.3.138.177     10.3.138.178	

​		         VIP：	10.3.138.200     10.3.138.200     Nor-arp


测试         Client： curl http:// 10.3.138.200                               

##### 1、关闭防火墙、iptables、selinux       

##### 2、配置RS 

确保RS nginx可用可以访问到

```
每台RS都需要配置
[root@tianyun ~]# ip addr add dev lo 10.3.138.200/32			     //在lo接口上绑定VIP
[root@tianyun ~]# echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore	     //non-arp
[root@tianyun ~]# echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
```

#####  3、Director分发器配置  

```
[root@tianyun ~]# ip addr add dev eth0 192.168.122.100/32	//配置VIP
[root@tianyun ~]# yum -y install ipvsadm				//RHEL确保LoadBalancer仓库可用
定义LVS分发策略
[root@tianyun ~]# ipvsadm -C                        // 清除内核虚拟服务器表中的所有记录
[root@tianyun ~]# ipvsadm -A -t 10.3.138.200:80 -s wrr 
[root@tianyun ~]# ipvsadm -a -t 10.3.138.200:80 -r 10.3.138.177 -g -w 1	
[root@tianyun ~]# ipvsadm -a -t 10.3.138.200:80 -r 10.3.138.178 -g  -w 2
[root@tianyun ~]# service ipvsadm save   //永久配置
Saving IPVS table to /etc/sysconfig/ipvsadm:               [  OK  ]
[root@tianyun ~]# ipvsadm -Ln //查看
[root@tianyun ~]# ipvsadm -Ln --stats			// 显示统计信息
```

##### 4、测试

client （用户端） 

```
curl http://10.3.138.200
```

​                                