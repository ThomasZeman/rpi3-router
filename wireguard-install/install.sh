docker build . -t rpi3-wireguard-install
docker run --rm -it --name rpi3-wireguard-install -v /lib/modules:/lib/modules -v /usr/src:/usr/src:ro rpi3-wireguard-install
mkdir /lib/modules/$(uname -r)/kernel/extra
cp $(find /lib/modules/ -name "wireguard.ko") /lib/modules/$(uname -r)/kernel/extra
depmod -a
