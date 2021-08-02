while true
do
	sync; 
	sudo sh -c "echo 3 > /proc/sys/vm/drop_caches";
	date +"cleared cache at %Y-%m-%d %T" >> ~/killcache.log;
	sleep 86400;
done
