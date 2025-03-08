#!/bin/bash

#Mysql backup script

OURDIR='/home/master/configs'

rm -rf ${OURDIR}/mysql-backup
mkdir ${OURDIR}/mysql-backup
cd ${OURDIR}/mysql-backup

for s in `sudo mysql --skip-column-names -e "SHOW DATABASES"`; do
	if [ "$s" != mysql -a "$s" != sys -a \
            "$s" != information_schema -a "$s" != performance_schema ]; then
	mkdir ./$s;
	for t in `sudo mysql --skip-column-names  \
                	     -e "show tables from $s"`;
		do
                sudo /usr/bin/mysqldump \
	        --set-gtid-purged=OFF \
        	--single-transaction  \
                --add-locks  \
	        --create-options \
        	--extended-insert \
                --quick \
	        --set-charset \
        	--events  \
                --triggers \
	        --tables \
        	$s $t > ./$s/$t.sql;
                done
	fi
	done

cd ..

tar cvf mysql-backup.tar mysql-backup/*/*
gzip mysql-backup.tar
rm -rf mysql-backup
