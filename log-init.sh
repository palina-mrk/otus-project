#!/bin/bash

# первая переменная должна быть ip адресом!!!
USER='log'
IP='192.168.0.205'
# хосты, с которых будем собирать метрики
TARGETHOSTS="\'localhost:9100\',\'192.168.0.200:9100\'\
,\'192.168.0.201:9100\',\'192.168.0.202:9100\'"
# директория с конфигами на удаленном хосте
OURDIR='/home/master/configs'

# изменяем конфиг для настройки сети
sed "s/dynaddress/$1/g" \
  ./${USER}-configs/.00-installer-config.yaml > \
  ./${USER}-configs/..00-installer-config.yaml
sed "s/stataddress/${IP}/g" \
  ./${USER}-configs/..00-installer-config.yaml > \
  ./${USER}-configs/00-installer-config.yaml

# изменяем конфиг для прометеуса
sed "s/targethosts/${TARGETHOSTS}/g" \
  ./${USER}-configs/.prometheus.yml > \
  ./${USER}-configs/prometheus.yml
# настраиваем вход по ssh без пароля
ssh-copy-id master@192.168.0.$1

# создаем на ВМ директорию и копируем туда все необходимые файлы
ssh master@192.168.0.$1 "mkdir /home/master/configs"
scp ./${USER}-configs/* master@192.168.0.$1:/home/master/configs
scp ./deb-files/loki*.deb master@192.168.0.$1:/home/master/configs
scp ./deb-files/promtail*.deb master@192.168.0.$1:/home/master/configs
scp ./deb-files/grafana*.deb master@192.168.0.$1:/home/master/configs

# даем право на использование sudo без пароля
ssh master@192.168.0.$1 \
    "echo 'changeme' | sudo -S cp /home/master/configs/sudoers /etc/sudoers"
# меняем имя хоста на log
ssh master@192.168.0.$1 "sudo hostnamectl set-hostname ${USER}"

# настраиваем статический ip 192.168.0.205
ssh master@192.168.0.$1 "sudo cp ${OURDIR}/00-installer-config.yaml \
		         /etc/netplan/00-installer-config.yaml"
ssh master@192.168.0.$1 "sudo netplan apply"
sleep 300
# устанавливаем prometheus и node-exporter 
ssh master@${IP} "sudo cp ${OURDIR}/resolv.conf \
			  /etc/resolv.conf"
ssh master@${IP} "sudo apt update"
ssh master@${IP} "sudo apt -y upgrade"
ssh master@${IP} "sudo apt -y install prometheus-node-exporter"
ssh master@${IP} "sudo apt -y install prometheus"
ssh master@${IP} "sudo apt install -y adduser libfontconfig1"
ssh master@${IP} "sudo apt -y install musl"
ssh master@${IP} "sudo dpkg -i ${OURDIR}/grafana*.deb"

# переходим на master для настройки пакетов
ssh master@${IP}
