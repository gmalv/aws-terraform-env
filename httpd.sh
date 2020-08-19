#! /bin/bash
#sudo yum -y update
sudo yum -y install httpd
sudo mkdir -p /var/html/
echo "<h1> awesome,dude!GG </h1>" >> /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl restart httpd

