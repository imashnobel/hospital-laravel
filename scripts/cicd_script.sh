#!/bin/bash
set -e

echo "Deploying application ...."

pushd /var/web/html_new/cicd/hospital-laravel/
#sudo rm -rf composer.lock


git checkout .
git pull origin dev

sudo /usr/local/bin/composer install --no-dev --optimize-autoloader
#sudo /usr/local/bin/composer require predis/predis
#npm install

sudo chmod -R 777 storage
sudo chmod -R 777 bootstrap/cache
php artisan config:cache      
php artisan cache:clear
php artisan config:clear
php artisan queue:restart

popd
sudo chown -Rf nginx:ecom /var/web/html_new/cicd/hospital-laravel/
sudo chmod -Rf 770 /var/web/html_new/cicd/hospital-laravel/
sudo chmod -Rf g+s /var/web/html_new/cicd/hospital-laravel/
sudo systemctl reload php-fpm.service
sudo nginx -s reload

echo "Application deployed!"
