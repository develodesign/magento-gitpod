FROM gitpod/workspace-full:latest

RUN sudo apt-get update
RUN sudo apt-get -y install lsb-release
RUN sudo apt-get -y install apt-utils
RUN sudo apt-get -y install python
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
RUN sudo apt-get -y install dialog

#Install php-fpm8.1
RUN sudo apt-get update \
    && sudo apt-get install -y curl zip unzip git software-properties-common supervisor sqlite3 \
    && sudo add-apt-repository -y ppa:ondrej/php \
    && sudo apt-get update \
    && sudo apt-get install -y php8.1-dev php8.1-fpm php8.1-common php8.1-cli php8.1-imagick php8.1-gd php8.1-mysql php8.1-pgsql php8.1-imap php-memcached php8.1-mbstring php8.1-xml php8.1-xmlrpc php8.1-soap php8.1-zip php8.1-curl php8.1-bcmath php8.1-sqlite3 php8.1-intl php-dev php8.1-dev php-redis \
    && sudo php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --version=2.3.5 --filename=composer \
    && sudo mkdir /run/php \
    && sudo chown gitpod:gitpod /run/php \
    && sudo chown -R gitpod:gitpod /etc/php \
    && sudo apt-get remove -y --purge software-properties-common \
    && sudo apt-get -y autoremove \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && sudo update-alternatives --remove php /usr/bin/php8.0 \
    && sudo update-alternatives --remove php /usr/bin/php7.3 \
    && sudo update-alternatives --set php /usr/bin/php8.1 \
    && sudo echo "daemon off;" >> /etc/nginx/nginx.conf

#Adjust few options for xDebug and disable it by default
RUN echo "xdebug.remote_enable=on" >> /etc/php/8.1/mods-available/xdebug.ini
    #&& echo "xdebug.remote_autostart=on" >> /etc/php/8.1/mods-available/xdebug.ini
    #&& echo "xdebug.profiler_enable=On" >> /etc/php/8.1/mods-available/xdebug.ini \
    #&& echo "xdebug.profiler_output_name = gitpod_xdebug.log >> /etc/php/8.1/mods-available/xdebug.ini \
    #&& echo "xdebug.show_error_trace=On" >> /etc/php/8.1/mods-available/xdebug.ini \
    #&& echo "xdebug.show_exception_trace=On" >> /etc/php/8.1/mods-available/xdebug.ini

# Install MySQL
ENV PERCONA_MAJOR 5.7
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
			"percona-server-server-$PERCONA_MAJOR/root-pass" \
			"percona-server-server-$PERCONA_MAJOR/re-root-pass" \
		; do \
			sudo echo "percona-server-server-$PERCONA_MAJOR" "$key" password 'nem4540'; \
		done; \
	} | sudo debconf-set-selections; \
	sudo apt-get update; \
	sudo apt-get install -y \
		percona-server-server-5.7 percona-server-client-5.7 percona-server-common-5.7 \
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
COPY gitpod/php-fpm.conf /etc/php/8.1/fpm/php-fpm.conf
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
     
#Install APCU..
RUN echo "apc.enable_cli=1" > /etc/php/8.1/cli/conf.d/20-apcu.ini
RUN echo "priority=25" > /etc/php/8.1/cli/conf.d/25-apcu_bc.ini
RUN echo "extension=apcu.so" >> /etc/php/8.1/cli/conf.d/25-apcu_bc.ini
RUN echo "extension=apc.so" >> /etc/php/8.1/cli/conf.d/25-apcu_bc.ini

RUN sudo chown -R gitpod:gitpod /etc/php
RUN sudo chown -R gitpod:gitpod /etc/nginx
RUN sudo chown -R gitpod:gitpod /etc/init.d/
RUN sudo echo "net.core.somaxconn=65536" | sudo tee /etc/sysctl.conf

RUN sudo rm -f /usr/bin/php
RUN sudo ln -s /usr/bin/php8.1 /usr/bin/php

# nvm environment variables
RUN sudo mkdir -p /usr/local/nvm
RUN sudo chown gitpod:gitpod /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.17.3

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

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.3-linux-x86_64.tar.gz --output elasticsearch-7.9.3-linux-x86_64.tar.gz \
    && tar -xzf elasticsearch-7.9.3-linux-x86_64.tar.gz
ENV ES_HOME79="$HOME/elasticsearch-7.9.3"

COPY gitpod/sp-elasticsearch.conf /etc/supervisor/conf.d/elasticsearch.conf
