### Python_邮件报警需求

- 将 dingding.py 和 mail.py 这两个文件 封装成两个类或函数 放在同一个文件中
- 将 hello.py 和 hello.py.bak2 两个文件内容封装成一个功能，使其能将数据推送到上述任意方法中
- 登录pass.html时，将登录信息（账号，密码，时间）发送到dingding或企业
   微信中。

#### 一、第一题。

```
首先导入包
cd /var/www/
把里面默认的文件删除或者备份一份
rm -rf /var/www/*
rz
Python-web.tar.gz   //老师发的
tar -xzvf Python-web.tar.gz
然后把python_web目录里面的文件copy一份出来
cp -r python_web/* ./

把 httpd.conf 复制到 /etc/httpd/conf/
先备份原来的
mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
cp httpd.conf /etc/httpd/conf/

进入cgi-bin/目录
cd cgi-bin/

将 dingding.py 和 mail.py 这两个文件 封装成两个类或函数 放在同一个文件中
要创建一个新文件
touch DingAndMail.py
vim DingAndMail.py

写入两个文件
:r ./dingding.py
:r ./mail.py

然后整理下代码 把import的包都放在开头
修改mail函数里面的调用sendmail那
server.sendmail([f'{from_add}'], [f'{for_add}', ], msg.as_string())

最终修改成下面样子
#!/usr/local/python3/bin/python3
# -*- coding: utf-8 -*-
import requests
import json
import sys
import os
import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr

class dingAndmail():
    #钉钉报警
    def __init__(self):
        headers = {'Content-Type': 'application/json;charset=utf-8'}
        api_url = "https://oapi.dingtalk.com/robot/send?access_token=be23b17553cede786108980257a259e5d4704d7db37d3df19585866d02354f8c"

        def msg(text):
            json_text = {
                "msgtype": "text",
                "at": {
                    "atMobiles": [
                        "all"
                    ],
                    "isAtAll": False
                },
                "text": {
                    "content": text
                }
            }
            return requests.post(api_url, json.dumps(json_text), headers=headers).content
    def mail(strd,sbj,from_add,for_add):
        msg = MIMEText(strd, 'plain/text', 'utf-8')
        msg['From'] = formataddr(["newrain", '{}'.format(from_add)])
        msg['To'] = formataddr(["me", '{}'.format(for_add)])
        msg['Subject'] = f"{sbj}"

        server = smtplib.SMTP("smtp.sina.com", 25)
        server.login("hackerlionz@sina.com", "afdfafsas****")  //新浪账号  授权码
        server.sendmail([f'{from_add}'], [f'{for_add}', ], msg.as_string())
        server.quit()


```

#### 二、第二题。

```
需求将 hello.py 和 hello.py.bak2 两个文件内容封装成一个功能，使其能将数据推送到上述任意方法中

1、修改hello.py文件
先把原来的备份一份 
cp hello.py hello.py.bak
vim hello2.py
把里面调用钉钉功能的函数都注释掉
#import dingding
#dingding.msg(f'{sbj},{from_add},{for_add},{strd}')
导入刚封装好的包
import DinAndMail
将 hello.py 和 hello.py.bak2 两个文件内容封装成一个功能
查看这两个文件发现有很多代码都是重复的 所以我们可以将其相同部分代码封装成一个函数，然后调用即可
2、封装输出html代码段
def send():
    print("Content-type:text/html")
    print()
    print("<html>")
    print("<head>")
    print("<meta charset=\"utf-8\">")
    print("<title>GET</title>")
    print("</head>")
    print("<body>")
    print("<h2>已成功发送</h2>")
    print("</body>")
    print("</html>")
    
然后再写个mail函数和一个dingding的函数，前面一定要导入刚包装好的DinAndMail包
def mail():
    DinAndMail.dingAndmail.mail(sbj=sbj, from_add=from_add, for_add=for_add, strd=strd)

def dindding():
    DinAndMail.dingAndmail.msg(sbj=sbj, from_add=from_add, for_add=for_add, strd=strd)

DinAndMail是刚刚封装好的包 dingAndmail 是包下面的class类mail 、msg是类下面的函数

然后调用函数即可，我这里是调用mail邮件的函数
# msg() 调用dingding的 
mail()
send()

这是全部代码
#!/usr/local/python3/bin/python3
# -*- coding: UTF-8 -*-

import cgi, cgitb
#import dingding
import DinAndMail


# 创建FieldStorage的实例化
form = cgi.FieldStorage()
#获取html页面传递过来的数据值
sbj = form.getvalue('data1')
from_add = form.getvalue('data2')
for_add = form.getvalue('data3')
strd = form.getvalue('data4')
#sbj='hello world'
#from_add='newrain_wang@163.com'
#for_add='newrain_wang@126.com'
#strd='你好'

#dingding.msg(f'{sbj},{from_add},{for_add},{strd}')

#DinAndMail.dingAndmail.mail(sbj=sbj,from_add=from_add,for_add=for_add,strd=strd)
def send():
    print("Content-type:text/html")
    print()
    print("<html>")
    print("<head>")
    print("<meta charset=\"utf-8\">")
    print("<title>GET</title>")
    print("</head>")
    print("<body>")
    print("<h2>已成功发送</h2>")
    print("</body>")
    print("</html>")
def mail():
    DinAndMail.dingAndmail.mail(sbj=sbj, from_add=from_add, for_add=for_add, strd=strd)

def dindding():
    DinAndMail.dingAndmail.msg(sbj=sbj, from_add=from_add, for_add=for_add, strd=strd)
mail()
send()

然后修改index.html文件里面的跳转路径使它跳转到hello2.py这
vim /var/www/html/index.html
修改成hello2.py
 <form action="../cgi-bin/hello2.py" method="get">

3、给www文件夹下所有文件赋予权限
chown -R 777 /var/www/*
chmod -R apache.apache /var/www/*

4、启动Apache 
systemctl start httpd
5、访问 
发送地址填你刚刚配的授权那个邮箱的账号
收件可以填写自己QQ号
```



#### 三、第三题。

```
登录pass.html时，将登录信息（账号，密码，时间）发送到dingding或企业
微信中。

要发送到钉钉或者企业微信就要调用其相关的接口
我这里是用企业微信的
1、首先导入一个企业微信接口包   //老师发过
 cd /var/www/cgi-bin/
 vim  QiYe.py       //没有直接复制下面的，修改自己的ID号之类的，打星号的地方
#!/usr/bin/python3
#-*-coding: utf-8-*-
# by Mr Zhong

import json
import sys
import time
import requests
import subprocess

# 此为企业的ID号
CorpID = 'ww2164c0740d*******'

# 应用的ID
Agentid = 100*******

# 认证信息，企业ID+认证信息可获取tokent，获取之后向此tokent发送内容
Secret = 'AQz-cJPhwRICfaihS2v7zkYehTAJ8**********'

localtime = time.strftime("[%H:%M:%S]", time.localtime())
class Tencent(object):
    def __init__(self,user,title,msg):
        # 格式化输出内容：标题+内容
        self.MSG = f'{title}\n{msg}\n{localtime}'
        self.User = user
        self.url = 'https://qyapi.weixin.qq.com'
        self.send_msg = json.dumps({
            "touser": self.User,
            "msgtype": 'text',
            "agentid": Agentid,
            "text": {'content': self.MSG},
            "safe": 0
        })
    # 获取tokent
    def get_token(self):
        token_url = '%s/cgi-bin/gettoken?corpid=%s&corpsecret=%s' % (self.url, CorpID, Secret)
        r = requests.get(token_url)
        r = r.json()
        token = r['access_token']
        return token

    # 发送信息
    def send_message(self):
        send_url = '%s/cgi-bin/message/send?access_token=%s' % (self.url,self.get_token())
        respone = requests.post(url=send_url, data=self.send_msg)
        respone = respone.json()
        x = respone['errcode']
        if x == 0:
            print ('Succesfully')
        else:
            print ('Failed')
            
2、然后修改passwd.py
vim passwd.py
导入上面封装好的包
import QiYe
由于需求中要发送时间，所以要用到时间模块
import datetime
#获取当前时间
curr_time = datetime.datetime.now()
curr_time.date()
time_str = datetime.datetime.strftime(curr_time,'%Y-%m-%d %H:%M:%S')
等下直接调用 time_str即可

整体代码

#!/usr/local/python3/bin/python3
# -*- coding: UTF-8 -*-

import cgi, cgitb
#import dingding
import QiYe
import datetime
# 创建FieldStorage的实例化
form = cgi.FieldStorage()
#获取当前时间
curr_time = datetime.datetime.now()
curr_time.date()
time_str = datetime.datetime.strftime(curr_time,'%Y-%m-%d %H:%M:%S')
#获取html页面传递过来的数据值
login = form.getvalue('data1')
passwd = form.getvalue('data2')
s = open('./success.txt','r')
e = open('./error.txt','r')
if login == 'test':
        if passwd == '123456':
                print(s.read())
                #dingding.msg(f'{login}已登录')
                send_obj = QiYe.Tencent('ZhongYiQian', '登录信息', f'时间:{time_str}\n用户: {login} 已登录\n密码:{passwd}')
                send_obj.send_message()
else:
        print(e.read())

3、重启Apache
systemctl restart httpd
访问 192.168.78.88/pass.html
账号：test
密码：123456
```

