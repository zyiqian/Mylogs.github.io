### 基于云服务器部署LAMP架构购物商城项目上线

LAMP指的是linux、Apache、mysql、PHP

linux版本：

```
[root@localhost ~]# cat /etc/redhat-release
CentOS Linux release 7.3.1611 (Core)
```

Apache:  **httpd-2.4.38** 

mysql:     **mysql-5.7.24**

PHP:   **php-5.6.16**

#### 1、首先安装Apache

访问 Apache 官网 https://www.apache.org/ 

```
1、下在Apache
cd /usr/local/src 
wget https://mirrors.tuna.tsinghua.edu.cn/apache/httpd/httpd-2.4.38.tar.gz

2、下载依赖包
wget http://mirror.bit.edu.cn/apache/apr/apr-1.6.5.tar.gz
wget http://mirror.bit.edu.cn/apache/apr/apr-util-1.6.1.tar.gz
wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz

3、解压 httpd 和 pcre 至 src
tar zxvf httpd-2.4.38.tar.gz -C ./
tar zxvf pcre-8.43.tar.gz -C ./

4、将apr和apr-util解压到/usr/local/src/httpd-2.4.38/srclib目录下  也就是httpd文件里面
tar zxvf apr-1.6.5.tar.gz -C /usr/local/src/httpd-2.4.38/srclib
tar zxvf apr-util-1.6.1.tar.gz -C /usr/local/src/httpd-2.4.38/srclib

5、将 apr-1.6.5 和 apr-util-1.6.1 分别改名 apr 和 apr-util
mv /usr/local/src/httpd-2.4.38/srclib/apr-1.6.5 /usr/local/src/httpd-2.4.38/srclib/apr
mv /usr/local/src/httpd-2.4.38/srclib/apr-util-1.6.1 /usr/local/src/httpd-2.4.38/srclib/apr-util

6、安装依赖包
   yum -y install  bzip2 bzip2-devel curl-devel libjpeg-devel libxslt libxslt-devel gcc make gcc gcc-c++ expat-devel openssl openssl-devel libmcrypt libpng-devel libpng freetype-devel 
   1、安装 pcre
   cd /usr/local/src/pcre-8.43
   mkdir /usr/local/pcre
	./configure --prefix=/usr/local/pcre
	make
	make install
	
   2、安装httpd
   cd /usr/local/src/httpd-2.4.38
   mkdir /usr/local/apache
   ./configure --prefix=/usr/local/apache \
    -with-pcre=/usr/local/pcre/bin/pcre-config -with-included-apr
    make
    make install
7、修改 apache 配置文件修改 80 端口为 81
vim /usr/local/apache/conf/httpd.conf
/Listen  #查找
Listen 80 ---> Listen 81

8、启动 apache
cd /usr/local/apache/bin/
./apachectl start
ps -ef | grep httpd
ss -ltpn

去浏览器访问 ip:81 
```

#### 2、安装PHP

PHP各种版本 http://mirrors.sohu.com/php/

```
cd /usr/local/src/
wget http://mirrors.sohu.com/php/php-5.6.16.tar.gz
tar -xzvf php-5.6.16.tar.gz -C /usr/local/src
mkdir /usr/local/php

cd /usr/local/src/php-5.6.16/
./configure --prefix=/usr/local/php --with-curl --with-freetype-dir --with-gd --with-gettext --with-iconv-dir --with-kerberos --with-libdir=lib64 --with-libxml-dir --with-mysqli --with-openssl --with-pcre-regex --with-pdo-mysql --with-pdo-sqlite --without-pear --disable-phar --with-png-dir --with-jpeg-dir --with-xmlrpc --with-xsl --with-zlib --with-bz2 --with-mhash --enable-fpm --enable-bcmath --enable-libxml --enable-inline-optimization --enable-gd-native-ttf --enable-mbregex --enable-mbstring --enable-opcache --enable-pcntl --enable-shmop --enable-soap --enable-sockets --enable-sysvsem --enable-sysvshm --enable-xml --enable-zip --with-apxs2=/usr/local/apache/bin/apxs

make
make install

若还需要安装其他依赖包自行下载
 cd /usr/local/php/bin/
 wget  http://pear.php.net/go-pear.phar
 chmod -R 755 go-pear.phar
7.打开Apache的/usr/local/apache/conf下的httpd.conf，为了使得Apache识别php，应该做如下修改：

vim /usr/local/apache/conf/httpd.conf
<IfModule dir_module> DirectoryIndex index.html </IfModule>

->添加个index.php

<IfModule dir_module> DirectoryIndex index.html  index.php </IfModule>

在配置文件中搜素： AddType 关键字，在其后面追加下面三行，如果不追加，httpd会直接打印php文件内容，不会调用php执行。
 AddType application/x-httpd-php .php
 AddType application/x-httpd-php .php .phtml .php3
 AddType application/x-httpd-php-source .phps

还有必须新增一行：
<FilesMatch \.php$>
    SetHandler application/x-httpd-php
</FilesMatch>

在/usr/local/apache/htdocs目录下新建info.php
vim /usr/local/apache/htdocs/info.php
添加以下内容
<?php
     phpinfo();
?>

重启apache
cd /usr/local/apache/bin/
./apachectl start
浏览器访问 192.168.78.88:81/info.php ,如显示php的版本信息，说明apache解析php成功
```

#### 3、安装mysql

我安装mysql是直接执行脚本安装，先上传我打包好的mysql安装脚本，如果本机安装有mysql就不必重装了

```
rz 
sh mysql_install_5.7.24.sh #记得把安装包放一起
安装完成后修改配置文件
vim /etc/my.cnf
skip-grant-tables=1             //添加这条命令如果不行则 添加这条 skip-grant-tables
systemctl restart mysqld
systemctl restart mysqld   我每次都要重启两次。。。
mysql -uroot
mysql> alter user 'root'@'localhost' identified by "1";  //ERROR 1290 (HY000)这个错误不用管
mysql> use mysql;

创建一个 用户root 密码为1
mysql> update user set authentication_string=password('1') where user='root'; 
Query OK, 1 row affected, 1 warning (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 1           //OK 则修改成功
mysql> flush privileges;
退出mysql

修改成功后把验证那条命令注释掉
[root@mysql ~]# vim /etc/my.cnf
[mysqld]
#skip-grant-tables=1
[root@mysql ~]# systemctl restart mysqld   
[root@mysql ~]# mysql -uroot -p1           //登录

无法通过套接字'/var/lib/mysql/mysql.sock'（2）在第1314行连接到本地MySQL服务器。

[root@localhost ~]# mkdir /var/lib/mysql
[root@localhost ~]# ln -s /usr/local/mysqld/tmp/mysql.sock /var/lib/mysql/mysql.sock   //  ln -s 源文件(my.cnf查找，不同安装方式路径也不同)  目标文件 

```

#### 4、上传项目

```
cd /usr/local/apache/htdocs/
rz 
dist.zip
unzip dist.zip
cd dist/api
vim connect.php  //修改登录数据库的用户名和密码
导入数据
进入dist项目目录的db目录，然后打开mysql
mysql -uroot -p1
mysql> create database onlineshop;  //现在创建一个库
mysql> use onlineshop   //使用库
mysql>  source /usr/local/apache/htdocs/dist/db/onlineshop.sql  //导入数据
mysql> flush privileges; //刷新下

重启apache
cd /usr/local/apache/bin/
./apachectl stop
./apachectl start
然后直接可以去浏览器 访问了
192.168.78.13:81/dist
测试里面的功能没问题就OK了
```

