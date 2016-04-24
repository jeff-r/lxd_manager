From my history. Installing the zfs loopback device with lxd:

  cd projects/
  cd containers/
  sudo apt-get install zfsutils-linux
  sudo truncate -s 10G /media/jeff/vmspace/zfs_loopbacks/lxd.img
  sudo zpool create lxd /media/jeff/vmspace/zfs_loopbacks/lxd.img -m none
  history
  sudo lxd init
  lxc --help
  lxc list
  lxc help image
  lxc image list
  lxc launch ubuntu:16.04 xenial

sudo dpkg-reconfigure -p medium lxd
