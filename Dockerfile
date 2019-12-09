FROM php:7.2
RUN apt-get update -yqq && apt-get install -yqq git libmcrypt-dev libpq-dev libcurl4-gnutls-dev libicu-dev libvpx-dev libjpeg-dev libpng-dev libxpm-dev zlib1g-dev libfreetype6-dev libxml2-dev libexpat1-dev libbz2-dev libgmp3-dev libldap2-dev unixodbc-dev libsqlite3-dev libaspell-dev libsnmp-dev libpcre3-dev libtidy-dev
# Install PHP extensions
RUN docker-php-ext-install mbstring pdo_pgsql curl json intl gd xml zip bz2 opcache exif
# Install mcryp
RUN pecl install mcrypt-1.0.2 && docker-php-ext-enable mcrypt
# Install & enable Xdebug for code coverage reports
RUN pecl install xdebug && docker-php-ext-enable xdebug
# Install unzip that will be used by composer
RUN apt-get update -yqq && apt-get install -yqq zip
# Increase PHP memory
COPY etc/php.ini /usr/local/etc/php/php.ini
# Install composer
RUN curl -sS https://getcomposer.org/installer | php && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer
# Composer prestissimo for running composer install faster
RUN composer global require hirak/prestissimo
# Install yarn
RUN apt-get update && \
    apt-get install gnupg apt-transport-https -y -qq && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install yarn -y -qq
# Install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get update && \
    apt-get install nodejs -y -qq
