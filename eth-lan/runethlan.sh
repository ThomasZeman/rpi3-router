#!/bin/sh

ethif=eth1
ethip=10.0.0.7
ethsubnet=10.0.0.0
ethmask=24

# Mostly copied from hostapd - consider common location for both

# Waiting 10 seconds for wlan interface to come up / be transfered to container namespace

counter=0
until [ -e "/sys/class/net/$ethif" ] || [ $counter -eq 1200 ]; do
  sleep 1
  echo "Waiting for interface '$ethif' to become available... $((counter++))"
done

if [ ! -e "/sys/class/net/$ethif" ]; then
  echo "Giving up. Make sure interface has been set to namespace of container"
  exit 1
fi


echo "Creating bridge br0"
brctl addbr br0

echo "Adding eth0 to bridge br0"
brctl addif br0 eth0

echo "Adding eth1 to bridge br0"
brctl addif br0 eth1

echo "Enabling spanning tree protocol"
brctl stp br0 on

echo "Adding ip to external eth interface"
ip addr add $ethip/$ethmask dev $ethif

echo "Setting external eth interface to up"
ip link set dev $ethif up

echo "Adding ip to bridge br0"
ip addr add 10.0.0.8/24 dev br0

echo "Setting br0 to up"
ip link set dev br0 up

echo "Flushing all routes"
ip route flush all

echo "Adding route for br0"
ip route add 10.0.0.0/24 dev br0

echo "Adding default route via 10.0.0.1"
ip route add default via 10.0.0.1

term_handler() {
        echo "Got SIGTERM"
        kill -TERM $sleep_pid
}
trap term_handler SIGTERM

sleep 2147483647 &
sleep_pid=$!
wait $sleep_pid

brctl stp br0 off

echo "Removing eth0 from br0"
brctl delif br0 eth0

echo "Removing eth1 from br0"
brctl delif br0 eth1

echo "Setting br0 to down"
ip link set dev br0 down

brctl show

echo "Removing br0"
brctl delbr br0

