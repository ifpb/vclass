#!/bin/bash
VERSION='node_exporter-1.3.1.linux-amd64'
SERVICENAME='node_exporter'

systemctl list-unit-files | grep -Fq "$SERVICENAME.service";
if $? = 0; then
  echo "$SERVICENAME instalado no sistema";
  
  systemctl list-units --full -all | grep -Fq "$SERVICENAME.service";
  if $? = 0; then
    echo "$SERVICENAME ativo no sistema";
  else
    systemctl daemon-reload;
    systemctl start node_exporter;
    STATUS=$(systemctl is-active node_exporter)
    if [ $STATUS == "inactive" ]; then echo "ERRO: $SERVICENAME nao estah ativo"; fi

else
  sudo apt update 2>&1 apt.log;
  sudo apt -y upgrade 2>&1 apt.log;

  wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/$VERSION.tar.gz;

  tar xvzf $VERSION.tar.gz;
  cp $VERSION/node_exporter /usr/local/bin;

  useradd --no-create-home --shell /bin/false node_exporter;
  chown node_exporter:node_exporter /usr/local/bin/node_exporter;

  tee -a /etc/systemd/system/node_exporter.service  << EOF
  [Unit]
  Description=Node Exporter
  Wants=network-online.target
  After=network-online.target

  [Service]
  User=node_exporter
  Group=node_exporter
  Type=simple
  ExecStart=/usr/local/bin/node_exporter

  [Install]
  WantedBy=multi-user.target
  EOF;

  systemctl daemon-reload;
  systemctl start node_exporter;
  STATUS=$(systemctl is-active node_exporter);
  if [ $STATUS == "inactive" ]; then echo "ERRO: $SERVICENAME nao estah ativo"; fi;
fi



