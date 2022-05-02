#!/bin/bash
version='phoronix-test-suite-10.8.3';
apt update && apt upgrade;
apt install -y    php php-xml  php-cli php-gd;
wget  https://phoronix-test-suite.com/releases/$version.tar.gz
tar xvf  $version.tar.gz;
cd  phoronix-test-suite;
sudo ./install-sh;
#Abaixo os testes benchmark instalados no projeto vclass
sudo  phoronix-test-suite force-install benchmark iozone;
sudo  phoronix-test-suite  force-install t-test1;
sudo phoronix-test-suite force-install iozone;
