## 十五、面向对象编程介绍

### 1、什么是对象和类

#### 1、从现实世界说起

##### a、什么是对象

现实世界中，任何一个可见，可触及的物体都可以成为对象。

比如说一辆汽车，一个人，都可以称为对象。

那每个对象都是有属性和功能(或者说技能)的。
比如：
一辆汽车的属性有：

> - 重量
> - 具体的大小尺寸
> - 车身颜色
> - 价格

一辆汽车的功能有:

> - 行驶
> - 载人

##### b、什么是类

什么又是类呢？

听人们常说，**物以类聚，人以群分**。

从字里行间不难看出，类就是具体很多对象共有属性和共有功能的抽象体。

这个抽象体，只是一个称谓，代表了具有相同属性和功能的某些对象。

比如，具体的一辆汽车是一个对象，红色汽车就是这些具有红色车身的汽车的统称，红色汽车就是一个类了。

相关的例子还有很多，比如 蔬菜是一个类，一个具体的茄子是属于蔬菜这个类的。

> 现实世界中是先有对象后有类的。

#### 2、回到计算机的世界

在计算机的代码中要表示对象的属性就是使用变量名 和数据的绑定方式。
如 `color = 'red'`

那要表示对象的功能(或者说技能)，在计算机的代码中是用函数实现的。这里的函数会被称为对象的 `方法`

计算机世界中是先有类，后有对象的。

> 就像建造一栋楼房，需要先有图纸，之后按照这个图纸建造房子。
> 在计算机语言中，都是先创建一个类，给这个类定义一些属性和方法。之后通过这个类去实例化出一个又一个的对象。

#### 3、什么是面向对象的编程

先说编程，个人理解，编程就是利用编程语言书写代码逻辑，来描述一些事件，在这个过程中会涉及到具体对象，具体的条件约束，以及事件的结果。

比如，现实世界中的一件事，鲨鱼学开车。

> 鲨鱼是我的网名 `^_^`

这里涉及到的对象有

- 车
- 教练
- 鲨鱼
- 道路

涉及到的技能有

- 车 ：
  - 行驶
- 教练 ：
  - 开车
  - 教学员学开车
- 鲨鱼：
  - 学习开车

当然所涉及到的东西，不止上面的这些，这里只是简单举例，表明原理即可。

假如想表述鲨鱼学开车这件事。

```python
鲨鱼跟着教练学习开车技能，使用的是绿色吉普汽车，之后他学会了开车。
```

很简单是吧，但是，要在计算机中体现出来该怎么办呢？

```python
1 先定义每个对象的类，在类里定义各自对象的属性和方法

2 通过类把对象创建处来，这个创建的过程成为实例化，实例化的结果成为这个类的一个实例，当然这个实例也是一个对象，一切皆对象嘛。

3 利用实例的方法互相作用得到事件单结果。
```

从最后一条不难发现， 每个对象的方法可以和其他对象进行交换作用的，从而也产生了新的结果。

这种用对象的方法和属性去相互作用来编写代码的逻辑思维或者说是编写代码的风格就是面向对象的编程了。

面向对象编程 Object Oriented Programming 简称 OOP，是一种程序设计思想。

OOP把对象作为程序的基本单元，一个对象包含了数据和操作数据的函数。

面向对象的程序设计是把计算机程序视为一组对象的集合，而且每个对象都可以接收其他对象发过来的消息，并处理这些消息，计算机程序的执行就是一系列消息在各个对象之间传递。这就是对象之间的交互。

### 2、Python 中一切皆对象

你可能听说过，在 Python 中一切皆对象。

在python中，一切皆对象。数字、字符串、元组、列表、字典、函数、方法、类、模块等等都是对象，包括你的代码。

之前也提到过，Python 中的对象都有三个特性

- **id**
  标识了一个对象的唯一性，使用内置函数 `id()` 可以获取到
- **类型**
  表明了这个对象是属于哪个类， 使用内置函数 `type()` 可以获取到
- **值**
  就是这个对象的本身，可以使用内置函数 `print()` 看到，这个看到的是 Python 让你看到的一个对象特有的表现方式而已。

### 3、创建类

使用关键字 `class` 创建一个类。

类名其实和之

前我们说的使用变量名的规则一样。

但是这里有一点儿要注意，就是类名的第一个字母需要大写，这是规范。

```python
class Foo:
    pass
class Car():
    color = 'red'    # 属性
    def run(self):   # 方法 
        pass
self 指的是类实例对象本身(注意：不是类本身)。

class Person:
    def __init__(self,name):
        self.name=name
    def sayhello(self):
        print('My name is:',self.name)
        
p = Person('luoyinsheng')
p.sayhello()
print(p)

class Person:
    def __init__(self,name,age):  #构造函数
        self.name=name
        self.age=age
    def sayhello(self):
        print('My name is:',self.name)
    def age1(self):
        print('is age',self.age)

p = Person('luoyinsheng','18')
p.sayhello()
p.age1()
print(p)
# 注意变量名和函数名不要重复

在上述例子中，self指向Person的实例p。 为什么不是指向类本身呢，如下例子：

class Person:
    def __init__(self,name,age):  #构造函数
        self.name=name
        self.age=age
    def sayhello(self):
        print('My name is:',self.name)
    def age1(self):
        print('is age',self.age)

p = Person('luoyinsheng','18')  # p的实例对象（p的self）
p.sayhello()
p.age1()

p1 = Person('test','18')  #p1的实例对象地址 （p1的self）
p1.sayhello()
p1.age1()

print(p)
print(p1)

如果self指向类本身，那么当有多个实例对象时，self指向哪一个呢？

总结
self 在定义时需要定义，但是在调用时会自动传入。
self 的名字并不是规定死的，但是最好还是按照约定是用self
self 总是指调用时的类的实例。
```

```python
#_*_ coding:utf-8 _*_
# 面向函数
def f1():
    print('name')

def f2(name):
    print('i am %s' % name)

f1()
f2('lili')

# 面向对象
class foo:
    def f1(self):
        print('name')

    def f2(self,name):
        print('i am %s' % name)

obj = foo()
obj.f1()
obj.f2('name')

```



### 4、实例化对象

使用 `类名()` 可以实例化一个对象，你可以使用给这个实例化的对象起一个名字。（根据类实例化对象）

定义类

```python
class Car():
    color = 'red'  # 属性
    def travel(self):   # 方法
        pass
```

实例化一个对象

```python
Car()  # 没有起名字

mycar = Car()  # 起了个名字 mycar
```

> 由类实例化出的对象成为这个类的一个实例

### 5、属性

类的属性分为类的数据属性（key=value）和函数属性

类的实例只有数据属性（key=value）

```python
class Person():
    city = "BeiJing"             # 类的数据属性
    def run(self):  # 类的函数属性
        pass
```

> 类属性可以被类和对象调用, 是所有对象共享的
>
> 实例属性只能由对象调用

### 6、对象的初始化方法 `__init__()`

对象的初始化方法是用于实例化对象时使用的。

方法的名称是固定的 `__init__()`

当进行实例化的时候，此方法就会自动被调用。

```python
# 类的封装
class Person():
    def __init__(self,name,age):  # 初始化方法
        self.Name = name
        self.Age = age

    def run(self):
        print('{} is running'.format(self.Name))
        
#_*_ coding:utf-8 _*_
# 面向函数
def fetch():
    #连接数据库，hostname，port ,user, pwd ,db,字符集，
    #打开数据连接
    #操作数据库链接
    #关闭
    pass

def modify():
    #连接数据库，hostname，port ,user, pwd ,db,字符集，
    #打开数据连接
    #操作数据库链接
    #关闭
    pass
def remove():
    #连接数据库，hostname，port ,user, pwd ,db,字符集，
    #打开数据连接
    #操作数据库链接
    #关闭
    pass
def create():
    #连接数据库，hostname，port ,user, pwd ,db,字符集，
    #打开数据连接
    #操作数据库链接
    #关闭
    pass

# 如果参数化也可以解决
def create(hostname,port ,user, pwd ,db):
    #连接数据库，hostname，port ,user, pwd ,db,字符集，
    #打开数据连接
    #操作数据库链接
    #关闭
    pass

# 面向对象
class foo:
    def __init__(self,hostname,port ,user, pwd ,db): #构造方法
        self.hostname = hostname
        self.port = port
        #...将所有的参数构造成方法
    def fetch(self):
        pass
    def modify(self,name):
        pass
    def create(self,name):
        # 连接 self.hostname,self.port  (直接调用构造函数的方法)
        pass
    def remove(self,name):
        pass

obj = foo(hostname,port,user,pwd,db)
obj.create()

# 类的执行流程（封装）
#1，解释器从上往下执行，将类读到内存里
#2，获取类的各种方法，没有创建对象
#3，创建一个foo对象obj，类对象指针（python一切都是对象，对象就有创建他的类）
#4，把值传给了构造函数，保存在了构造函数里
#5，通过类对象指针指向foo类，调用里面的方法（简单理解还是变量，把类和对象关联起来）

#类里面要公用的字段统一封装到构造函数里，统一调用

```

### 7、方法

凡是在类里定义的函数都都称为方法

方法本质上是函数，也是类的函数属性

```python
class Person():
    def run(self):  # 方法
        pass
    
    def talk(self):  # 方法 
        pass
#_*_ coding:utf-8 _*_
#游戏模式

#1、创建三个游戏人物，分别是：
#莎莎，女，18，初始战斗力1000
#浪浪，男，20，初始战斗力1800
#小爱，女，19，初始战斗力2500

# class Person:
#     def __init__(self, name, gen, age, fig):  # 构造函数
#         self.name = name
#         self.gender = gen
#         self.age = age
#         self.fight =fig
#
# #创建角色
# obj1 = Person('莎莎','女',18,1000)

...
# 内存里根据类，创建了3个对象，3个对象都指向同一个类
# 给游戏添加功能（聊天，打架）怎么添加
class Person:
    def __init__(self, na, gen, age, fig):
        self.name = na
        self.gender = gen
        self.age = age
        self.fight = fig

    def grassland(self):
        """注释：战斗，消耗200战斗力"""
        self.fight = self.fight - 200

    def practice(self):
        """注释：自我修炼，增长100战斗力"""
        self.fight = self.fight + 200

    def incest(self):
        """注释：多人游戏，消耗500战斗力"""
        self.fight = self.fight - 500

    def detail(self):
        """注释：当前对象的详细情况"""
        temp = "姓名:%s ; 性别:%s ; 年龄:%s ; 战斗力:%s" % (self.name, self.gender, self.age, self.fight)
        print(temp)

# 创建游戏角色
obj1 = Person('莎莎','女',18,1000)
obj1.grassland()
obj1.practice()
obj1.detail()

obj1 = Person('浪浪','男',18,2000)
obj1.grassland()
obj1.detail()

obj1 = Person('小爱','女',18,10000)
obj1.grassland()
obj1.detail()

#1, 通过obj2找到类，
#2，再通过类执行类里面的方法
#3，执行对应的方法，然后就是对自身属性的改变（减少增加）

# 面向对象模板的实现过程（函数式编程做不到）
# 通过面向对象的类先创建模板，通过模板创建多个角色，
# 然后多个角色再来执行模板里面的方法
# 将内存里对象的属性进行改变

```

方法可以被这个类的每个实例对象调用，当一个实例对象调用此方法的时候， `self` 会不自动传值，传入的值就是目前的 实例对象。

### 8、魔法函数`__str__()` 实现定义类的实例的表现形式

当我们定义一个类的时候，默认打印出它实例时是不易读的，某些情况下我需要让这个类的实例的表现形式更易读。就可以使用 `__str__()` 这个方法。

**使用前**

```python
class Person:
    def __init__(self, name):
        self.name = name

p = Person('shark')

print(p)
# <__main__.Person object at 0x10ac290f0>
    
```

**使用后**

```python
class Person:
    def __init__(self, name):
        self.name = name
        
    def __str__(self):
        return "{}".format(self.name)
p = Person('shark')

print(p)
# shark
```

> 其实，`__str__()` 方法本身在我们定义类的时候就已经存在了，是 Python 内置的。我们在这里只是有把这个方法重写了。
> 这个方法在使用的时候有**返回值**，且返回值必须是**字符串**类型

### 9、继承

在现实世界中，类的继承，表现为我们可以把一个类的共同的属性和方法再进行一个高度的抽象，成为另一个类，这个被抽象出来的类成为父类，刚才被抽象的类成为子类。

但在计算机中，需要先定义一个父类，之后再定义其他的类（子类）并且继承父类。

这时子类即使什么也不用做，就会具备父类的所以属性(数据属性和函数属性）。这在计算机语言中就被称为`继承`。 继承并不是 Python 语言特有的，而是所有面向对象语言都有的特性。

面向对象语言的特性还有另外两个: `多态`, `封装`。

`继承`、 `多态` 和 `封装` 被称为面向对象语言都三大特性。

这里我们先只对 `继承` 来讲解。

#### 1、单纯的继承

(菱形继承)

下面我是定义了两个类 `Person` 和 `Teacher`。

```python
Teacher 继承了 Person
```

`Teacher` 被称为子类， `Person` 就是父类

```python
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def run(self):
        print(f'{self.name} is running')
        
        
class Teacher(Person):
    pass

t = Teacher('shark', '18')
t.run()
```

#### 2、添加新方法

在继承的时候，子类可以定义只属于自己的方法。

```python
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def run(self):
        print(f'{self.name} is running')

class Teacher(Person):
    def talk(self):
        print(f"{self.name} is talking...")

t = Teacher('shark', '18')
t.talk()
```

#### 3、覆盖方法（方法重写）

在继承中，子类还可以把父类的方法重新实现一下。

就是定义一个和父类方法同名的方法，但是方法中代码不一样。

```python
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def run(self):
        print(f'{self.name} is running')


class Teacher(Person):
    def run(self):
        print(f"{self.name} running on the road")
        
    def talk(self):
        print(f"{self.name} is talking...")

t = Teacher('shark', '18')
t.run()
```

#### 4、添加属性

在继承时，子类还可以为自己的实例对象添加实例的属性。

```python
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def run(self):
        print(f'{self.name} is running')

class Teacher(Person):
    def __init__(self,name, age, lev):
        super().__init__(name, age)
        self.lev = lev


t = Teacher('shark', 18, 5)

print(t.lev)
```

### 10、对象之间的互相作用

王者农药

在一个类中的方法中，可以通过给其传递相应的参数，从而对其他类的的实例对象进行操作。

```python
#_*_ coding:utf-8 _*_
class Master:
    def __init__(self, name, age,init_self=516, mana=230, attack_num=100):
        self.name = name
        self.age = age
        self.init_self = init_self
        self.init_mana = mana
        self.attack_num = attack_num

    def attack(self, obj):
        self.init_mana = self.init_mana - 20  # 210
        #print(self.init_mana)
        obj_self_num = obj.init_self - self.attack_num  # 516-90=426
        obj.init_self = obj_self_num     #426
    def __str__(self):
        return "{}".format(self.init_mana)

class Soldier():
    def __init__(self, name, age,init_self=960, attack_num=90):
        self.name = name
        self.age = age
        self.init_self = init_self
        self.attack_num = attack_num

    def attack(self, obj):
        obj_self_num = obj.init_self - self.attack_num   #960-100=860
        obj.init_self = obj_self_num   #860
m = Master('貂蝉', 18)
print(m)

s = Soldier("阿轲", 30)
#s.attack()
# 貂蝉攻击 阿轲， 把被攻击的对象 s 作为实参传给 m 对象的方法 `attack`
m.attack(s)
s.attack(m)
# 验证
print(s.init_self)
print(m.init_self)
print(m.init_mana)
```

### 11、反射

#### 1、什么是反射？

说到反射，相信我们是经常使用浏览器的，在使用浏览器的时候最重要的也就是输入网址了，在浏览器的地址栏中输入对应的网址，对应的网站也就会有反应，并给你返回对应的网页。首相我们要知道，我们输入到浏览器地址栏的`url`是一个字符串，这个字符串的`url`到web服务器上后是怎么找到对应的代码函数并执行后给我们返回内容的。

说反射之前先介绍一下__import__方法,这个和import导入模块的另一种方式

```
import  commons
__import__('commons') 
```

如果是多层导入:

```
from list.text import commons 
__import__(' list.text.commons',fromlist=True) #如果不加上fromlist=True,只会导入list目录
```

反射即想到4个内置函数分别为:

getattr       获取成员

hasattr      检查成员

setattr       设置成员

delattr       删除成员

下面逐一介绍，先看例子：

```
#!/usr/bin/env python
# -*- coding:utf-8 -*-
class Foo(object):
 
    def __init__(self):
        self.name = 'abc'
 
    def func(self):
        return 'ok'
 
obj = Foo()
#获取成员
ret = getattr(obj, 'func')#获取的是个对象
r = ret()
print(r)
#检查成员
ret = hasattr(obj,'func')#因为有func方法所以返回True
print(ret)
#设置成员
print(obj.name) #设置之前为:abc
ret = setattr(obj,'name',19)
print(obj.name) #设置之后为:19
#删除成员
print(obj.name) #abc
delattr(obj,'name')
print(obj.name) #报错
```

#### 2、反射对模块的操作

```
#!/usr/bin/env python
# -*- coding:utf-8 -*-
 
"""
程序目录：
    home.py
    index.py
 
当前文件：
    index.py
"""
 
import home as obj
 
#obj.dev()
 
func = getattr(obj, 'dev')
func() 
```

#### 3、对于反射小节

```
1.根据字符串的形式导入模块。
2.根据字符串的形式去对象（某个模块）中操作其成员　
```

实例：基于反射实现类Web框架的路由系统

实现思路：规定用户输入格式 模块名/函数名 通过__import__的形式导入模块并通过 hasattr和getattr 检查并获取函数返回值

