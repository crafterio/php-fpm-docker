FROM php:7.0.5-cli

MAINTAINER Miguel Angel Garcia <mgarcia.inf@gmail.com>

# Environment
ENV USER app
ENV FOLDER /home/app/app
ENV PACKAGE_LIST xdebug redis
ENV EXTENSION_LIST phpredis bcmath calendar exif intl opcache pcntl \
    shmop sockets wddx zip bz2 gettext gmp mcrypt mysqli pdo_mysql \
    readline recode xsl xdebug

# Persistent / runtime deps
RUN apt-get update && apt-get install -y sudo git wget openssh-client \
    libssl-dev libmcrypt4 libicu-dev ca-certificates curl libpcre3 librecode0 \
    libsqlite3-0 libxml2 libxml2-dev libxslt1.1 libmhash2 libmcrypt-dev \
    bzip2 libbz2-dev libgmp-dev libpcre3-dev libreadline6-dev libedit-dev libedit2 \
    librecode-dev libsqlite3-dev libssl-dev libcurl4-gnutls-dev libxslt1-dev \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/* \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

# Create app user
RUN mkdir -p $FOLDER && \
    useradd -m -u 1000 -d $FOLDER $USER

# Get phpredis extension
RUN git clone -b php7 https://github.com/phpredis/phpredis.git /usr/src/php/ext/phpredis

# Download source for external PHP extensions
RUN cd /usr/src/php/ext && pecl download $PACKAGE_LIST && \
    for PACKAGE in $PACKAGE_LIST; do tar xzf $PACKAGE-* && \
    rm $PACKAGE*.tgz && mv $PACKAGE-* $PACKAGE; done

COPY docker-php-ext-* /usr/local/bin/

# Install PHP extensions
RUN chmod +x /usr/local/bin/docker-php-ext-* && sync \
    && docker-php-ext-install -j$(nproc) $EXTENSION_LIST

# Install composer
RUN curl -sS https://getcomposer.org/installer \
    | php && mv composer.phar /usr/local/bin/composer;

# Clean the temporary files
RUN rm -rf /usr/src/php/ext/* /var/tmp/* \
            /tmp/* /var/lib/apt/lists/* /usr/src/php/ext/* \
            /etc/ssh/ssh_host_* /usr/share/man/?? \
            /usr/share/man/??*

WORKDIR $FOLDER

EXPOSE 9000
CMD ["php", "-a"]
