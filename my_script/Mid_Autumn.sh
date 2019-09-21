#!/bin/bash
#Author:Mr_Zhong
#由于技术和时间有限，没有去完成调用数据库功能 后期将补上，现在只是纯属实现;
#先创建一个文件用于储存用户信息
ls /home/user/user_info.txt &> /dev/null
if [ $? != 0 ];then
   mkdir /home/user &> /dev/null
   touch /home/user/user_info.txt &> /dev/null
fi
login () {
l=0 #定义用户名输入次数
p=0  #定义密码输入次数
while true
do
read -p "Please input your username:" user
read -p "Please input your password:" -s pas
usr=`cat /home/user/user_info.txt|grep "$user"|awk -F":" '{print $1}'`  #获取用户
pass=`cat /home/user/user_info.txt|grep "$pas"|awk -F":" '{print $2}'` #获取密码
sum_money=`cat /home/user/user_info.txt|grep "$user"|awk -F":" '{print $3}'|awk -F"=" '{print $2}'` #获取账户余额
if [[ $user = $usr ]];then  #判断用户是否注册有
   if [[ $pas = $pass ]];then #如果账号密码正确登录主菜单
#############################主菜单###########################################
	echo "                                     "	
	echo -e "\033[32mWelcome $usr to login!\033[0m"
	echo "+--------------------Username:$usr"
	echo "|---------1..Inquire*查询*----------|"
	echo "|---------2.Recharge*充值*----------|"
	echo "|---------3.Consumption*消费*-------|"
	echo "|---------0.Quit*退出*--------------|"
	echo "+-----------------------------------+"
	while true
	do
	sum_money=`cat /home/user/user_info.txt|grep "$user"|awk -F":" '{print $3}'|awk -F"=" '{print $2}'` #获取账户余额
	read -p "Please input your choice:" numm
	case $numm in
	1)
	   echo -e "\033[33m[username:$usr Balance:$sum_money ]\033[0m"
	   ;;
	2)
	   read -p "Please input recharge amount:" money1
	   sed -i "s/sum_money=$sum_money/sum_money=$(($sum_money+$money1))/" /home/user/user_info.txt
	   echo -e "\033[32mBalance:$(($sum_money+$money1)) \033[0m"
	   ;;
	3)
##############################消费菜单######################################
	   echo "                                                "	
	   echo "+---------------中秋大餐-----------------------+"
	   echo "|--------------1.叉烧全家桶     ￥88 ----------|"
	   echo "|--------------2.蛋黄莲蓉       ￥188 ---------|"
	   echo "|--------------3.超级大月饼     ￥888 ---------|"
	   echo "|--------------4.豪华送礼套餐   ￥1888---------|"
	   echo "|--------------0.退出商城----------------------|"
	   echo "|______________________________________________|"
	   while true
	     do
		sum_money=`cat /home/user/user_info.txt|grep "$pas"|awk -F":" '{print $3}'|awk -F"=" '{print $2}'` #获取账户余额
	   	 read -p "请输入你需要购买的大餐: " num1
		 case $num1 in
		 1)
		    if [ "$sum_money" -ge 88 ];then 
		    	echo -e "\033[32m你已选叉烧全家桶￥88的套餐...\033[0m"
		    	read -p "购买成功,剩余余额:$(($sum_money-88)) 还需要选其他套餐么?[y/n] " num2
		        sed -i "s/sum_money=$sum_money/sum_money=$(($sum_money-88))/" /home/user/user_info.txt
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
		    if [ "$sum_money" -ge 188 ];then
		     	echo -e "\033[32m你已选蛋黄莲蓉￥188的套餐...\033[0m"
                   	 read -p "购买成功,剩余余额:$(($sum_money-188))  还需要选其他套餐么?[y/n] " num2
	   	    	sed -i "s/sum_money=$sum_money/sum_money=$(($sum_money-188))/" /home/user/user_info.txt
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
		    if [ "$sum_money" -ge 888 ];then
		          echo -e "\033[32m你已选超级大月饼￥888的套餐...\033[0m"
                    	  read -p "购买成功,剩余余额:$(($sum_money-888))  还需要选其他套餐么?[y/n] " num2
	            	  sed -i "s/sum_money=$sum_money/sum_money=$(($sum_money-888))/" /home/user/user_info.txt
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
		    if [ "$sum_money" -ge 1888 ];then
		   	   echo -e "\033[33m你已选豪华送礼套餐￥1888的套餐...\033[0m"
                    	    read -p "购买成功,剩余余额:$(($sum_money-1888)) 还需要选其他套餐么?[y/n] " num2
	            	   sed -i "s/sum_money=$sum_money/sum_money=$(($sum_money-1888))/" /home/user/user_info.txt
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
	    	   echo "正在退出商城...."
                   echo -e "\033[32mBay~Bay~Bay~~\033[0m"
		  exit ;;  	
	 	 esac
		done 
	    exit ;;
#####################消费菜单底部######################################
	0)
           echo -e "\033[32mBay~Bay~Bay~~\033[0m"
	   exit ;;
	  esac	
	done
#####################################主菜单底部#######################################
      else  #以下是输入密码错误判断，若超过三次则退出 
	echo -e "\033[31mYour password is wrong,please reinput!!!\033[0m"	
	l=$((l+1))
	if [ $l -eq 3 ];then
	echo -e "\033[31mYou have entered the error three times in succession!!!\033[0m"
	 exit
	fi
   fi 
  else 
    echo -e "\033[31mYour $usr is not found,please reinput!!!\033[0m"
	p=$((p+1))
	if [ $p -eq 3 ];then 
	 echo -e "\033[31mYou have entered the error three times in succession!!!\033[0m"
	exit
	fi	
fi
done
}
#########################注册功能#######################################
register () {
	echo "Welcome to the registration page..."
	read -p "Please input your username:" user
	read -p "Please input your password:" -s pass
        usr=`cat /home/user/user_info.txt|grep "$user"|awk -F":" '{print $1}'`  #获取用户
	if [[ $user != $usr ]];then 
	    echo "$user:$pass:sum_money=100" >> /home/user/user_info.txt
	    echo -e "\033[32mRegistration success,Jumping to login\033[0m"
	else 
	    echo " "
	    echo -e "\033[31mThis user already exists!\033[0m"
	fi
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
read -p "Please input your choice:" ab
case "$ab" in
a)
    login ;;
b)
    register ;;
d)
    echo -e "\033[32mBay~Bay~Bay~~\033[0m"
    exit ;;
*)
    echo -e "\033[31mPlease enter the correct option!!!!\033[0m" ;;
esac
done 
