# 参数化构建代码发布

## 整体思路

![](https://i.loli.net/2019/09/24/ukgGztSm59Px8wW.jpg)

## 依赖环境及工具

- Git
- Centos7及以上
- Gitlab
- Jenkins
- shell
- ansible

## 安装基础环境

### Gitlab install

[gitlab install](https://www.liuwq.com/views/%E8%87%AA%E5%8A%A8%E5%8C%96%E5%B7%A5%E5%85%B7/gitlab_install.html)

###  jenkins install

[jenkins install](https://www.liuwq.com/views/%E8%87%AA%E5%8A%A8%E5%8C%96%E5%B7%A5%E5%85%B7/jenkins.html)



Ansible install

yum安装

```
yum install -y epel-release
yum install -y ansible
```

####  配置文件

```
/etc/ansible/ansible.cfg ###主要为ansible一些基本配置
/etc/ansible/hosts   ## ansible groups hosts 配置
```



### shell

- control.sh 控制脚本调用ansible

```
#!/bin/bash
## version:1.2
## date: 2018-04-29  



# ENV

PROJECT_NAME=$1
GITTYPE=$2
SERVICE=$3
HARDID= $4

# ansible hosts address
ANSIBLE_HOSTS_ADDR=/cron/base_conf/ansible_conf/ansible/hosts-xxx

#ansible command
/usr/bin/ansible -i $ANSIBLE_HOSTS_ADDR $PROJECT_NAME -m shell -a "/bin/bash /cron/xxx-scripts/update_code.sh $PROJECT_NAME $GITTYPE $SERVICE $HARDID"

```

- update code shell

```
#!/bin/bash
## version:1.2
## date: 2018-11-29   update


PROJECT=$1
PROJECT_TYPE=pro

# 判断环境
if [[ ${PROJECT:0-2} == 'hd' || ${PROJECT:0-2} == 'Hd' || ${PROJECT:0-2} == 'hD' || ${PROJECT:0-2} == 'HD' ]];then
    PROJECT_TYPE='hd'
    PROJECT=${PROJECT%${PROJECT:0-2}*}
elif [[ ${PROJECT:0-2} == 'cc' || ${PROJECT:0-2} == 'Cc' || ${PROJECT:0-2} == 'cC' || ${PROJECT:0-2} == 'CC' ]];then
    PROJECT_TYPE='cc'
    PROJECT=${PROJECT%${PROJECT:0-2}*}
fi

# 定义变量

PROJECT_NAME=$PROJECT
GIT_SSH_ADDR=git@gitlab.xxxxx:ERP/$PROJECT_NAME.git ### gitlab库
FILE_OWNER=carry
SCIRPTS_DIR=/cron/erp-scripts

if [ -d "/data/$PROJECT_NAME" ];then
        CODE_DIR=/data
else
        CODE_DIR=/app
fi


START_LOG=/tmp/$PROJECT\_version_iterate.log

rm -f $START_LOG
touch $START_LOG


# 检查项目名
if [  -z  "$1" ];then
    echo "please input project name!!!" >>  $START_LOG 2>&1
    exit 1
fi

#工程赋权
function chownpj()
{
        cd $CODE_DIR/$PROJECT_NAME
        for i in $(ls |grep -v 'upload')
        do
               chown -R $FILE_OWNER.$FILE_OWBER $i >>  $START_LOG 2>&1
        done

}


##拷贝函数，视情况进行相应设计。
function copy_file()
{
#appMobile
#	cp /bak/$PROJECT/$PROJECT--$CUDATE/ini/{mongoConfig.xml,config.properties,task.xml}  $CODE_DIR/$PROJECT_NAME/ini/ >>  $START_LOG 2>&1
#appSyncBaseMsg
#	cp /bak/$PROJECT/$PROJECT--$CUDATE/ini/{mongoConfig.xml,config.properties}  $CODE_DIR/$PROJECT_NAME/ini/ >>  $START_LOG 2>&1
#appSyncBiz
	cp /bak/$PROJECT/$PROJECT--$CUDATE/ini/{jdbc.properties,config-timer-jdbc.properties,mongoConfig.xml,appTaskStartConfig.xml,task.xml,config.properties,appMainConfig.xml}  $CODE_DIR/$PROJECT_NAME/ini/ >>  $START_LOG 2>&1
#       cp /bak/$PROJECT/$PROJECT--$CUDATE/WEB-INF/web.xml  $CODE_DIR/$PROJECT_NAME/WEB-INF/  >>  $START_LOG 2>&1
#webMobile2/webMobile3/webErp2/webFile
#       cp /bak/$PROJECT/$PROJECT--$CUDATE/WEB-INF/classes/{config.properties,mongoConfig.xml,redis.properties}  $CODE_DIR/$PROJECT_NAME/WEB-INF/classes  >>  $START_LOG 2>&1
#webErpReport
#	cp /bak/$PROJECT/$PROJECT--$CUDATE/WEB-INF/classes/{config.properties,mongoConfig.xml,redis.properties}  $CODE_DIR/$PROJECT_NAME/WEB-INF/classes  >>  $START_LOG 2>&1
#	cp /bak/$PROJECT/$PROJECT--$CUDATE/WEB-INF/web.xml  $CODE_DIR/$PROJECT_NAME/WEB-INF/  >>  $START_LOG 2>&1
}

function code_clone()
{
	chown -R $FILE_OWNER.$FILE_OWBER $START_LOG
	runuser -l $FILE_OWNER -c "/bin/bash $SCIRPTS_DIR/newrestart.sh stop $PROJECT"  >>  $START_LOG 2>&1

	if [ -d "/data/$PROJECT_NAME" ];then
	        cd /data/$PROJECT_NAME
		GITREMOTE=`git remote -v 2>/dev/null|grep $PROJECT_NAME`  >>  $START_LOG 2>&1
		if [[ -z $GITREMOTE ]];then
			cd /data
			mkdir -pv /bak/$PROJECT
			CUDATE=`date +"%Y-%m-%d-%H-%M"`
			mv /data/$PROJECT_NAME /bak/$PROJECT/$PROJECT--$CUDATE  >>  $START_LOG 2>&1
			git clone $GIT_SSH_ADDR >>  $START_LOG 2>&1
			copy_file
		else
			cd /data/$PROJECT_NAME
			git reset --hard origin/master
			git pull -f >>  $START_LOG 2>&1
		fi
	elif [ -f /app/$PROJECT_NAME/bin/server.sh ];then
		cd /app/$PROJECT_NAME
                GITREMOTE=`git remote -v 2>/dev/null|grep $PROJECT_NAME`  >>  $START_LOG 2>&1
                if [[ -z $GITREMOTE ]];then
                        cd /app
                        mkdir -pv /bak/$PROJECT
                        CUDATE=`date +"%Y-%m-%d-%H-%M"`
                        mv /app/$PROJECT_NAME /bak/$PROJECT/$PROJECT--$CUDATE  >>  $START_LOG 2>&1
                        git clone $GIT_SSH_ADDR >>  $START_LOG 2>&1
                        copy_file
                else
                        cd /app/$PROJECT_NAME
			git reset --hard origin/master
                        git pull -f >>  $START_LOG 2>&1
                fi
	else
		cd /data
	        git clone $GIT_SSH_ADDR > /dev/null 2>&1
	fi
	chownpj
}
function reback_one()
{
	cd $CODE_DIR/$PROJECT_NAME
	git reset --hard HEAD^ >>  $START_LOG 2>&1
	chownpj
}
function reback_two()
{
	cd $CODE_DIR/$PROJECT_NAME
        git reset --hard HEAD^^  >>  $START_LOG 2>&1
	chownpj
}
function reback_hard() {
  cd $CODE_DIR/$PROJECT_NAME
        git reset --hard $4 >>  $START_LOG 2>&1
  chownpj
}
## $2 git command 
case "$2" in
pull)
code_clone
;;
reback_one)
reback_one
;;
reback_two)
reback_two
;;
reback_hard)
reback_hard
;;
none)
;;
*)
printf 'Usage: %s {pull|reback_one|reback_two|reback_hard}\n' "$"
exit 1
;;
esac

## restart service
chown -R $FILE_OWNER.$FILE_OWBER $START_LOG
runuser -l $FILE_OWNER -c "/bin/bash $SCIRPTS_DIR/newrestart.sh $3 $PROJECT" >>  $START_LOG 2>&1
if [[ $? -eq 0 ]]; then
   PROJECT_PID=`ps -ef | grep $PROJECT | grep java|awk '{print $2}'`
   if [[ ! -z $PROJECT_PID  ]];then
     echo "@@@@@@@@  service $PROJECT $PROJECT_TYPE $3  Successfully！！！!,PID is: $PROJECT_PID.  @@@@@@@@"
   else
     echo "!!!!!!!!  service $PROJECT $PROJECT_TYPE $3  failed. !!!!!!!!"
   fi
else
  echo "!!!!!!!! service $PROJECT $3 $PROJECT_TYPE failed. !!!!!!!!"
fi
```



### jenkins配置

所需插件

- Publish Over SSH

任务配置

![](https://i.loli.net/2019/09/24/bLrSNG9cPKgoZyY.jpg)

![](https://i.loli.net/2019/09/24/BfSnvVPl5FwzHXE.jpg)

![](https://i.loli.net/2019/09/24/PJZzfelBioG6LTp.jpg)

![](https://i.loli.net/2019/09/24/bgmVNct56fzkFpQ.jpg)

![](https://i.loli.net/2019/09/24/kMN1HyweK7OX5ar.jpg)

可讲上述最后一步骤简化为

![](https://i.loli.net/2019/09/24/w7TgfS4zMI1aVsR.jpg)



其他简化

简化后的control.sh

脚本写在与部署Jenkins同一台机器上

jenkins:192.168.78.13

```
#!/bin/bash
## version:1.2
## date: 2018-04-29   update
## mail


# ENV
PROJECT_NAME=`cat /tmp/gitlab_jenkins_ansible.txt |awk '{print $1}'`
GITTYPE=`cat /tmp/gitlab_jenkins_ansible.txt |awk '{print $2}'`
SERVICE=`cat /tmp/gitlab_jenkins_ansible.txt |awk '{print $3}'`
#PROJECT_NAME=$1
#GITTYPE=$2
#SERVICE=$3
#HARDID= $4
echo $PROJECT_NAME $GITTYPE $SERVICE >/tmp/contorl.txt

# ansible hosts address
ANSIBLE_HOSTS_ADDR=/cron/ansible/hosts-nginx

#ansible command
/usr/bin/ansible -i $ANSIBLE_HOSTS_ADDR $PROJECT_NAME -m shell -a "/bin/bash /cron/nginx-scripts/update_code.sh $PROJECT_NAME $GITTYPE $SERVICE "


简化版本二:
#!/bin/bash
## version:1.0

# ENV
PROJECT_NAME=`cat /tmp/gitlab_jenkins_ansible.txt |awk '{print $1}'`
GITTYPE=`cat /tmp/gitlab_jenkins_ansible.txt |awk '{print $2}'`
SERVICE=`cat /tmp/gitlab_jenkins_ansible.txt |awk '{print $3}'`
update_code_host="192.168.78.140"     //定义对哪台机器操作

ssh $update_code_host  "/usr/bin/sh /cron/update_code.sh $PROJECT_NAME $GITTYPE $SERVICE"

```

host:192.168.78.140

简化后的update_code.sh

```
if [ $1 == log ];then    //服务名称
  case $2 in 
      pull) 
        cd /usr/share/nginx/html/log  && git pull;;
      reback-one)
        cd /usr/share/nginx/html/log  && git reset --hard HEAD^ ;;
      reback-two)
        cd /usr/share/nginx/html/log  && git reset --hard HEAD^^ ;;
        *)
        sleep 1;;
   esac
   case $3 in
      restart)
        nginx -s reload;;
      start)
        nginx;;
      stop)
        nginx -s quit;;
   esac
fi
```

**nginx 配置文件**

```
 server {
   server_name _;
   location / {
    root /usr/share/nginx/html/log;
    index index.html;

    }
```



# pipeline流水线代码发布

jenkins pipeline 持续构建用法简单介绍

## 背景

前段时间一直在想，怎么做CI方面的东西，后来通过整理nginx、rabbitmq、bind等等一下软件的配置，虽然都有相关的备份。但是并没有统一管理，无法做相关治理的目的。

有这么两种做法进行管理：

- 通过ansible 进行管理及相关备份
            优点: 编辑简单、方便更改等等
            比较难做到很好版本管理

- 通过jenkins pipeline + gitlab 方式进行 配置文件治理。
            版本管理方便、回退方便、完全可以自动化发布
            需要 知晓整个构建原理、以及根据实际业务需要编写 相关脚本、需要知识相对负载。
        

  我选择第二种方案进行治理，也就是本文主要讲解内容。背景介绍完成，进入正题。

## 架构思路

![img](http://img.liuwenqi.com/blog/2019-07-23-125238.jpg)

git push 到gitlab >> 触发jenkins webhooks API >> 执行ansible

## jenkins所需插件

在插件里面搜索pipeline ，凡是有pipeline的都安装，完成后，重启jenkins



## gitlab和jenkins绑定

- jenkins

![](https://i.loli.net/2019/05/15/5cdc2846c79b295918.jpg)

构建自由风格项目

![](https://i.loli.net/2019/05/16/5cdcfef5602b471584.jpg)

![](https://i.loli.net/2019/05/16/5cdcff4b97a8b18914.jpg)



构建触发器

![](https://i.loli.net/2019/05/16/5cdd00b44185158313.jpg)

![](https://i.loli.net/2019/05/16/5cdd018676c1332830.jpg)



- gitlab

找到对应的git库  点击setting --> Integrations ,填写以下内容，然后下拉点击 Add webhook

![](https://i.loli.net/2019/05/16/5cdd02254e31b80243.jpg)



##  jenkins pipeline

![](https://i.loli.net/2019/09/24/bgmVNct56fzkFpQ.jpg)

```
pipeline {
    agent any
    environment {
        def GIT_NAME = "my-test1"
        def CODE_DIR = "/cron"
        def GIT_ADDR = "git@10.3.138.30:root/my-test1.git"
        def ANSIBLE_HOST_DIR = "/cron/ansible/hosts-nginx"
        def ANSIBLE_HOST_NAME = "nginx1"
    }
    stages {
        stage('Git') {
            steps {
                sh '/root/scripts/jenkins_pip_git_pull.sh $CODE_DIR $GIT_NAME $GIT_ADDR'
            }
        }
        stage('Ansible Git pull') {
            steps {
                sh 'ansible -i $ANSIBLE_HOST_DIR $ANSIBLE_HOST_NAME  -m shell -a "cd $CODE_DIR/$GIT_NAME;git pull"'
            }
        }
    }
}
```



> 在你的ansible机器上创建 jenkins_pip_git_pull.sh

```
jenkins_pip_git_pull

#!/bin/bash
## Version:1.0

GIT_DIR=$1
GIT_NAME=$2
GIT_ADDR=$3
#echo $GIT_DIR $GIT_NAME $GIT_ADDR
if [ -d ${GIT_DIR}/${GIT_NAME} ];then
        cd ${GIT_DIR}/${GIT_NAME}
        git pull
else
        cd ${GIT_DIR}
 #       git clone ${GIT_ADDR}/${GIT_NAME}.git
        git clone ${GIT_ADDR}
fi
```

