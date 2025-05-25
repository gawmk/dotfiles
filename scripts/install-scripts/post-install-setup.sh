# setting up syncthing as user service
#

systemctl --user enable syncthing.service
echo 'Syncthing user service started!'


systemctl enable iwd.service
echo 'iwd enabled!'


