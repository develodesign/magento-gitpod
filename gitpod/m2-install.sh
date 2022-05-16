#!/bin/bash
sudo composer selfupdate --2;
sudo chown -R gitpod:gitpod /home/gitpod/.config/composer;
cd $GITPOD_REPO_ROOT &&
composer config -g -a http-basic.repo.magento.com 64229a8ef905329a184da4f174597d25 a0df0bec06011c7f1e8ea8833ca7661e &&
composer create-project --no-interaction --no-progress --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.3 magento2
cd magento2 && cp -avr .* $GITPOD_REPO_ROOT;
cd $GITPOD_REPO_ROOT && rm -r -f magento2 &&

mysql -u root -pnem4540 -e 'CREATE DATABASE IF NOT EXISTS magento2;' &&
url=$(gp url | awk -F"//" {'print $2'}) && url+="/" && url="https://8002-"$url; cd $GITPOD_REPO_ROOT && composer install -n && php bin/magento setup:install --db-name='magento2' --db-user='root' --db-password='nem4540' --base-url=$url --backend-frontname='admin' --admin-user='admin' --admin-password='adm4540' --admin-email=$GITPOD_GIT_USER_EMAIL --admin-firstname='Admin' --admin-lastname='User' --use-rewrites='1' --use-secure='1' --base-url-secure=$url --use-secure-admin='1' --language='en_GB' --db-host='127.0.0.1' --cleanup-database --timezone='Europe/London' --currency='GBP' --session-save='redis'
git checkout -- .gitignore &&

n98-magerun2 module:disable Magento_Csp &&
n98-magerun2 module:disable Magento_TwoFactorAuth &&
n98-magerun2 setup:upgrade &&

yes | php bin/magento setup:config:set --session-save=redis --session-save-redis-host=127.0.0.1 --session-save-redis-log-level=3 --session-save-redis-db=0 --session-save-redis-port=6379;
yes | php bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=127.0.0.1 --cache-backend-redis-db=1;
yes | php bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=127.0.0.1 --page-cache-redis-db=2;

php bin/magento config:set web/cookie/cookie_path "/" --lock-config &&
php bin/magento config:set web/cookie/cookie_domain ".gitpod.io" --lock-config &&

n98-magerun2 cache:flush &&
redis-cli flushall &&
#Use this section to import a staging DB instead of using the default blank M2
#cd $GITPOD_REPO_ROOT/gitpod && unzip magento-db.sql.zip && 
#url=$(gp url | awk -F"//" {'print $2'}) && url="8002-"$url && sed -i 's#staging-domain.com#'$url'#g' magento-db.sql && 
#mysql -uroot -pnem4540 magento2 < magento-db.sql && 
#cd $GITPOD_REPO_ROOT && ./bin/magento setup:upgrade && 
#mysql -u root -pnem4540 -e 'use magento2; update core_config_data set value = 8 where path = "design/theme/theme_id";' &&
#n98-magerun2 cache:flush &&
touch $GITPOD_REPO_ROOT/gitpod/db-installed.flag
