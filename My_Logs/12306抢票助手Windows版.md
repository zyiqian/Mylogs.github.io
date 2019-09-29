### 12306抢票助手Windows版

**传送门：**<https://github.com/testerSunshine/12306> 

这种方式抢票也不过是比某平台那些充钱或者朋友圈点加速才能给你有点几率能抢到。只不过是把刷新

时间调高了点而已，然而用这种方式运行抢票，就是实时给你监控着，一有票就下单。所以理论上是比某些平台要高效得很多的。

PS：高峰期并不一定会抢得到票哦！！！！

#### 一、环境介绍

- Windows10 
- PyCharm 

​      下载地址:<http://www.jetbrains.com/pycharm/download/#section=windows> 

- Python 3.6.6 

  下载地址:https://www.python.org/ftp/python/3.6.6/python-3.6.6-amd64.exe

- Google Chrome   77.0.3865.90（正式版本)
- webDriver   [77.0.3865.10](http://chromedriver.storage.googleapis.com/index.html?path=77.0.3865.10/)  (尽量与谷歌版本接近)  解压好 等下配置文件需要用到其路径

		<http://chromedriver.storage.googleapis.com/index.html> 

#### 二、安装

PyCharm安装步骤略。百度一大堆

Python 3.6.6安装步骤略。

##### 1、**配置python环境 （重要）**

![](https://i.loli.net/2019/09/29/vstYI6dhagCzfo5.jpg)

![](https://i.loli.net/2019/09/29/BeOpEiIzjylSoRL.jpg)



![](https://i.loli.net/2019/09/29/67iXLrVHCdEZIsb.jpg)

![](https://i.loli.net/2019/09/29/96oMZAFzN3RG2lP.jpg)

**然后一项项确定**

打开命令行 (也可以使用快捷键 win+ R 输入cmd)

![](https://i.loli.net/2019/09/29/gBfOqjCVwsXZuno.jpg)

​        **输入 python  -V**

![1569759473734](C:\Users\MRZHON~1\AppData\Local\Temp\1569759473734.png)

显示python 3.6.6则表示安装成功了

##### 2、下载12306-master (主程序)

<https://github.com/testerSunshine/12306> 

![](https://i.loli.net/2019/09/29/ETUPqSl2O8MvoYi.jpg)

下载好解压出来，下面两个模块必须有 不然后面无法验证登录

```
如果没有则手动下载
PS: 
      1. 模型下载链接:https://pan.baidu.com/s/1rS155VjweWVWIJogakechA  密码:bmlm
         群里面也可以下载
      2. git仓库下载：https://github.com/testerSunshine/12306model.git 
```

![](https://i.loli.net/2019/09/29/enCAzkwb7mOVqhd.jpg)

然后安装一堆依赖包

```
在命令行中切换到12306-master目录下
G:     //切换硬盘
cd     //切换到目录下
pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt

如果报什么time之类的鬼英文 就重新又装
pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt
要确保requirements.txt里面的依赖包全都装上

出黄色那堆字体就执行
pip3 install --upgrade pip
报错就再执行一次  再把错截图给我

```

![](https://i.loli.net/2019/09/29/i6d4L9vhGXYZjPy.jpg)

![](https://i.loli.net/2019/09/29/bM2SYxHqJazonKv.jpg)

```
如果以上步骤都安装好了就执行这条命令
pip3 --version

G:\12306-master>pip3 --version
pip 10.0.1 from g:\python36\lib\site-packages\pip (python 3.6)

出现这个则表示安装完成
```







##### 3、打开Pycharm

导入12306-master项目

![](https://i.loli.net/2019/09/29/Omf4bE2tjeNcIhH.jpg)

![](https://i.loli.net/2019/09/29/jDocakAEl8qVrmQ.jpg)

**填写配置文件  也就是填写抢票的信息，**  

![](https://i.loli.net/2019/09/29/iK92gTQvdVe6qfD.jpg)

因为使用python写的里面的语法格式都限制很严格）

![](https://i.loli.net/2019/09/29/4fz6cuRXIerlVnK.jpg)

**这里比较重要！！！！！填写刚刚已经下好的webDriver的路径**

![](https://i.loli.net/2019/09/29/1Lue8PDIghr2Gji.jpg)

写好配置文件后可以启动了

![](https://i.loli.net/2019/09/29/UwxP7GsZ8BLRI1v.jpg)

然后它会报很多错误，没想到吧

```
前面的是路径....FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of
 numpy, it will be understood as (type, (1,)) / '(1,)type'.
 
 然后我们点击那个路径 每个错误都是一样 修改后面那个  , 1 修改成  (1,)  例如下图
```

![](https://i.loli.net/2019/09/29/LhJo4G6YbKayseU.jpg)

修改完成后再启动程序

下面这种警告不用管它

![](https://i.loli.net/2019/09/29/x3rLUjh64nYyvRm.jpg)



启动的时候它会自动弹出一个谷歌浏览器12306官网的窗口， 这个不用管 只是在自动登录

如果出现 302之类的错误 你就重新启动 然后再它弹出官网这个窗口的时候就手动登录12306官网

出现这些信息就已经好了

挂在后台让它慢慢跑

![](https://i.loli.net/2019/09/29/2FsTYXBqUxdtwLW.jpg)