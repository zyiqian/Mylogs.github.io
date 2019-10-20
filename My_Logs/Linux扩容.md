### Linux扩容

对/dev/mapper/cl-root扩容

下面的是我扩容过的,之前是17G，扩容了30G

![](https://i.loli.net/2019/10/19/3kpXqogt9xu87fZ.jpg)

首先添加一个磁盘

![](https://i.loli.net/2019/10/19/qBOfVHv2dtDUWis.jpg)

对新增的硬盘空间做新增分区 

fdisk /dev/sdb

没有分区的

![](https://i.loli.net/2019/10/19/16wpVhGSQrm7nef.jpg)

![](https://i.loli.net/2019/10/19/GRvTw7aFW6pY512.jpg)

![](https://i.loli.net/2019/10/19/7ciUJxIbst1eQhl.jpg)

![](https://i.loli.net/2019/10/19/O5jqYNvncfyAhHb.jpg)



然后重启系统 reboot

在新磁盘上创建xfs文件系统     mkfs.xfs /dev/sdb1

![](https://i.loli.net/2019/10/19/SGp86wxfX7jvFat.jpg)

然后创建vg

![](https://i.loli.net/2019/10/19/jwCoOlEaL2JvGmt.jpg)

![](https://i.loli.net/2019/10/19/41iDXZOy8lPTV53.jpg)



VG加入LV  下面的“+7679”来自于vgdisplay命令的Free PE/Size字段 

/dev/cl/root”来自于lvdisplay命令的LV Path字段。 

![](https://i.loli.net/2019/10/19/nAPcYvmrL3UzQsg.jpg)



调整文件系统大小，本例中是xfs文件系统使用xfs_growfs命令调整 

​    xfs_growfs /dev/cl/root

![](https://i.loli.net/2019/10/19/GimJyr2YdlBSuXM.jpg)

然后就完成了

![](https://i.loli.net/2019/10/19/ICPA2qb9nwoesdF.jpg)

