while true
do
		sleep 172800
		sudo rm -rf /mnt/BigLinux/backups/backup4;
		sudo mv -f /mnt/BigLinux/backups/backup3 /mnt/BigLinux/backups/backup4;
		sudo mv -f /mnt/BigLinux/backups/backup2 /mnt/BigLinux/backups/backup3;
		sudo mv -f /mnt/BigLinux/backups/backup1 /mnt/BigLinux/backups/backup2;
		sudo mkdir /mnt/BigLinux/backups/backup1;
		sudo cp -Prf /home/* /mnt/BigLinux/backups/backup1 &
		date +"backed up at %Y-%m-%d %T" >> ~/backup.log;
done
