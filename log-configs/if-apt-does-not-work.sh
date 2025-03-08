#!/bin/bash

sudo kill -9 $( sudo ps aux | grep -i apt | awk '{print $2}' )
sudo rm -rf /var/lib/dpkg/lock-frontend
sudo dpkg --configure -a
