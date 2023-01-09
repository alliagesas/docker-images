FROM php:7.4-fpm-buster

# install FR locales
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get clean; \
	apt-get update; \
	apt-get install -y locales;
RUN echo "fr_FR.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen fr_FR.UTF-8 && \
    update-locale fr_FR.UTF-8
ENV LC_ALL fr_FR.UTF-8

# Install networks utils
RUN apt-get install -y iputils-ping;

# install the PHP extensions we need
RUN set -ex; \
        BUILD_PACKAGES="libjpeg-dev libpng-dev libc-client-dev libkrb5-dev libldap2-dev libxml2-dev libzip-dev libfreetype6-dev"; \
	apt-get update; \
	apt-get install -y $BUILD_PACKAGES; \
	docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
	docker-php-ext-configure gd  --with-freetype --with-jpeg; \
        docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/; \
	docker-php-ext-install zip exif gd mysqli opcache pdo_mysql json pcntl imap ldap soap sysvmsg; \
        rm -rf /tmp/pear;
        
        # Removing the *-dev deps and only keeping the necessary lib* packages
        #apt-get remove --purge -y $BUILD_PACKAGES && rm -rf /var/lib/apt/lists/*; \
        #apt-get clean -y;

# MEMCACHED
RUN apt-get install -y libmemcached-dev;
RUN curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/v3.1.5.tar.gz" \
  && mkdir -p memcached \
  && tar -C memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
  && ( \
    cd memcached \
    && phpize \
    && ./configure \
    && make -j$(nproc) \
    && make install \
  ) \
  && rm -r memcached \
  && rm /tmp/memcached.tar.gz \
  && docker-php-ext-enable memcached

# SSH2 package
RUN set -ex; \
        BUILD_PACKAGES="libssh2-1-dev libssh2-1"; \

	apt-get update; \
	apt-get install -y $BUILD_PACKAGES; \
        pecl install -o -f ssh2-1.2 \
        && docker-php-ext-enable ssh2 \
        && rm -rf /tmp/pear;


# Microsoft SQL Server Prerequisites
ENV ACCEPT_EULA=Y
RUN apt-get install -y gnupg \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list \
        > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        unixodbc-dev \
        msodbcsql17;

# XDEBUG
RUN pecl install -o -f xdebug
RUN docker-php-ext-enable xdebug

# MSMTP
RUN apt-get install -y msmtp
COPY msmtprc /etc/msmtprc
RUN chown root:msmtp /etc/msmtprc
RUN chmod 640 /etc/msmtprc
RUN touch /var/log/msmtp.log; chmod 660 /var/log/msmtp.log

# Clean setup
RUN rm -rf /var/lib/apt/lists/*

# SET php.ini-developpement
RUN ln -s /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini;

# COPY CUSTOM CONFIGS
ADD php.ini /usr/local/etc/php/conf.d/user-php.ini
ADD logs.ini /usr/local/etc/php/conf.d/logs.ini
ADD uploads.ini /usr/local/etc/php/conf.d/uploads.ini
ADD xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
ADD opcache.ini /usr/local/etc/php/conf.d/opcache.ini
ADD php-mail.ini /usr/local/etc/php/conf.d/php-mail.ini

RUN sed -i -e "s/listen = 127.0.0.1:9000/listen = 9000/g" /usr/local/etc/php-fpm.d/www.conf;

# START PHP-FPM
CMD ["php-fpm"]
EXPOSE 9000