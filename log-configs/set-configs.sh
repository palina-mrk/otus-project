#!/bin/bash

OURDIR='/home/master/configs'

# копируем конфиги
# для prometheus и grafana
sudo cp ${OURDIR}/prometheus.yml \
     /etc/prometheus/prometheus.yml 

# запускаем prometheus и grafana
sudo systemctl daemon-reload
sudo systemctl start prometheus-node-exporter
sudo systemctl enable prometheus-node-exporter
sudo systemctl restart prometheus
sudo systemctl enable prometheus
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
