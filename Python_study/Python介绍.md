---
typora-root-url: ./assets
---



## ![img](/python-1551763364090.jpg)

## 一、Python 语言介绍

### 1、Python 发展历史

​        Python 是由 Guido van Rossum （吉多·范罗苏姆）在八十年代末和九十年代初，在荷兰国家数学和计算机科学研究所设计出来的。Python 本身也是由诸多其他语言发展而来的,这包括 ABC、lisp、perl、C、C++、Unix shell 和其他的脚本语言等等。像 Perl 语言一样，Python 源代码同样遵循 GPL(GNU General Public License)协议。现在 Python 是由一个核心开发团队在维护，Guido van Rossum（吉多·范罗苏姆） 仍然占据着至关重要的作用，指导其进展。

![10829283-b919aba40fef7acd.webp](/10829283-b919aba40fef7acd.webp.jpg)

**Guido van Rossum（吉多·范罗苏姆）个人事迹**

2002年，在比利时布鲁塞尔举办的自由及开源软件开发者欧洲会议上，吉多·范罗苏姆获得了由自由软件基金会颁发的2001年自由软件进步奖。

2003年五月，吉多获得了荷兰 UNIX用户小组奖。

2006年，他被美国计算机协会（ACM）认定为著名工程师。

2005年12月，吉多·范罗苏姆加入Google。他用Python语言为Google写了面向网页的代码浏览工具。在那里他把一半的时间用来维护Python的开发。

2012年12月7日，Dropbox宣布吉多·范罗苏姆加入Dropbox公司。

### 2、Python 简介

Python 是一个高层次的结合了解释性、编译性、互动性和面向对象的脚本语言。Python 的设计具有很强的可读性，相比其他语言经常使用英文关键字，其他语言的一些标点符号，它具有比其他语言更有特色语法结构

**Python是一种解释型、面向对象、动态数据类型的高级程序设计语言。**

**Python由Guido van Rossum于1989年底发明，第一个公开发行版发行于1991年。**

**像Perl语言一样, Python 源代码同样遵循 GPL(GNU General Public License)协议。**

### 3、Python 特点

- **1.易于学习：**Python有相对较少的关键字，结构简单，和一个明确定义的语法，学习起来更加简单。
- **2.易于阅读：**Python代码定义的更清晰。
- **3.易于维护：**Python的成功在于它的源代码是相当容易维护的。
- **4.一个广泛的标准库：**Python的最大的优势之一是丰富的库，跨平台的，在UNIX，Windows和Macintosh兼容很好。
- **5.互动模式：**互动模式的支持，您可以从终端输入执行代码并获得结果的语言，互动的测试和调试代码片断。
- **6.可移植：**基于其开放源代码的特性，Python已经被移植（也就是使其工作）到许多平台。
- **7.可扩展：**如果你需要一段运行很快的关键代码，或者是想要编写一些不愿开放的算法，你可以使用C或C++完成那部分程序，然后从你的Python程序中调用。
- **8.数据库：**Python提供所有主要的商业数据库的接口。
- **9.GUI编程：**Python支持GUI可以创建和移植到许多系统调用。
- **10.可嵌入:** 你可以将Python嵌入到C/C++程序，让你的程序的用户获得"脚本化"的能力。

### 4、Python 的能力

2019年最新的TIOBE排行榜显示，Python 仅次于 C 排行在第三位。

![编程语言TIOBE排行榜](/编程语言TIOBE排行榜.PNG)

​         Python可以应用于众多领域，如：数据分析、组件集成、网络服务、图像处理、数值计算和科学计算等众多领域。目前业内几乎所有大中型互联网企业都在使用Python，如：Youtube、Dropbox、BT、Quora（中国知乎）、豆瓣、知乎、Google、Yahoo!、Facebook、NASA、百度、腾讯、汽车之家、美团等。互联网公司广泛使用Python来做的事一般有：**自动化运维**、**自动化测试**、**大数据分析、爬虫、Web 等。**

### **5、Python 与其他语言比较**

- **C 和 Python、Java、C#等**

　　C语言： 代码编译得到**机器码** ，机器码在处理器上直接执行，每一条指令控制CPU工作                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              

　　其他语言： 代码编译得到**字节码** ，虚拟机执行字节码并转换成机器码再后在处理器上执行

- **Python 和** **C**（Python这门语言是由C开发而来）

　　对于使用：Python的类库齐全并且使用简洁，如果要实现同样的功能，Python 10行代码可以解决，C可能就需要100行甚至更多.

　　对于速度：Python的运行速度相较与C相比，绝逼是慢了

- **Python 和 Java、C#等**

　　对于使用：Linux原装Python，其他语言没有；以上几门语言都有非常丰富的类库支持

　　对于速度：Python在速度上可能稍显逊色

所以，Python和其他语言没有什么本质区别，其他区别在于：擅长某领域、人才丰富、先入为主。

### **6、Python 解释器的种类**

- **CPython**

  ​    当我们从[Python官方网站](https://www.python.org/)下载并安装好Python 后，我们就直接获得了一个官方版本的解释器：CPython。这个解释器是用C语言开发的，所以叫CPython。在命令行下运行`python`就是启动CPython解释器。

- **IPython**

　　   IPython是基于CPython之上的一个交互式解释器，也就是说，IPython只是在交互方式上有所增强，但是执行Python代码的功能和CPython是完全一样的。好比很多国产浏览器虽然外观不同，但内核其实都是调用了IE。

　　   CPython用`>>>`作为提示符，而IPython用`In [序号]:`作为提示符。

- **Jyhton**

  ​    Jython是运行在Java平台上的Python解释器，可以直接把Python代码编译成Java字节码执行。

- **IronPython**

  ​    IronPython和Jython类似，只不过IronPython是运行在微软.Net平台上的Python解释器，可以直接把Python代码编译成.Net的字节码。

- **PyPy（特殊）**

  ​    PyPy是另一个Python解释器，它的目标是执行速度。PyPy采用[JIT技术](http://en.wikipedia.org/wiki/Just-in-time_compilation)，对Python代码进行动态编译（注意不是解释），所以可以显著提高Python代码的执行速度。

　　　绝大部分Python代码都可以在PyPy下运行，但是PyPy和CPython有一些是不同的，这就导致相同的Python代码在两种解释器下执行可能会有不同的结果。如果你的代码要放到PyPy下执行，就需要了解[PyPy和CPython的不同点](http://pypy.readthedocs.org/en/latest/cpython_differences.html)。

- **RubyPython、Brython... 等**

- **PyPy，在Python的基础上对Python的字节码进一步处理，从而提升执行速度！**

## 二、Linux 编译安装Python3

### 1、源码安装

#### 1、安装依赖软件包

```shell
yum -y install gcc gcc-c++ zlib-devel bzip2-devel openssl-devel  sqlite-devel readline-devel libffi-devel
```

> 前提条件是：你的系统已经安装了开发工具包。

#### 2、下载

```shell
curl -o python3.7.tgz https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
// 或者
wget  https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
```

#### 3、解压安装

```shell
tar -xf Python-3.6.5.tgz
cd Python-3.6.5/
```

**进入目录后，执行下面的命令**

修改文件 `Python-3.6.5/Modules/Setup.dist`， 去掉如下几行的注释 ：

```shell
readline readline.c -lreadline -ltermcap

SSL=/usr/local/ssl
_ssl _ssl.c \
        -DUSE_SSL -I$(SSL)/include -I$(SSL)/include/openssl \
        -L$(SSL)/lib -lssl -lcrypto
```

或者在 `shell` 命令提示符下执行如下命令：

```shell
sed -ri 's/^#readline/readline/' Modules/Setup.dist
sed -ri 's/^#(SSL=)/\1/' Modules/Setup.dist
sed -ri 's/^#(_ssl)/\1/' Modules/Setup.dist 
sed -ri 's/^#([\t]*-DUSE)/\1/' Modules/Setup.dist 
sed -ri 's/^#([\t]*-L\$\(SSL\))/\1/' Modules/Setup.dist
```

**开始编译安装**

```shell
./configure --enable-shared --prefix=/usr/local/python3
make -j 2 && make install
```

> --enable-shared 指定安装共享库，共享库在使用其他需调用python的软件时会用到，比如使用`mod_wgsi` 连接Apache与python时需要。

#### 4、配置共享库文件

为所有用户设置共享库目录

用 vim 编辑器打开配置文件 `/etc/profile.d/python3.sh`

```shell
vim /etc/profile.d/python3.sh
```

在文件末尾写上如下内容：

```shell
# python3.6 共享库目录
export PATH=$PATH:/usr/local/python3/bin
```

编辑文件 `/etc/ld.so.conf.d/python3.conf`，并且添加如下内容：

```shell
/usr/local/python3/lib
```

保存退出文件后， 执行如下命令 加载配置信息使其生效

```shell
ldconfig
```

执行如下命令，使环境变量生效

```shell
source /etc/profile.d/python3.sh
```

#### 5、测试python3

```python
$ python3
Python 3.6.3 (default, Dec 17 2017, 04:11:01)
[GCC 4.8.5 20150623 (Red Hat 4.8.5-11)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> print('qf')
qf
>>> exit()
```

> 输入 `exit()` 即可退出 python3

#### 6、测试 pip3

> 一般情况下你不需要执行下面的安装命令。

```shell
[root@newrain ~]# pip3 -V
pip 9.0.3 from /usr/local/lib/python3.6/site-packages (python 3.6)
```

> 假如上面显示的含有 python3.6 就没问题了，说名 pip3 安装的模块会安装到上面显示的目录下

**特殊问题**

假如 Python Shell 中敲击方向键显示「[[C[[D」
 可以安装以下包

> 一般情况下你不需要执行下面的安装命令。

```shell
pip3 install gnureadline
```

### 2、 配置使用国内源安装第三方模块

#### 1、创建配置文件

配置 pip3 使用国内源

```shell
mkdir ~/.pip
vi ~/.pip/pip.conf
# Windows 下使用 pip.ini
```

写入如下内容：

```shell
[global]
index-url=https://mirrors.aliyun.com/pypi/simple
```

> `豆瓣源: https://pypi.douban.com/simple/`
>
> `阿里源: https://mirrors.aliyun.com/pypi/simple`
>
> `清华: https://pypi.tuna.tsinghua.edu.cn/simple`
>
> `阿里云: http://mirrors.aliyun.com/pypi/simple/`
>
> `中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/`
>
> `华中理工大学: http://pypi.hustunique.com/`
>
> `山东理工大学: http://pypi.sdutlinux.org/`

示例：
 比如安装一个执行远程主机命令的模块

```shell
[root@newrain ~]# pip3 install paramiko
Collecting paramiko
  Downloading https://mirrors.aliyun.com/pypi/packages/4b/80/74dace9e48b0ef923633dfb5e48798f58a168e4734bca8ecfaf839ba051a/paramiko-2.6.0-py2.py3-none-any.whl (199kB)
    100% |████████████████████████████████| 204kB 2.3MB/s 
Collecting bcrypt>=3.1.3 (from paramiko)
  Downloading https://mirrors.aliyun.com/pypi/packages/8b/1d/82826443777dd4a624e38a08957b975e75df859b381ae302cfd7a30783ed/bcrypt-3.1.7-cp34-abi3-manylinux1_x86_64.whl (56kB)
    100% |████████████████████████████████| 61kB 3.1MB/s 
Collecting pynacl>=1.0.1 (from paramiko)
...
```

## 三、Windows 10 安装 Python3 和 pip3

### 1、下载Python3

下载地址：<https://www.python.org/downloads/windows/>  

注意：window版本有32位和64位，这里我下载的是64位。

![技术分享图片](/20180717132339311904.png)

### 2、安装Python3

1、下载好安装包后双击安装出现下面的安装步骤：选择自定义安装，和自动添加到path环境变量中。

![技术分享图片](/20180717132340028728.png)

![技术分享图片](/20180717132340894972.png)

![技术分享图片](/20180717132341228969.png)

![技术分享图片](/20180717132341700667.png)

![技术分享图片](/20180717132342006343.png)

2、安装成功后，会自动添加到环境变量中，如下图

![aaa](/20180717132340472104-1551798940478.png)

在你的win10中查看表示安装成功。

![技术分享图片](/20180717132342296393.png)

### 3、下载 pip3

下载地址：<https://pypi.org/project/pip/#downloads>

![img](/1279634-20180908194648643-169751769.png)

### 4、安装 pip3

下载保存到python路径下且解压压缩包

![img](/1279634-20180908194938475-142632781.png)

以管理员身份启动cmd。进入解压的文件路径，执行 python setup.py install

![img](/1279634-20180908195453387-1770103496.png)

 安装完成后配置pip环境变量

![img](/1279634-20180908195747049-2116648955.png)

 

 输入pip list 出现如下界面说明pip安装配置ok

![img](/1279634-20180908195210239-2145044376.png)

## 四、Ipython 交互式解释器

### 1、Ipython 简介

**IPython外加一个文本编辑器**

Windows系统下是IPython加notepad++，Linux系统下是IPython加vim配合使用，写起代码来体验很流畅，很容易获取到写代码时候的那种“流体验”。

IPython的设计目的是在交互式计算和软件开发这两个方面最大化地提高生产力，它鼓励一种“执行-探索”的工作模式，支持matplotlib等库的绘图操作。同时IPython还提供一个基于WEB的交互式浏览器开发环境（Jupyter Notebook），用起来也很不错。

### 2、安装 Ipython

#### 1、安装 python-devel

​         python-dev或python-devel称为是python的开发包，其中包括了一些用C/Java/C#等编写的python扩展在编译的时候依赖的头文件等信息。

比如：我们在编译一个用C语言编写的python扩展模块时，因为里面会有#include<Python.h>等这样的语句，因此我们就需要先安装python-devel开发包

执行以下命令安装即可（需要有 epel 源支持）：

```shell
yum -y install python-devel
```

#### 2、安装 ipython

```shell
pip3 install ipython
```

#### 3、启动 ipython

```python
[root@localhost ~]# ipython
Python 3.6.5 (default, Mar  6 2019, 06:36:12) 
Type 'copyright', 'credits' or 'license' for more information
IPython 7.3.0 -- An enhanced Interactive Python. Type '?' for help.

In [1]:  
```

#### 4、退出 ipython

```python
[root@localhost ~]# ipython
Python 3.6.5 (default, Mar  6 2019, 06:36:12) 
Type 'copyright', 'credits' or 'license' for more information
IPython 7.3.0 -- An enhanced Interactive Python. Type '?' for help.

In [1]: exit                                                                                                                                                      
[root@localhost ~]# 
```

#### 5、使用 ipython

```python
[root@localhost ~]# ipython
Python 3.6.5 (default, Mar  6 2019, 06:36:12) 
Type 'copyright', 'credits' or 'license' for more informat
IPython 7.3.0 -- An enhanced Interactive Python. Type '?' 
#定义一个字符串
In [1]: str = "hello"                                     
#tab显示字符串类型的方法
In [2]: str. 
           capitalize()   encode()       format()        
           casefold()     endswith()     format_map()    
           center()       expandtabs()   index()        >
           count()        find()         isalnum()      

[root@localhost ~]# ipython
Python 3.6.5 (default, Mar  6 2019, 06:36:12) 
Type 'copyright', 'credits' or 'license' for more informat
IPython 7.3.0 -- An enhanced Interactive Python. Type '?' 

In [1]: str = "hello"                                     
# 定义一个数字型
In [2]: int = 1                                          
# tab显示数字类型的方法
In [3]: int. 
             bit_length() from_bytes() real        
             conjugate()  imag         to_bytes()  
             denominator  numerator                   
# 执行系统命令，加！是以变量的形式执行命令                                                    In [4]: !pwd                                             
/root

In [5]: pwd                                              
Out[5]: '/root'

In [6]: cd /home/                                        
/home

In [7]: pwd                                              
Out[7]: '/home'

In [8]: ls                                               

In [9]: ls /                                             
bin@   etc/   lib64@  opt/   run/   sys/  var/
boot/  home/  media/  proc/  sbin@  tmp/
dev/   lib@   mnt/    root/  srv/   usr/

In [10]:   
```

### 3、ipython 附加内容(预留为作业)

#### 基础用法

#####  1、Tab键自动补全

和其他命令行环境的Tab自动补全功能类似，不过会隐藏那些以下划线开头的方法和属性（为了防止内容太多）。厉害的是哪怕是在python字符串中也可以自动补全类似文件路径的字符串。比如：

![page11image5621168.png](/page11image5621168.png) 

##### 2、内省

在方法或变量的前面或后面加一个问号（`?`）就可以将有关该方法或变量的一些通用信息都显示出来，这叫做内省；使用`??`还可以显示函数的源代码。见下：


![page11image5633856.png](/page11image5633856.png) 

![page12image5756400.png](/page12image5756400.png) 

![page12image5756816.png](/page12image5756816.png) 

##### 3、`?`和通配符结合使用搜索命名空间

![page12image5755568.png](/page12image5755568.png) 

##### 4、`%run`命令

```
%run xxx.py`：可以执行一个python脚本`xxx.py`，脚本是在一个空的命名空间中运行的。成功运行脚本后，在IPython中可以使用脚本中定义的变量和函数。
如果希望在脚本中能访问IPython之前定义的变量和函数，那么需要用-i参数执行：
 `%run -i xxx.py
```



##### 5、IPython键盘快捷键

-  `Ctrl + P或上箭头`：后向搜索命令历史记录中以当前输入的文本开头的命令。
-  `Ctrl + N或下箭头`：前向搜索命令历史记录中以当前输入的文本开头的命令。
-  `Ctrl + R`：按行读取的反向历史搜索（部分匹配）。
-  `Ctrl + Shift + V`：从剪贴板中粘贴文本。
-  `Ctrl + C`：终止当前正在执行的代码。
-  `Ctrl + A`：将光标移动到行首。
-  `Ctrl + E`：将光标移动到行尾。
-  `Ctrl + K`：删除从光标开始到行尾的文本。
-  `Ctrl + U`：删除从行首到光标处的文本。
-  `Ctrl + F`：将光标向前移动一个字符。
-  `Ctrl + B`：将光标向后移动一个字符。
-  `Ctrl + L`：清屏。

##### 6、魔术命令

以`%`开头的一些命令，比如`%run`就是一个魔术命令，可以使用`%run?`来查看其详细用法。

- `%quickref`：显示IPython的快速参考。

- `%magic`：显示所有魔术命令的详细文档。

- **`%hist`：打印命令的输入（可选输出）历史。**

- `%pdb`：在异常发生后自动进入调试器。

- **`%reset`：删除interactive命名空间中的全部变量/名称。**

- **`%run xxx.py`：执行xxx.py脚本文件。**

- `%prun statement`：通过cProfile执行statement，并打印分析器的输出结果。

- `%time statement`：计算statement的执行时间。

- `%timeit statement`：多次执行（次数可以通过参数配置）statement以计算平均执行时间。对那些执行时间非常短的代码很有用。

- **`%who`**
  
  ：显示interactive命名空间中定义的变量，如下：

  ![page13image5585744.png](/page13image5585744.png) 

- **`%who_ls`：显示interactive命名空间中定义的变量（列表形式），如下：**


![page13image5583872.png](/page13image5583872.png) 

- **`%whos`：显示interactive命名空间中定义的变量（详情形式），如下：**


![page13image5586368.png](/page13image5586368.png) 

- **`%xdel variable`：删除变量variable，并尝试清除其在IPython中的对象上的一切引用。**

##### 7、 输入和输出变量

最近的两个输出结果分别保存在下划线和双下划线两个变量中，如下：

![page14image5585328.png](/page14image5585328.png) 

##### 8、记录输入输出过的变量

某一行的输入变量：`_iX`（X为行号）
 某一行的输出变量：`_X`（X为行号）
 见下：

![page14image5581584.png](/page14image5581584.png) 

##### 9、清理命名空间

当处理大数据集时，IPython的输入输出历史会影响到大量的变量的内存释放，所以及时用`%xdel`和`%reset`清理还是很有必要的。

##### 10、记录日志

记录输入和输出日志：`%logstart -o`，将记录整个会话的日志（包括之前的命令），使用详情可以用`%logstart?`命令查看。

##### 11、与操作系统交互

-  **`!cmd`：执行操作系统的shell命令。**
-  **`output = !cmd`：执行shell命令，并将结果存到output中。**
-  **`%alias new_name cmd`：为系统shell命令定义别名。**
-  `%bookmark`：使用IPython的目录书签系统。
-  `%cd directory`：将工作目录切换到directory路径。
-  **`%pwd`：打印当前的工作目录。**
-  `%dhist`：打印目录访问历史。
-  **`%env`：以dict形式返回系统环境变量。**

##### 12、在执行shell命令时使用IPython环境中的变量

如下：

![page15image5582416.png](/page15image5582416.png) 

#####  13、使用书签

如下：

![page15image5585120.png](/page15image5585120.png) 

#### 进阶用法

##### 1. 代码执行时间分析

命令：`%time`、`%timeit`，如下：


![page15image5580336.png](/page15image5580336.png) 

![page15image5583664.png](/page15image5583664.png) 

![page15image5583040.png](/page15image5583040.png) 

##### 2. IPython HTML Notebook

HTML Notebook是在浏览器中使用的交互式环境，现在最新版本又叫做Jupyter Notebook，功能很强大，完全是一个B/S模式的IDE，体验非常棒。可以用以下命令打开：

- 安装notebook：`pip install notebook` 

- 在命令行中打开notebook：`ipython notebook`（或者：`jupyter notebook`）

- 出现一个带token的url，把url复制到浏览器中，即出现如下页面：

  ![page16image5529312.png](/page16image5529312.png) 

  

- 点击右上角的

  ```python
  New
  ```

  —>

  ```python
  python 2
  ```

  即可打开交互式环境：

  ![page16image5529104.png](/page16image5529104.png) 

- 在输入行中输入

  ```
  %pylab inline
  ```

  命令并执行（Shift + Enter快捷键），即可无缝集成matplotlib的绘图功能到页面中，如图：

  ![page17image5530352.png](/page17image5530352.png) 


##### 3. IPython个性化配置

配置文件在如下目录：
 Unix：`~/.config/ipython/`
 Windows：`%HOME%/.ipython/`
 根据配置文件中的注释，即可修改相应的配置。

##### 4. jupyter 配置跨机器访问

```shell
1、生成一个 notebook 配置文件: jupyter notebook --generate-config
2、生成密码：jupyter notebook password
[root@localhost ~]# cat /root/.jupyter/jupyter_notebook_config.json
{
  "NotebookApp": {
    "password": "sha1:0cabb94e8aa7:a47b98ec3602f9db022f2043b6161f570c722d85"  # 复制下来
  }
[root@localhost ~]# vim /root/.jupyter/jupyter_notebook_config.py
c.NotebookApp.ip='*'
c.NotebookApp.password = u'sha:ce...刚才复制的那个密文'
c.NotebookApp.open_browser = False
c.NotebookApp.port =8888 #可自行指定一个端口, 访问时使用该端口

```





## 补充内容

一，我们操作代码的方式 终端  文件
   终端
   字符串需要用引号

   文件
   文件名以.py结尾
   解释器申明
   终端执行文件

   输入命令的执行流程
   属于代码-->解释器--->语法词法分析

在 /root 目录下创建 hello.py 文件，内容如下：

```python
print("hello,world")
```

执行 hello.py 文件，即： `python /root/hello.py`

python内部执行过程如下：

![img](/425762-20151024160748145-1165720810.png)

**二、解释器**

上一步中执行 python3 /root/hello.py 时，明确的指出 hello.py 脚本由 python 解释器来执行。

如果想要类似于执行shell脚本一样执行python脚本，例： `./hello.py `，那么就需要在 hello.py 文件的头部指定解释器，如下：

```python
#!/usr/bin/env python3
print("hello,world")
```

如此一来，执行： .`/hello.py` 即可。

ps：执行前需给予 hello.py 执行权限，chmod 755 hello.py

```python
#!/usr/bin/env python3 
print("hello,世界")
```



**三、内容编码**

python解释器在加载 .py 文件中的代码时，会对内容进行编码（默认ascill）

ASCII（American Standard Code for Information Interchange，美国标准信息交换代码）是基于拉丁字母的一套电脑编码系统，主要用于显示现代英语和其他西欧语言，其最多只能用 8 位来表示（一个字节），即：2**8 = 256，所以，ASCII码最多只能表示 256 个符号。

显然ASCII码无法将世界上的各种文字和符号全部表示，所以，就需要新出一种可以代表所有字符和符号的编码，即：Unicode

Unicode（统一码、万国码、单一码）是一种在计算机上使用的字符编码。Unicode 是为了解决传统的字符编码方案的局限而产生的，它为每种语言中的每个字符设定了统一并且唯一的二进制编码，规定虽有的字符和符号最少由 16 位来表示（2个字节），即：2 **16 = 65536，
注：此处说的的是最少2个字节，可能更多

UTF-8，是对Unicode编码的压缩和优化，他不再使用最少使用2个字节，而是将所有的字符和符号进行分类：ascii码中的内容用1个字节保存、欧洲的字符用2个字节保存，东亚的字符用3个字节保存...

所以，python解释器在加载 .py 文件中的代码时，会对内容进行编码（默认ascill），如果是如下代码的话：

报错：ascii码无法表示中文

**四、注释**

　　当行注视：# 被注释内容

　　多行注释：""" 被注释内容 """

**五、执行脚本传入参数**

Python有大量的模块，从而使得开发Python程序非常简洁。类库有包括三中：

- Python内部提供的模块
- 业内开源的模块
- 程序员自己开发的模块

Python内部提供一个 sys 的模块，其中的 sys.argv 用来捕获执行执行python脚本时传入的参数

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
print(sys.argv)
```

**六、 pyc 文件**

执行Python代码时，如果导入了其他的 .py 文件，那么，执行过程中会自动生成一个与其同名的 .pyc 文件，该文件就是Python解释器编译之后产生的字节码。

ps：代码经过编译可以产生字节码；字节码通过反编译也可以得到代码。

**八、输入**

```
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 将用户输入的内容赋值给 name 变量
name = input("请输入用户名：")
# 打印输入的内容
print(name)
```

输入密码时，如果想要不可见，需要利用getpass 模块中的 getpass方法，即：

```
#!/usr/bin/env python
# -*- coding: utf-8 -*-
import getpass
# 将用户输入的内容赋值给 name 变量
pwd = getpass.getpass("请输入密码：")
# 打印输入的内容
print(pwd)
```



## 五、变量

### 1、变量的声明

python语言是动态语言

- 变量不需要事先声明
- 变量的类型不需要声明

每个变量在使用前都必须赋值，变量赋值以后该变量才会被创建。

在 Python 中，变量就是变量，它没有类型，我们所说的 `类型`是变量所指的内存中对象的类型。

等号（=）用来给变量赋值。

等号（=）运算符左边是一个变量名,等号（=）运算符右边是其指向的具体的值。

```
a = 1
a = '千锋'
```

### 2、变量命名规则

可以包含以下字符

- 大小写字母（a-z,A-Z）

- 变量名区分大小写; a 和 A 是不同的变量

- 数字（0-9）

- 下划线（_）

  ==**不可以以数字开头**==

### 3、变量命名潜规则

- 不要以单下划线和双下划线开头；如：_user或 __user
- 变量命名要易读；如：user_name,而不是username
- 不用使用标准库中(内置)的模块名或者第三方的模块名
- 不要用这些 Python 内置的关键字：

```python
>>> import keyword
>>> keyword.kwlist
['False', 'None', 'True', 'and', 'as', 'assert', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try', 'while', 'with', 'yield']

> 上面打印出来的数据在 Python 中被称为列表， 列表是 Python中一种数据结构。关于数据结构，后面的章节会详细说明。
>列表的都是 Python3 中的关键字。

#可以使用一下方法验证，返回 True 就是 Python 的关键字
>>> keyword.iskeyword('del')
True
>>>
```

### 4、变量赋值

python 中使用等号 `=` 对变量进行赋值,。

等号左边被称为变量名，等号右边称为变量的值，确切的说是对象

```python
n = 5
```

### 5、Python 中的变量是什么

在 python 中究竟该如何正确理解变量的赋值过程呢？

```python
s = 'hello'
```

以上的变量赋值，应该说成**把变量分配给对象更合理。**

`hello` 这个字符串对象会在内存中先被创建，之后再把变量名 `s` 分配给这个对象。



![page19image5508560.png](/page19image5508560.png) 



**所以要理解 Python 中的变量赋值，应该始终先看等号右边。**

**对象是在右边先被创建或者被获取**，在此之后左边的变量名才会被绑定到对象上，这就像为对象贴上了标签。

**变量名本质上是对象的标签或者说是对象的名字，当然一个对象可以有多个标签或者名字。**
比如： 张三 和 小张 指的都是同一个人

**请看下面的代码示例：**

```python
a = 1
b = a
a = 2
print(b)  # b 会是 ?
```

`a = 1` 时如下图：

![page20image5532224.png](/page20image5532224.png) 

`b = a` 时如下图:

![page20image5530976.png](/page20image5530976.png) 

`a = 2` 时如下图:

![page20image5531184.png](/page20image5531184.png) 

上面的 `b = a` 我们称它为 **传递引用**，此时对象会拥有两个名称(标签) ，分别是 `a` 和 `b`

### 6、变量的多元赋值

在 Python3 中你可以这样给变量赋值

```python
In [2]: x, y, z = 1, 2, 3

In [3]: x
Out[3]: 1

In [4]: y
Out[4]: 2

In [5]: z
Out[5]: 3
```

当然也可以这样

```python
In [10]: a, b, c = 'abc'

In [11]: a
Out[11]: 'a'

In [12]: b
Out[12]: 'b'

In [13]: c
Out[13]: 'c'
```

> 假如你需要对一个序列类型中的数据进行一一解开赋值，那就需要等号左边的变量名和序列类型数据中的元素个数相同。

> 这种多元赋值方式在 Python 中也可以称为元组解包。

### 7、Python 中对象(变量的值)都有三个特性

```python
# 唯一标识，是对象在内存中的整数表示形式，在 CPython 中可以理解为# 内存地址
# 可以用 id 这个函数查看 
id(10)    # 直接给一个对象
id(n)      # 给你变量名
# 类型， 对象都有不同的类型，用 type 这个函数查看
type(10)
type(n)
# 值，对象本身
10
```

## 六、运算符

### **1、算数运算**

```python
#!/usr/bin/python3
 
a = 21
b = 10
c = 0
 
c = a + b
print ("c 的值为：", c)
 
c = a - b
print ("c 的值为：", c)
 
c = a * b
print ("c 的值为：", c)
 
c = a / b
print ("c 的值为：", c)
 
c = a % b
print ("c 的值为：", c)
 
# 修改变量 a 、b 、c
a = 2
b = 3
c = a**b 
print ("c 的值为：", c)
 
a = 10
b = 5
c = a//b 
print ("c 的值为：", c)
```

```python
c 的值为： 31
c 的值为： 11
c 的值为： 210
c 的值为： 2.1
c 的值为： 1
c 的值为： 8
c 的值为： 2
```

### **2、比较运算**

![img](/425762-20151025004535395-2018056438.png)

### **3、赋值运算**

![img](/425762-20151025004625020-515390534.png)

```python
#!/usr/bin/python3
a = 21
b = 10
c = 0
 
if ( a == b ):
   print ("a 等于 b")
else:
   print ("a 不等于 b")
 
if ( a != b ):
   print ("a 不等于 b")
else:
   print ("a 等于 b")
 
if ( a < b ):
   print ("a 小于 b")
else:
   print ("a 大于等于 b")
 
if ( a > b ):
   print ("a 大于 b")
else:
   print ("小于等于 b")
 
# 修改变量 a 和 b 的值
a = 5;
b = 20;
if ( a <= b ):
   print ("a 小于等于 b")
else:
   print ("a 大于  b")
 
if ( b >= a ):
   print ("b 大于等于 a")
else:
   print ("b 小于 a")
```

```python
1 - a 不等于 b
2 - a 不等于 b
3 - a 大于等于 b
4 - a 大于 b
5 - a 小于等于 b
6 - b 大于等于 a
```

### **4、逻辑运算**



```python
#!/usr/bin/python3
 
a = 10
b = 20
 
if ( a and b ):
   print ("变量 a 和 b 都为 true")
else:
   print ("变量 a 和 b 有一个不为 true")
 
if ( a or b ):
   print ("变量 a 和 b 都为 true，或其中一个变量为 true")
else:
   print ("变量 a 和 b 都不为 true")

# 修改变量 a 的值
a = 0
if ( a and b ):
   print ("变量 a 和 b 都为 true")
else:
   print ("变量 a 和 b 有一个不为 true")
 
if ( a or b ):
   print ("变量 a 和 b 都为 true，或其中一个变量为 true")
else:
   print ("变量 a 和 b 都不为 true")
 
if not( a and b ):
   print ("变量 a 和 b 都为 false，或其中一个变量为 false")
else:
   print ("变量 a 和 b 都为 true")
```

```python
1 - 变量 a 和 b 都为 true
2 - 变量 a 和 b 都为 true，或其中一个变量为 true
3 - 变量 a 和 b 有一个不为 true
4 - 变量 a 和 b 都为 true，或其中一个变量为 true
5 - 变量 a 和 b 都为 false，或其中一个变量为 false
```

### **5、成员运算**

![img](/425762-20151025004934286-1134210223.png)

```python
#!/usr/bin/python3
 
a = 10
b = 20
list = [1, 2, 3, 4, 5 ];
 
if ( a in list ):
   print ("变量 a 在给定的列表中 list 中")
else:
   print ("变量 a 不在给定的列表中 list 中")
 
if ( b not in list ):
   print ("变量 b 不在给定的列表中 list 中")
else:
   print ("变量 b 在给定的列表中 list 中")
 
# 修改变量 a 的值
a = 2
if ( a in list ):
   print ("变量 a 在给定的列表中 list 中")
else:
   print ("变量 a 不在给定的列表中 list 中")
```

```python
1 - 变量 a 不在给定的列表中 list 中
2 - 变量 b 不在给定的列表中 list 中
3 - 变量 a 在给定的列表中 list 中
```

## 七、流程控制语句

### 1、判断

基本的语法格式:

```python
#if 条件语句:   # 注意这里必须以英文的冒号结束
#    条件语句为真时，执行的语句
n = input("输入数字>>:")
n = int(n)    # input 接收到的数据，都是字符串类型
if n == 5:
    print('相等')
n = input("输入数字>>:")
n = int(n)
if n == 5:
    print('相等')
else:               # else 后边必须有英文的冒号
    print('No')
    
#_*_ coding:utf-8 _*_
n = input("输入数字>>:")
# 必须输入数字来测试
if not n:           # 如果为空
    print("空值")    # 输出 空值
else:    #否则
    n = int(n)       # n 转化为整型
    if n == 5:       # 如果等于5
        print('ok')    # 输出ok
    elif n > 5:        # 如果 大于5
        print('大了')  # 输出大了
    else:               # 否则
        print('小了')   #输出小了
```

### 2、嵌套

```python
n = input("输入数字>>:")
if n.isdigit():
    f_n = int(n)
    if f_n == 5:
        print('ok')
    elif f_n > 5:
        print('大了')
    else:
        print('小了')
else:
    print('请输入数字')
```

### 3、循环

```python
while True:
    n = input("输入数字>>:")
    n = int(n)
    if n == 5:
        print('相等')
        break
    elif n > 5:
        print('大了')
    else:
        print('小了')
```

### 4、迭代

- 什么是迭代

​      迭代 是重复反馈过程的活动，其目的通常是为了接近并到达所需的目标或结果。

​      每一次对过程的重复被称为一次“迭代”。

- for 循环（英语：for loop）

​    是一种编程语言的迭代陈述，能够让程式码反复的执行。

​    它跟其他的循环，如while循环，最大的不同，是它拥有一个循环计数器。

​    这使得for循环能够知道在迭代过程中的执行顺序,记住上次被循环元素的位置。

```python
for i in 'hello world':
    print(i)
```

**range(n)**

产生一个可被循环的整数序列，默认序列的元素从 零 开始

产生的元素数量是 `n`  个

```python
for i in range(5):
    print(i)
```

**break 和 continue**

```python
for i in range(0, 10):
    print(i)
    if i < 3:
        inp_num = int(input(">>:").strip())
        # inp_num = int(inp_num)
        if inp_num == 15:
            print('You get it')
            break
        elif inp_num > 15:
            print("高了")
        else:
            print("低了")
    else:
        print("Game over")
        break
for i in range(2, 10, 2):
    print("循环到", i)
    if i == 4:
        continue
    print(i)
    if i == 6:
        break
```

> `range(开始索引号:结束索引号:步长)`
> 其道理和切片一样
>
> 

### 5、扩展知识

**for  …  else**

•1. 当  for  循环体正常执行完毕时，再执行一下 else 后面的代码

•2. 当  执行了 break  后，就不再执行 else 后面的代码了

```python
for i in range(2):
    if i == 10:
        print('get it')
        n = i
        break
else:
    print("Nothing")
```

### 6、作业

1、使用while循环输入 1 2 3 4 5 6     8 9 10

```
i = 0
while i < 10:
    i +=1
    if i == 7:
        continue
    print(i)
```

2、求1-100的所有数的和

```
sum = 0 
for i in  range(1,101):
    sum += i
    i +=1
    print(sum)
```

3、输出 1-100 内的所有奇数

```
for i in range(1,101):
    n = i % 2
    if n == 1:
        print("奇数:" i)
        i +=1
```

4、输出 1-100 内的所有偶数

```
for i in range(1,101):
    n = i%2
    if n == 0:
        print("偶数:" i)
        i +=1
```

5、求1-2+3-4+5 ... 99的所有数的和

```
sum  = 0 
for i in range(1,101):
    if i % 2 == 1:
        #sum = sum + (i+1)
        sum +=i+1
        #print(sum)
    if i % 2 == 0:
        sum -=i+1
        #print(sum)
print(sum)
```

6、用户登陆（三次机会重试）

```
user = 'root'
pas = 'root' 
i = 3
while i > 0:
    n = input("user: ")
    u = input("password: ")
    n = str(n)
    u = str(u)
    if n == user:
        if u == pas:
            print("Login Successful")
            break
    else:
        i -=1
        print("Login Failed, You have ",i, "times!!!" )
```

7、猜数游戏

要求：

1. 提示用户输入一个数字    inp =     input()
2. 判断用户输入的值是否等于 18    == inp
3. 允许用户尝试 3 次
4. 假如 3 次机会都没有猜对，就再次提示用户是否继续
5. 用户输出 `y` ,就再给 3 次机会。 输入 `n` 则退出游戏

```
i = 3
while i > 0:
    inp = input("please input a number:")
    inp = int(inp)
    if inp == 18:
        print("you vary so good!!!")
        break
    else:
            i -=1
            print("you have ",i , "times" )
            inp1 = input("Whether to continue? y/n ")
            inp1 = str(inp1)
            if inp1 == "y":
                print("Come on!!!")
            elif inp1 == "n":
                print("Welcome next time!!!")
                break
```

