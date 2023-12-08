FROM php:7.0-apache

# 提供の終わった deb.debian.org のURLをアーカイブに変更
RUN echo "deb http://archive.debian.org/debian/ stretch main" > /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list

# ミドルウェアインストール
RUN apt-get update \
    && apt-get install -y \
  nano vim wget \
  zip unzip \
  libzip-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libjpeg-dev \
  libpng-dev \
  libmcrypt-dev \
  libicu-dev \
  libpq-dev \
  cron \
  zlib1g-dev \
  libonig-dev \
  && docker-php-ext-install \
    pdo_mysql \
    mysqli \
    pdo \
    intl \
    zip \
    opcache

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd \
  && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
  && apt-get clean

RUN apt-get install -y imagemagick libmagickwand-dev \
 && pecl install imagick \
 && docker-php-ext-enable imagick

RUN cd /etc/apache2/mods-enabled \
    && ln -s ../mods-available/rewrite.load \
    && ln -s ../mods-available/include.load

# リライトモジュール
RUN a2enmod rewrite \
    && a2enmod include
