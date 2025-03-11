#!/bin/bash

MASTERIP='192.168.0.200'
IP='192.168.0.201'

ssh master@${IP} "/home/master/configs/mysql-back.sh"
scp master@${IP}:/home/master/configs/mysql-backup.tar.gz ./master-configs/
scp ./master-configs/mysql-backup.tar.gz \
    master@${MASTERIP}:/home/master/configs/
