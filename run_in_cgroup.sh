sudo cgcreate -g cpuset:/mycgroup
sudo cgset -r cpuset.cpus=0 /mycgroup

fallocate -l 100 file.txt

sudo cgexec -g cpuset:/mycgroup time parallel ./cp ::: file.txt file.txt ::: copy1.txt copy2.txt 2>> time_res.txt
