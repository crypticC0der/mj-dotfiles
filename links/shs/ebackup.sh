while true
do
		sleep 172800;
		ssh mj@192.168.0.30 "
		rm ~/backups/backup4 -rf;
		mv ~/backups/backup3 ~/backups/backup4 -f;
		mv ~/backups/backup2 ~/backups/backup3 -f; 
		mv ~/backups/backup1 ~/backups/backup2 -f;
		mkdir ~/backups/backup1;"
		scp -r ~/Documents/Programming mj@192.168.0.30:~/backups/backup1 & 
		date +"externally backed up code at %Y-%m-%d %T" >> ~/ebackup.log;
done
