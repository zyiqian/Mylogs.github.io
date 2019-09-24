### Jenkins+Maven+Gitlab+Tomcat 自动化构建打包、部署

**Jenkins功能包括：**

1、持续的软件版本发布/测试项目。

2、监控外部调用执行的工作。

**maven简介**

[Maven](https://baike.baidu.com/item/Maven)项目对象模型(POM)，可以通过一小段描述信息来管理项目的构建，报告和文档的[项目管理工具](https://baike.baidu.com/item/%E9%A1%B9%E7%9B%AE%E7%AE%A1%E7%90%86%E5%B7%A5%E5%85%B7/6854630)软件。 

Maven 是一个项目管理工具，可以对 Java 项目进行构建、依赖管理。

Maven 也可被用于构建和管理各种项目

#### **1、环境需求**

本帖针对的是Linux环境，Windows或其他系统也可借鉴。具体只讲述Jenkins配置以及整个流程的实现。

- 1.JDK（或JRE）及Java环境变量配置，我用的是JDK1.8.0_144，网上帖子也很多，不赘述。
- 2.Jenkins 持续集成和持续交付项目。
- 3.现有项目及gitlab（SVN或本地路径也行）地址。
- 4.maven工具及环境变量配置，用于构建和管理任何基于Java的项目。
- 5.下载解压Tomcat，我用的是Tomcat8。

#### **2、环境准备**

##### **1、安装服务**

（1）安装JDK、Jenkins和gitlab

JDK yum安装和编译安装都可以；

gitlab 安装详见：gitlab 部署；

tomcat 安装详见：tomcat 服务部署

（2）mave安装

1、下载 maven 包

http://mirrors.cnnic.cn/apache/maven 选择自己需要的maven版本

```
下载maven包 
cd /usr/local/src/
wget https://mirrors.cnnic.cn/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz

解压
tar -zxvf apache-maven-3.5.4-bin.tar.gz -C /usr/local/
cd ..
mv apache-maven-3.5.4 maven-3.5.4
```

##### **2、配置环境变量**

（1）配置全局环境变量

```
1、需要用到java环境（配置java环境略）
2、配置maven环境
vim /etc/profile.d/maven.sh
export MAVEN_HOME=/data/jenkins_tools/maven-3.5.4
export PATH=${MAVEN_HOME}/bin:$PATH 
3、测试
java -version
java version "1.8.0_144"
.....
 mvn -version
 Apache Maven 3.5.4 (1edded0.....
```

#### **3、Jenkins工具、环境、插件配置**

**2、配置全局变量**

系统管理--->全局工具配置

修改maven默认settings.xml文件，配置git、jdk、maven工具后保存（不要勾选自动安装）。

![](https://i.loli.net/2019/09/24/MQipFKJ9segaSNd.jpg)



JDK、和  Git

![](https://i.loli.net/2019/09/24/QmdrEMp3Y6J2HON.jpg)



maven

![](https://i.loli.net/2019/09/24/hyxamSdWPMDFT6X.jpg)



**2、配置全局变量**

系统管理--->系统设置--->全局属性

![](https://i.loli.net/2019/09/24/BKdk9sg83ESqpfY.jpg)



**3、安装2个插件**

系统管理--->插件管理

（1）Maven Integration plugin 安装此插件才能构建maven项目

​     如果查找Maven Integration

![](https://i.loli.net/2019/09/24/nXKbTjFqNEQUChD.jpg)

（2）Deploy to container Plugin 安装此插件，才能将打好的包部署到tomcat上

![](https://i.loli.net/2019/09/24/Oi4eyB9Avm5FnDc.jpg)



#### **4、创建一个Maven工程**

**1、构建maven项目**

![](https://i.loli.net/2019/09/24/gmqhGyPJiwxLC6I.jpg)



**2、源码管理**

填写git地址信息，添加认证凭据，详见[Jenkins持续集成01—Jenkins服务搭建和部署](https://www.cnblogs.com/along21/p/9724036.html)

![](https://i.loli.net/2019/09/24/of6AxWZu8VMYDpt.jpg)



**3、build打包构建**

① Root POM：指定pom.xml的文件路径（这里是相对路径）

② Goals and options：mvn的选项，构件参数

![](https://i.loli.net/2019/09/24/p7lmxBUg5f4vwP3.jpg)

4、到这里就配置完成了，点击构建从控制台查看输出信息即可

#### **5、构建项目**

![](https://i.loli.net/2019/09/24/4WHCmNIGk5dSJ9P.jpg)

**查看控制台输出**

点击#1--->控制台输出；就能看到执行的整个过程

![](https://i.loli.net/2019/09/24/VQN45OwMbJBKaYo.jpg)

#### 6、jenkins + gitlab + nginx 自动部署

**做这个实验需要用到一下插件**

- Generic Webhook Trigger 

- Gitlab API 

- GitLab 

  这三个插件

**1、构建新的项目**

![](https://i.loli.net/2019/05/15/5cdc2846c79b295918.jpg)

**构建自由风格项目**

![](https://i.loli.net/2019/05/16/5cdcfef5602b471584.jpg)

![](https://i.loli.net/2019/05/16/5cdcff4b97a8b18914.jpg)



**源码管理**

![](https://i.loli.net/2019/05/16/5cdcffaf04c8224886.jpg)



**git 添加认证**

![](https://i.loli.net/2019/05/16/5cdd005d445ec35626.jpg)



**构建触发器**

![](https://i.loli.net/2019/05/16/5cdd00b44185158313.jpg)

![](https://i.loli.net/2019/05/16/5cdd018676c1332830.jpg)



**要记录下上边的URL和认证密钥**

切换到gitlab，找到对应的git库  点击setting --> Integrations ,填写以下内容，然后下拉点击 Add webhook

![](https://i.loli.net/2019/05/16/5cdd02254e31b80243.jpg)

可能会报下列错误，这是新版本gitlab 的保护功能，禁止内网跳转，解决方法如下：

![](https://i.loli.net/2019/05/16/5cdd030d0443c72410.jpg)

![](https://i.loli.net/2019/09/24/uWaXsjNPDMQkoyK.jpg)

![](https://i.loli.net/2019/05/16/5cdd03a32ee5252484.jpg)

重复上列步骤添加 webhook。即可成功。



#### 7、Jenkins与Docker的自动化CI/CD流水线实践

Pipeline 有诸多优点，例如：

- 项目发布可视化，明确阶段，方便处理问题
- 一个Jenkins File文件管理整个项目生命周期
- Jenkins File可以放到项目代码中版本管理

**Jenkins管理界面**

![img](assets/1352872-20180728204341141-291722191.png)



**操作实例：Pipeline的简单使用**

![img](assets/1352872-20180728204527837-451304456.png)





![img](assets/1352872-20180728204554081-1369553982.png)

![img](assets/1352872-20180728204657389-347280504.png)



**这里是比较重要的核心，构建流程**

```
pipeline {
    agent any
    stages {
        stage('Git') {
            steps {
                sh 'echo helloworld'
            }
        }
        stage('Ansible Git pull') {
            steps {
                sh 'sleep 1'
            }
        }
    }
}

复制到下面的输入框中
```



![img](assets/1352872-20180728210429075-601796351.png)

**点击保存之后，立即构建**

![img](assets/1352872-20180728210527044-1222721532.png)

 

pipeline有诸多优点：

- 项目发布可视化，明确阶段，方便处理问题
- 一个Jenkins File 文件管理整个项目生命周期
- Jenkins File 可以放到项目代码中版本管理

#### 小结：

Jenkins与kubernetes搭建CI/CD流水线有诸多好处：

- Jenkins高可用
- 自动伸缩
- 环境隔离
- 易维护







