#!/bin/bash 

version="prometheus-2.34.0.linux-amd64.tar.gz";

useradd --no-create-home --shell /bin/false prometheus;

useradd --no-create-home --shell /bin/false node_exporter;

mkdir /etc/prometheus;

mkdir /var/lib/prometheus;

wget "https://github.com/prometheus/prometheus/releases/download/v2.34.0/$version";

tar xvf  $version;

cp $version/prometheus /usr/local/bin/;

cp $version/promtool /usr/local/bin/;

chown -R prometheus:prometheus /etc/prometheus/consoles

chown -R prometheus:prometheus /etc/prometheus/consoles_libraries
