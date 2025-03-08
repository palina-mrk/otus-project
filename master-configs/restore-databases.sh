#!/bin/bash

OURDIR='/home/master/configs'

cd ${OURDIR}
rm -rf ${OURDIR}/mysql-backup
gunzip mysql-backup.tar.gz
tar xvf  mysql-backup.tar

for s in `ls ${OURDIR}/mysql-backup`; do
	sudo mysql -e "DROP DATABASE IF EXISTS $s"
	sudo mysql -e "CREATE DATABASE $s"
	for t in `ls ${OURDIR}/mysql-backup/$s`; do
		sudo /usr/bin/mysqldump $s < ${OURDIR}/mysql-backup/$s/$t
	done
done
