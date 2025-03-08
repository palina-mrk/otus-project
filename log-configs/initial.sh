#!/bin/bash

OURDIR='/home/master/configs'

# даем права на sudo без пароля
echo 'changeme' | sudo -S cp ${OURDIR}/sudoers /etc/sudoers

# меняем имя хоста
sudo hostnamectl set-hostname log

# настраиваем сеть
sudo cp ${OURDIR}/00-installer-config.yaml /etc/netplan/00-installer-config.yaml
sudo netplan apply
