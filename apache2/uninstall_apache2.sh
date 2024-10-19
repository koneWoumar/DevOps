sudo systemctl stop apache2
sudo apt -y purge apache2 apache2-utils apache2-bin apache2.2-common
sudo apt autoremove
sudo rm -rf /etc/apache2 /var/www/html /var/log/apache2
