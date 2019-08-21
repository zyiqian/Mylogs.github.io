#### 创建库             

​		    create database  库名；

​			  create database school;

#### 查看库              

​	                show databases;                  / show create database  库名；  (更详细)

#### 进入库           

​		        use  库名     use school;

#### 创建表	

show tables;           

 create table  表名(id      int       auto_increment primary key,name char(20) not null,age int);
                                 字段 类型   自动增长                  主键            字段    类型 (长度) 非空，字段  类型         (字段后便的就是字段的修饰符(约束条件))
     create table stu1(id int auto_increment primary key,name char(20) not null,age int);

#### 查看表

​                     (show   desc   select) 

show tables;(查看表名称)   /    desc   stu1 （查看表的详细字段信息）    /    select  * from stu1;（查看表记录）

```
mysql> show tables;
+------------------+
| Tables_in_scholl |
+------------------+
| stu              |
| stu1             |
| stu2             |
+------------------+
mysql> desc stu2;
+-------+---------------+------+-----+---------+----------------+
| Field | Type          | Null | Key | Default | Extra          |
+-------+---------------+------+-----+---------+----------------+
| id    | int(11)       | NO   | PRI | NULL    | auto_increment |
| name  | char(20)      | NO   |     | NULL    |                |
| sex   | enum('m','f') | YES  |     | NULL    |                |
| age   | int(3)        | YES  |     | NULL    |                |
+-------+---------------+------+-----+---------+----------------+
mysql> select * from stu1;
+----+-------+------+---------+-----+-------------+
| id | name  | age  | addr    | sex | tl          |
+----+-------+------+---------+-----+-------------+
|  1 | zhong |   21 | guangxi | m   | 13088792523 |
|  2 | zhang |   20 | guangxi | f   | 13088792523 |
+----+-------+------+---------+-----+-------------+
```

​     查看表名称      show tables;    desc  表名;(表的详细字段信息)      show create table   表名;    <-----当表特别长的时候；该为\G 可以更清楚看到               
     查看表结构      desc  表名；
     查看表记录      select   *   from  表名；     select   字段，字段  from  表名； 
     查看表状态      show  table status  like  '表名' \G

#### 修改表

​                    **alter、add 、 delect 、 change**

#####      修改表名        

​			rename table 原表名  to  新表名;   alter table 原表名 rename  to 新表名

```
mysql> rename table stu2 to stu3;
mysql> alter table stu3 rename to stu2;
```

#####      添加字段        

​		alter  table 表名  add  字段   修饰符;

mysql> alter table stu2 add tl char(11);

mysql> alter table stu2 add (addr char(30),smail char(15));

```
mysql> desc stu2;
+-------+---------------+------+-----+---------+----------------+
| Field | Type          | Null | Key | Default | Extra          |
+-------+---------------+------+-----+---------+----------------+
| id    | int(11)       | NO   | PRI | NULL    | auto_increment |
| name  | char(20)      | NO   |     | NULL    |                |
| sex   | enum('m','f') | YES  |     | NULL    |                |
| age   | int(3)        | YES  |     | NULL    |                |
+-------+---------------+------+-----+---------+----------------+
mysql> alter table stu2 add tl char(11);
mysql> desc stu2;
+-------+---------------+------+-----+---------+----------------+
| Field | Type          | Null | Key | Default | Extra          |
+-------+---------------+------+-----+---------+----------------+
| id    | int(11)       | NO   | PRI | NULL    | auto_increment |
| name  | char(20)      | NO   |     | NULL    |                |
| sex   | enum('m','f') | YES  |     | NULL    |                |
| age   | int(3)        | YES  |     | NULL    |                |
| tl    | char(11)      | YES  |     | NULL    |                |
+-------+---------------+------+-----+---------+----------------+

```

##### 删除字段 

​       alter   table  表名  drop  字段;  

```
mysql> alter table stu2 drop smail;
```

##### 修改字段        

alter table 表名 change  旧字段  新字段 修饰符;

```
mysql> alter table stu2 change addr addr1 char(20);
```

##### 修改记录                                         

​                     (inster  update  delete  where)

##### 添加记录 

insert  into  表名 values  (),(),(),();    

```
mysql> insert into stu2 values(2,"zhong","m",21,123,"gaungxi");
```

insert into  表名(字段，字段，字段)  values  (),(),(); 

```
mysql> insert into stu2(id,name) values(3,"zhang");
```

##### 修改记录（更新）   

​	update   表名  set 字段=' '(需要更新字段)   where   其他字段=' ';

```
mysql> update stu2 set name="keai" where id=3;
```

##### 删除记录        

 delete from  表名 where   其他字段=' '; 

```
mysql> delete from stu2 where id=3;
```

 delete from 表名; //删除表

mysql> delete from stu2;  //删除表中所有记录

##### 各种查询

删除表 drop tables  表名；

mysql> drop tables stu;

删除库  drop  database 库名； 

mysql> drop database test;



上月第一天 SELECT date_sub(date_sub(date_format(now(),'%y-%m-%d '),interval extract( day from now())-1 day),interval 1 month) 
本月第一天 select date_sub(date_sub(date_format(now(),'%y-%m-%d'),interval extract(  day from now())-1 day),interval 0 month) 
本周周五的日期 SELECT SUBDATE(CURDATE(),DATE_FORMAT(CURDATE(),'%w')-5); 
上周周三的日期 SELECT SUBDATE(CURDATE(),DATE_FORMAT(CURDATE(),'%w')+3); 
