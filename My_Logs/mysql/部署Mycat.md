#### 部署Mycat

##### 主要步骤：

​	1、配置java环境

​	2、下载安装mycat 

​	3、修改server.xml (虚拟用户、密码、虚拟库、   注销user)

​	4、修改schema.xml  (配置)

​	5、授权在schema 配置的用户能访问 真实库

​	6、启动服务  /usr/local/mycat/bin/mycat  start   可选restart stop status..

​	7、如果有报错则查看日志

​	cat /usr/local/mycat/logs/wrapper.log

  	8、登录  mysql -u虚拟用户  -p虚拟库密码  -hmycatIP地址 -P8066

##### 1、配置java环境

```
上传jdk安装包
解压
[root@mycat ~]# tar -xf jdk-8u211-linux-x64.tar.gz   -C  /usr/local/
[root@mycat ~]# mv /usr/local/jdk1.8.0_181/ /usr/local/java
配置环境变量
[root@mycat ~]# vim /etc/profile.d/java.sh
export JAVA_HOME=/usr/local/java
export PATH=$JAVA_HOME/bin:$PATH

使环境变量生效
[root@mycat ~]# source /etc/profile.d/java.sh
java -version
```

##### 2、下载安装mycat 

```
下载
[root@mycat ~]# wget http://dl.mycat.io/1.6.5/Mycat-server-1.6.5-release-20180122220033-linux.tar.gz
解压
[root@mycat ~]# tar xf Mycat-server-1.6.5-release-20180122220033-linux.tar.gz -C /usr/local/

```

认识配置文件

MyCAT 目前主要通过配置文件的方式来定义逻辑库和相关配置:

/usr/local/mycat/conf/server.xml             定义用户以及系统相关变量，如端口等。其中用户信息是前端应用程序连接 mycat 的用户信息。

/usr/local/mycat/conf/schema.xml       定义逻辑库，表、分片节点等内容。

##### 3、server.xml

```
修改server.xml
vim /usr/local/mycat/conf/server.xml
 <user name="lion" defaultAccount="true">              //虚拟用户（这个名字需要和后面 schema.xml 文件中配置的一致。）
                <property name="password">1</property>    //虚拟用户密码
                <property name="schemas">mycat_db</property>    //虚拟库
```

##### 4、schema.xml

以下是组合为完整的配置文件，适用于一主一从的架构

```
<?xml version="1.0"?>
<!DOCTYPE mycat:schema SYSTEM "schema.dtd">
<mycat:schema xmlns:mycat="http://io.mycat/">

  <schema name="mycat_db"   <!-- 虚拟逻辑库名称,与server.xml的一致-->
        checkSQLschema="false"   <!-- 不检查-->
        sqlMaxLimit="100"      <!-- 最大连接数-->
        dataNode="lion">     <!--  数据节点名称-->
   <!--这里定义的是分库分表的信息-->     
   </schema>
   

  <dataNode name="lion"    <!--此数据节点的名称-->  
          dataHost="localhost1"    <!--主机组 -->
          database="mycat_test" />   <!--真实的数据库名称 -->
        
        
  <dataHost name="localhost1"       <!--主机组 -->
            maxCon="1000" minCon="10"     <!-- 连接-->
            balance="0"                   <!-- 负载均衡-->
            writeType="0"                    <!--写模式配置 -->
            dbType="mysql" dbDriver="native"           <!--数据库配置 -->
            switchType="1"  slaveThreshold="100">      
            
            
   <heartbeat>select user()</heartbeat>    <!--健康检查-->
       <!-- can have multi write hosts -->
   <writeHost host="hostM1" url="192.168.78.130:3306"    <!--读配置-->主
              user="root"  password="1">
      <!-- can have multi read hosts -->
      <readHost host="hostS2" url="192.168.78.6:3306"  <!--写配置-->从
                user="root" password="1" />
     </writeHost>
   </dataHost>
</mycat:schema>
```



##### 5、授权在schemal 配置的用户能访问 真实库，在真实的 master 数据库上给用户授权

```
mysql> grant all on mycat_test.* to root@'%' identified by '1';   //主服务器上
mysql> flush privileges;
```

##### 6、启动服务  /usr/local/mycat/bin/mycat  start   可选restart stop status.. 

```
[root@mycat ~]# /usr/local/mycat/bin/mycat  start

支持一下参数
start | restart |stop | status
```

##### 7、如果有报错则查看日志

​	cat /usr/local/mycat/logs/wrapper.log

##### 8、测试

在 mycat 的机器上测试用户权限有效性

测试是否能正常登录上 主服务器

mysql -uroot -p'1' -h192.168.78.130

继续测试是否能登录上从服务器

mysql -uroot -p'123' -h192.168.78.6

##### 9、登录  mysql -u虚拟用户  -p虚拟库密码  -hmycatIP地址 -P8066

**192.168.78.130 是mycat的主机地址**

注意端口号是 8066

```
[root@mysqlclient ~]# mysql -ulion -p1 -h192.168.78.131 -P8066

MySQL [(none)]> show databases;
+----------+
| DATABASE |
+----------+
| mycat_db |
+----------+
1 row in set (0.00 sec)
```

##### 继续测试读写分离策略

使用  `mysql` 客户端工具使用  `mycat` 的账户和密码登录 `mycat` ,
 之后执行 `select` 语句。

之后查询 `mycat` 主机上 `mycat` 安装目录下的 `logs/mycat.log` 日志。

在日志重搜索查询的语句或者查询 从库的 ip 地址，应该能搜索到