echo "Removing docker networks (Errors can be ignored)"
docker network rm lan lantowan0 lantowan1 wan

echo "Creating network 'lan'"
docker network create -d bridge --internal --ip-range=10.1.1.0/28 --subnet=10.1.1.0/24 \
-o "com.docker.network.bridge.name"="lanbridge" lan

echo "Creating network 'lantowan0'"
docker network create -d bridge --internal --ip-range=10.1.2.0/28 --subnet=10.1.2.0/24 \
-o "com.docker.network.bridge.name"="lantowan0bridge" lantowan0

echo "Creating network 'lantowan1'"
docker network create -d bridge --internal --ip-range=10.1.3.0/28 --subnet=10.1.3.0/24 \
-o "com.docker.network.bridge.name"="lantowan1bridge" lantowan1

echo "Creating network 'wan'"
docker network create -d macvlan  --ip-range=10.1.4.0/28 --subnet=10.1.4.0/24 \
-o "com.docker.network.bridge.name"="wanbridge" \
-o parent=eth0 wan

echo "Creating volume 'rpi3-openvpn-data' to store the openvpn configuration"
docker volume create rpi3-openvpn-data

echo "Creating volume 'rpi3-dhcpd-data' to store the dhcp leases"
docker volume create rpi3-dhcpd-data

echo "Copying init script to /etc/init.d"
cp ./scripts/etc/init.d/rpi3-router* /etc/init.d/

echo "Adding rpi3-router init scripts to default runlevel"
rc-update add rpi3-router-base default
rc-update add rpi3-router-hostapd default

echo "Before the openvpn container can be started, you must store a openvpn configuration file called 'client.ovpn' in the ovpn volume under \
/var/lib/docker/volumes/rpi3-openvpn-data/_data"
