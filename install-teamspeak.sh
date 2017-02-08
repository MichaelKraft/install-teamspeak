#/bin/bash
# create user
adduser --disabled-login -gecos "" teamspeak
# download and open package
wget http://dl.4players.de/ts/releases/3.0.12.4/teamspeak3-server_linux_amd64-3.0.12.4.tar.bz2
tar xvf teamspeak3-server_linux_amd64-3.0.12.4.tar.bz2
cd teamspeak3-server_linux_amd64
# move everything to teamspeak user's home dir
cp * -R /home/teamspeak
cd ..
# cleanup, set permissions
rm -rf teamspeak3-server_linux_amd64*
chown -R teamspeak:teamspeak /home/teamspeak
# create the systemd file
echo "[Unit]" > /lib/systemd/system/teamspeak.service
echo "Description=Team Speak 3 Server" >> /lib/systemd/system/teamspeak.service
echo "After=network.target" >> /lib/systemd/system/teamspeak.service
echo "[Service]" >> /lib/systemd/system/teamspeak.service
echo "WorkingDirectory=/home/teamspeak/" >> /lib/systemd/system/teamspeak.service
echo "User=teamspeak" >> /lib/systemd/system/teamspeak.service
echo "Group=teamspeak" >> /lib/systemd/system/teamspeak.service
echo "Type=forking" >> /lib/systemd/system/teamspeak.service
echo "ExecStart=/home/teamspeak/ts3server_startscript.sh start inifile=ts3server.ini" >> /lib/systemd/system/teamspeak.service
echo "ExecStop=/home/teamspeak/ts3server_startscript.sh stop" >> /lib/systemd/system/teamspeak.service
echo "PIDFile=/home/teamspeak/ts3server.pid" >> /lib/systemd/system/teamspeak.service
echo "RestartSec=15" >> /lib/systemd/system/teamspeak.service
echo "Restart=alway" >> /lib/systemd/system/teamspeak.services
echo "[Install]" >> /lib/systemd/system/teamspeak.service
echo "WantedBy=multi-user.target" >> /lib/systemd/system/teamspeak.service
# install and start service
systemctl --system daemon-reload
systemctl start teamspeak.service
systemctl enable teamspeak.service
# display privilege key for admin
echo ""
echo "Privilege Key:"
cat /home/teamspeak/logs/ts3server_* | grep token=
