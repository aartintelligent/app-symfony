ARG PHP_VERSION='8.3'

FROM aartintelligent/ops-composer:${PHP_VERSION} AS symfony-ops-composer

ARG COMPOSER_AUTH=""

ENV \
COMPOSER_ALLOW_SUPERUSER="1" \
COMPOSER_ALLOW_XDEBUG="0" \
COMPOSER_CACHE_DIR="/var/cache/composer" \
COMPOSER_AUTH="${COMPOSER_AUTH}"

VOLUME ["/var/cache/composer"]

COPY .composer /var/cache/composer

COPY src /src

RUN set -eux; \
composer install \
--prefer-dist \
--no-autoloader \
--no-interaction \
--no-scripts \
--no-progress \
--no-dev; \
composer dump-autoload \
--optimize

FROM aartintelligent/ops-yarn:latest AS symfony-ops-yarn

ENV \
YARN_CACHE_FOLDER="/var/cache/yarn"

VOLUME ["/var/cache/yarn"]

COPY .yarn /var/cache/yarn

COPY src /src

RUN set -eux; \
yarn install; \
yarn run encore production

FROM aartintelligent/app-php:${PHP_VERSION}

USER root

ENV \
APP_USAGE="local" \
APP_ENV="prod" \
APP_DEBUG="0" \
APP_SECRET="0a8b194977b0562f420b014564bfc0fc" \
DATABASE_URL="sqlite:///%kernel.project_dir%/var/data.db" \
MESSENGER_TRANSPORT_DSN="doctrine://default?auto_setup=0" \
MAILER_DSN="sendmail://default?command=/usr/sbin/sendmail%20-i%20-t" \
PHP_MEMORY_LIMIT="4096M" \
PHP_OPCACHE__PRELOAD="/var/www/config/preload.php"

COPY --chown=rootless:rootless src /var/www

COPY --chown=rootless:rootless --from=symfony-ops-composer /src/vendor /var/www/vendor

COPY --chown=rootless:rootless --from=symfony-ops-yarn /src/public/build /var/www/public/build

COPY --chown=rootless:rootless system /

RUN set -eux; \
echo "/docker/d-bootstrap-symfony.sh" >> /docker/d-bootstrap.list; \
chmod +x /docker/d-*.sh

USER rootless
