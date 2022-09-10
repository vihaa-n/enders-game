echo "made by vihaan"
sleep 1

if [[ $EUID -ne 0 ]]
then
  echo "This script must be run as root or you may get those messages asking if you are root"
  exit
fi

# Setting a password for all users

pw=T2@Cybertaipan

for user in `cat /etc/passwd | grep -v "nologin\|false\|sync" | awk '{split($0,a,":");print a[1]}'`; 
do 
    echo $pw > thepword.txt
    cat thepword.txt | xargs -i /bin/bash -c "(echo '{}'; echo '{}') | sudo passwd $user"
done
rm thepword.txt 

echo "The New  Password is $pw"

apt-get -V -y install firefox hardinfo chkrootkit iptables portsentry lynis ufw gufw sysv-rc-conf nessus clamav
ufw enable 
apt-get update 
    #read -p "Do you want to download Openssh?" sshvar
    #if [$sshvar == yes] 
    #then 
    #    apt-get install openssh-server -y

    #elif [$sshvar == no]
    #then 
    #    read -p "Do you want it removed?" sshtwovar
    #    if [$sshtwovar == yes]
    #    then 
    #    echo "OpenSSH shall be removed"
    #    apt-get remove openssh-server -y
    #    elif [$sshtwovar == no]
    #    echo "OpenSSH shall not be removed"
    #fi 

#ipv4 cookie enable
echo 1 > /proc/sys/net/ipv4/tcp_syncookies
sed -i 's/net.ipv4.tcp_syncookies=0/net.ipv4.tcp_syncookies=1/' /etc/sysctl.d/10-network-security.conf 
sed -i 's/#net.ipv4.tcp_syncookies=1/net.ipv4.tcp_syncookies=1/' /etc/sysctl.conf 

# ignore ipv4 requests
sed -i 's/#net.ipv4.conf.all.accept_redirects = 0/net.ipv4.conf.all.accept_redirects = 0/' /etc/sysctl.conf 
sed -i 's/#net.ipv6.conf.all.accept_redirects = 0/net.ipv6.conf.all.accept_redirects = 0/' /etc/sysctl.conf
sed -i 's/#net.ipv4.conf.default.accept_redirects = 0/net.ipv4.conf.default.accept_redirects = 0/' /etc/sysctl.conf 
sed -i 's/#net.ipv6.conf.default.accept_redirects = 0/net.ipv6.conf.default.accept_redirects = 0/' /etc/sysctl.conf

sysctl -p 
# ftp service disabling

#DOES NOT WORK DO MANUALLY

#read -p "Do you want ftp to be disabled? " ftpvar
#if ["$ftpvar" == "yes"]; then 
#    systemctl stop -pureftpd
#else 
#    echo "ftp shall be left alone."
#fi

# disabling guest account

# disabling ssh root login (I tested in the training images and it works)
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Deleting prohibited files 
find /home -regextype posix-extended -regex '.*\.(midi|mid|mod|mp3|mp2|mpa|abs|mpega|au|snd|wav|aiff|aif|sid|flac|ogg|mpeg|mpg|mpe|dl|movie|movi|mv|iff|anim5|anim3|anim7|avi|vfw|avx|fli|flc|mov|qt|spl|swf|dcr|dir|dxr|rpm|rm|smi|ra|ram|rv|wmv|asf|asx|wma|wax|wmv|wmx|3gp|mov|mp4|flv|m4v|xlsx|pptx|docx|csv|tiff|tif|rs|iml|gif|jpeg|jpg|jpe|png|rgb|xwd|xpm|ppm|pbm|pgm|pcx|ico|svg|svgz|pot|xml|pl)$' -delete
echo "All prohibited files should be deleted."


# Removing prohibited applications:

    echo "Removing prohibited applications"

    echo -e "netcat\nnetcat-openbsd\nminetest\nicmpush\nwesnoth\nmanaplus\ngameconqueror\nnetcat-traditional\ngcc\ng++\nncat\npnetcat\nsocat\nsock\nsocket\nsbd\ntransmission\ntransmission-daemon\ndeluge\nyersinia\nnis\nrsh-client\ntalk\nldap-utils\njohn\njohn-data\nhydra\nhydra-gtk\naircrack-ng\nfcrackzip\nlcrack\nophcrack\nophcrack-cli\npdfcrack\npyrit\nrarcrack\nsipcrack\nirpas\nwireshark\ntshark\nkismet\nzenmap\nnmap\nwireguard\ntorrent\nopenvpn\nlogkeys\nzeitgeist-core\nzeitgeist-datahub\npython-zeitgeist\nrythmbox-plugin-zeitgeist\nzeitgeist\nnfs-kernel-server\nnfs-common\nportmap\nrpcbind\nautofs\nnginx\nnginx-common\ninetd\nopenbsd-inetd\nxinetd\ninetutils-\nvnc\nvtgrab\nsnmp" > applications.txt
    while IFS= read badapp 
    do 
        apt remove $badapp -y 
    done < applications.txt
    rm applications.txt

echo "All prohibited applications are removed."

