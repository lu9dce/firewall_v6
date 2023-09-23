#!/bin/bash
#
####################################################################
# Definir el comando de ip6tables con sudo
####################################################################
IPT6="sudo ip6tables"
IPT4="sudo iptables"

####################################################################
# Limpiar todas las reglas existentes
####################################################################
$IPT6 -F
$IPT6 -X

####################################################################
# Establecer una política predeterminada de DENEGAR
####################################################################
$IPT6 -P INPUT DROP
$IPT6 -P FORWARD DROP
$IPT6 -P OUTPUT ACCEPT

####################################################################
# Permitir tráfico local
####################################################################
$IPT6 -A INPUT -i lo -j ACCEPT
$IPT6 -A OUTPUT -o lo -j ACCEPT

####################################################################
# Permitir el tráfico de respuesta de las conexiones establecidas
####################################################################
$IPT6 -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

####################################################################
# Permitir tráfico ICMP (ping)
####################################################################
$IPT6 -A INPUT -p ipv6-icmp -j ACCEPT

####################################################################
# Puertos UDP abiertos ENTRADA
####################################################################
#$IPT6 -A INPUT -p udp --dport 53 -j ACCEPT        # DNS (UDP)
#$IPT6 -A INPUT -p udp --dport 93 -j ACCEPT        # BBS AXIP
#$IPT6 -A INPUT -p udp --dport 2223 -j ACCEPT      # FT8 ADI
#$IPT6 -A INPUT -p udp --dport 2237 -j ACCEPT      # FT8
$IPT6 -A INPUT -p udp --dport 5353 -j ACCEPT      # mDNS
#$IPT6 -A INPUT -p udp --dport 10093 -j ACCEPT     # BBS AXIP
#$IPT6 -A INPUT -p udp --dport 30051 -j ACCEPT     # D-STAR
#$IPT6 -A INPUT -p udp --dport 40880 -j ACCEPT     # BBS AXIP

####################################################################
# Puertos TCP abiertos de ENTRADA
####################################################################
#$IPT6 -A INPUT -p tcp --dport 21 -j ACCEPT        # FTP
#$IPT6 -A INPUT -p tcp --dport 22 -j ACCEPT        # SSH
#$IPT6 -A INPUT -p tcp --dport 53 -j ACCEPT        # DNS (tcp)
#$IPT6 -A INPUT -p tcp --dport 80 -j ACCEPT        # HTTP
#$IPT6 -A INPUT -p tcp --dport 110 -j ACCEPT       # POP3
#$IPT6 -A INPUT -p tcp --dport 143 -j ACCEPT       # IMAP
#$IPT6 -A INPUT -p tcp --dport 443 -j ACCEPT       # HTTPS
#$IPT6 -A INPUT -p tcp --dport 465 -j ACCEPT       # SMTPS
#$IPT6 -A INPUT -p tcp --dport 587 -j ACCEPT       # SMTP (submission)
#$IPT6 -A INPUT -p tcp --dport 631 -j ACCEPT       # CUPS (printers)
#$IPT6 -A INPUT -p tcp --dport 993 -j ACCEPT       # IMAPS
#$IPT6 -A INPUT -p tcp --dport 995 -j ACCEPT       # POP3S
#$IPT6 -A INPUT -p tcp --dport 5200 -j ACCEPT      # Echolink
$IPT6 -A INPUT -p tcp --dport 5900 -j ACCEPT      # VNC
#$IPT6 -A INPUT -p tcp --dport 6300 -j ACCEPT      # BBS TELNET FWD
#$IPT6 -A INPUT -p tcp --dport 8010 -j ACCEPT      # BBS TELNET USER
#$IPT6 -A INPUT -p tcp --dport 8073 -j ACCEPT      # BBS WEB
#$IPT6 -A INPUT -p tcp --dport 8772 -j ACCEPT      # Winlink
#$IPT6 -A INPUT -p tcp --dport 11063 -j ACCEPT     # PSK31
#$IPT6 -A INPUT -p tcp --dport 14580 -j ACCEPT     # APRS
#$IPT6 -A INPUT -p tcp --dport 22555 -j ACCEPT     # SSH (personal)
#$IPT6 -A INPUT -p udp --dport 52001 -j ACCEPT     # ADI TCP

####################################################################
# Registrar y rechazar todo lo demás
####################################################################
$IPT6 -A INPUT -j LOG --log-prefix "IP6Tables-Dropped: "
$IPT6 -A INPUT -j REJECT

####################################################################
# Habilitar IPv6 reenvio
####################################################################
echo "1" | sudo tee /proc/sys/net/ipv6/conf/all/forwarding  > /dev/null
echo "1" | sudo tee /proc/sys/net/ipv6/conf/default/forwarding  > /dev/null
#
#
