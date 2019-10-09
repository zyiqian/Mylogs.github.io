# SmileAgainZ.github.io
##                        要么出众，要么与众不同

这个仓库主要是对我日常所学习过的东西做一个简单的总结，我基本会每天都往上面写一个日总结，

其内容主要包括一些：项目的部署流程，项目的简介，框架的简介使用等...里面的项目部署基本都是经我部署

成功后上传上去的，只要部署环境跟我的环境一样基本不会错趴。

我对GitHub的使用还不是很到位，就只会上一些纯文本的文件。例如：Markdown，txt之类的

后期将会经常用到这个网站，现阶段还很难看懂上面一些大佬发布的项目。

所以现在我也只能往上面传一点日总结（^_^!）, _我的仓库里并不是所有的代码都是自己手动敲上去的，有的是

直接copy过来，所以有些地方会有细小的差距。

----------------------------------------------------------------------------------
---
2019-10-9

今天主要是学习了Python的一些数据类型及list列表的使用。

Python3 中有六个标准的数据类型：
- Number（数字）
- String（字符串）
- List（列表）
- Tuple（元组）
- Set（集合）
- Dictionary（字典）

Python3 的六个标准数据类型中：

- 不可变数据（3 个）：Number（数字）、String（字符串）、Tuple（元组）；
- 可变数据（3 个）：List（列表）、Dictionary（字典）、Set（集合）

今天主要学习了三种不同数值类型**int、 float、complex; 字符串string; 及列表list**

------------[Python_tow day](https://github.com/Shmil-You/Mylogs.github.io/blob/master/Python_study/2%E3%80%81Python%20%E7%AC%AC%E4%BA%8C%E3%80%81%E4%B8%89%E5%A4%A9.md)-------------
---
---
2019-10-8

今天开始接触python，对python语言的介绍及特点优点等做了详细的讲解。

Python 是一个高层次的结合了解释性、编译性、互动性和面向对象的高级程序设计语言

--------------[Python_study_one_day](https://github.com/Shmil-You/Mylogs.github.io/blob/master/Python_study/Python%E4%BB%8B%E7%BB%8D.md)---------

---
2019-10-2

对12306抢票助手Linux版进行了修改，需要给chromedriver添加x权限

2019-10-1

有一种感动，叫“中国红”，

有一种骄傲，叫“五星红旗”

有一种表白，叫“我爱你中国”

祝祖国70周年快乐。繁荣昌盛，盛世辉煌!!!

2019-9-30

今天学习的内容主要有zabbix的自定义监控和zabbix的自动发现，还有些它的web界面等内容，有点消化不完，心思全放在
修改12306抢票程序这边了，动不动就是满屏红代码，谷歌等下都要嫌弃我了（^_^!） ..._ 主要是问群里的大佬也很少给
解答,回一句不回一句那种，超无奈的。今天又对昨天的12306抢票做了linux版本的文档，这也是一时兴起，觉得在Windows
系统上面跑是要比linux下面耗内存更大些所以特此又做了Linux版的,文档在--MyLog--目录下，有兴趣的小伙伴可以尝试下。

-------------------[12306抢票助手linux版](https://github.com/Shmil-You/Mylogs.github.io/blob/master/My_Logs/12306%E6%8A%A2%E7%A5%A8%E5%8A%A9%E6%89%8BLinux%E7%89%88.md)------------


2019-9-29

今天主要是对zabbix的模板的创建使用、宏的定义和zabbix邮件的报警做了相关学习。

今天绝大部分时间我都用在了分析12306抢票的上面，因为临近十一了，很多好友都抢不到票，所以想尝试下这种方法到底可不可行。

这个只是在Windows上操作，唯一觉得不足的就是那个计划任务不会定义，而且python我也是没怎么了解过。但是基本的语法也没多大差异
只是python的书写格式严格了点

-----------------[12306抢票助手Windows版](https://github.com/Shmil-You/Mylogs.github.io/blob/master/My_Logs/12306%E6%8A%A2%E7%A5%A8%E5%8A%A9%E6%89%8BWindows%E7%89%88.md)-------------------------


2019-9-28

今天是自习的一天，主要是对zabbix添加了两个监控模块-内存使用和CPU使用率，实施实时监控服务器，若使用率超过80%则报警；
还对kali MITMF web渗透的几个插件做了测试：

- ScreenShotter ：使用HTML5 Canvas渲染客户端浏览器的准确屏幕截图
- JSkeylogger ：将Javascript键盘记录程序注入到客户端的网页中
- Upsidedownternet：将图像翻转180度
- imgrand --img-dir：替换html的图片
 
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


