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
# изменяем конфиг для promtail
sed "s/stataddress/${IP}/g" \
  ./${USER}-configs/.config.yml > \
  ./${USER}-configs/config.yml
# изменяем конфиг для прометеуса
sed "s/targethosts/${TARGETHOSTS}/g" \
  ./${USER}-configs/.prometheus.yml > \
  ./${USER}-configs/prometheus.yml
# настраиваем вход по ssh без пароля
ssh-copy-id master@192.168.0.$1

# создаем на ВМ директорию и копируем туда все необходимые файлы
ssh master@192.168.0.$1 "mkdir /home/master/configs"
scp ./${USER}-configs/* master@192.168.0.$1:/home/master/configs

# даем право на использование sudo без пароля
ssh master@192.168.0.$1 \
    "echo 'changeme' | sudo -S cp /home/master/configs/sudoers /etc/sudoers"
# меняем имя хоста на log
ssh master@192.168.0.$1 "sudo hostnamectl set-hostname ${USER}"

# настраиваем статический ip 192.168.0.205
ssh master@192.168.0.$1 "sudo cp ${OURDIR}/00-installer-config.yaml \
		         /etc/netplan/00-installer-config.yaml"
ssh master@192.168.0.$1 "sudo netplan apply"

# устанавливаем prometheus и node-exporter 
ssh master@${IP} "sudo cp ${OURDIR}/resolv.conf \
			  /etc/resolv.conf"
ssh master@${IP} "sudo apt update"
ssh master@${IP} "sudo apt -y upgrade"
ssh master@${IP} "sudo apt -y install prometheus-node-exporter"
ssh master@${IP} "sudo apt -y install prometheus"
ssh master@${IP} "sudo apt install -y adduser libfontconfig1"
ssh master@${IP} "sudo apt -y install musl"
ssh master@${IP} "sudo dpkg -i ${OURDIR}/grafana_6.6.0_amd64.deb"
# устанавливаем loki и promtail для сбора логов
ssh master@${IP} "sudo dpkg -i /home/master/configs/loki*.deb"
ssh master@${IP} "sudo dpkg -i /home/master/configs/promtail*.deb"

# переходим на master для настройки пакетов
ssh master@${IP}
