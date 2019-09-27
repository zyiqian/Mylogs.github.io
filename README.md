# SmileAgainZ.github.io
##                        要么出众，要么与众不同

这个仓库主要是对我日常所学习过的东西做一个简单的总结，除了放假外，我基本会每天都往上面写一个日总结，

其内容主要包括一些：项目的部署流程，项目的简介，框架的简介使用等...里面的项目部署基本都是经我部署

成功后上传上去的，只要部署环境跟我的环境一样基本不会错趴。

我对GitHub的使用还不是很到位，就只会上一些纯文本的文件。例如：Markdown，txt之类的

后期将会经常用到这个网站，现阶段还很难看懂上面一些大佬发布的项目。

所以现在我也只能往上面传一点日总结（^_^!）,我的仓库里并不是所有的代码都是自己手动敲上去的，有的是

直接copy过来，所以有些地方会有细小的差距。

----------------------------------------------------------------------------------
2019-9-27

由于昨天已经安装部署好zabbix了，所以今天主要是在zabbix GUI 上面做了些相关操作，定义动作，定义报警媒介
，还有定义一些图形等操作；
定义动作的时候，我们还需要在虚拟机上进行两项操作：

- 一是修改sudo配置文件使zabbix用户能够临时拥有管理员权限；
- 二是修改zabbix配置文件使其允许接收远程命令

[root@node1 ~]# visudo          #相当于“vim /etc/sudoers”
    ## Allow root to run any commands anywhere
    root    ALL=(ALL)   ALL
    zabbix    ALL=(ALL)   NOPASSWD: ALL     #添加的一行，表示不需要输入密码

[root@node1 ~]# vim /etc/zabbix/zabbix_agentd.conf
    EnableRemoteCommands=1          #允许接收远程命令
    LogRemoteCommands=1             #把接收的远程命令记入日志

[root@node1 ~]# systemctl restart zabbix-agent.service




2019-9-26

今天又接触到了一个新的学习内容---Zabbix ,zabbix是一个基于WEB界面的提供分布式系统监视以及网络监视功能的企业级的开源解决方案
zabbix能监视各种网络参数，保证服务器系统的安全运营；并提供灵活的通知机制以让系统管理员快速定位/解决存在的各种问题。
zabbix由2部分构成，zabbix server与可选组件zabbix agent。

zabbix agent需要安装在被监视的目标服务器上，它主要完成对硬件信息或与操作系统有关的内存，CPU等信息的收集。

zabbix server可以单独监视远程服务器的服务状态；同时也可以与zabbix agent配合，可以轮询zabbix agent主动接收监视数据（agent方式），同时还可被动接收zabbix agent发送的数据（trapping方式）。

----zabbix的简单安装部署------


2019-9-25

今天主要是对Jenkins的参数构建及pipeline流水线代码发布做了个简单的部署

通过jenkins pipeline + gitlab 方式进行 配置文件治理

  1、版本管理方便、回退方便、完全可以自动化发布

  2、需要知晓整个构建原理、以及根据实际业务需要编写 相关脚本、需要知识相对负载。

---->代码发布_参数化构建&pipeline构建----

2019-9-24

今天主要是学习了Jenkins+maven+gitlab+Tomcat自动化构建打包、部署，还有一个流水线pipeline的实践

----Jenkins+Maven+Gitlab+Tomcat 自动化构建打包、部署----

2019-9-23

今天由于学校那边电路检修，所以停课一天，也就是又是休息的一天，今天主要是玩了下kali，arp域网攻击，域网图片嗅探，使用Aircrack破解wifi密码（三次握手四次挥手原理抓去握手包），MITMF的使用(实现替换图片)；

-----kali的一些骚操作--------


2019-9-22

今天是休息的一天，跟舍友一起出去白云山一日行，可惜的是去到那边已是傍晚，没有来得及爬上顶端领略山顶的风光，这是最可惜的，后面就随便去了个小景点，装了点山泉水喝，还挺清甜的，回去的时候都已经是要打手机电筒回了。一个来回也就两个小时左右。没时间登顶是怪可惜的。所以今天也没学到什么东西，就只是装好了个Python，主要是想用来做12306抢票的。由于这个工程有点大，加上一天的劳累也没捣鼓出点什么东西来。(-_-!)

2019-9-21

今天使用前天的文档安装了编译安装了Git,安装的是Git最新版2.23.0,发现安装不用makefile编译，可以直接make && make install

更新修改 My_Los-->  Git及GitHub的使用.md

更新修改 My_Los-->  Gitlab+Jenkins的部署
 
对仓库进行了整理一番。


2019-9-20 

今天主要是学习了下gitlab和Jenkins的使用

-----Gitlab+Jenkins的部署------


2019-9-19

今天让我对身体素质及健康有了深刻的理解，身体才是革命的本钱嘛，只有把身体搞好了才能更有精力去接触别的

东西，所以今天花了一点时间把我之前的时间表重构了下。

前两天的学习ELK+filebeat+kafka的部署流程我最后那个kafka还没来做成功

所以那个ELK+filebeat+kafka的部署kafka的那个部署没加上去；由于课程也比较紧，只能先落下。后面有时间再更

新；

今天我们主要学习了Git命令的详解和GitHub、gitlab的相关使用，差别不是很大，会用一个另一个基本也会用,流程

我也上传到我的日志里面了----Git及GitHub的使用----


. . . . 以下省略一个月日志，这个格式是最近今天才开始这么写的^_^


