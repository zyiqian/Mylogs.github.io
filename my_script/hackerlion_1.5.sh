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


#pingIP的函数，扫描一个网段中所能ping通和ping不通的ip
PingIP () {
 #ping一个网段中的IP
        echo -e "\033[31m  正在搜索请稍后..... \033[0m"
        >ip_up.txt
        >ip_no.txt
        for i in {1..255}
        do
            ping -c 1 -W 1 10.3.138.$i &>/dev/null
            rev=$?
        #如果ping通则保存到ip_up.txt，ping不通则保存到ip_no.txt
            if [ $rev -eq 0 ];then
               echo "10.3.138.$i 可以Ping通" >>ip_up.txt
             else
                echo "10.3.138.$i 不可以ping通" >>ip_no.txt
             fi
         done
        #查看ping通或不通的文件
        IPN=`cat ip_no.txt|wc -l`
        IP=`cat ip_up.txt|wc -l`
        echo -e "\033[31m ***可Ping通的IP有一共有$IP 个*** \033[0m"
        echo -e "\033[31m ***不可Ping通的IP有一共有$IPN 个*** \033[0m"
        read -p "是否需要查看y:查看ping通的;n:查看ping不通的;摁任意键退出 [y/n]" yn
        if [ "$yn" = y ] ;then
                cat ip_up.txt
        elif [ "$yn" = n ];then
             cat ip_no.txt
        else
              exit
        fi
          echo "   "
}

#查看用户
Lookup_User () {
        echo -e "\033[31m  正在搜索启动功能请稍后..... \033[0m"  
	sleep 1
        echo -e "\033[31m  2、判断一个用户是否存在..... \033[0m"
	read -p "请输入需要查找的用户:" user
	
	if id -u $user >/dev/null 2>&1 ;then
	 	echo -e "\033[31m  存在用户: $user ..... \033[0m"
	else 
		echo -e "\033[33m 用户 $user 不存在 ..... \033[0m" 
	fi
	  echo "   "
          echo -e "\033[31m按任意键返回。 \033[0m" && read yn
          continue
}

#查看客户端II的基本信息
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
#查看内核版本
Lookup_kernel () {
	  echo -e "\033[31m  正在在努力搜索中..... \033[0m"
          sleep 1
	   NEIHE=`uname -r|awk -F'.' '{print $1}'`
	  if [ "$NEIHE" = 3 ] ;then
	   BANBEN=`uname -r|awk -F'.' '{print $2}'`
	    if [ "$BANBEN" = 10 ] ;then
	          echo -e "\033[33m  内核版本为3,且此版本是大于10 ..... \033[0m"
	    fi
          else 
		 echo -e "\033[31m  不在此范围内..... \033[0m"	
	  fi
         	echo -e "\033[31m按任意键返回。 \033[0m" && read yn
          continue

}
#查找软件
Lookup_app () {
          echo -e "\033[31m  正在努力搜索中..... \033[0m"
          sleep 2
	   echo -e "\033[31m  请输入需要查找的软件: \033[0m" 
	   read ruanjian
	   VS=`rpm -q $ruanjian`
	   if [ "$VS" = "package $ruanjian is not installed" ] ;then
	          echo -e "\033[31m  你没有安装软件: $VS \033[0m"
            else
                   echo -e "\033[33m  你安装的软件为: $VS  \033[0m"
            fi
	  echo "   "
           echo -e "\033[31m按任意键返回。 \033[0m" && read yn
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

            #echo -e "\033[33m请输入你的网关: \033[0m" && read gw
            echo "GATEWAY=192.168.78.2" >> /etc/sysconfig/network-scripts/ifcfg-ens33
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

#源码配置Nginx
#1、上传或下载Nginx包
#2、准备软件 nginx-1.16.0.tar.gz
#3、部署Nginx
#
config_Nginx () {
 	echo -e "\033[31m自动配置Nginx已启动... \033[0m"
	echo -e "\033[31m正在关闭防火墙,SELINUX,IPTABLES... \033[0m"
  	#检测系统是否安装了nginx
        #是否使用rpm方式安装了nginx
	rpm -q nginx
	if [ $? = 0 ];then
            echo -e "\033[32m你已用rpm方式安装了nginx.如继续安装请按[yes]..按任意键退出\033[0m" && read yes
	 	
		if [ $yes = "yes" ];then
		  echo "正在准备安装"
		else
			echo -e "\033[33m正在退出...\033[0m"
			exit
		fi
	 else
	     #源码方式启动nginx
	    /usr/local/nginx/sbin/nginx
	    if [ $? = 0 ];then
	      echo -e "\033[32m系统自动检测到你已使用源码方式安装了nginx 继续安装?[yes/任意键退出]\033[0m" && read yes
		 if [ $yes = "yes" ];then
                  echo "正在准备安装"
                else
                        echo -e "\033[33m正在退出...\033[0m"
                        exit
                  fi
	    else
	     echo -e " "
	    fi
	    echo  -e "\033[31m准备以源码方式安装Nginx\033[0m"   
	fi
	while 1>0

	do 
              wget http://nginx.org/download/nginx-1.16.1.tar.gz >/dev/null	
	  ls nginx-1.16.1.tar.gz &>/dev/null
	 if [ $? = 0 ];then 
	     echo -e "\033[33m系统已经自动检测到Nginx包 \033[0m"
	     rpm -q tar &>/dev/null
	    if [ $? = 0 ];then
		echo -e "\033[33m正在安装Nginx，请稍等... \033[0m"
		   #创建一个www用户
		 echo -e "\033[33m正在创建一个nginx用户 \033[0m"
		   userdel -r nginx
		   useradd nginx
		   mkdir /tmp/nginx/
		   touch /tmp/nginx/client_body
		   chown -R nginx.nginx /tmp/nginx
		   mv nginx-1.16.1.tar.gz /usr/local/src
		   cd /usr/local/src
		   tar xzvf nginx-1.16.1.tar.gz -C /usr/local
		    mv /usr/local/nginx-1.16.1 /usr/local/nginx
	           yum -y install gcc gcc-c++ pcre pcre-devel openssl openssl-devel zlib zlib-devel
		   cd /usr/local/nginx
		   
		   config=`./configure \--user=nginx \--group=nginx \--prefix=/usr/local/nginx \--sbin-path=/usr/sbin/nginx \--conf-path=/etc/nginx/nginx.conf \--error-log-path=/var/log/nginx/error.log \--http-log-path=/var/log/nginx/access.log \--http-client-body-temp-path=/tmp/nginx/client_body \--http-proxy-temp-path=/tmp/nginx/proxy \--http-fastcgi-temp-path=/tmp/nginx/fastcgi \--pid-path=/var/run/nginx.pid \--lock-path=/var/lock/nginx \--with-http_stub_status_module \--with-http_ssl_module \--with-http_gzip_static_module \--with-pcre`
		   echo "$config" 
		   sleep 1
		   make  && make install
		   #启动Nginx
		   /usr/sbin/nginx
		   if [ $? = 0 ];then
		    echo -e "\033[33m已经安装完成\033[0m"
			exit
	            else 
			echo -e "\033[31m安装失败！请重新安装\033[0m"
		   	exit
		    fi
		     #清理yum缓存
		    echo -e "\033[33m正在安装清理yum缓存，请稍等... \033[0m"
		    yum clean all && yum makecache
		 
		exit
	     else 
		echo -e "\033[31m经系统检测未安装tar包,正在为你安装tar包\033[0m"
                 yum -y install tar >/dev/null
	        echo -e "\033[33m正在安装Nginx，请稍等... \033[0m"
		 echo -e "\033[33m正在创建一个nginx用户 \033[0m"
		 userdel -r nginx
                   useradd nginx
		  mkdir /tmp/nginx/
                   touch /tmp/nginx/client_body
                   chown -R nginx.nginx /tmp/nginx
                   mv nginx-1.16.1.tar.gz /usr/local/src
                   cd /usr/local/src
                   tar xzvf nginx-1.16.1.tar.gz -C /usr/local
                    mv /usr/local/nginx-1.16.1 /usr/local/nginx
                   yum -y install gcc gcc-c++ pcre pcre-devel openssl openssl-devel zlib zlib-devel
                   cd /usr/local/nginx

                config=`./configure \--user=nginx \--group=nginx \--prefix=/usr/local/nginx \--sbin-path=/usr/sbin/nginx \--conf-path=/etc/nginx/nginx.conf \--error-log-path=/var/log/nginx/error.log \--http-log-path=/var/log/nginx/access.log \--http-client-body-temp-path=/tmp/nginx/client_body \--http-proxy-temp-path=/tmp/nginx/proxy \--http-fastcgi-temp-path=/tmp/nginx/fastcgi \--pid-path=/var/run/nginx.pid \--lock-path=/var/lock/nginx \--with-http_stub_status_module \--with-http_ssl_module \--with-http_gzip_static_module \--with-pcre`

                   echo "$config" 
                   make  && make install
                   #启动Nginx
                   /usr/sbin/nginx
                   if [ $? = 0 ];then
                    echo -e "\033[33m已经安装完成\033[0m"
		    	exit
                    else
                        echo -e "\033[31m安装失败！请重新安装\033[0m"
                        exit
                    fi
		    #清理yum缓存
                    echo -e "\033[33m正在安装清理yum缓存，请稍等... \033[0m"
                    yum clean all && yum makecache
			exit

             fi
	  else
		echo -e "\033[31m下载失败,请检查网络!\033[0m"
		exit   
	  fi
	done 
	
}
# yum 安装官方nginx
yum_nginx () {
 echo "正在安装nginx~~~"
  yum -y install yum-utils
 ls /etc/yum.repos.d/nginx.repo
if [ $? = 0 ];then
  mv /etc/yum.repos.d/nginx.repo /etc/yum.repos.d/nginx.repo.bak
fi
 touch  /etc/yum.repos.d/nginx.repo
 echo "[nginx-stable]" >> /etc/yum.repos.d/nginx.repo
 echo "name=nginx stable repo" >> /etc/yum.repos.d/nginx.repo
echo 'baseurl=http://nginx.org/packages/centos/$releasever/$basearch/' >> /etc/yum.repos.d/nginx.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/nginx.repo
echo "enabled=1" >> /etc/yum.repos.d/nginx.repo
echo "gpgkey=https://nginx.org/keys/nginx_signing.key" >> /etc/yum.repos.d/nginx.repo
echo "" >> /etc/yum.repos.d/nginx.repo
echo "[nginx-mainline]" >> /etc/yum.repos.d/nginx.repo
echo "name=nginx mainline repo" >> /etc/yum.repos.d/nginx.repo
echo 'baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/' >> /etc/yum.repos.d/nginx.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/nginx.repo
echo "enabled=0" >> /etc/yum.repos.d/nginx.repo
echo "gpgkey=https://nginx.org/keys/nginx_signing.key" >> /etc/yum.repos.d/nginx.repo
yum -y install nginx
nginx -V
echo -e "\033[32m安装完成~~~~\033[0m"
exit 
}

##部署Tomcat
tomcat_config () {
   #查找是否安装了Tomcat
   ls /usr/local/tomcat* &>/dev/null
   if [ "$?" = 0 ];then
     echo -e  "\033[31mTomcat already exist！！！\033[0m"
     read -p "Whether to continue installation ?" yn
     if [ $yn = "y" ];then
       echo -e "\033[32mInstalling Tomcat~\033[0m"
	break
      else 
        echo -e "\033[32mExiting~\033[0m"
	 exit
     fi
     else
       echo -e "\033[32mInstalling Tomcat~\033[0m"
   fi
  #判断是否装有wget
   rpm -q wget &>/dev/null
   if [ $? != 0 ];then
     echo -e "\033[32Installing wget~\033[0m"
     yum -y install wget
   fi
  #安装Tomcat
  disable_FSI
  install_tm=`wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.85/bin/apache-tomcat-7.0.85.tar.gz`
  tar_tm=`tar xzvf apache-tomcat-7.0.85.tar.gz -C /usr/local/`
  cg_name=`mv /usr/local/apache-tomcat-7.0.85 /usr/local/tomcat_7`    
  move_tm=`mv apache-tomcat-7.0.85.tar.gz /usr/local/src`
  scp 192.168.78.6:/usr/local/src/jdk-7u67-linux-x64.tar.gz .
  ls jdk-7u67-linux-x64.tar.gz >/dev/null
  if [ $? = 0 ];then
      echo -e "\033[32mConfiguring java environment\033[0m"
      install_java=`tar xzvf jdk-7u67-linux-x64.tar.gz -C /usr/local/`
      change_name_j=`mv /usr/local/jdk1.7.0_67 /usr/local/java_7`
      echo 'export JAVA_HOME=/usr/local/java_7' >> /etc/profile.d/java_7.sh
      echo 'export PATH=$JAVA_HOME/bin/:$PATH' >> /etc/profile.d/java_7.sh
      echo 'export CATALINA_HOME=/usr/local/tomcat_7' >>/etc/profile.d/java_7.sh
      jiancha_ja=`source /etc/profile.d/java_7.sh`
      sleep 1
      java_up=`java -version`
      if [ $? = 0 ];then
         echo -e "\033[32mJava environment config successful~~~\033[0m"
      else 
        echo -e "\033[31mJava environment config fail !!!\033[0m"
      fi
    else 
       echo -e "\033[31mNot found jdk !!! [0m"
       echo -e "\033[31mJava environment config fail !!!\033[0m" 
  fi  
  start_up=`/usr/local/tomcat_7/bin/startup.sh`
  if [ $? = 0 ];then
    echo -e "\033[32mSuccessful installation Tomcat~\033[0m"
      exit 
   else 
      echo -e "\033[31mInstallation failed, please reinstall !!!\033[0m"
       exit
   fi
}

##配置java环境
java_config () {
#先判断系统是否配置有
java -version
if [ $? != 0 ];then
     echo -e "\033[31m经检测你的系统未配置有java环境,正在为你配置,请先将jdk压缩包放置家目录下...\033[0m"
	#检查是否有java包 
	ls jdk-8u211-linux-x64.tar.gz
	if [ $? = 0 ];then
        	echo "检查完毕"
	else
		echo -e "\033[31m未检测到java包,请重新导入!\033[0m"
		exit	
	fi
	echo -e "\033[31m是否开始安装?[yes/no]\033[0m" && read yn
	 if [ $yn = "yes" ];then
		echo "正在开始安装..."
		mv jdk-8u211-linux-x64.tar.gz  /usr/local/src/
		cd /usr/local/src/
		tar xf jdk-8u211-linux-x64.tar.gz  -C /usr/local/
		cd /usr/local/
		mv jdk1.8.0_211 java
		echo "export JAVA_HOME=/usr/local/java" >> /etc/profile.d/java.sh
	        echo 'export PATH=$JAVA_HOME/bin/:$PATH' >> /etc/profile.d/java.sh
		source /etc/profile.d/java.sh
		java -version
		if [ $? = 0 ];then
		   echo -e "\033[32m已经配置完成java环境!\033[0m"	
		exit 
		fi
	 else 
	 	echo "正在退出..."
		exit 
	 fi
else
     echo -e "\033[31m经检测你的系统已配置有java环境..\033[0m" 
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
               | |      |*        1、获取可Ping通的全部IP         *|      
               O_O      |*        2、查看是否存在用户             *|      
               / \      |*        3、一键安装常用包               *|      
                        |*        4、查看内核版本                 *|
                        |*        5、配置阿里云yum源              *|
                        |*        6、配置静/动态 IP               *|
                        |*        7、配置阿里云epel源(CentOS_7*)  *|
                        |*        8、一键三连                     *|
                        |*        a、源码安装Nginx                *|
                        |*        b、使用yum装官方nginx           *|
                        |*        c、配置java_8环境               *|
                        |*        t、部署Tomcat_7                 *|
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
"1")
	PingIP 
	;;
"2")
	Lookup_User
	;;
"3")
	Lookup_clientII
  	  ;;
"4")
        Lookup_kernel
	;;
"b")
	yum_nginx
        ;;
"5")
	Aliyun_yum
	;;
"6")
	Configure_IP
	;;
"7") 
	Config_epel
	;;
"8")
	disable_FSI
	;;
"a")  
	config_Nginx
        ;;
"c")
	java_config
	;;
"t")
        tomcat_config
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

