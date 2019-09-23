概观
什么是MITMf？
链接：https：//github.com/byt3bl33d3r/MITMf

MITMf是中间框架中的人。

这是一个用Python编写的非常好的工具，能够使用多种方法执行中间人攻击（想想Bettercap但是用Python而不是Ruby实现，是的！）。

MITMf最好的部分是你可以使用Scapy处理数据包- 这样你就可以充分利用你已经掌握的所有知识库。

安装
在安装MITMf之前，您需要安装一堆aptitude包：

```
$ apt-get install python-dev python-setuptools libpcap0.8-dev libnetfilter-queue-dev libssl-dev libjpeg-dev libxslt1-dev libcapstone3 libcapstone-dev libffi-dev file
$ apt-get install libxml2-dev 
```


查看来自github的MITMf repo，并克隆git子模块：

```
$ git clone https://github.com/byt3bl33d3r/MITMf
$ cd MITMf && git submodule init && git submodule update --recursive
```


这在MITMf安装说明中提到：https：//github.com/byt3bl33d3r/MITMf/wiki/Installation

现在你需要安装一堆python包（从你签出的MITMf的git仓库执行它）：

```
$ pip install -r requirements.txt
```


如果仍遇到问题，请使用update标志运行：

```
$ pip install --update -r requirements.txt
```


这将确保您安装最新，最好的一切。

ImportError：没有模块命名为bdfactory
注意：如果您看到与bdfactory相关的导入错误，则表示您没有克隆git子模块。请仔细按照说明操作。

安装说明：https：//github.com/byt3bl33d3r/MITMf/wiki/Installation

```
$ git clone https://github.com/byt3bl33d3r/MITMf
$ cd MITMf && git submodule init && git submodule update --recursive
```

```
rm -f /usr/share/mitmf/plugins/filepwn.py 
```


使用虚拟环境安装
安装说明指定Kali Linux中Python中的系统站点包可能会导致冲突，作者建议使用virtualenv来安装和使用MITMf。

要在虚拟环境中执行以上所有操作：

```
$ pip install virtualenvwrapper
$ mkvirtualenv MITMf -p /usr/bin/python2.7
```


现在您可以下载/安装MITMf并将所有先决条件安装到虚拟环境中：

```
$ git clone https://github.com/byt3bl33d3r/MITMf
$ cd MITMf && git submodule init && git submodule update --recursive
$ pip install -r requirements.txt
$ python mitmf.py --help
```


测试和获得帮助
使用--help标志运行mitmf.py脚本以测试它是否正常工作并获得一些帮助：

```
$ python mitmf.py --help
```