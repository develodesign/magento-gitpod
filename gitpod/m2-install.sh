#!/bin/bash
GITPOD_DIR=$GITPOD_REPO_ROOT/gitpod/;
REPO_ROOT=$GITPOD_REPO_ROOT/;

echo "============ 1. Install Magento if required =========="
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e 'CREATE DATABASE IF NOT EXISTS magento2;'
url=$(gp url | awk -F"//" {'print $2'}) && url+="/" && 
url="https://8002-"$url && 
if [ "${INSTALL_MAGENTO}" = "YES" ]; then php bin/magento setup:install --db-name='magento2' --db-user='root' --db-password=$MYSQL_ROOT_PASSWORD --base-url=$url --backend-frontname='admin' --admin-user=$MAGENTO_ADMIN_USERNAME --admin-password=$MAGENTO_ADMIN_PASSWORD --admin-email=$GITPOD_GIT_USER_EMAIL --admin-firstname='Admin' --admin-lastname='User' --use-rewrites='1' --use-secure='1' --base-url-secure=$url --use-secure-admin='1' --language='en_GB' --db-host='127.0.0.1' --cleanup-database --timezone='Europe/London' --currency='GBP' --session-save='redis'; fi &&
echo "----------------------------------------------"

echo "================ 2. INSTALL DB ==============="
### UNCOMMENT if using an existing Magento staging DB instead of using the default blank M2 ** ###
#cd $GITPOD_REPO_ROOT/gitpod && unzip magento-db.sql.zip && 
#sed -i 's#staging-domain.com#'$url'#g' magento-db.sql && 
#mysql -uroot -pnem4540 magento2 < magento-db.sql && 
echo "----------------------------------------------"

echo "======= 3. INSTALL MAGENTO ENV & CONFIG ======"
### UNCOMMENT if using an existing Magento code base ###
#cd $GITPOD_DIR &&
#cp "./.magento.env.php" "$GITPOD_REPO_ROOT/app/etc/env.php" &&
#sed -i 's#{{GITPOD_ROOT_DOMAIN}}#'$MAGENTO_URL_FULL'#g' "$GITPOD_REPO_ROOT/app/etc/env.php" &&
#cd $GITPOD_REPO_ROOT && 
#php bin/magento cache:flush &&
#php bin/magento setup:upgrade && 
echo "-----------------------------------------------"

echo "==== 4. CONFIGURATION (config:set) CHANGES ===="
php bin/magento config:set system/security/max_session_size_admin 1024000 &&
php bin/magento config:set web/cookie/cookie_path "/" &&
php bin/magento config:set web/cookie/cookie_domain ".gitpod.io" &&
php bin/magento config:set system/full_page_cache/caching_application 1 &&
php bin/magento deploy:mode:set developer &&
php bin/magento module:disable Magento_AdminAdobeImsTwoFactorAuth Magento_TwoFactorAuth &&
php bin/magento module:disable Magento_Csp  &&
php bin/magento module:disable Magento_TwoFactorAuth  &&
#php bin/magento config:set algoliasearch_credentials/credentials/enable_backend 0 &&
echo "----------------------------------------------"

echo "============ 5. CLEAR CACHES ETC ============"
php bin/magento cache:clean config && redis-cli flushall;
php bin/magento indexer:reindex;
echo "----------------------------------------------"

echo "========== 6. INSTALL FLAG COMPLETE =========="
touch $GITPOD_REPO_ROOT/gitpod/db-installed.flag;
echo "----------------------------------------------"
