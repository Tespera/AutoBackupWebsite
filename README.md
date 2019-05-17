

# <p align="center">The little Shell script will auto backup your website and mysql file.</p>

<p align="center">
    <a href="https://github.com/Tespera/AutoBackupWebsite/blob/master/LICENSE">
        <img src="https://img.shields.io/cocoapods/l/EFQRCode.svg?style=flat">
        </a>
    <a href="https://github.com/Tespera/AutoBackupWebsite">
        <img src="https://img.shields.io/badge/language-shell-49d292.svg">
        </a>
    <a href="https://github.com/Tespera/AutoBackupWebsite">
    <img src="https://img.shields.io/github/stars/Tespera/AutoBackupWebsite.svg?style=social&label=Star">
        </a>
    <a href="https://github.com/Tespera/AutoBackupWebsite">
    <img src="https://img.shields.io/github/forks/Tespera/AutoBackupWebsite.svg?style=social&label=Fork">
        </a>
</p>


代码有价，数据无价，为了安全起见，我们每天都需要备份数据库，但是备份数据库的时间往往是在凌晨左右，大家都休息，没人使用的时候，而我们也不能长期在每天的这个时候手动进行备份，所以我们就需要 Linux 系统实现自动备份，即定时自动执行脚本任务，但是我们也不能让所有的备份一直保留，那样长期备份的数据会占用很大的存储空间，所以我们还需要自动删除过期的备份。为了方便自己和大家，我写了一个 Shell 脚本来实现自动备份。


##### 首先切换到脚本存放目录，然后下载安装脚本

```
# git clone https://github.com/Tespera/AutoBackupWebsite.git
```

##### 修改配置信息
```shell
## 备份配置信息 （示例）## 

# 备份名称，用于标记 
BACKUP_NAME="www.tespera.com" 
# 备份目录，多个请空格分隔 
BACKUP_SRC="home/www" 
# Mysql主机地址 
MYSQL_SERVER="127.0.0.1" 
# Mysql用户名 
MYSQL_USER="user" 
# Mysql密码 
MYSQL_PASS="password" 
# Mysql备份数据库，多个请空格分隔 
MYSQL_DBS="blog" 
# 备份文件存放目录 
BACKUP_DIR="/Data/BlogBackup" 
# 备份文件压缩密码 
BACKUP_FILE_PASSWD="123456" 
# 备份文件保留天数 
SAVE_DAYS="30" 

## 备份配置信息 End ##

```


##### 赋予脚本执行权限
```
# chmod +x AutoBackupWebsite.sh
```

##### 开始执行备份
```
# ./AutoBackupWebsite.sh
```

##### 当命令行显示如下信息时即表示备份成功

```

Start dump MySQL ...
Dump MySQL OK ！

Start tar ...
tar OK ! 

Start clean temp file ...
Clean temp file OK ！

Start clean outdated file ...
Clean outdated file OK ！
 
Backup Successifully! 
 
[root@VM_135_138_centos backblog]#

```

注：脚本中清理过期备份的命令：

```
find $BACKUP_DIR -type f -name "*zip" -mtime +3 -exec rm -rf {} \;
```

参数 -mtime 表示修改时间，按天计算，以当前时间 2019-05-17 04：00 来说， -mtime +3 表示整数三天前，即 2019-05-14 04：00 之前，04：00 之后的不在查找范围之内。该行命令表示查找以当前时间 2019-05-17 04：00 计算三天之外的以 zip 结尾的普通文件并静默删除。 

本地测试需将 -mtime 参数改为 -mmin ，即修改时间按分钟计算，-mmin +3 可以删除三分钟之前修改过的文件，-mtime 无法在本地测试。 

测试成功之后，我们需要将此脚本添加至 Linux 的定时任务中，让其每天按时自动执行。 

先查看系统是否安装了 cron 服务（一般默认都安装了）

```
crontab -l  
```

输入上述命令如果不报错并输出了 corntab 里面已经存在的定时任务列表即表示系统已安装了 corntab 服务，如果显示 ‘no crontab for root’ 表示系统没有安装 corn ，安装指南：

ContOS 
```
yum -y install vixie-cron crontabs 
```

Ubuntu
```
apt-get install cron
```

安装成功之后，终端输入下面指令，打开定时器：
```
crontab -e  
```

按 i 修改，在最后一行添加如下代码，保存并退出，即可实现每天凌晨 4 点自动执行备份：
```
0 4 * * * /你的脚本存放目录/AutobackupWebsite.sh  
```
❉ 凌晨 4 点上网人数最少，服务器压力最小，适合做备份，可自行修改时间。

OK ！ Enjoy ！😘


### LICENSE
[MIT](https://github.com/Tespera/AutoBackupWebsite/blob/master/LICENSE)
