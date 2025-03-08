#!/bin/bash

OURDIR='/home/master/configs'

# настраиваем nginx
sudo cp ${OURDIR}/default  /etc/nginx/sites-enabled/default
sudo systemctl reload nginx
# копируем конфиги для filebeats
sudo cp ${OURDIR}/nginx.yml /etc/filebeat/modules.d/nginx.yml
sudo cp ${OURDIR}/filebeat.yml /etc/filebeat/filebeat.yml 

# настраиваем mysql
sudo hostnamectl set-hostname master
sudo cp ${OURDIR}/mysqld.cnf  /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart
sudo mysql -e "CREATE USER slave@'%' \
               IDENTIFIED WITH 'caching_sha2_password' \
               BY 'changeme';"
sudo mysql -e "GRANT REPLICATION SLAVE \
               ON *.* TO slave@'%';"

# включаем node_exporter
sudo systemctl daemon-reload
sudo systemctl start prometheus-node-exporter
sudo systemctl enable prometheus-node-exporter

# добавляем в конфиг promtail чтение логов из nginx
sudo cp ${OURDIR}/config.yml /etc/promtail/config.yml
# даем право promtail на чтение логов nginx
sudo usermod -aG adm promtail
# включаем promtail и loki
sudo systemctl daemon-reload
sudo systemctl enable --now promtail
sudo systemctl enable --now loki
sudo systemctl restart promtail
sudo systemctl restart loki
