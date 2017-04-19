FROM clarencep/php7c:7.1

ENV APP_ROOT /var/www/tp5

WORKDIR $APP_ROOT

# RUN sed 's/archive.ubuntu.com/mirrors.aliyun.com/' -i.bak /etc/apt/sources.list && apt-get update -y

RUN DEBIAN_FRONTEND="noninteractive" \
    && apt-get update -y \
    && apt-get install -y zip \
    && useradd www && chown -R www:www $APP_ROOT \
    && mkdir -p /var/www && chown -R www:www /var/www \
    && HOME=/var/www USER=www su -p -s /bin/sh -c "composer config -g repo.packagist composer https://packagist.phpcomposer.com && composer create-project topthink/think $APP_ROOT --prefer-dist" www \
    && apt-get clean  \
    && apt-get autoclean  \
    && apt-get remove -y  \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/www/.composer/cache

EXPOSE 8000

CMD su -p -s /bin/sh -c "php -S 0.0.0.0:8000 -t $APP_ROOT/public" www
