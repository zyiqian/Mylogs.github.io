### MySQL 单表查询和多表查询

#### 单表查询

```
测试表：company.employee5
	雇员编号	id				    int				
	雇员姓名	name			    varchar(30)
	雇员性别	sex				    enum
	雇用时期	hire_date			date
	职位			post					varchar(50)
	职位描述	job_description	varchar(100)
	薪水			salary				double(15,2)
	办公室		office			    int
	部门编号	dep_id				int
mysql> CREATE TABLE company.employee5(
     id int primary key AUTO_INCREMENT not null,
    name varchar(30) not null,
    sex enum('male','female') default 'male' not null,
     hire_date date not null,
     post varchar(50) not null,
     job_description varchar(100),
     salary double(15,2) not null,
     office int,
     dep_id int
     );
 mysql> insert into company.employee5(name,sex,hire_date,post,job_description,salary,office,dep_id) values 
	('jack','male','20180202','instructor','teach',5000,501,100),
	('tom','male','20180203','instructor','teach',5500,501,100),
	('robin','male','20180202','instructor','teach',8000,501,100),
	('alice','female','20180202','instructor','teach',7200,501,100),
	('tianyun','male','20180202','hr','hrcc',600,502,101),
	('harry','male','20180202','hr',NULL,6000,502,101),
	('emma','female','20180206','sale','salecc',20000,503,102),
	('christine','female','20180205','sale','salecc',2200,503,102),
    ('zhuzhu','male','20180205','sale',NULL,2200,503,102),
    ('gougou','male','20180205','sale','',2200,503,102);

查看表记录
	select 字段名1，字段名2 from 表名 where 条件
select name,salary from employee5 where salary>=4000;

简单查询:
select * from employee5
select name,salary,dep_id from employee5;

避免重复: DISTINCT/distinct
    SELECT post FROM employee5;
    mysql> SELECT post FROM employee5;
+------------+
| post       |
+------------+
| instructor |
| instructor |
| instructor |
| instructor |
| hr         |
| hr         |
| sale       |
| sale       |
| sale       |
| sale       |
+------------+

	SELECT DISTINCT post  FROM employee5;
+------------+
| post       |
+------------+
| instructor |
| hr         |
| sale       |
+------------+

	注：不能部分使用DISTINCT，通常仅用于某一字段。
	
通过四则运算查询
    运算：
    mysql>select 437.4384/5
    mysql>select 5>3;

    SELECT name, salary, salary*14 FROM employee5;
    SELECT name, salary, salary*14 AS Annual_salary FROM employee5; //AS 别名
    SELECT name, salary, salary*14 Annual_salary FROM employee5;

定义显示格式
   CONCAT() 函数用于连接字符串
   select concat(name,' annual_salary: ',salary*14) as Annual_salary from employee5;
   mysql> select concat(name,' annual_salary: ',salary*14) as Annual_salary from employee5 where name="jack";
+------------------------------+
| Annual_salary                |
+------------------------------+
| jack annual_salary: 70000.00 |
+------------------------------+

单条件查询
	select  name,salary from employee5 where name="jack";
多条件查询
	select  name,salary from employee5 where salary>=6000 and salary<=8000;
关键字between and
	select name,salary from employee5 
	        where salary between 4000 and 6000;
	SELECT name,salary FROM employee5 
		    WHERE salary NOT BETWEEN 5000 AND 15000;

关键字 IS NULL
	    SELECT name,job_description FROM employee5  WHERE job_description IS NULL;
	    SELECT name,job_description FROM employee5  WHERE job_description IS NOT NULL;
	    SELECT name,job_description FROM employee5  WHERE job_description='';
NULL说明：
        1、等价于没有任何值、是未知数。
        2、NULL与0、空字符串、空格都不同,NULL没有分配存储空间。
        3、对空值做加、减、乘、除等运算操作，结果仍为空。
        4、比较时使用关键字用“is null”和“is not null”。
        5、排序时比其他数据都小（索引默认是降序排列，小→大），所以NULL值总是排在最前。

```



##### 排序查询：asc[升序] / desc [降序]

select 字段名 from 表名 order by 字段名 asc/desc,字段名 asc/desc 
	 按多列排序:
	        入职时间相同的人薪水不同
		    SELECT * FROM employee5 
			    ORDER BY hire_date DESC,
			    salary ASC;
		先按入职时间，再按薪水排序
		select * from employee5 ORDER BY hire_date DESC,salary DESC;
		
		先按职位，再按薪水排序
		select * from employee5 ORDER BY post,salary DESC;
##### 限制查看记录数

	   SELECT * FROM employee5 ORDER BY salary DESC 
	
			    limit 5;					        //默认初始位置为0 
	
	  SELECT * FROM employee5 ORDER BY salary DESC
		    LIMIT 0,5;
	
	    SELECT * FROM employee5 ORDER BY salary DESC
		    LIMIT 3,5;					        //从第4条开始，共显示5条
##### 分组查询

```
mysql> select count(salary),salary from employee5 group by salary;
+---------------+----------+
| count(salary) | salary   |
+---------------+----------+
|             1 |   600.00 |
|             3 |  2200.00 |
|             1 |  5000.00 |
|             1 |  5500.00 |
|             1 |  6000.00 |
|             1 |  7200.00 |
|             1 |  8000.00 |
|             1 | 20000.00 |
+---------------+----------+
```



#####  GROUP BY和GROUP_CONCAT()函数一起使用

```
SELECT GROUP_CONCAT(name) FROM employee5 GROUP BY dep_id;
SELECT dep_id,GROUP_CONCAT(name) as emp_members FROM employee5 GROUP BY dep_id;
+--------+------------------------------+
| dep_id | emp_members                  |
+--------+------------------------------+
|    100 | jack,tom,robin,alice         |
|    101 | tianyun,harry                |
|    102 | emma,christine,zhuzhu,gougou |
+--------+------------------------------+
mysql> select dep_id,avg(salary) from employee5 group by dep_id;
+--------+-------------+
| dep_id | avg(salary) |
+--------+-------------+
|    100 | 6425.000000 |
|    101 | 3300.000000 |
|    102 | 6650.000000 |
+--------+-------------+
```

#####  GROUP BY和集合函数一起使用

```
select dep_id,SUM(salary) FROM employee5 GROUP BY dep_id;
    select dep_id,AVG(salary) FROM employee5 GROUP BY dep_id;
```

##### 模糊查询（通配符）

​		_ 任意个字符
		% 所有字符

##### 正规查询

```
SELECT * FROM employee5 WHERE name REGEXP '^ali';
```

##### 子查询

```
mysql> select name from t2 where math=(select max(math) from t2);
```

##### 函数

```
    count()
    max()
    min()
    avg()
    database()
    user()
    now()
    sum()
    
    password()
    md5()
    sha1()
    power()
    SELECT COUNT(*) FROM employee5;//查看总记录
	SELECT COUNT(*) FROM employee5 WHERE dep_id=101;
	SELECT MAX(salary) FROM employee5;
	SELECT MIN(salary) FROM employee5;
	SELECT AVG(salary) FROM employee5;
	SELECT SUM(salary) FROM employee5;
	SELECT SUM(salary) FROM employee5 WHERE dep_id=101; 
```



#### 多表查询

#####     多表连接查询

#####     复合条件连接查询

#####     子查询

```
一、准备两张测试表
表一、company.employee6
mysql> create table employee6( 
emp_id int auto_increment primary key not null, 
emp_name varchar(50), 
age int, 
dept_id int);

mysql> insert into employee6(emp_name,age,dept_id) values
('tianyun',19,200),
('tom',26,201),
('jack',30,201),
('alice',24,202),
('robin',40,200),
('natasha',28,204);

表二、company.department6
mysql> create table department6(
dept_id int,
dept_name varchar(100)
);

mysql> insert into department6 values
(200,'hr'),
(201,'it'),
(202,'sale'),
(203,'fd');

```



##### 二、多表的连接查询

交叉连接：生成笛卡尔积，它不使用任何匹配条件  自己了解就好，这个生产用会把数据库跑死
内连接：只连接匹配的行
外连接
    左连接：会显示左边表内所有的值，不论在右边表内匹不匹配
    右连接：会显示右边表内所有的值，不论在左边表内匹不匹配
全外连接： 包含左、右两个表的全部行

=================内连接=======================
两种方式：
    方式1：使用where条件 
    方式2：使用inner join
只找出有部门的员工 (部门表中没有natasha所在的部门)

```
mysql> select employee6.emp_id,employee6.emp_name,employee6.age,department6.dept_name
from employee6,department6 
where employee6.dept_id = department6.dept_id;
+--------+----------+------+-----------+
| emp_id | emp_name | age  | dept_name |
+--------+----------+------+-----------+
|      1 | tianyun  |   19 | hr        |
|      2 | tom      |   26 | it        |
|      3 | jack     |   30 | it        |
|      4 | alice    |   24 | sale      |
|      5 | robin    |   40 | hr        |
+--------+----------+------+-----------+

使用inner join
select --- from - inner join - on --
> select a.emp_id,a.emp_name,a.age,b.dept_name from employee6 a inner join department6 b on a.dept_id = b.dept_id;
+--------+----------+------+-----------+
| emp_id | emp_name | age  | dept_name |
+--------+----------+------+-----------+
|      1 | tianyun  |   19 | hr        |
|      2 | tom      |   26 | it        |
|      3 | jack     |   30 | it        |
|      4 | alice    |   24 | sale      |
|      5 | robin    |   40 | hr        |
+--------+----------+------+-----------+

======================================
```

##### 外连接语法：

SELECT 字段列表
	    FROM 表1 LEFT|RIGHT JOIN 表2
	    ON 表1.字段 = 表2.字段;
    左连接：	会显示左边表内所有的值，不论在右边表内匹不匹配
    右连接：	会显示右边表内所有的值，不论在左边表内匹不匹配

```
mysql> select * from employee6;
+--------+----------+------+---------+
| emp_id | emp_name | age  | dept_id |
+--------+----------+------+---------+
|      1 | tianyun  |   19 |     200 |
|      2 | tom      |   26 |     201 |
|      3 | jack     |   30 |     201 |
|      4 | alice    |   24 |     202 |
|      5 | robin    |   40 |     200 |
|      6 | natasha  |   28 |     204 |
+--------+----------+------+---------+

mysql> select * from department6;;
+---------+-----------+
| dept_id | dept_name |
+---------+-----------+
|     200 | hr        |
|     201 | it        |
|     202 | sale      |
|     203 | fd        |
+---------+-----------+


=================外连接(左连接 left join)=======================
mysql> select emp_id,emp_name,dept_name from  employee6 left join department6 on employee6.dept_id = department6.dept_id;
找出所有员工及所属的部门，包括没有部门的员工
+--------+----------+-----------+
| emp_id | emp_name | dept_name |
+--------+----------+-----------+
|      1 | tianyun  | hr        |
|      5 | robin    | hr        |
|      2 | tom      | it        |
|      3 | jack     | it        |
|      4 | alice    | sale      |
|      6 | natasha  | NULL      |
+--------+----------+-----------+

=================外连接(右连接right join)=======================
mysql> select emp_id,emp_name,dept_name from  employee6 right join department6 on employee6.dept_id = department6.dept_id;
找出所有部门包含的员工，包括空部门
+--------+----------+-----------+
| emp_id | emp_name | dept_name |
+--------+----------+-----------+
|      1 | tianyun  | hr        |
|      2 | tom      | it        |
|      3 | jack     | it        |
|      4 | alice    | sale      |
|      5 | robin    | hr        |
|   NULL | NULL     | fd        |
+--------+----------+-----------+

=================全外连接(了解)=======================
> select * from employee6 full  join departmant6;
+--------+----------+------+---------+---------+-----------+
| emp_id | emp_name | age  | dept_id | dept_id | dept_name |
+--------+----------+------+---------+---------+-----------+
|      1 | tianyun  |   19 |     200 |     200 | hr        |
|      1 | tianyun  |   19 |     200 |     201 | it        |
|      1 | tianyun  |   19 |     200 |     202 | sale      |
|      1 | tianyun  |   19 |     200 |     203 | fd        |
|      2 | tom      |   26 |     201 |     200 | hr        |
|      2 | tom      |   26 |     201 |     201 | it        |
|      2 | tom      |   26 |     201 |     202 | sale      |
|      2 | tom      |   26 |     201 |     203 | fd        |
|      3 | jack     |   30 |     201 |     200 | hr        |
|      3 | jack     |   30 |     201 |     201 | it        |
|      3 | jack     |   30 |     201 |     202 | sale      |
|      3 | jack     |   30 |     201 |     203 | fd        |
|      4 | alice    |   24 |     202 |     200 | hr        |
|      4 | alice    |   24 |     202 |     201 | it        |
|      4 | alice    |   24 |     202 |     202 | sale      |
|      4 | alice    |   24 |     202 |     203 | fd        |
|      5 | robin    |   40 |     200 |     200 | hr        |
|      5 | robin    |   40 |     200 |     201 | it        |
|      5 | robin    |   40 |     200 |     202 | sale      |
|      5 | robin    |   40 |     200 |     203 | fd        |
|      6 | natasha  |   28 |     204 |     200 | hr        |
|      6 | natasha  |   28 |     204 |     201 | it        |
|      6 | natasha  |   28 |     204 |     202 | sale      |
|      6 | natasha  |   28 |     204 |     203 | fd        |
+--------+----------+------+---------+---------+-----------+

```

##### 三、复合条件连接查询

示例1：以内连接的方式查询employee6和department6表，并且employee6表中的age字段值必须大于25
找出公司所有部门中年龄大于25岁的员工

```
select emp_id,emp_name,age,dept_name FROM employee6,department6 WHERE employee6.dept_id=department6.dept_id AND age > 25;
```

示例2：以内连接的方式查询employee6和department6表，并且以age字段的升序方式显示  select -- from - order by ---

```
mysql> select emp_id,emp_name,age,dept_name from employee6 inner join department6 on employee6.dept_id=department6.dept_id  order by age asc;
```

##### 四、子查询

子查询是将一个查询语句嵌套在另一个查询语句中。
内层查询语句的查询结果，可以为外层查询语句提供查询条件。
子查询中可以包含：IN、NOT IN、ANY、ALL、EXISTS 和 NOT EXISTS等关键字
还可以包含比较运算符：= 、 !=、> 、<等

1. ###### 带IN关键字的子查询

  查询employee表，但dept_id必须在department表中出现过

  ```
  mysql> SELECT * FROM employee6 WHERE dept_id IN (SELECT dept_id FROM department6);
  ```

  ###### 2.带比较运算符的子查询

  =、!=、>、>=、<、<=、<>
  查询年龄大于等于25岁员工**所在部门**（查询老龄化的部门）

```
mysql> SELECT dept_id,dept_name FROM department6 WHERE dept_id IN (SELECT DISTINCT dept_id FROM employee6 WHERE age >= 25);
```

3. ###### 带EXISTS关键字的子查询    **exists**

  EXISTS关字键字表示**存在**。在使用EXISTS关键字时，内层查询语句不返回查询的记录，而是返回一个真假值。
  True或False，当返回True时，外层查询语句将进行查询；当返回值为False时，外层查询语句不进行查询

```
department表中存在dept_id=203，Ture
SELECT * from employee6 WHERE EXISTS (SELECT * FROM depratment6 WHERE dept_id=203);
```

