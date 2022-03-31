#Configuración de Firewall

service NetworkManager stop
service firewalld start

echo "Habilitar el redireccionamiento de paquetes"
	echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

echo "Configuracion de las zonas"
	firewall-cmd --zone=public --remove-interface=eth0 --permanent
	firewall-cmd --zone=public --remove-interface=eth1 --permanent
	firewall-cmd --zone=public --remove-interface=eth2 --permanent
	firewall-cmd --zone=internal --remove-interface=eth0 --permanent
	firewall-cmd --zone=internal --remove-interface=eth1 --permanent
	firewall-cmd --zone=internal --remove-interface=eth2 --permanent
	firewall-cmd --zone=dmz --remove-interface=eth0 --permanent
	firewall-cmd --zone=dmz --remove-interface=eth1 --permanent
	firewall-cmd --zone=dmz --remove-interface=eth2 --permanent
	
	firewall-cmd --set-default-zone=dmz
	firewall-cmd --zone=dmz --add-interface=eth1 --permanent
	firewall-cmd --zone=internal --add-interface=eth2 --permanent
	
	firewall-cmd --zone=dmz --add-masquerade --permanent
	firewall-cmd --zone=internal --add-masquerade --permanent
	
	firewall-cmd --zone=dmz --add-service=ftp --permanent
	firewall-cmd --zone=dmz --add-service=dns --permanent
	firewall-cmd --zone=dmz --add-service=tftp --permanent
	
	firewall-cmd --zone=dmz --add-forward-port=port=20:proto=tcp:toport=20:toaddr=192.168.100.3 --permanent
	firewall-cmd --zone=dmz --add-forward-port=port=21:proto=tcp:toport=21:toaddr=192.168.100.3 --permanent
	firewall-cmd --zone=dmz --add-forward-port=port=53:proto=udp:toport=53:toaddr=192.168.100.3 --permanent
	firewall-cmd --zone=dmz --add-forward-port=port=53:proto=tcp:toport=53:toaddr=192.168.100.3 --permanent
	
	firewall-cmd --zone=dmz --add-port=20/tcp --permanent
	firewall-cmd --zone=dmz --add-port=21/tcp --permanent
	firewall-cmd --zone=dmz --add-port=53/udp --permanent
	firewall-cmd --zone=dmz --add-port=53/tcp --permanent
	
echo "Poner la configuracion en runtime"
	firewall-cmd --reload

echo "Iniciando el servicio"
	service NetworkManager start
	service firewalld restart
	chkconfig firewalld on

echo "Reconfigurando el /etc/resolv.conf"
	cat <<TEST> /etc/resolv.conf
nameserver 192.168.10.15
nameserver 192.168.100.4
TEST