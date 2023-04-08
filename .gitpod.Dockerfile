FROM gitpod/workspace-full:latest

# Magento Config
ENV INSTALL_MAGENTO YES
ENV MAGENTO_VERSION 2.4.4
ENV MAGENTO_ADMIN_EMAIL admin@magento.com
ENV MAGENTO_ADMIN_PASSWORD password1
ENV MAGENTO_ADMIN_USERNAME admin
ENV MAGENTO_COMPOSER_AUTH_USER 64229a8ef905329a184da4f174597d25
ENV MAGENTO_COMPOSER_AUTH_PASS a0df0bec06011c7f1e8ea8833ca7661e

# Platform Config
ENV PHP_VERSION 8.1
ENV PERCONA_MAJOR 5.7
ENV ELASTICSEARCH_VERSION 7.9.3
ENV COMPOSER_VERSION 2.3.5
ENV NODE_VERSION 14.17.3
ENV MYSQL_ROOT_PASSWORD nem4540
ENV XDEBUG_DEFAULT_ENABLED YES

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN sudo apt-get update
RUN sudo apt-get -y install lsb-release
RUN sudo apt-get -y install apt-utils
RUN sudo apt-get -y install python-is-python3
RUN sudo apt-get install -y libmysqlclient-dev
RUN sudo apt-get -y install rsync
RUN sudo apt-get -y install curl
RUN sudo apt-get -y install libnss3-dev
RUN sudo apt-get -y install openssh-client
RUN sudo apt-get -y install mc
RUN sudo apt install -y software-properties-common
RUN sudo apt-get -y install gcc make autoconf libc-dev pkg-config
RUN sudo apt-get -y install libmcrypt-dev
RUN sudo mkdir -p /tmp/pear/cache
RUN sudo mkdir -p /etc/bash_completion.d/cargo
RUN sudo apt install -y php-dev
RUN sudo apt install -y php-pear
RUN sudo install-packages php-xdebug

#Install php-fpm
RUN sudo apt-get update \
    && sudo apt-get install -y curl zip unzip git supervisor sqlite3 \
    && sudo apt update && sudo apt -y upgrade \
    && sudo apt install ca-certificates apt-transport-https -y \
    && sudo add-apt-repository ppa:ondrej/php \
    && sudo apt-get update \
    && sudo apt-get install -y php${PHP_VERSION}-dev php${PHP_VERSION}-fpm php${PHP_VERSION}-common php${PHP_VERSION}-cli php${PHP_VERSION}-imagick php${PHP_VERSION}-gd php${PHP_VERSION}-mysql php${PHP_VERSION}-pgsql php${PHP_VERSION}-imap php-memcached php${PHP_VERSION}-mbstring php${PHP_VERSION}-xml php${PHP_VERSION}-xmlrpc php${PHP_VERSION}-soap php${PHP_VERSION}-zip php${PHP_VERSION}-curl php${PHP_VERSION}-bcmath php${PHP_VERSION}-sqlite3 php${PHP_VERSION}-intl php-dev php${PHP_VERSION}-dev php${PHP_VERSION}-xdebug php-redis \
    && sudo php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --version=${COMPOSER_VERSION} --filename=composer \
    && sudo chown -R gitpod:gitpod /etc/php \
    && sudo apt-get remove -y --purge software-properties-common \
    && sudo apt-get -y autoremove \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && sudo update-alternatives --set php /usr/bin/php${PHP_VERSION} \
    && sudo echo "daemon off;" >> /etc/nginx/nginx.conf

#Adjust few options for xDebug and disable it by default
RUN sudo echo "xdebug.remote_enable=on" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
    #&& echo "xdebug.remote_autostart=on" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
    #&& echo "xdebug.profiler_enable=On" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini \
    #&& echo "xdebug.profiler_output_dir = /var/log/" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini \
    #&& echo "xdebug.profiler_output_name = gitpod_xdebug.log >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini \
    #&& echo "xdebug.show_error_trace=On" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini \
    #&& echo "xdebug.show_exception_trace=On" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
    
RUN if [ ! "$XDEBUG_DEFAULT_ENABLED" = "YES" ]; then sudo mv /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini-bak; fi

# Install MySQL
RUN sudo apt-get update \
 && sudo apt-get -y install gnupg2 \
 && sudo apt-get clean && sudo rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* \
 && sudo mkdir /var/run/mysqld \
 && sudo wget -c https://repo.percona.com/apt/percona-release_latest.stretch_all.deb \
 && sudo dpkg -i percona-release_latest.stretch_all.deb \
 && sudo apt-get update
 
RUN set -ex; \
	{ \
		for key in \
			percona-server-server/root_password \
			percona-server-server/root_password_again \
			"percona-server-server-${PERCONA_MAJOR}/root-pass" \
			"percona-server-server-${PERCONA_MAJOR}/re-root-pass" \
		; do \
			sudo echo "percona-server-server-${PERCONA_MAJOR}" "$key" password ${MYSQL_ROOT_PASSWORD}; \
		done; \
	} | sudo debconf-set-selections; \
	sudo apt-get update; \
	sudo apt-get install -y \
		percona-server-server-${PERCONA_MAJOR} percona-server-client-${PERCONA_MAJOR} percona-server-common-${PERCONA_MAJOR} \
	;
	
RUN sudo chown -R gitpod:gitpod /etc/mysql /var/run/mysqld /var/log/mysql /var/lib/mysql /var/lib/mysql-files /var/lib/mysql-keyring

# Install our own MySQL config
COPY gitpod/mysql.cnf /etc/mysql/conf.d/mysqld.cnf
COPY gitpod/.my.cnf /home/gitpod/.my.cnf
COPY gitpod/mysql.conf /etc/supervisor/conf.d/mysql.conf
RUN sudo chown gitpod:gitpod /home/gitpod/.my.cnf

# Install default-login for MySQL clients
COPY gitpod/client.cnf /etc/mysql/conf.d/client.cnf

#Copy nginx default and php-fpm.conf file
#COPY default /etc/nginx/sites-available/default
COPY gitpod/php-fpm.conf /etc/php/${PHP_VERSION}/fpm/php-fpm.conf
COPY gitpod/sp-php-fpm.conf /etc/supervisor/conf.d/sp-php-fpm.conf
RUN sudo chown -R gitpod:gitpod /etc/php

COPY gitpod/nginx.conf /etc/nginx

# Install Redis.
RUN sudo apt-get update \
 && sudo apt-get install -y \
  redis-server \
 && sudo rm -rf /var/lib/apt/lists/*
 
 #n98-magerun2 tool
 RUN wget https://files.magerun.net/n98-magerun2.phar \
     && chmod +x ./n98-magerun2.phar \
     && sudo mv ./n98-magerun2.phar /usr/local/bin/n98-magerun2

RUN sudo chown -R gitpod:gitpod /etc/php
RUN sudo chown -R gitpod:gitpod /etc/nginx
RUN sudo chown -R gitpod:gitpod /etc/init.d/
RUN sudo echo "net.core.somaxconn=65536" | sudo tee /etc/sysctl.conf

RUN sudo rm -f /usr/bin/php
RUN sudo ln -s /usr/bin/php${PHP_VERSION} /usr/bin/php

# nvm environment variables
RUN sudo mkdir -p /usr/local/nvm
RUN sudo chown gitpod:gitpod /usr/local/nvm
ENV NVM_DIR /usr/local/nvm

# Replace shell with bash so we can source files.
RUN sudo rm /bin/sh && sudo ln -s /bin/bash /bin/sh

# install nvm
# https://github.com/creationix/nvm#install-script.
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# install node and npm, set default alias
RUN source $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default

RUN curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz --output elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz \
    && tar -xzf elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz
ENV ES_HOME="$HOME/elasticsearch-${ELASTICSEARCH_VERSION}"

COPY gitpod/sp-elasticsearch.conf /etc/supervisor/conf.d/elasticsearch.conf
