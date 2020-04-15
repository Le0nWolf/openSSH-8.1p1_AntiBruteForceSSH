#!/bin/bash

#Check if User is ROOT
if [[ $EUID -ne 0 ]]; then
	echo "Sorry, this script must be run as root" 1>&2
	exit 1
fi
#Update
SECONDS=0
apt update
apt upgrade && apt --yes upgrade

#Install necessary Packets for building SSH: build-essential, zlib1g-dev, libssl-dev, libsystemd-dev, pkg-config, libpam0g-dev
apt --yes install build-essential zlib1g-dev libssl-dev libsystemd-dev pkg-config libpam0g-dev

#Configure
cd  openssh-8.1p1
echo wird Configuriert
sleep 1
./configure --with-systemd --with-pam --prefix=/usr --sysconfdir=/etc/ssh
echo Configurieren abgeschlossen Compilieren wird gestartet
sleep 1
#compile
make
echo Compilieren abgeschlossen. Installation wird gestartet
sleep 1
#Installieren
make install
sleep 1
#disable PAM authentication for nicer log
sed -i "s/UsePAM yes/UsePAM no/g" /etc/ssh/sshd_config
#restart SSH deamon
systemctl restart ssh && echo && echo openSSH_Patch by Leon erfolgreich installiert :D
duration=$SECONDS
echo
echo
echo
echo "Installationszeit: $(($duration / 60))m und $(($duration % 60))s"
