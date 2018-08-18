#!/bin/sh

wlanif=wlan0
wlanip=10.1.1.1
wlansubnet=10.1.1.0
wlanmask=24

# Waiting 10 seconds for wlan interface to come up / be transfered to container namespace

counter=0
until [ -e "/sys/class/net/$wlanif" ] || [ $counter -eq 10 ]; do
  sleep 1
  echo "Waiting for interface '$wlanif' to become available... $((counter++))"
done

if [ ! -e "/sys/class/net/$wlanif" ]; then
  echo "Giving up. Make sure interface has been set to namespace of container"
  exit 1
fi

ip addr add $wlanip/$wlanmask dev $wlanif

cat > /etc/hostapd/hostapd.conf << '__EOF__'
interface=wlan0
driver=nl80211
ssid=Deep Space One
hw_mode=g
channel=7
wmm_enabled=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=test1234
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
__EOF__


# trap signals
trap 'true' SIGINT
trap 'true' SIGTERM
trap 'true' SIGHUP

/usr/sbin/hostapd /etc/hostapd/hostapd.conf &

route add $wlansubnet/$wlanmask dev $wlanif

wait $!

route del $wlansubnet/$wlanmask dev $wlanif
