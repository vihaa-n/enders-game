echo "made by vihaan"
sleep 1
echo "you should run as root for this script to work"

if [[ $EUID -ne 0 ]]
then
  echo "This script must be run as root as it has commands that normally require a sudo"
  exit
fi

# Setting a password for all users

echo "Setting Password..."

pw=T2@Cybertaipan

for user in `cat /etc/passwd | grep -v "nologin\|false\|sync" | awk '{split($0,a,":");print a[1]}'`; 
do 
    echo $pw > thepword.txt
    cat thepword.txt | xargs -i /bin/bash -c "(echo '{}'; echo '{}') | sudo passwd $user"
done
rm thepword.txt 

echo "The New  Password is T2@Cybertaipan. Please note down."
sleep 1

# enabling ufw 
apt install ufw -y
ufw enable

# USER POLICIES
    # deleting the unauthorized users. 
    echo "deleting unauthorized users"
    sleep 1
    echo "if there are no users to delete, leave bad_users.txt empty."

    while IFS= read usertobedel
    do
        deluser "$usertobedel"
    done < bad_users.txt

# ipv4 cookies enabling
echo 1 > /proc/sys/net/ipv4/tcp_syncookies
sed -i 's/net.ipv4.tcp_syncookies=0/net.ipv4.tcp_syncookies=1/' /etc/sysctl.d/10-network-security.conf 
sed -i 's/#net.ipv4.tcp_syncookies=1/net.ipv4.tcp_syncookies=1/' /etc/sysctl.conf 

# ignore ipv4 requests
sed -i '#net.ipv4.conf.all.accept_redirects = 0/net.ipv4.conf.all.accept_redirects = 0/' /etc/sysctl.conf 
sed -i '#net.ipv6.conf.all.accept_redirects = 0/net.ipv6.conf.all.accept_redirects = 0/' /etc/sysctl.conf
sed  -i '#net.ipv4.conf.default.accept_redirects = 0/net.ipv4.conf.default.accept_redirects = 0/' /etc/sysctl.conf 
sed -i '#net.ipv6.conf.default.accept_redirects = 0/net.ipv6.conf.default.accept_redirects = 0/' /etc/sysctl.conf

# ftp service disabling
systemctl stop -pureftpd

# disabling guest account

# disabling ssh root login 
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Deleting prohibited files 
find /home -regextype posix-extended -regex '.*\.(midi|mid|mod|mp3|mp2|mpa|abs|mpega|au|snd|wav|aiff|aif|sid|flac|ogg|mpeg|mpg|mpe|dl|movie|movi|mv|iff|anim5|anim3|anim7|avi|vfw|avx|fli|flc|mov|qt|spl|swf|dcr|dir|dxr|rpm|rm|smi|ra|ram|rv|wmv|asf|asx|wma|wax|wmv|wmx|3gp|mov|mp4|flv|m4v|xlsx|pptx|docx|csv|tiff|tif|rs|iml|gif|jpeg|jpg|jpe|png|rgb|xwd|xpm|ppm|pbm|pgm|pcx|ico|svg|svgz|pot|xml|pl)$' -delete
echo "All prohibited files SHOULD be deleted."

# updating applications
    apt-get update 
    sudo apt-get upgrade 
    apt install unattended-upgrades -y

# Removing prohibited applications:

    echo "Removing prohibited applications:"

    echo -e "netcat\nnetcat-openbsd\nminetest\nicmpush\nwesnoth\nmanaplus\ngameconqueror\nnetcat-traditional\ngcc\ng++\nncat\npnetcat\nsocat\nsock\nsocket\nsbd\ntransmission\ntransmission-daemon\ndeluge\nyersinia\nnis\nrsh-client\ntalk\nldap-utils\njohn\njohn-data\nhydra\nhydra-gtk\naircrack-ng\nfcrackzip\nlcrack\nophcrack\nophcrack-cli\npdfcrack\npyrit\nrarcrack\nsipcrack\nirpas\nwireshark\ntshark\nkismet\nzenmap\nnmap\nwireguard\ntorrent\nopenvpn\nlogkeys\nzeitgeist-core\nzeitgeist-datahub\npython-zeitgeist\nrythmbox-plugin-zeitgeist\nzeitgeist\nnfs-kernel-server\nnfs-common\nportmap\nrpcbind\nautofs\nnginx\nnginx-common\ninetd\nopenbsd-inetd\nxinetd\ninetutils-\nvnc\nvtgrab\nsnmp" > applications.txt
    while IFS= read badapp 
    do 
        apt remove $badapp -y 
    done < applications.txt
    rm applications.txt

echo "All prohibited applications are removed."
