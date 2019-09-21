### ELK Stack简介

传送门：<http://www.liuwq.com/views/%E6%97%A5%E5%BF%97%E4%B8%AD%E5%BF%83/ELK%E6%A6%82%E5%BF%B5.html#%E9%9B%86%E4%B8%AD%E5%BC%8F%E6%97%A5%E5%BF%97%E7%AE%A1%E7%90%86> 

ELK stack 是以Elasticsearch、Logstash、Kibana三个开源软件为主的数据处理工具链，在于实时数据检索和分析场合，三个通常是配合使用

- L（logstash）作为作为信息收集者，主要是用来对日志的搜集、分析、过滤，支持大量的数据获取方式，一般工作方式为c/s架构，client端安装在需要收集日志的主机上，server端负责将收到的各节点日志进行过滤、修改等操作在一并发往elasticsearch上去。

- E=(elasticsearch): 主要是存储收集的日志数据用的，有点类似mongo的意思。Elasticsearch是一个实时分布式搜索和分析引擎。它让你以前所未有的速度处理大数据成为可能。

- K（Kibana）作为展示者，主要是将ES上的数据通过页面可视化的形式展现出来。包括可以通过语句查询、安装插件对指标进行可视化等。

#### 有什么用？

- 通过工作经验，迅速判断问题出在哪。
- 通过日志
- 系统日志：/var/log 目录下的问题的文件
- 程序日志： 代码日志（项目代码输出的日志）
- 服务应用日志
- nginx、HAproxy、lvs
- tomcat、php-fpm
- redis、mysql、mongo
- RabbitMq、kafka
- Glusterfs、HDFS、NFS等等
- 通过日志排除，发现问题根源解决问题

如果1台或者几台服务器，我们可以通过 linux命令，tail、cat，通过grep、awk等过滤去查询定位日志查问题

但是如果几十台、甚至几百台。通过这种方式肯定不现实。

怎么办？

一些聪明人就提出了建立一套集中式的方法，把不同来源的数据集中整合到一个地方。

一个完整的集中式日志系统，是离不开以下几个主要特点的。

- 收集－能够采集多种来源的日志数据
- 传输－能够稳定的把日志数据传输到中央系统
- 存储－如何存储日志数据
- 分析－可以支持 UI 分析
- 警告－能够提供错误报告，监控机制

##### 市场上的产品
基于上述思路，于是许多产品或方案就应运而生了

简单的 Rsyslog，Syslog-ng
商业化的 Splunk
开源的

- FaceBook 公司的 Scribe，
- Apache 的 Chukwa，
- Linkedin 的 Kafak，
- Cloudera 的 Fluentd，
- ELK

Splunk是一款非常优秀的产品，但是它是商业产品，价格昂贵，让许多人望而却步.

对于我们这些穷逼只能是使用开源的  ELK

### Elasticsearch

`Elasticsearch` 是一个实时的分布式搜索和分析引擎，它可以用于全文搜索，结构化搜索以及分析。它是一个建立在全文搜索引擎 `Apache Lucene`基础上的搜索引擎，使用`Java`语言编写

**主要特点**

- 实时分析
- 分布式实时文件存储，并将每一个字段都编入索引
- 文档导向，所有的对象全部是文档
- 高可用性，易扩展，支持集群（Cluster）、分片和复制（Shards 和 Replicas）。见图 2 和图 3
- 接口友好，支持 JSON

![](https://i.loli.net/2019/09/11/WHTNQx2SKVA89qa.jpg)

![](https://i.loli.net/2019/09/11/6uiNxRYjFlDhI5a.jpg)



### Logstash

Logstash 是一个具有实时渠道能力的数据收集引擎。使用 JRuby 语言编写。其作者是世界著名的运维工程师乔丹西塞 (JordanSissel)

#### 主要特点

- 几乎可以访问任何数据

- 可以和多种外部应用结合

- 支持弹性扩展

  ##### 它由三个主要部分组成，见图 4：

- Shipper－发送日志数据
- Broker－收集数据，缺省内置 Redis
- Indexer－数据写入

![](https://i.loli.net/2019/09/11/npLrTe458Du3k2g.jpg)

### Kibana

Kibana是一款基于 Apache开源协议，使用 JavaScript语言编写，为 Elasticsearch提供分析和可视化的 Web 平台。它可以在Elasticsearch的索引中查找，交互数据，并生成各种维度的表图

### Filebeat

ELK 协议栈的新成员，一个轻量级开源日志文件数据搜集器，基于 Logstash-Forwarder源代码开发，是对它的替代。在需要采集日志数据的 server 上安装Filebeat，并指定日志目录或日志文件后，Filebeat就能读取数据，迅速发送到Logstash进行解析，亦或直接发送到 Elasticsearch进行集中式存储和分析

### ELK 常用架构及使用场景介绍

#### 最简单架构

在这种架构中，只有一个 Logstash、Elasticsearch 和 Kibana 实例。Logstash 通过输入插件从多种数据源（比如日志文件、标准输入 Stdin 等）获取数据，再经过滤插件加工数据，然后经 Elasticsearch 输出插件输出到 Elasticsearch，通过 Kibana 展示 

![](https://i.loli.net/2019/09/11/AsXrd3qQhLKZuj5.jpg)

