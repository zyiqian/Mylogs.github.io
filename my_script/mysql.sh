#!/bin/bash
mysql_u="root"
mysql_p=1
#  数据库查询
mysql_find () {
   export MYSQL_PWD=1
   read -p "输入user:" user
   sql="select username from user where username='$user'"
  read -p "输入密码:" pss
   sql1="select password from user where password='$pss'"
   result=`mysql -u$mysql_u  << EOF
	use user_info;
	$sql;
	$sql1;
	quit
EOF`
#echo "结果"
echo "$result" 
}

#mysql_find

# 数据库插入
mysql_in(){
 echo "输入插入内容(username,password,money):"
 read insert_sql
 #将字符串转化为数组
arr=($insert_sql)
sql="insert into user(username,password,sum_money) values('${arr[0]}','${arr[1]}',${arr[2]})"
#连接数据库
result=`mysql -u$mysql_u -p$mysql_p << EOF
	use user_info;
	$sql;
	quit
EOF`
#判断是否插入成功
if [ $? = 0 ];then
    echo "执行成功!"
else 
    echo "执行失败!"   
fi
}
#mysql_in

#数据库库修改
 mysql_up(){
  echo "请输入旧用户名称以及新用户名，中间以空格分割: "
  read upp_username
arr=($upp_username)
  sql="update user set username='${arr[1]}' where username='${arr[0]}'"
 #连接数据库
  result=`mysql -u$mysql_u -p1 << EOF 
	use user_info;
	$sql;
	flush privileges;
	quit
EOF` 
#判断是否成功
if [ $? = 0 ];then
    echo "执行成功!"
else
    echo "执行失败!"   
fi
}
#mysql_up

#数据库删除
mysql_del(){
    echo "请输入需要删除的用户:"
    read delsql
    sql="delete from user where username='${delsql}'"
    #连接数据库
    result=`mysql -u$mysql_u -p1 << EOF
	use user_info;
        $sql;
        flush privileges;
        quit
EOF`
#判断是否成功
if [ $? = 0 ];then
    echo "执行成功!"
else
    echo "执行失败!"   
fi
}
#mysql_del
Login () {
 export MYSQL_PWD=1
 read -p "Please input your username:" user
read -p "Please input your password:" -s pas
 sql="select username from user where username='$user'"
 result_u=`mysql -u$mysql_u  << EOF
        use user_info;
        $sql;
        quit
EOF`
 sql1="select password from user where password='$pas'"
 result_p=`mysql -u$mysql_u  << EOF
        use user_info;
        $sql1;
        quit
EOF`
  u=`echo $result_u|awk '{print $2}'`
  p=`echo $result_p|awk '{print $2}'` 
if [[ $u = $user ]];then 
   if [[ $p = $pas ]];then
	echo "登录成功~~"
    else 
        echo "密码错误~"
   fi
else 
  echo "用户不存在"
fi
}
Login
