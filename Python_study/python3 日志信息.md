# python3 日志信息

### 日志模块  logging

- 日志级别

```python
import logging
# 5个级别，从上到下
logging.debug('调试模式')
logging.info('详细信息')
logging.warning('警告信息')
logging.error('错误信息')
logging.critical('严重错误')
```

- 配置日志文件

```python
import logging
logging.basicConfig(filename='access.log',level=logging.DEBUG,format='%(asctime)s %(message)s',datefmt='%Y-%m-%d %H:%M:%S')
#basicConfig 方法对日志进本信息进行配置，文件名、日志级别、输出格式等，但必须以key-value形式使用
logging.debug('调试模式') # 上方设置中为debug，所以会打印所有信息，默认不低于设置级别
logging.info('详细信息')
logging.warning('警告信息')
```

- format自定义格式

```python
%(levelno)s	数字形式的日志级别
%(levelname)s	文本形式的日志级别
%(pathname)s	调用日志输出函数的模块的完整路径名，可能没有
%(filename)s	调用日志输出函数的模块的文件名
%(module)s	调用日志输出函数的模块名
%(funcName)s	调用日志输出函数的函数名
%(lineno)d	调用日志输出函数的语句所在的代码行
%(created)f	当前时间，用UNIX标准的表示时间的浮 点数表示
%(relativeCreated)d	输出日志信息时的，自Logger创建以 来的毫秒数
%(asctime)s	字符串形式的当前时间。默认格式是 “2003-07-08 16:49:45,896”。逗号后面的是毫秒
%(thread)d	线程ID。可能没有
%(threadName)s	线程名。可能没有
%(process)d	进程ID。可能没有
%(message)s	用户输出的消息
```

- ## 日志与控制台同时输出

  **Python 使用logging模块记录日志涉及四个主要类，使用官方文档中的概括最为合适：**

  - logger提供了应用程序可以直接使用的接口；
  - handler将(logger创建的)日志记录发送到合适的目的输出；
  - filter提供了细度设备来决定输出哪条日志记录；
  - formatter决定日志记录的最终输出格式

  ### 一个同时输出到屏幕、文件的完成例子

  可按以下步骤进行创建

  1. 生成logger对象
  2. 生成handler 对象
  3. 把handler 对象绑定到logger对象
  4. 生成formatter 对象
  5. 将formatter对象绑定到handler对象

```python
# -*- coding:utf-8 -*-

import logging


def logger(log_obj):

    logger = logging.getLogger(log_obj)
    logger.setLevel(logging.INFO)

    console_handle = logging.StreamHandler()

    log_file = "access.log"
    file_handle = logging.FileHandler(log_file)
    file_handle.setLevel(logging.WARNING)

    formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s')

    console_handle.setFormatter(formatter)
    file_handle.setFormatter(formatter)

    logger.addHandler(console_handle)
    logger.addHandler(file_handle)

    return logger
```

### 日志文件截取

- 按照大小截取
  logging.handlers.RotatingFileHandler()
  当文件达到一定大小之后，它会自动将当前日志文件改名，然后创建 一个新的同名日志文件继续输出。比如日志文件是chat.log。当chat.log达到指定的大小之后，RotatingFileHandler自动把 文件改名为chat.log.1。不过，如果chat.log.1已经存在，会先把chat.log.1重命名为chat.log.2。。。最后重新创建 chat.log，继续输出日志信息。它的函数是：

RotatingFileHandler( filename[, mode[, maxBytes[, backupCount]]])
其中filename和mode两个参数和FileHandler一样。

maxBytes用于指定日志文件的最大文件大小。如果maxBytes为0，意味着日志文件可以无限大，这时上面描述的重命名过程就不会发生。

backupCount用于指定保留的备份文件的个数。比如，如果指定为2，当上面描述的重命名过程发生时，原有的chat.log.2并不会被更名，而是被删除。

- 按照时间截取
  logging.handlers.TimedRotatingFileHandler()
  这个Handler和RotatingFileHandler类似，不过，它没有通过判断文件大小来决定何时重新创建日志文件，而是间隔一定时间就 自动创建新的日志文件。重命名的过程与RotatingFileHandler类似，不过新的文件不是附加数字，而是当前时间。它的函数是：

TimedRotatingFileHandler( filename [,when [,interval [,backupCount]]])
其中filename参数和backupCount参数和RotatingFileHandler具有相同的意义。

interval是时间间隔。

when参数是一个字符串。表示时间间隔的单位，不区分大小写。它有以下取值：

S 秒
M 分
H 小时
D 天
W 每星期（interval==0时代表星期一）
midnight 每天凌晨

- 代码实现如下:

```
# -*- coding:utf-8 -*-

import logging
from logging import handlers


logger = logging.getLogger(__name__)

log_file_size = "sizelog.log"
log_file_time = "timelog.log"
file_handler_size = logging.handlers.RotatingFileHandler(filename=log_file_size,maxBytes=10,backupCount=3)

file_handler_time = logging.handlers.TimedRotatingFileHandler(filename=log_file_time,when="S",interval=5,backupCount=3)


formatter = logging.Formatter('%(asctime)s %(module)s:%(lineno)d %(message)s')

file_handler_size.setFormatter(formatter)
file_handler_time.setFormatter(formatter)

logger.addHandler(file_handler_size)
logger.addHandler(file_handler_time)

logger.warning("test1")
logger.warning("test12")
logger.warning("test13")
```