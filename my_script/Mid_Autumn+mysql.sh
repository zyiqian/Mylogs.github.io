#!/bin/bash
#Author:Mr_Zhong
#由于技术和时间有限，没有去完成调用数据库功能 后期将补上，现在只是纯属实现;
##################数据库增删改查函数#############################
mysql_u="root"
mysql_p=1
#  数据库查询
mysql_find () {
   #export mysql_pwd="$mysql_p"
   sql="select * from user"
   result=`mysql -u$mysql_u -p$mysql_p << EOF
	use user_info;
	$sql;
	quit
EOF`
echo "结果"
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
############################################################
#  登录用户密码验证模块
Login_1 () {
in_num=0
u_num=0
 while 1>0
do
 export MYSQL_PWD=1
 read -p "Please enter your username:" user
read -p "Please enter your password:" -s pas
#查找用户
 sql="select username from user where username='$user'"
 result_u=`mysql -u$mysql_u  << EOF
        use user_info;
        $sql;
        quit
EOF`
   u=`echo $result_u|awk '{print $2}'`
#查找密码
 sql1="select password from user where password='$pas'"
 result_p=`mysql -u$mysql_u  << EOF
        use user_info;
        $sql1;
        quit
EOF`
  p=`echo $result_p|awk '{print $2}'`
  #查余额
   money="select sum_money from user where username='$user'"
   money_u=`mysql -u$mysql_u  << EOF
        use user_info;
	flush privileges;
        $money;
        quit
EOF`
   m=`echo $money_u|awk '{print $2}'`

if [[ $u = $user ]];then
   if [[ $p = $pas ]];then
                   #   主菜单
        echo "                                     "    
        echo -e "\033[32mWelcome $user login Mid-Autumn Festival Food Shopping Mall!\033[0m"
        echo "+--------------------username:$user  "
        echo "|---------1.user_info*信息*----------|"
        echo "|---------2.Recharge*充值*-----------|"
        echo "|---------3.Consumption*消费*--------|"
        echo "|---------0.exit*退出*---------------|"
        echo "+------------------------------------+"
	while true
        do
        read -p "Please input your choies:" numm
        case $numm in
         1)
            echo "Username: $user"
            echo "Balance:￥$m"
	     ;;
         2)
	  export MYSQL_PWD=1
	   read -p "Please enter the amount of recharge:￥" m_in
           m=$(($m+$m_in))
        up_m=" update user set sum_money='$m' where username='$user'"
        money_u=`mysql -u$mysql_u  << EOF
        use user_info;
        flush privileges;
        $up_m;
        quit
EOF`
	echo "Recharge successful, current account balance:￥$m "
	    ;;
         3)
	##############################消费菜单######################################
           echo "                                                "      
           echo "+-------------Mid-Autumn Festival--------------+"
           echo "|--------------1.叉烧全家桶     ￥88 ----------|"
           echo "|--------------2.蛋黄莲蓉       ￥188 ---------|"
           echo "|--------------3.超级大月饼     ￥888 ---------|"
           echo "|--------------4.豪华送礼套餐   ￥1888---------|"
           echo "|--------------0.退出商城----------------------|"
           echo "|______________________________________________|"
           while true
             do   
		read -p "Please input your choies:" order
		case $order in
		 1)
		   if [ $m -ge 88 ];then
		    echo -e "\033[32m你已选叉烧全家桶￥88的套餐...\033[0m"
		     m=$(($m-88))
                        export MYSQL_PWD=1
    		     	up_m=" update user set sum_money='$m' where username='$user'"
	       		 money_u=`mysql -u$mysql_u  << EOF
        			use user_info;
       		 		flush privileges;
        			$up_m;
       				 quit
EOF`
                    read -p "购买成功,剩余余额:￥$m  还需要选其他套餐么?[y/n] " num2
		     if [ $num2 = "n" ];then
                                echo -e "\033[32mBay~Bay~Bay~~\033[0m"
                            exit
                     fi
                    else
                        echo -e "\033[31m你的余额不足，请充值后再购买...\033[0m"
                        exit
		   fi
			;;
		 2)
		     if [ $m -ge 88 ];then
                    echo -e "\033[32m你已选蛋黄莲蓉￥188的套餐...\033[0m"
                     m=$(($m-188))
                        export MYSQL_PWD=1
                        up_m=" update user set sum_money='$m' where username='$user'"
                         money_u=`mysql -u$mysql_u  << EOF
                                use user_info;
                                flush privileges;
                                $up_m;
                                 quit
EOF`
                    read -p "购买成功,剩余余额:￥$m  还需要选其他套餐么?[y/n] " num2
                     if [ $num2 = "n" ];then
                                echo -e "\033[32mBay~Bay~Bay~~\033[0m"
                            exit
                     fi
                    else
                        echo -e "\033[31m你的余额不足，请充值后再购买...\033[0m"
                        exit
                   fi

		   ;;
		 3)
	     	     if [ $m -ge 888 ];then
                    echo -e "\033[32m你已选超级大月饼￥888的套餐...\033[0m"
                     m=$(($m-888))
                        export MYSQL_PWD=1
                        up_m=" update user set sum_money='$m' where username='$user'"
                         money_u=`mysql -u$mysql_u  << EOF
                                use user_info;
                                flush privileges;
                                $up_m;
                                 quit
EOF`
                    read -p "购买成功,剩余余额:￥$m  还需要选其他套餐么?[y/n] " num2
                     if [ $num2 = "n" ];then
                                echo -e "\033[32mBay~Bay~Bay~~\033[0m"
                            exit
                     fi
                    else
                        echo -e "\033[31m你的余额不足，请充值后再购买...\033[0m"
                        exit
                   fi

		   ;;
		 4)
		    if [ $m -ge 1888 ];then
                    echo -e "\033[32m你已选豪华送礼套餐￥1888的套餐...\033[0m"
                     m=$(($m-1888))
                        export MYSQL_PWD=1
                        up_m=" update user set sum_money='$m' where username='$user'"
                         money_u=`mysql -u$mysql_u  << EOF
                                use user_info;
                                flush privileges;
                                $up_m;
                                 quit
EOF`
                    read -p "购买成功,剩余余额:￥$m  还需要选其他套餐么?[y/n] " num2
                     if [ $num2 = "n" ];then
                                echo -e "\033[32mBay~Bay~Bay~~\033[0m"
                            exit
                     fi
                    else
                        echo -e "\033[31m你的余额不足，请充值后再购买...\033[0m"
                        exit
                   fi
		   ;;
		 0)
		   echo "Exiting the mall...."
                   echo -e "\033[32mBay~Bay~Bay~~\033[0m"
                   exit ;;
		 *)
		    echo -e "\033[31mPlease enter a valid option!!!\033[0m"	
		   ;; 
		esac	
	     done
	       exit  ;;
         0)
	   echo "Exiting the mall...."
           echo -e "\033[32mBay~Bay~Bay~~\033[0m"	
	   exit  ;;
         *) 
           echo -e "\033[31mPlease enter a valid option!!!\033[0m"  ;;
        esac
       done
    else
	echo "  "
        echo -e "\033[31mThe password is wrong, you only have three chances~~\033[0m"
	in_num=$((l+1))
        if [ $in_num -eq 3 ];then
        echo -e "\033[31mYou have entered the password three times in succession and are exiting the system.!!!\033[0m"
         exit
        fi
   fi
else
  echo ""
  echo -e "\033[31mUser does not exist, please re-enter\033[0m"
        u_num=$((l+1))
        if [ $u_num -eq 3 ];then
        echo -e "\033[31mEnter the maximum number of times, exiting the system!!!\033[0m"
         exit
        fi

fi
done
}
#  注册用户模块

register() {
     export MYSQL_PWD=1
     while 1>0
     do
     echo "Please input your username:" 
     read insert_u
     echo "Please input your password:"
     read -s insert_p
  
     sql2="select username from user where username='$insert_u'" 
     sql="insert into user(username,password,sum_money) values('${insert_u}','${insert_p}',100)"
 #判断用户是否存在
    result_u1=`mysql -u$mysql_u  << EOF
        use user_info;
        $sql2;
        quit
EOF`
    u1=`echo $result_u1|awk '{print $2}'`
    if [[ $insert_u = $u1 ]] ;then
       echo -e "\033[31mUser:$insert_u already exists, please re-enter\033[0m"
    else
       break
    fi
  done
        echo ""
        echo -e "\033[32mSuccessful registration, jumping to login interface!\033[0m"
        echo ""
#连接数据库
result=`mysql -u$mysql_u << EOF
        use user_info;
        $sql;
        quit
EOF`

sleep 1
}
#########################登录界面##################################
while true
do
cat << EOF
+-----------Login----------+
|			   |
|---------a.login----------|
|			   |
|---------b.register-------|
|			   |
|---------d.exit-----------|
|__________________________|
EOF
read -p "Please input your choies:" ab
case "$ab" in
a)
    Login_1 ;;
b)
    register ;;
d)
    echo -e "\033[32mBay~Bay~Bay~~\033[0m"
    exit ;;
*)
    echo -e "\033[31mPlease enter a valid option!!!!\033[0m" ;;
esac
done 
