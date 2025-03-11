#!/bin/bash

OURDIR='/home/master/configs'

# копируем конфиги
# для prometheus и grafana
sudo cp ${OURDIR}/prometheus.yml \
     /etc/prometheus/prometheus.yml 
# настраиваем promtail 
sudo cp ${OURDIR}/config.yml /etc/promtail/config.yml
# даем право promtail на чтение логов 
sudo usermod -aG adm promtail

# запускаем prometheus и grafana
sudo systemctl daemon-reload
sudo systemctl start prometheus-node-exporter
sudo systemctl enable prometheus-node-exporter
sudo systemctl restart prometheus
sudo systemctl enable prometheus
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# включаем promtail и loki
sudo systemctl enable --now promtail
sudo systemctl enable --now loki
sudo systemctl restart promtail
sudo systemctl restart loki
