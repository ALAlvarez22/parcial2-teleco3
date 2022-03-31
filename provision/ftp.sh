#Configuración ftp

echo "Instalar vsftpd"
	yum install vsftpd -y

echo "Modificando el archivo de configuracion"
	echo "allow_writeable_chroot=YES" >> /etc/vsftpd/vsftpd.conf
	sed  's/#write_enable=NO/write_enable=YES/g' /etc/vsftpd/vsftpd.conf
	
echo "Habilitando el servicio"
	service vsftpd start
	chkconfig vsftpd on