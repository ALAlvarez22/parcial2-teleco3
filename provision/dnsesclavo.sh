#Configuración DNS Esclavo

echo "Instalar Bind"
	yum install bind-utils bind-libs bind-* -y

echo "Modificando /etc/named.conf"
	
	cat <<TEST> /etc/named.conf
options {
        listen-on port 53 { 127.0.0.1; 192.168.100.3; };
        listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        secroots-file   "/var/named/data/named.secroots";
        recursing-file  "/var/named/data/named.recursing";
        allow-query     { localhost; 192.168.100.0/24; 192.168.10.0/24; };

        recursion yes;

        dnssec-enable yes;
        dnssec-validation yes;

        managed-keys-directory "/var/named/dynamic";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
		};	
};

zone "." IN {
        type hint;
        file "named.ca";
};

zone "daanez.com" IN{
        type slave;
        file "slaves/daanez.com.fwd";
        masters { 192.168.100.4; };
};

zone "100.168.192.in-addr.arpa" IN{
        type slave;
        file "slaves/daanez.com.rev";
        masters { 192.168.100.4; };
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
TEST
	
echo "Levantando el servicio"
	service named start
	chkconfig named on

echo "Reconfigurando el /etc/resolv.conf"
	cat <<TEST> /etc/resolv.conf
nameserver 192.168.10.15
nameserver 192.168.100.4
TEST