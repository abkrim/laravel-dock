# Laravel Docker Image for CI/CD and Development
# https://github.com/abkrim/laravel-dock
# https://hub.docker.com/r/abkrim/laravel-dock

ARG PHP_VERSION=8.4

FROM php:${PHP_VERSION}-fpm-alpine

LABEL maintainer="abkrim"
LABEL description="PHP image optimized for Laravel applications"
LABEL org.opencontainers.image.source="https://github.com/abkrim/laravel-dock"

# Install system dependencies
RUN apk add --no-cache \
    bash \
    git \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    zip \
    unzip \
    mysql-client \
    oniguruma-dev \
    libxml2-dev \
    icu-dev \
    linux-headers \
    $PHPIZE_DEPS

# Install PHP extensions required by Laravel
# Already compiled in PHP 8.x: ctype, fileinfo, tokenizer, pdo, xml (dom/simplexml)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        zip \
        intl \
        opcache

# Install Redis extension
RUN printf '\n\n\n\n\n\n' | pecl install redis && docker-php-ext-enable redis

# Configure opcache for performance
RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.memory_consumption=256" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.interned_strings_buffer=16" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.max_accelerated_files=20000" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Configure PHP
RUN echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/docker-php-memory.ini \
    && echo "upload_max_filesize = 100M" >> /usr/local/etc/php/conf.d/docker-php-uploads.ini \
    && echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/docker-php-uploads.ini

# Create non-root user for security
RUN addgroup -g 1000 laravel \
    && adduser -u 1000 -G laravel -s /bin/bash -D laravel

# Set permissions
RUN chown -R laravel:laravel /var/www

USER laravel

EXPOSE 9000

CMD ["php-fpm"]