# mysql官方测试库安装

```shell
unzip test_db-master.zip
cd test_db-master
mysql -u root -p***  -t < employees.sql
mysql -u root -p***  -t < employees_partitioned.sql
测试安装的数据
mysql -u root -p***  -t < test_employees_md5.sql
mysql> show tables;
+----------------------+
| Tables_in_employees  |
+----------------------+
| current_dept_emp     |   # 当前部门人数
| departments          |   # 部门
| dept_emp             |   # 部门总人数
| dept_emp_latest_date |   # 最新的入离职信息
| dept_manager         |   # 部门经理
| employees            |   # 职员
| salaries             |   # 薪水
| titles               |   # 职称
+----------------------+

```



# sql注入--sql语句回顾

```sql
select database(); # 查看当前所在库
select user(); # 查看当前用户
select now(); # 查看当前时间
DESC table_name; # 查看表结构
show create table table_name # 查看表的创建信息
status  # 查看当前数据库信息
show full processlist; # 查看当前所有正在执行的sql语句
show processlist;  # 查看当前正在执行的sql语句前100条
avg()  # 求平均值
count() # 求记录总数
distinct() # 去重
max()  # 最大值
min() # 最小值

```

# sql测试

```sql
# 求当前员工总人数
mysql> select count(emp_no) from  current_dept_emp;
# 求员工平均薪资
mysql> select avg(salary) from salaries;
# 求1985年入职的人
mysql> select * from titles where from_date like '1985%' limit 1;
# 求目前在职的员工
mysql> select * from titles where to_date like '9999%' limit 1;
# 求职称为Staff得人有多少
mysql> select count(emp_no) from titles where title = 'Staff';
```

