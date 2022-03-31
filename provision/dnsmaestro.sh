#Configuración DNS Maestro

echo "Instalar Bind"
	yum install bind-utils bind-libs bind-* -y

echo "Modificando /etc/named.conf"	
	cat <<TEST> /etc/named.conf
options {
        listen-on port 53 { 127.0.0.1; 192.168.100.4; 192.168.10.15; };
        listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        secroots-file   "/var/named/data/named.secroots";
        recursing-file  "/var/named/data/named.recursing";
        allow-query     { localhost; 192.168.100.0/24; 192.168.10.0/24; };
        allow-transfer  { localhost; 192.168.100.3; };

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
        type master;
        file "daanez.com.fwd";
        allow-update { none; };
};

zone "100.168.192.in-addr.arpa" IN{
        type master;
        file "daanez.com.rev";
        allow-update { none; };
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
TEST
	
echo "Creando los archivos de zona"
	cp /var/named/named.empty /var/named/daanez.com.fwd
	cp /var/named/named.empty /var/named/daanez.com.rev
	chmod 755 /var/named/daanez.com.fwd
	chmod 755 /var/named/daanez.com.rev
	
	cat <<TEST> /var/named/daanez.com.fwd
@       IN SOA  servidor3.daanez.com. root@daanez.com. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
@       IN      NS      servidor3.daanez.com.
@       IN      NS      servidor2.daanez.com.

;host en la zona

servidor3       IN      A       192.168.100.4
servidor2       IN      A       192.168.100.3
firewall        IN      A       192.168.10.15
smart           IN      A       192.168.10.14
TEST

echo "$ORIGIN 100.168.192.in-addr.arpa." >> /var/named/daanez.conf.fwd
echo "$TTL 3H" >> /var/named/daanez.conf.fwd
	
	cat <<TEST> /var/named/daanez.com.rev
@       IN SOA  servidor3.daanez.com. root@daanez.com. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
@       IN      NS      servidor3.daanez.com.
@       IN      NS      servidor2.daanez.com.

;host en la zona
4       IN      PTR     servidor3.daanez.com.
3       IN      PTR     servidor2.daanez.com.
2       IN      PTR     firewall.daanez.com.
TEST

echo "$ORIGIN 100.168.192.in-addr.arpa." >> /var/named/daanez.conf.rev
echo "$TTL 3H" >> /var/named/daanez.conf.rev
	
echo "Levantando el servicio"
	service named start
	chkconfig named on

echo "Reconfigurando el /etc/resolv.conf"
	cat <<TEST> /etc/resolv.conf
nameserver 192.168.10.15
nameserver 192.168.100.4
TEST