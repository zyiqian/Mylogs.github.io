### Gitlab+Jenkins的部署

#### 一、Gitlab的部署

##### 1、环境介绍

```
1.系统版本：CentOS7.3
2.Gitlab版本：gitlab-ce 9.1.4
3.初始化系统环境
4.关闭防火墙、selinux、iptables
```

##### 2、部署gitlab

```
安装gitlab依赖包
[root@localhost ~]# yum install -y curl openssh-server openssh-clients postfix cronie policycoreutils-python
开启postfix，并设置开机自启
[root@localhost ~]# systemctl start postfix;systemctl enable postfix

# gitlab-ce 10.x.x以后的版本需要依赖policycoreutils-python
下载Gitlab包
http://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7

rpm -ivh gitlab-----

出现个狐狸图标则安装成功

查看Gitlab版本
[root@localhost src]# head -1 /opt/gitlab/version-manifest.txt
gitlab-ce 12.2.5

Gitlab 配置文登录链接
[root@localhost ~]# vim /etc/gitlab/gitlab.rb
# 没有域名，可以设置为本机IP地址
external_url 'http://192.168.78.11'  #绑定监听的域名或IP
```

##### 3、初始化gitlab

```
 [root@localhost ~]# gitlab-ctl reconfigure   
```

##### 4、启动gitlab

```
启动前先看下防火墙Firewalld selinux iptables 是否都关闭了

[root@vm1 ~]# gitlab-ctl start
ok：
ok:
ok:
.....
[root@vm1 ~]# lsof -i:80  
如果Gitm没有配置的先配置下Git
[root@gitlab ~]# git config --global user.name "lion"  #配置git使用用户
[root@gitlab ~]# git config --global user.email "hackerlion@aliyun.com"  #配置git使用邮箱
[root@gitlab ~]# git config --global color.ui true  #语法高亮
[root@gitlab ~]# git config --list # 查看全局配置
user.name=lion
user.mail=hackerlion@aliyun.com
color.ui=true
```

##### 5、Gitlab 设置 HTTPS 方式

```
如果想要以上的 https 方式正常生效使用，则需要把 letsencrypt 自动生成证书的配置打开，这样在执行重
新让配置生效命令 (gitlab-ctl reconfigure) 的时候会自动给域名生成免费的证书并自动在 gitlab 自带的
 nginx 中加上相关的跳转配置，都是全自动的，非常方便。
letsencrypt['enable'] = true 
letsencrypt['contact_emails'] = ['caryyu@qq.com']     # 这应该是一组要添加为联系人的电子邮件地址
```

##### 6、基本命令

```
gitlab-ctl start                        # 启动所有 gitlab 组件；
gitlab-ctl stop                         # 停止所有 gitlab 组件；
gitlab-ctl restart                      # 重启所有 gitlab 组件；
gitlab-ctl status                       # 查看服务状态；
gitlab-ctl reconfigure                  # 启动服务；
vim /etc/gitlab/gitlab.rb               # 修改默认的配置文件；
gitlab-ctl tail                         # 查看日志；
```

##### 7、测试

**gitlab的使用**
**在浏览器中输入本地ip  http://192.168.78.11/ ，然后 change password:  ，并使用root用户登录 即可 (后续动作根据提示操作)**

##### 8、登录gitlab

######      1)、设置密码

  ![](https://i.loli.net/2019/09/20/T7kaxdrmWZ5phEc.jpg)

######     2）、登录

![](https://i.loli.net/2019/09/20/FxlBvEhOMdqiTz2.jpg)

###### 3）创建项目一个test01项目

![](https://i.loli.net/2019/09/20/QJU6vT3NBskLAp4.jpg)

###### 4）、创建完成后会提示没有添加ssh密钥

![](https://i.loli.net/2019/09/20/AS5Hkxh4Rf1GNBL.jpg)

###### 5）、 在服务器上创建ssh密钥 使用ssh-ketgen 命令

```

```

###### 6）、将密钥添加到web界面的用户中

![](https://i.loli.net/2019/09/20/OFxPTlzSqGIheop.jpg)

![](https://i.loli.net/2019/09/20/TfwCMKylrJbkWco.jpg)

###### 7）、复制链接

![](https://i.loli.net/2019/09/20/SQPGwKX1qW6yktE.jpg)

######  

###### 8）、从远程仓库克隆到本地

```
[root@gitlab ~]# git clone git@lion:root/test01.git
正克隆到 'Test1'...
[root@gitlab ~]# ls 
test01
[root@gitlab ~]# cd test01
创建文件并推到远端git仓库
[root@gitlab test01]# echo "test01" >> README
[root@gitlab test01]# git add .
[root@gitlab test01]# git commit -m 'test01 first commit'
[root@gitlab test01]# git push -f origin master
分支 master 设置为跟踪来自 origin 的远程分支 master。
```

推送完成后能够在web界面中查看,test01里面有添加内容

##### 9、gitlab 命令行修改密码

```
gitlab-rails console production
irb(main):001:0> user = User.where(id: 1).first     # id为1的是超级管理员
irb(main):002:0>user.password = 'yourpassword'      # 密码必须至少8个字符
irb(main):003:0>user.save!                          # 如没有问题 返回true
exit 												# 退出
```

#### 二、Jenkins的部署

##### 1、Jenkins概念

　　Jenkins是一个功能强大的应用程序，允许**持续集成和持续交付项目**，无论用的是什么平台。这是一个免费的源代码，可以处理任何类型的构建或持续集成。集成Jenkins可以用于一些测试和部署技术。Jenkins是一种软件允许持续集成。

##### 2、Jenkins目的

① 持续、自动地构建/测试软件项目。

② 监控软件开放流程，快速问题定位及处理，提示开放效率。

##### 3、特性

① 开源的java语言开发持续集成工具，支持CI，CD。

② 易于安装部署配置：可通过yum安装,或下载war包以及通过docker容器等快速实现安装部署，可方便web界面配置管理。

③ 消息通知及测试报告：集成RSS/E-mail通过RSS发布构建结果或当构建完成时通过e-mail通知，生成JUnit/TestNG测试报告。

④ 分布式构建：支持Jenkins能够让多台计算机一起构建/测试。

⑤ 文件识别:Jenkins能够跟踪哪次构建生成哪些jar，哪次构建使用哪个版本的jar等。

⑥ 丰富的插件支持:支持扩展插件，你可以开发适合自己团队使用的工具，如git，svn，maven，docker等。

##### 4、产品发布流程

产品设计成型 -> 开发人员开发代码 -> 测试人员测试功能 -> 运维人员发布上线

持续集成（Continuous integration，简称CI）

持续交付（Continuous delivery）

持续部署（continuous deployment）

##### 5、安装Jenkins   方式(1) 未用过

1）、部署jdk环境

```
[root@lion test01]# cat /etc/profile.d/java_8.sh 
export JAVA_HOME=/usr/local/java_8
export PATH=$JAVA_HOME/bin:$PATH
export TOMCAT_HOME=/usr/local/tomcat_7
```

2）、安装Jenkins

```
[root@jenkins ~]# cd /etc/yum.repos.d/
[root@jenkins yum.repos.d]# wget http://pkg.jenkins.io/redhat/jenkins.repo
[root@jenkins ~]# rpm --import http://pkg.jenkins.io/redhat/jenkins.io.key
[root@jenkins ~]# yum install -y jenkins
修改配置文件
[root@jenkins ~]# rpm -ql jenkins
/etc/init.d/jenkins
/etc/logrotate.d/jenkins
/etc/sysconfig/jenkins
/usr/lib/jenkins
/usr/lib/jenkins/jenkins.war
/usr/sbin/rcjenkins
/var/cache/jenkins
/var/lib/jenkins
/var/log/jenkins
创建Jenkins主目录
[root@jenkins ~]# mkdir /data/jenkins -p
[root@jenkins ~]# chown -R jenkins.jenkins /data/jenkins/
修改配置文件
[root@jenkins ~]# vim /etc/sysconfig/jenkins
JENKINS_HOME="/data/jenkins"
JENKINS_USER="jenkins"
JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Xms256m -Xmx512m -XX:MaxNewSize=256m -XX:Maxize=256m"    //-Xms256m -Xmx512m -XX:MaxNewSize=256m -XX:Maxize=256m可以不添加
JENKINS_PORT="8000" 
开启Jenkins服务
[root@jenkins bin]# systemctl start jenkins
5）网页打开配置
打开192.168.78.13:8000/
```

##### 5、安装Jenkins  方式(2)

1、部署jdk和Tomcat环境

```
[root@lion test01]# cat /etc/profile.d/java_8.sh 
export JAVA_HOME=/usr/local/java_8
export PATH=$JAVA_HOME/bin:$PATH
export TOMCAT_HOME=/usr/local/tomcat_7
```

2、部署Tomcat

```
安装Tomcat步骤省略
修改Tomcat默认端口；因为会跟gitlab里面的进程冲突
[root@lion ~]# vim /usr/local/tomcat_7/conf/server.xml 

/%  s/8080/8081/  //把8080端口改成8081
```

3、直接上传Jenkins.war包

```
先把Tomcat目录webapps中的文件删除
[root@lion ~]# rm -rf /usr/local/tomcat_7/webapps/*
然后上传Jenkins到webapps目录中
解压
[root@lion ~]# cd /usr/local/tomcat_7/webapps/
[root@lion webapps]# unzip jenkins.war -d jenkins
启动Tomcat服务
[root@lion ~]# cd /usr/local/tomcat_7/
[root@lion tomcat_7]# ./bin/startup.sh 
```

4、启动

浏览器访问http://192.168.78.13:8081/jenkins/  

![](https://i.loli.net/2019/09/20/imbjZqSWG5czkfD.jpg)

在Jenkins服务器上查询管理员密码 然后复制粘贴上去

 cat /data/jenkins/secrets/initialAdminPassword

**② 选择需要安装的插件**

选择默认推荐即可，会安装通用的社区插件，剩下的可以在使用的时候再进行安装。

3 开始安装，由于网络原因，有一些插件会安装失败。如果一直安装失败则跳过，后期加上

4 设置Admin用户和密码

5 安装完成

6 登录Jenkins

##### 6、安装完后，简单的配置

1) 、系统配置

添加JDK工具

点击新增---> 取消自动安装 ---->然后查询Jenkins服务器上JDK的路径，填写JAVA_HOME --->  保存即可

2）、插件管理

这里有可更新、可选未安装插件、已安装插件；可以通过过滤快速查找

![](https://i.loli.net/2019/09/20/rSK3izcw4WyVGj1.jpg)



##### 7、开始一个简单的项目

1）、新建任务

输入一个项目名称，构建一个自由风格的软件项目

![](https://i.loli.net/2019/09/20/XUdsKFjJ1S8IQLt.jpg)

2）、配置项目

1）General

描述：test    自己随意添加；

显示名称：along  是Jenkins看到的项目名称；

其他更多的用法，后续再讲；

![](https://i.loli.net/2019/09/20/BSsaUwkFrM3KZv1.jpg)

（2）源码管理（就是拉取代码的地方，可以选择git或SVN）

① 选择git，输入gitlab项目地址   上面部署好的那个 git@lion:root/test01.git

![](https://i.loli.net/2019/09/20/oiE8ZIDJzAwagdl.jpg)



```
获取私钥
[root@lion ~]# cat .ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
.....
-----END RSA PRIVATE KEY-----

```

这个功能主要是 在host2机器上启动nginx  这时候要更新版本 则直接可以修改gitlab库中的index文件 然后Jenkins上面构建一个工作  这时host2上面的机器就直接更新了  要是想回到上个版本 则可以在Jenkins上点回上个版本 ，就不用再重新上线

![](https://i.loli.net/2019/09/20/hVA7JctGUFpuoOK.jpg)

这里需要把192.168.78.13和192.168.78.6两个机器做个免密登录

```
  [root@lion ~]# ssh-copy-id -i 192.168.78.6
  [root@lion ~]# ls /root/.jenkins/workspace/project-first/index.html  
```

##### 8、构建项目

1）点击项目damo，立即构建

![](https://i.loli.net/2019/09/20/FjNhcoB3IznqmPl.jpg)

2）可以点击#1，查询详细的控制台输出信息；

![1568980209576](C:\Users\MRZHON~1\AppData\Local\Temp\1568980209576.png)

到这里 gitlab+Jenkins的基本部署就完成了