#!/bin/bash 

version="prometheus-2.34.0.linux-amd64.tar.gz";

useradd --no-create-home --shell /bin/false prometheus;

useradd --no-create-home --shell /bin/false node_exporter;

mkdir /etc/prometheus;

mkdir /var/lib/prometheus;

wget "https://github.com/prometheus/prometheus/releases/download/v2.34.0/$version";

tar xvf  $version;

cp prometheus-*/prometheus /usr/local/bin/;
cp prometheus-*/promtool /usr/local/bin/;

chown prometheus:prometheus /usr/local/bin/prometheus;
chown prometheus:prometheus /usr /local/bin/promtool;

cp -r prometheus-* /consoles/etc/prometheus;
cp -r prometheus-* /console_libraries/etc/prometheus;
 
chown -R prometheus:prometheus /etc/prometheus/consoles;
chown -R prometheus:prometheus /etc/prometheus/console_libraries;

mv prometheus-*/prometheus.yml /etc/prometheus/config-backup; 

touch /etc/prometheus/prometheus.yml;

tee -a /etc/prometheus/prometheus.yml  << EOF

global:
  scrape_interval:     10s
  evaluation_interval: 20s
rule_files:
  - 'alert.rules'
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
         - targets: ['localhost:9090'] EOF;

tee -a /etc/systemd/system/prometheus.service << EOF 
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target EOF;

systemctl daemon-reload;
systemctl start prometheus;
systemctl enable prometheus;
systemctl status prometheus;
