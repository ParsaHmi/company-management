# مرحله ۱: ساخت composer dependencies
FROM composer:2 AS vendor
WORKDIR /app
COPY src/composer.json src/composer.lock ./
RUN composer install --no-dev --no-scripts --prefer-dist

# مرحله ۲: PHP-FPM + Laravel app
FROM php:8.3-fpm
WORKDIR /var/www/html

# نصب اکستنشن‌های مورد نیاز لاراول
RUN apt-get update && apt-get install -y \
    zip unzip git libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# کپی کد پروژه
COPY src . 
COPY --from=vendor /app/vendor ./vendor

# تنظیمات دسترسی
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

CMD ["php-fpm"]
