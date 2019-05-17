#!/bin/bash
# Author：Tespera
# Blog: https://www.tespera.com/

## 备份配置信息 ##

# 备份名称，用于标记
BACKUP_NAME="www.tespera.com"
# 备份目录，多个请空格分隔
BACKUP_SRC="/home/www "
# Mysql主机地址
MYSQL_SERVER="127.0.0.1"
# Mysql用户名
MYSQL_USER="user"
# Mysql密码
MYSQL_PASS="password"
# Mysql备份数据库，多个请空格分隔
MYSQL_DBS="blog"
# 备份文件存放目录
BACKUP_DIR="/Data/Backup"
# 备份文件压缩密码
BACKUP_FILE_PASSWD="www.tespera.com"
# 备份文件保留天数
SAVE_DAYS="30"
## 备份配置信息 End ##



## 以下内容无需修改 ##

NOW=$(date +"%Y%m%d%H%M%S") #精确到秒，同一秒内上传的文件会被覆盖

mkdir -p $BACKUP_DIR
mkdir -p $BACKUP_SRC/MySQL_bak

# 备份Mysql
echo -e "\nStart dump MySQL ..."
for db_name in $MYSQL_DBS
do
	mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p$MYSQL_PASS $db_name > "$BACKUP_SRC/MySQL_bak/$BACKUP_NAME-$db_name-$NOW.sql"
done
echo "Dump MySQL OK ！"

# 打包备份文件
echo -e "\nStart tar ..."
BACKUP_FILENAME="$BACKUP_NAME-backup-$NOW.zip"
zip -q -r -P $BACKUP_FILE_PASSWD $BACKUP_DIR/$BACKUP_FILENAME $BACKUP_SRC/MySQL_bak/*.sql $BACKUP_SRC
echo "tar OK ! "

# 清理临时备份文件
echo -e "\nStart clean temp file ..."
rm -rf $BACKUP_SRC/MySQL_bak/*.sql
echo "Clean temp file OK ！"

# 清理过期备份文件
echo -e "\nStart clean outdated file ..."
find $BACKUP_DIR -type f -name "*zip" -mtime +$SAVE_DAYS -exec rm -rf {} \;
echo "Clean outdated file OK ！"

# 写入日志
echo "$NOW  Backup $BACKUP_SRC successifully!" >> $BACKUP_DIR/backup.log 2>&1

# 备份结束
echo -e "\033[32m \nBackup Successifully! \n \033[0m" 


