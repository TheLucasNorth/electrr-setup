# electrr-setup
Automated setup script for electrr

Refer to https://lucasnorth.gitbook.io/electrr/automated-installation for further details.

This script will install Nginx, MySQL, relevant PHP extensions, Composer, electrr, and Certbot for SSL. The script will configure most of these, but requires input for MYSQL_SECURE_SETUP, and Certbot. The process is otherwise non-interactive.

After running this, you will need to configure your database and database user, and update your .env file, which will be located at /var/www/electrr/.env

## Pre-requisites

This script is intended to be run on an otherwise clean (new) VPS running Ubuntu 20.04.
You should have created a non-root user with sudo privileges, e.g.:
 > adduser electrr
 > 
 > usermod -aG sudo electrr
  
## Installation

As the non-root user you created, run the following:

 > curl https://raw.githubusercontent.com/TheLucasNorth/electrr-setup/main/electrr-setup.sh -o electrr-setup.sh
 > 
 > sh electrr-setup.sh YOUR_ELECTRR_DOMAIN
 
It is essential that you replace YOUR_ELECTRR_DOMAIN with the domain you intend to use for electrr. It should be the fully qualified domain name only, e.g. electrr.example.com
This value is used to configure your NGINX sites.

This script is destructive - it will remove any existing /var/www/html directory, and unlink the default Nginx site. It is not intended to be used where you have already configured Nginx or other services.
