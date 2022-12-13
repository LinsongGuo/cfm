# Step 1. Mount a big partition to /mnt/data, only required on cloudlab
sudo mkdir -p /mnt/data
sudo mkfs -t ext3 /dev/sda4
sudo mount /dev/sda4 /mnt/data
sudo chmod 777 /mnt/data


# Step 2. change kernel version
sudo apt update
sudo apt-get install -y git build-essential kernel-package fakeroot libncurses5-dev libssl-dev ccache bison flex

cd /mnt/data
git clone https://github.com/clusterfarmem/fastswap.git

wget https://github.com/torvalds/linux/archive/a351e9b9fc24e982ec2f0e76379a49826036da12.zip
mv a351e9b9fc24e982ec2f0e76379a49826036da12.zip linux-4.11.zip
unzip linux-4.11.zip
mv linux-a351e9b9fc24e982ec2f0e76379a49826036da12 linux-4.11
cd linux-4.11
git init .
git add .
git commit -m "first commit"

git apply ../fastswap/kernel/kernel.patch
cp ../fastswap/kernel/config-4.11.0-041100-generic .config

make -j `getconf _NPROCESSORS_ONLN` deb-pkg LOCALVERSION=-fastswap

cd ..
sudo dpkg -i *.deb

# change the kernel to the default kernel 
# See https://gist.github.com/chaiyujin/c08e59752c3e238ff3b1a5098322b363
# then reboot

# Step 3. Install mlnx_ofed
# we use MLNX_OFED_LINUX-4.3-1.0.1.0-ubuntu18.04-x86_64.tgz
sudo ./mlnxofedinstall --add-kernel-support
sudo /etc/init.d/openibd restart
sudo reboot
# Check show_gids, ip a, ifconfig
# May need to do:
# sudo ip link set {interface} up
# sudo ip ad a {ip}/24 dev {interface} like  sudo ip ad a 10.10.1.1/24 dev enp65s0f0

# If in c6525 machine:
# open /etc/default/grub
# Then add "amd_iommu=on iommu=pt" to GRUB_CMDLINE_LINUX_DEFAULT
# Then reboot

# Step 4. change cgroup
# open /etc/default/grub
# add "cgroup_no_v1=memory" to GRUB_CMDLINE_LINUX_DEFAULT
# Then reboot

git clone https://github.com/clusterfarmem/cfm.git
cd cfm
sudo mkdir /cgroup2
./cfm/setup/init_bench_cgroups.sh


# Step 5. Run app.
# in memory node, change rmserver.c
# const unsigned int NUM_PROCS = num_of_cores;

# At node0, remove fastswap's loaded modules:
sudo rmmod fastswap
sudo rmmod fastswap_rdma

# At node1, start farmemory
cd /mnt/data/fastswap/farmemserver
./rmserver 9400

# At node0, insert fastswap's modules:
cd /mnt/data/fastswap/drivers
sudo insmod fastswap_rdma.ko sport=9400 sip="10.10.1.2" cip="10.10.1.1" nq=8
sudo insmod fastswap.ko

# At node0, run applications:
cd /mnt/data/cfm
# ./benchmark.py <workload> <ratio> (see https://github.com/clusterfarmem/cfm for details)

sudo apt install python3-pip -y
pip3 install grpcio grpcio-tools numpy scipy psutil

# For example:
./benchmark.py quicksort 0.5


