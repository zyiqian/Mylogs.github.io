# zabbix监控centos7内存使用率及CPU使用率

### 一、环境介绍

- zabbix-3.4 
- centos7.2

### 二、监控内存的使用率

#### 1、计算方式

使用率=( (总(total) — 可用的(avaliable) )  /  总(total)  )*100

```
100*(last("vm.memory.size[total]")-last("vm.memory.size[available]"))/last("vm.memory.size[total]")
```

#### 2、先定义一个总内存监控项

可以先去服务器端测试参数是否可用

```
[root@localhost Mylogs.github.io]# zabbix_get -s 192.168.78.88 -p 10050 -k "vm.memory.size[total]"

4127145984

```



![](https://i.loli.net/2019/09/28/GpVM9URIjOnaYih.jpg)





#### 3、再定义一个可用内存的监控项



![](https://i.loli.net/2019/09/28/cSTket1Kz3wNYOQ.jpg)



#### 4、最后定义一个内存使用率的监控项

![](https://i.loli.net/2019/09/28/9V56kW7nJQjeKRv.jpg)



**都启动即监控项创建完成**

![](https://i.loli.net/2019/09/28/YWBAikFJQyewRqC.jpg)



**下面我们再创建一个使用率的触发器**

![](https://i.loli.net/2019/09/28/BeaXdyQVYf694xv.jpg)



#### 5、vm.memory.size的一些相关参数

- **total** - 总物理内存.
- **free** - 可用内存.
- **active** - 内存当前使用或最近使用，所以它在RAM中。
- **inactive** - 未使用内存.
- **wired** - 被标记为始终驻留在RAM中的内存，不会移动到磁盘。
- **pinned** - 和'wired'一样。
- **anon** - 与文件无关的内存(不能重新读取)。
- **exec** - 可执行代码，通常来自于一个(程序)文件。
- **file** - 缓存最近访问文件的目录。
- **buffers** - 缓存文件系统元数据。
- **cached** - 缓存为不同事情。
- **shared** - 可以同时被多个进程访问的内存。
- **used** - active + wired 内存。
- **pused** - active + wired 总内存的百分比。
- **available** - inactive + cached + free 内存。
- **pavailable** - inactive + cached + free memory 占'total'的百分比。

### 三、监控CPU的使用率 

#### 1、添加一个监控项

![](https://i.loli.net/2019/09/28/mYACqtorxlyOfW8.jpg)

#### 2、再添加一个触发器

**让他最后一个值大于85就触发这个触发器**



![](https://i.loli.net/2019/09/28/7Ent8kDNewzKWhH.jpg)



![](https://i.loli.net/2019/09/28/HRUx7Izms5vLYQT.jpg)











