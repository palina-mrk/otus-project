#!/bin/bash

# первая переменная должна быть ip адресом!!!
USER='slave2'
IP='192.168.0.202'

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
# настраиваем вход по ssh без пароля
ssh-copy-id master@192.168.0.$1

# создаем на ВМ директорию и копируем туда все необходимые файлы
ssh master@192.168.0.$1 "mkdir /home/master/configs"
scp ./${USER}-configs/* master@192.168.0.$1:/home/master/configs

# даем право на использование sudo без пароля
ssh master@192.168.0.$1 \
    "echo 'changeme' | sudo -S cp /home/master/configs/sudoers /etc/sudoers"
# меняем имя хоста на slave2
ssh master@192.168.0.$1 "sudo hostnamectl set-hostname ${USER}"

# настраиваем статический ip 192.168.0.202
ssh master@192.168.0.$1 "sudo cp /home/master/configs/00-installer-config.yaml \
		         /etc/netplan/00-installer-config.yaml"
ssh master@192.168.0.$1  "sudo netplan apply"

# устанавливаем mysql и nginx
ssh master@${IP} "sudo cp /home/master/configs/resolv.conf \
			  /etc/resolv.conf"
ssh master@${IP} "sudo apt update"
ssh master@${IP} "sudo apt -y upgrade"
ssh master@${IP} "sudo apt -y install apache2"
ssh master@${IP} "sudo apt -y install mysql-server-8.0"
ssh master@${IP} "sudo apt -y install prometheus-node-exporter"
# устанавливаем loki и promtail для сбора логов
ssh master@${IP} "sudo dpkg -i /home/master/configs/loki*.deb"
ssh master@${IP} "sudo dpkg -i /home/master/configs/promtail*.deb"

# переходим на master для настройки пакетов
ssh master@${IP}
