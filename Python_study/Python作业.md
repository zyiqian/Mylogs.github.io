### Python作业

#### 一、监控CPU利用率、磁盘使用率以及内存使用率

- CPU利用率超过80%则发送信息报警
- 磁盘使用率超过80%则发送信息报警
- 内存使用率超过80%则发送信息报警

##### 1、首先先获取一下CPU的负载信息

```
[root@localhost ~]# uptime
 23:31:58 up 3 days, 13:07,  4 users,  load average: 0.15, 0.15, 0.17
截取后面三个获取平均值，它们分别是（一分钟负载，五分钟负载，十五分钟负载）
vim monitor.py
#!/usr/bin/python3
#-*-coding: utf-8-*-
# by Mr Zhong
#
##################################################
#先导入老师发的报警脚本
import json
import sys
import time
import requests
import subprocess

# 此为企业的ID号
CorpID = 'ww2164c0740d0df89b'

# 应用的ID
Agentid = 1000002

# 认证信息，企业ID+认证信息可获取tokent，获取之后向此tokent发送内容
Secret = 'AQz-cJPhwRICfaihS2v7zkYehTAJ8JUY9fyoF1HUzto'

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
##################################################

#下面开始自己定义报警信息
def monitor():
    #获取磁盘的使用量
    disk = subprocess.getoutput('df -Th')
    disk = disk.replace(',','').split()
    #获取内存的使用量
    Men = subprocess.getoutput('free -m')
    Men = Men.replace(',','').split()
    #获取内存总大小，这里需要转成int型的 因为后面要做运算
    mtotal = int(Men[7])
    #获取内存当前使用量
    mused = int(Men[8])
    #求出内存的使用率
    Mprc = mused * 100 / mtotal
    #print(mtotal,mused,Mprc,"%")
    #Men1 = (f"total:{int(Men[7])}\nused: {int(Men[8])}\n")
    #CPU的使用负载
    data = subprocess.getoutput('uptime')
    data = data.replace(',','').split()
    #cpu一分钟负载情况，这里转成float型为了后面做运算
    cpu = float(data[-3])
    #print(cpu)
    #cpu五分钟负载情况
    cpu2 = float(data[-2])
    #cpu十五分钟负载情况
    cpu3 = float(data[-1])
    #Cpu平均负载
    cpu_monitor = (cpu + cpu2 + cpu3) * 100 / 3
    #print(cpu_monitor)
    data = (f"CPU一分钟负载: {data[-3]}\nCPU五分钟负载: {data[-2]}\nCPU十五分钟负载: {data[-1]}\nCPU平均负载率:{cpu_monitor}%\n磁盘使用率:{disk[13]}\n内存使用率: {Mprc}%")
    print(data)
    #CPU使用率超过80%则发送信息报警
    if cpu_monitor > 10:
        if __name__ == '__main__':
            # 创建对象
            send_obj = Tencent('ZhongYiQian', 'Warning warning', 'CPU快要冒烟了，赶紧处理下！！！')
            # 调用发送函数
            send_obj.send_message()

    #磁盘使用率超过80%则发送信息报警
    if disk[13] > "60%":
        if __name__ == '__main__':
            # 创建对象
            send_obj = Tencent('ZhongYiQian', 'Warning warning', '保存学习资料的磁盘快满了，赶紧买块新的！！！')
            # 调用发送函数
            send_obj.send_message()
    #内存使用率超过80%则发送信息报警
    if Mprc > 10:
        if __name__ == '__main__':
            # 创建对象
            send_obj = Tencent('ZhongYiQian', 'Warning warning', '内存条要炸了！！！')
            # 调用发送函数
            send_obj.send_message()
monitor()


```

bash shell 方式

系统的使用情况

获取硬盘使用率：df -h |awk 'NR==2{print $5}'

获取CPU利用率：uptime

内存使用量used： free -m |awk '/^Mem/{print $3}'

内存总量total：free -m |awk '/^Mem/{print $2}'

内存使用率：(used/total)*100

