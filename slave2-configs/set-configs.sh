#!/bin/bash

OURDIR='/home/master/configs'

# настраиваем конфиги apache
sudo cp ${OURDIR}/000-default.conf \
        /etc/apache2/sites-available/000-default.conf
sudo cp ${OURDIR}/index.html /var/www/html/index.html
sudo cp ${OURDIR}/ports.conf /etc/apache2/ports.conf


# настраиваем репликацию mysql
sudo hostnamectl set-hostname slave2
sudo cp ${OURDIR}/mysqld.cnf  /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart
sudo mysql -e "STOP SLAVE;"
sudo mysql -e "CHANGE REPLICATION SOURCE TO SOURCE_HOST='192.168.0.200', \
               SOURCE_USER='slave', \
               SOURCE_PASSWORD='changeme', \
               SOURCE_AUTO_POSITION=1, \
               GET_SOURCE_PUBLIC_KEY=1;"
sudo mysql -e "START SLAVE;"
