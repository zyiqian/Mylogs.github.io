### Git 及GitHub的使用

**今天主要是介绍一下Git和GitHub的托管服务**

git是一个分布式版本控制软件，最初由林纳斯·托瓦兹（Linus Torvalds）创作，于2005年以GPL发布。最初目的是为更好地管理Linux内核开发而设计。

在这类系统中，像Git、Mercurial、Bazaar 以及 Darcs 等，客户端并不只提取最新版本的文件快照，而是把代码仓库完整地镜像下来。这么一来，任何一处协同工作用的服务器发生故障，事后都可以用任何一个镜像出来的本地仓库恢复。因为每一次的克隆操作，实际上都是一次对代码仓库的完整备份。

![](https://i.loli.net/2019/09/19/4v1bytrZxMWNcme.jpg)

#### 一、Git的安装

#### 1、环境说明

```
[root@gitlab ~]# rpm -qa centos-release
centos-release-7-4.1708.el7.centos.x86_64
[root@gitlab ~]# uname -a
Linux gitlab 3.10.0-693.el7.x86_64 #1 SMP Tue Aug 22 21:09:27 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
防火墙 selinux iptbles记得都需要关闭
```

#### 2、Yum安装Git

```
[root@gitlab ~]# rpm -qa git   // 系统自带
git-1.8.3.1-11.el7.x86_64

如果没有则可以自己安装
yum install git -y
```

#### 3、编译安装方法

```
编译安装可以安装较新版本的git
Git下载地址： https://github.com/git/git/releases
# 安装依赖关系
yum install curl-devel expat-devel gettext-devel  openssl-devel zlib-devel
# 编译安装
tar -zxf git-2.0.0.tar.gz
cd git-2.0.0
make configure
./configure --prefix=/usr
make  
make install  
```

#### 4、初次运行Git前的配置

#####   1）、配置Git

```
[root@gitlab ~]# git config --global user.name "lion"  #配置git使用用户
[root@gitlab ~]# git config --global user.email "hackerlion@aliyun.com"  #配置git使用邮箱
[root@gitlab ~]# git config --global color.ui true  #语法高亮
[root@gitlab ~]# git config --list # 查看全局配置
user.name=lion
user.mail=hackerlion@aliyun.com
color.ui=true
```

#####   2)、获取帮助，或查看Git命令

```
[root@lion ~]# git help
[root@lion ~]# man git
[root@lion ~]# git config --help //查看配置命令
              或者  git help config
```

##### 3)、 初始化Git仓库

```
# 创建目录
mkdir /data/git_data
# 进入目录
cd /data/git_data/
# 初始化
git init
# 查看工作区状态
git status
```

##### 4)、操作过程

```
[root@gitlab git_data]# git init
初始化空的 Git 版本库于 /data/git_data/.git/
Initialized empty Git repository in /data/git_data/.git/
[root@gitlab git_data]# git status	
# 位于分支 master
#
# 初始提交
#
无文件要提交（创建/拷贝文件并使用 "git add" 建立跟踪）

# On branch master
#
# Initial commit
#
nothing to commit (create/copy files and use "git add" to track)
```

##### 5）、Git常用命令

| **命令**     | **命令说明**                                 |
| ------------ | -------------------------------------------- |
| **add**      | 添加文件内容至索引                           |
| **bisect**   | 通过二分查找定位引入 bug 的变更              |
| **branch**   | 列出、创建或删除分支                         |
| **checkout** | 检出一个分支或路径到工作区                   |
| **clone**    | 克隆一个版本库到一个新目录                   |
| **commit**   | 记录变更到版本库                             |
| **diff**     | 显示提交之间、提交和工作区之间等的差异       |
| **fetch**    | 从另外一个版本库下载对象和引用               |
| **grep**     | 输出和模式匹配的行                           |
| **init**     | 创建一个空的                                 |
| **Git**      | 版本库或重新初始化一个已存在的版本库         |
| **log**      | 显示提交日志                                 |
| **merge**    | 合并两个或更多开发历史                       |
| **mv**       | 移动或重命名一个文件、目录或符号链接         |
| **pull**     | 获取并合并另外的版本库或一个本地分支         |
| **push**     | 更新远程引用和相关的对象                     |
| **rebase**   | 本地提交转移至更新后的上游分支中             |
| **reset**    | 重置当前HEAD到指定状态                       |
| **rm**       | 从工作区和索引中删除文件                     |
| **show**     | 显示各种类型的对象                           |
| **status**   | 显示工作区状态                               |
| **tag**      | 创建、列出、删除或校验一个GPG签名的 tag 对象 |

**操作示意图**

![](https://i.loli.net/2019/09/19/u25LqpIXE8Wt6HM.jpg)

##### 6）、创建文件

```
[root@gitlab git_data]# touch README
[root@gitlab git_data]# git status
# 位于分支 master
#
# 初始提交
#
# 未跟踪的文件:
#   （使用 "git add <file>..." 以包含要提交的内容）
#
#    README
提交为空，但是存在尚未跟踪的文件（使用 "git add" 建立跟踪）
---
# On branch master
#
# Initial commit
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#       README
nothing added to commit but untracked files present (use "git add" to track)
```

添加文件

git add  * 添加到暂存区域
git commit  提交git仓库 -m 后面接上注释信息，内容关于本次提交的说明，方便自己或他人查看

添加文件跟踪（暂存区）

```
[root@gitlab git_data]# git add .
[root@gitlab git_data]# git status
# 位于分支 master
#
# 初始提交
#
# 要提交的变更：
#   （使用 "git rm --cached <file>..." 撤出暂存区）
#
#    新文件：    README
#
---
# On branch master
#
# Initial commit
#
# Changes to be committed:
#   (use "git rm --cached <file>..." to unstage)
#
#       new file:   README
#
```

文件会添加到.git的隐藏目录

```
[root@gitlab git_data]# tree  .git/
.git/
├── branches
├── config
├── description
├── HEAD
├── hooks
│   ├── applypatch-msg.sample
│   ├── commit-msg.sample
│   ├── post-update.sample
│   ├── pre-applypatch.sample
│   ├── pre-commit.sample
│   ├── prepare-commit-msg.sample
│   ├── pre-push.sample
│   ├── pre-rebase.sample
│   └── update.sample
├── index
├── info
│   └── exclude
├── objects
│   ├── e6
│   │   └── 9de29bb2d1d6434b8b29ae775ad8c2e48c5391
│   ├── info
│   └── pack
└── refs
    ├── heads
    └── tags
```

由工作区提交到本地仓库

```
[root@gitlab git_data]# git commit  -m 'first commit'  
// -m "注释信息"  -a 表示直接提交
[master（根提交） bb963eb] first commit
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 README
 
 查看git的状态
 [root@gitlab git_data]# git status
# 位于分支 master
无文件要提交，干净的工作区

# On branch master
nothing to commit, working directory clean

提交后的git目录状态
[root@gitlab git_data]# tree  .git/
.git/
├── branches
├── COMMIT_EDITMSG
├── config
├── description
├── HEAD
├── hooks
│   ├── applypatch-msg.sample
│   ├── commit-msg.sample
│   ├── post-update.sample
│   ├── pre-applypatch.sample
│   ├── pre-commit.sample
│   ├── prepare-commit-msg.sample
│   ├── pre-push.sample
│   ├── pre-rebase.sample
│   └── update.sample
├── index
├── info
│   └── exclude
├── logs
│   ├── HEAD
│   └── refs
│       └── heads
│           └── master
├── objects
│   ├── 54
│   │   └── 3b9bebdc6bd5c4b22136034a95dd097a57d3dd
│   ├── bb
│   │   └── 963eb32ad93a72d9ce93e4bb55105087f1227d
│   ├── e6
│   │   └── 9de29bb2d1d6434b8b29ae775ad8c2e48c5391
│   ├── info
│   └── pack
└── refs
    ├── heads
    │   └── master
    └── tags
```

##### 7)、删除文件

**命令说明：**

• 没有添加到暂存区的数据直接rm删除即可。

• 已经添加到暂存区数据：

git rm --cached database 

\#→将文件从git暂存区域的追踪列表移除(并不会删除当前工作目录内的数据文件)

git rm -f database

\#→将文件数据从git暂存区和工作目录一起删除

##### 8）、重命名暂存区数据

• 没有添加到暂存区的数据直接mv/rename改名即可。

• 已经添加到暂存区数据：

git mv README NOTICE

##### 9）、查看历史记录

 git log   #→查看提交历史记录

• git log -2   #→查看最近几条记录

• git log -p -1  #→-p显示每次提交的内容差异,例如仅查看最近一次差异

• git log --stat -2 #→--stat简要显示数据增改行数，这样能够看到提交中修改过的内容，对文件添加或移动的行数，并在最后列出所有增减行的概要信息

• git log --pretty=oneline #→--pretty根据不同的格式展示提交的历史信息

• git log --pretty=fuller -2 #→以更详细的模式输出提交的历史记录

• git log --pretty=fomat:"%h %cn"  #→查看当前所有提交记录的简短SHA-1哈希字串与提交着的姓名。

##### 10）、还原历史数据

Git服务程序中有一个叫做HEAD的版本指针，当用户申请还原数据时，其实就是将HEAD指针指向到某个特定的提交版本，但是因为Git是分布式版本控制系统，为了避免历史记录冲突，故使用了SHA-1计算出十六进制的哈希字串来区分每个提交版本，另外默认的HEAD版本指针会指向到最近的一次提交版本记录，而上一个提交版本会叫HEAD^，上上一个版本则会叫做HEAD^^，当然一般会用HEAD~5来表示往上数第五个提交版本。

git reset --hard   hash

git reset --hard HEAD^  #→还原历史提交版本上一次

git reset --hard 3de15d4 #→找到历史还原点的SHA-1值后，就可以还原(值不写全,系统

会自动匹配)

##### 11）、还原未来数据

什么是未来数据？就是你从新的数据还原到历史旧的数据了，但是你后悔了，想撤销更改，但是git log已经找不到这个版本了。

git reflog #→查看未来历史更新点

```
[root@gitlab git_data]#  git reflog
e9ed8b3 HEAD@{0}: reset: moving to e9ed8b38a
f5b7955 HEAD@{1}: commit: 456
e9ed8b3 HEAD@{2}: commit: commit 123
9d39411 HEAD@{3}: commit (initial): first commit
[root@gitlab git_data]# git reset --hard e9ed8b3
```

##### 12)、标签的使用

前面回滚使用的是一串字符串，又长又难记。

git tag v1.0   #→当前提交内容打一个标签(方便快速回滚)，每次提交都可以打个tag。

git tag          #→查看当前所有的标签

git show v1.0   #→查看当前1.0版本的详细信息

git tag v1.2 -m "version 1.2 release is test"  #→创建带有说明的标签,-a指定标签名字，-m指定说明文字

git tag -d v1.0   #→我们为同一个提交版本设置了两次标签,删除之前的v1.0

```
[root@gitlab git_data]# git tag  v20171129
[root@gitlab git_data]# git tag 
v20171129
[root@gitlab git_data]# git reset --hard e9ed8b38a
[root@gitlab git_data]# git reset --hard v20171129
```

##### 13）、对比数据

git diff可以对比当前文件与仓库已保存文件的区别，知道了对README作了什么修改

后，再把它提交到仓库就放⼼多了。

```
git diff README
git diff --name-only HEAD HEAD^
git diff --name-only head_id head_id2
```

##### 14）、分支结构

在实际的项目开发中，尽量保证master分支稳定，仅用于发布新版本，平时不要随便直接修改里面的数据文件。

那在哪干活呢？干活都在dev分支上。每个人从dev分支创建自己个人分支，开发完合并到dev分支，最后dev分支合并到master分支。所以团队的合作分支看起来会像下图那样。

分支切换

```
[root@gitlab git_data]# git branch tiger
[root@gitlab git_data]# git branch 
* master
  tiger
[root@gitlab git_data]# git checkout tiger 
切换到分支 'tiger'
Switched to branch 'tiger'
[root@gitlab git_data]# git branch 
  master
* tiger
```

**在tiger** **分支进行修改**

```
[root@gitlab git_data]# cat README 
This is git_data readme
[root@gitlab git_data]#  echo '1901' >> README 
[root@gitlab git_data]# git add .
[root@gitlab git_data]# git commit -m '1901'
[tiger 4310e7e] 1901
 1 file changed, 1 insertion(+)
[root@gitlab git_data]# git status
# On branch tiger
nothing to commit, working directory clean
---
# 位于分支 tiger
无文件要提交，干净的工作区
```

**回到master**分支

```
[root@gitlab git_data]# git checkout master
Switched to branch 'master'
切换到分支 'master'
[root@gitlab git_data]# cat README 
This is git_data readme
[root@gitlab git_data]# git log  -1
commit f5b79552635a7dc60afc35c99c1170366d8c5f6b
Author: tigerfive <tigerfive@aliyun.com>
Date:   Sat May 11 21:29:21 2019 -0700

    456

```

**合并代码**

```
[root@gitlab git_data]#  git merge tiger
Updating f5b7955..4310e7e
Fast-forward
 README | 1 +
 1 file changed, 1 insertion(+)
[root@gitlab git_data]# git status
# On branch master
nothing to commit, working directory clean
# 位于分支 master
无文件要提交，干净的工作区
[root@gitlab git_data]# cat README 
This is git_data readme
1901
```

**合并失败解决**

*模拟冲突，在文件的同一行做不同修改*

**在master** **分支进行修改**

```
[root@gitlab git_data]# cat README 
This is git_data readme
1901
[root@gitlab git_data]#  echo '1901-git' > README 
[root@gitlab git_data]#  git commit -m 'tiger 1901-git'
[master 4e6c548] tiger 1901-git
 1 file changed, 1 insertion(+), 2 deletions(-)
```

**切换到tiger****分支**

```
[root@gitlab git_data]# git checkout tiger
Switched to branch 'tiger'
[root@gitlab git_data]# cat README 
This is git_data readme
1901
[root@gitlab git_data]# echo 'tiger' >> README 
[root@gitlab git_data]# git commit -m '1901-git-check'
# On branch tiger
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#       modified:   README
#
no changes added to commit (use "git add" and/or "git commit -a")
```

**回到master****分区，进行合并，出现冲突*

```
[root@gitlab git_data]# git checkout master 
切换到分支 'master'
[root@gitlab git_data]# git merge linux
自动合并 README
冲突（内容）：合并冲突于 README
自动合并失败，修正冲突然后提交修正的结果。
```

**解决冲突**

```
[root@gitlab git_data]# vim README 
This is git_data readme
1901
tiger
meger test ti
meger test master
```

*手工解决冲突*

```
[root@gitlab git_data]# git commit -a -m "merge-ti-test"
[master 2594b2380] merge-ti-test
```

**删除分支**

因为之前已经合并了tiger分支，所以现在看到它在列表中。 在这个列表中分支名字前没有 * 号的分支通常可以使用 git branch -d 删除掉；你已经将它们的工作整合到了另一个分支，所以并不会失去任何东西。

查看所有包含未合并工作的分支，可以运行 *git branch --no-merged**：*

```
git branch --no-merged
  testing
  这里显示了其他分支。 因为它包含了还未合并的工作，尝试使用 git branch -d 命令删除它时会失败：
  如果真的想要删除分支并丢掉那些工作，如同帮助信息里所指出的，可以使用 -D 选项强制删除它。
```

#### GitHub托管服务

Github顾名思义是一个Git版本库的托管服务，是目前全球最大的软件仓库，拥有上百万的开发者用户，也是软件开发和寻找资源的最佳途径，Github不仅可以托管各种Git版本仓库，还拥有了更美观的Web界面，您的代码文件可以被任何人克隆，使得开发者为开源项贡献代码变得更加容易，当然也可以付费购买私有库，这样高性价比的私有库真的是帮助到了很多团队和企业

##### 1、首先要有一个已经注册好的GitHub账号

##### 2、然后创建好一个仓库

##### 3、获取linux上的密钥

```
[root@gitlab ~]# ssh-keygen 
[root@gitlab ~]# cat .ssh/id_rsa.pub  //全复制
```

##### 4、添加密钥

在github上添加一个新的ssh密钥   在settings 里面有个ssh 什么的

##### 5、在个人主机上进行推送测试

```
[root@gitlab clsn]# echo "# test" >> README.md  /test 是仓库名称
[root@gitlab clsn]# git init
[root@gitlab clsn]# git add README.md
[root@gitlab clsn]# git commit -m "first commit"
[root@gitlab clsn]# git remote add origin git@github.com:clsn-git/test.git   //从GitHub上面复制仓库的ssh
[root@gitlab clsn]# git push -u origin master
推送完成，刷新界面就可以发现，推送上去的README.md文件

```

##### 6、拉取文件测试

```
[root@gitlab clsn]# git pull
remote: Counting objects: 3, done.
remote: Compressing objects: 100% (3/3), done.
Unpacking objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
来自 github.com:clsn-git/test
   089ae47..a16be65  master     -> origin/master
更新 089ae47..a16be65
Fast-forward
 clsn.txt | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 clsn.txt 
```

