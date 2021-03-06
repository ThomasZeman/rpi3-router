echo "Removing docker networks (Errors can be ignored)"
docker network rm lan lantowan0 lantowan1 wan

echo "Creating network 'lan'"
docker network create -d bridge --internal --ip-range=10.0.0.0/28 --subnet=10.0.0.0/24 --gateway=10.0.0.254 \
-o "com.docker.network.bridge.name"="lanbridge" lan

echo "Creating network 'lantowan1'"
docker network create -d bridge --internal --ip-range=10.1.1.0/28 --subnet=10.1.1.0/24 --gateway=10.1.1.254 \
-o "com.docker.network.bridge.name"="lantowan1bridge" lantowan1

echo "Creating network 'lantowan2'"
docker network create -d bridge --internal --ip-range=10.1.2.0/28 --subnet=10.1.2.0/24 --gateway=10.1.2.254 \
-o "com.docker.network.bridge.name"="lantowan2bridge" lantowan2

echo "Creating network 'wan'"
docker network create -d bridge --ip-range=10.1.0.0/28 --subnet=10.1.0.0/24 --gateway=10.1.0.254 \
-o "com.docker.network.bridge.name"="wanbridge" wan

echo "Creating volume 'rpi3-openvpn-data' to store the openvpn configuration"
docker volume create rpi3-openvpn-data

echo "Creating volume 'rpi3-dhcpd-data' to store the dhcp leases and dynamic dns update key"
docker volume create rpi3-dhcpd-data

echo "Creating volume 'rpi3-bind9-data' to store bind9 configuration"
docker volume create rpi3-bind9-data

/usr/sbin/dnssec-keygen -a HMAC-MD5 -b 512 -r /dev/urandom -n USER dns_update_key
update_key=$( /bin/sed -n 's@^Key:[[:space:]]\+\(.*\)$@\1@ ; 3p' K*.private )
/bin/cat << EOF > /var/lib/docker/volumes/rpi3-bind9-data/_data/dns_update_key
key dns_update_key {
  algorithm hmac-md5;
  secret "${update_key}";
};
EOF
cp /var/lib/docker/volumes/rpi3-bind9-data/_data/dns_update_key /var/lib/docker/volumes/rpi3-dhcpd-data/_data/dns_update_key
rm K*.key
rm K*.private

echo "Copying init script to /etc/init.d"
cp ./scripts/etc/init.d/rpi3-router* /etc/init.d/

echo "Adding rpi3-router init scripts to default runlevel"
rc-update add rpi3-router-base default

echo "Before the openvpn container can be started, you must store a openvpn configuration file called 'client.ovpn' in the ovpn volume under \
/var/lib/docker/volumes/rpi3-openvpn-data/_data"
