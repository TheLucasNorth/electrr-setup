#!/bin/sh
echo "Set up for electrr, domain $1"
echo "Updating repositories"
sudo apt-get -qq update
echo "Installing NGINX…"
sudo apt-get -qq install nginx > /dev/null
echo "NGINX installed, configuring ufw (firewall)"
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
echo "Install MySQL…"
sudo apt-get -qq install mysql-server > /dev/null
echo "MySQL installed, configuring secure installation…"
echo "This will require input from you."
sudo mysql_secure_installation
echo "MySQL installed, installing PHP extensions"
sudo apt-get -qq install php-fpm php-mysql php-xml php-mbstring php-pear php-curl php-gd php-bcmath php-zip php-imagick php-tidy php-intl php-xmlrpc > /dev/null
echo "Installing Composer…"
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --quiet
sudo rm composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
echo "Composer installed"
echo "Installing electrr…"
sudo chown -R $USER: /var/www
cd /var/www
git clone https://github.com/TheLucasNorth/electrr.git
echo "Downloaded, installing...
sudo rm -rf html
cd electrr
echo "Installing composer dependencies..."
composer update -q
echo "electrr installed, configuring..."
cp .env.example .env
php artisan key:generate
sudo usermod -aG www-data $USER
sudo chown -R www-data:www-data /var/www/electrr/storage
sudo chown -R www-data:www-data /var/www/electrr/bootstrap/cache
sudo chmod -R 775 /var/www/electrr/storage
sudo chmod -R 775 /var/www/electrr/bootstrap/cache
echo "electrr installed"
echo "configuring Nginx…"
sed -i -e "s/example.com/$1/g" .nginx.example
sudo cp .nginx.example /etc/nginx/sites-available/electrr
sudo ln -s /etc/nginx/sites-available/electrr /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-enabled/default
sudo systemctl reload nginx
echo "Nginx configured"
echo "Configuring SSL"
sudo snap install core
sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --nginx
echo "Configured SSL"
echo "Installation complete, please create and configure your database, database user, and any further environment settings as needed"
echo "Enjoy using electrr!"
rm ~/electrr-setup.sh
