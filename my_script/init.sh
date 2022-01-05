#!/bin/bash

#关闭防火墙、SELINXU、IPtables
disable_FSI () {
	echo  -e "\033[31mdisable Firewalld、SELINUX、iptables... \033[0m"
	 systemctl stop firewalld
	 systemctl disable firewalld
	 sed -i '/^SELINUX=/cSELINUX=disabled' /etc/selinux/config
	 setenforce 0
	iptables -F
	echo -e "\033[33mOK，all disable，you can happy play... \033[0m"
}

Lookup_clientII () {
	  echo -e "\033[31m  正在一键装常用包请稍后..... \033[0m"
	  echo -e "\033[31m *************************** \033[0m"
	  echo "   "
	  yum -y install wget vim tar lrzsz 
	  yum clean all
	  yum makecache
	  echo " "
	  echo -e "\033[31m安装完成请按任意键返回。 \033[0m" && read yn
	  continue
}

#配置阿里云yum源
Aliyun_yum () {
	echo -e "\033[31m正在安装配置中，请稍后.... \033[0m" 
        #先查看linux系统版本
        Linux_banben=`cat /etc/redhat-release |awk '{print $4}'|awk -F"." '{print $1}'`
        #查看系统是否安装了wget
	Lookup_wget=`rpm -q wget|awk -F'-' '{print $1}'`
	#替换原yum源或者删除
	mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
	#判断系统版本是否是7*版本
	 if [ "$Linux_banben" = "7" ] ;then
	    if [ "$Lookup_wget" = "wget" ] ;then
                #如果系统安装有wget 则使用wget安装
         	echo -e "\033[33m这是CentOS 7 使用wget安装 \033[0m"
		 wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo 
	         yum makecache
	     else 
		#系统没安装有wget则使用curl安装
		echo -e "\033[33m这是CentOS 7 使用curl安装 \033[0m"
	
		curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
	   	yum makecache
	      fi
	#判断版本是否是6*版本
	 if [ "$Linux_banben" = "6" ] ;then
		if [ "$Lookup_wget" = "wget" ] ;then
                 echo -e "\033[33m这是CentOS 6 使用wget安装 \033[0m"
                 wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo  
                 yum makecache
	     else
                echo -e "\033[33m这是CentOS 6 使用curl安装 \033[0m"
                curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
                yum makecache
	      fi
	 fi
	
           #判断版本是否是5*版本
         if [ "$Linux_banben" = "5" ] ;then
                if [ "$Lookup_wget" = "wget" ] ;then
		echo -e "\033[33m这是CentOS 5 使用wget安装 \033[0m"
                wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo 
                yum makecache
            else
                 echo -e "\033[33m这是CentOS 5 使用curl安装 \033[0m"
                curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo
                yum makecache
            fi
         fi
	#如果都不符，请自行查看版本
        else
              echo -e "\033[31m未匹配到，请自行查看系统相关版本... \033[0m"
	      Linux_lookup=`cat /etc/redhat-release`
	      echo -e "\033[33m  你系统版本为: $Linux_lookup  \033[0m"
        fi
}

#配置静态/动态 IP
Configure_IP () {
  #先判断ip是动态IP还是静态IP
   grep "dhcp" /etc/sysconfig/network-scripts/ifcfg-ens33 >/dev/null
  if [ $? = 0 ] ;then
   	echo -e "\033[33m本IP为动态IP \033[0m"
        cat /etc/sysconfig/network-scripts/ifcfg-ens33
	while 1>0 
        do 
   	echo -e "\033[31m是否需要配置静态IP?[y/n] \033[0m" && read yn
	case "$yn" in
	y | Y)
	      echo -e "\033[33m正在为你配置静态IP，请稍后... \033[0m"
	   sed -i 's/dhcp/none/' /etc/sysconfig/network-scripts/ifcfg-ens33
           ##判断网卡配置文件里面有没有ip地址，网关，掩码，dns
	    grep 'IPADDR' /etc/sysconfig/network-scripts/ifcfg-ens33
	#$?=1 则是没有IP
         if [ $? = 1 ];then	 
	    echo -e "\033[33m请输入一个心仪的IP: \033[0m" && read ipp
	    echo "IPADDR=$ipp" >> /etc/sysconfig/network-scripts/ifcfg-ens33
	    yum -y install net-tools
	    # echo -e "\033[33m请输入你的网关: \033[0m" && read gw
            	wg=`route -n |awk 'NR==3{print $2}'`
	     echo "GATEWAY=$wg" >> /etc/sysconfig/network-scripts/ifcfg-ens33
            #echo -e "\033[33m请输入你的子掩码: \033[0m" && read pf       
            echo "PREFIX=24" >> /etc/sysconfig/network-scripts/ifcfg-ens33
	    
	    #echo -e "\033[33m请输入你的DNS1: \033[0m" && read dns1  
            echo "DNS1=202.96.128.86" >> /etc/sysconfig/network-scripts/ifcfg-ens33
            #echo -e "\033[33m请输入你的DNS2: \033[0m" && read dns2  
            echo "DNS2=223.5.5.5" >> /etc/sysconfig/network-scripts/ifcfg-ens33
	 else 
	      
	    sed -i 's/IPADDR=/#IPADDR=/ ; s/GATEWAY=/#GATEWAY=/ ; s/PREFIX=/#PREFIX=/ ; s/DNS/#DNS/' /etc/sysconfig/network-scripts/ifcfg-ens33
	    echo -e "\033[33m请输入一个心仪的IP \033[0m" && read ipp
            echo "IPADDR=$ipp" >> /etc/sysconfig/network-scripts/ifcfg-ens33

            yum -y install net-tools
            wg=`route -n |awk 'NR==3{print $2}'`
            echo "GATEWAY=$wg" >> /etc/sysconfig/network-scripts/ifcfg-ens33
            #echo -e "\033[33m请输入你的子掩码: \033[0m" && read pf
            echo "PREFIX=24" >> /etc/sysconfig/network-scripts/ifcfg-ens33

            #echo -e "\033[33m请输入你的DNS1: \033[0m" && read dns1
            echo "DNS1=202.96.128.86" >> /etc/sysconfig/network-scripts/ifcfg-ens33
            #echo -e "\033[33m请输入你的DNS2: \033[0m" && read dns2
            echo "DNS2=223.5.5.5" >> /etc/sysconfig/network-scripts/ifcfg-ens33
	fi
 	     echo -e "\033[33m已配置成功，正在重启网络... \033[0m"
	     echo -e "\033[33m正在测试网络... \033[0m"
   	     systemctl restart network
	     sleep 2
             ping -c 2 www.baidu.com
	      if [ $? = 0 ] ;then 
	        echo -e "\033[33m配置静态IP成功! \033[0m"
	      else 
		echo -e "\033[31m网络出错，请自行检查网络状态! \033[0m"
	      fi
	      exit
		 ;; 
	n | N)
	       echo -e "\033[31m正在退出，请稍后...\033[0m" 
	       exit	
              ;;      
	*) 
               echo -e "\033[31m请输入正确字符! \033[0m" ;;
	esac
	done

  else 
	echo -e "\033[33m原本IP为静态IP \033[0m"
         cat /etc/sysconfig/network-scripts/ifcfg-ens33
	while 1>0 
        do 
   	echo -e "\033[31m是否需要配置动态IP?[y/n] \033[0m" && read yn
	case "$yn" in
	y | Y)
	      echo -e "\033[33m正在为你配置动态IP，请稍后... \033[0m"
	      sed -i 's/none/dhcp/ ; s/static/dhcp/' /etc/sysconfig/network-scripts/ifcfg-ens33
	     #把IP地址网关之类的先注释掉
		 sed -i 's/IPADDR=/#IPADDR=/ ; s/GATEWAY=/#GATEWAY=/ ; s/PREFIX=/#PREFIX=/ ; s/DNS/#DNS/' /etc/sysconfig/network-scripts/ifcfg-ens33
             echo -e "\033[33m已配置成功，正在重启网络... \033[0m"
	     echo -e "\033[33m正在测试网络... \033[0m"
   	     systemctl restart network
	     sleep 2
             ping -c 2 www.baidu.com
	      if [ $? = 0 ] ;then 
	        echo -e "\033[33m配置动态IP成功! \033[0m"
	      else 
		echo -e "\033[31m网络出错，请自行检查网络状态! \033[0m"
	      fi
	      exit
		 ;; 
	n | N)
	       echo -e "\033[31m正在退出，请稍后...\033[0m" 
	       exit	
              ;;      
	*) 
               echo -e "\033[31m请输入正确字符! \033[0m" ;;
	esac
	done
  fi
}

#配置阿里云epel源适用 CentOS 7*
Config_epel () {
	ls /etc/yum.repos.d/epel.repo &>/dev/null || /etc/yum.repos.d/epel-testing.repo &>/dev/null
	if [ $? -eq 0 ];then
		echo -e "\033[33m已经安装了epel源，是否覆盖？yes/no \033[0m"
		read yon
	     if [ "$yon" = yes ];then
	      #判断系统是否装有wget
	             rpm -q wget &>/dev/null
	          if [ "$?" -eq 0 ];then
	              echo -e "\033[31m正在安装请稍后.... \033[0m"
	             wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
			 echo -e "\033[33m阿里云epel源已安装成功... \033[0m"
		     Find_epel=`find /etc/yum.repos.d/ -name 'epel*'`
                      echo $Find_epel
		     yum makecache
			exit
	          else	
		       echo -e "\033[31m经检测你的系统没有安装wget正在安装wget请稍后.... \033[0m"
		      yum -y install wget &>/dev/null
	 	       echo -e "\033[33mwget已安装完成，正在安装epel "
		      wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
		      echo -e "\033[33m阿里云epel源已安装成功... \033[0m"
                      Find_epel=`find /etc/yum.repos.d/ -name 'epel*'`
                      echo $Find_epel
		     yum makecache
			exit
	           fi
	    elif [ "$yon" = no ];then
		echo -e "\033[31m正在退出...\033[0m"
		exit
	      fi
	 else 
		rpm -q wget &>/dev/null
           if [ "$?" -eq 0 ];then
                echo -e "\033[31m正在安装请稍后.... \033[0m"
                wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
		 echo -e "\033[33m阿里云epel源已安装成功... \033[0m"
                Find_epel=`find /etc/yum.repos.d/ -name 'epel*'`
                echo $Find_epel

		     yum makecache
			exit
            else
                echo -e "\033[31m经检测你的系统没有安装wget正在安装wget请稍后.... \033[0m"
                yum -y install wget &>/dev/null
                echo -e "\033[33mwget已安装完成，正在安装epel \033[0m"
                wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
                echo -e "\033[33m阿里云epel源已安装成功... \033[0m"
		Find_epel=`find /etc/yum.repos.d/ -name 'epel*'`
		echo $Find_epel
		     yum makecache
			exit
           fi
	fi
}



while 1>0
do
cat << EOF
                         	    (\\                /) 
                         	     \\\              //
                         	      \\\____________//  
                        +--------------|------------|--------------+      \_/
                        |******************************************|      OYO
                        |*      ( Oo)                 (oO )       *|      | |
                        |*            HackerLion_v1.2             *|      | |
               +--------|*                 V V V                  *|------+ |
               | +------|******************************************|--------+ 
               | |      |*                                        *|      
               | |      |*        1、配置阿里云yum源              *|      
               O_O      |*        2、配置阿里云epel               *|      
               / \      |*        3、配置动静态IP                 *|      
                        |*        4、一键三连                     *|
                        |*        5、安装常用包                   *|
                        |*        0、退出系统                     *|
                        |*                                        *|
                        |******************************************|
                        +------+_+--+_+-------------+_+--+_+-------+
				|    |	             |    |
				|    | 	             |    |
			    ____(    )		     (    )____
			   (|___|    |		     |    |___|)
			   (|___|    |               |    |___|)
		          (|_________)               (_________|)   
EOF
read -p "请输入需要启动的功能:" numm
case "$numm" in
"5")
	Lookup_clientII
  	  ;;
"1")
	Aliyun_yum
	;;
"3")
	Configure_IP
	;;
"2") 
	Config_epel
	;;
"4")
	disable_FSI
	;;
"0")
	  echo -e "\033[31m  正在退出中请稍后..... \033[0m"
       	  echo "欢迎下次使用~Bay~Bay~ "
	  echo "   "
  	  exit
		;;
*)
        echo -e "\033[31m  请输入正确的功能序号！！！ \033[0m"
	  echo "   "
	;;
esac
done

