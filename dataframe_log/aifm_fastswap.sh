#/bin/bash

sudo sh -c "echo '+memory' > /sys/fs/cgroup/unified/cgroup.subtree_control"
#sudo sh -c "mkdir /sys/fs/cgroup/unified/bench"
sudo sh -c "echo $$ > /sys/fs/cgroup/unified/bench/cgroup.procs"

cache_sizes=(31) # (1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31)

sudo pkill -9 main

# log_folder=`pwd`
#cd cfm/dataframe/
#rm -rf build
#mkdir build
#cd build
#cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=g++-9 ..
#make -j

cd cfm/dataframe/build 

for cache_size in ${cache_sizes[@]}
do
	mem_bytes_limit=`echo $(($(($(($cache_size * 1024))*1024))*1024))`
	        sudo sh -c "echo $mem_bytes_limit > /sys/fs/cgroup/unified/bench/memory.high"
		    sudo taskset -c 1 ./bin/main > /mnt/data/log2/log.$cache_size
	    	# sudo taskset -c 1 ./run.sh > /mnt/data/log/log.$cache_size
	    done

