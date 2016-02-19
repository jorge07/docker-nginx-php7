FROM php:5.6-fpm

ENV NGINX_VERSION 1.9.11-1~jessie
ENV NOTVISIBLE "in users profile"

### Install NGINX & SUPERVISOR

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y ca-certificates nginx=${NGINX_VERSION} gettext-base \
	&& rm -rf /var/lib/apt/lists/*

# PHP && Supervisor
RUN apt-get update && apt-get install -y git zlib1g-dev libmcrypt-dev supervisor openssh-server \
    && mkdir -p /var/log/supervisor && mkdir -p /var/run/sshd

#Add composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Default config
ADD php/php.ini /usr/local/etc/php/php.ini
COPY nginx/default.conf /etc/nginx/conf.d/app.conf
COPY supervisor/supervisor.conf /etc/supervisor/conf.d/supervisord.conf

RUN docker-php-ext-install bcmath mbstring opcache pcntl zip mcrypt pdo_mysql \
    ## APCu
   && pecl install apcu \
   && docker-php-ext-enable apcu \
   ## Xdebug
   && pecl install xdebug-beta \
   && docker-php-ext-enable xdebug

RUN echo 'root:jarcodev' | chpasswd

RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 9000 80 443 22

RUN usermod -u 1000 www-data

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
