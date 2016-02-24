FROM leos/nginx-php7-composer:latest

MAINTAINER Jorge Arco <jorge.arcoma@gmail.com>

ENV NGINX_VERSION 1.9.11-1~jessie
ENV NOTVISIBLE "in users profile"

RUN apt-get update && apt-get install -y openssh-server \
    && mkdir -p /var/run/sshd

### Install NGINX & SUPERVISOR
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y ca-certificates nginx=${NGINX_VERSION} gettext-base \
	&& rm -rf /var/lib/apt/lists/*

# PHP mods && Supervisor
RUN apt-get update && apt-get install -y git zlib1g-dev libmcrypt-dev supervisor openssh-server \
    && mkdir -p /var/log/supervisor && mkdir -p /var/run/sshd

RUN docker-php-ext-install bcmath mbstring opcache pcntl zip mcrypt pdo_mysql \
    ## APCu
   && pecl install apcu \
   && docker-php-ext-enable apcu \
   ## Xdebug
   && pecl install xdebug-beta \
   && docker-php-ext-enable xdebug

# Default ssh config
COPY ssh/credentials.sh /root/
RUN chmod 755 /root/credentials.sh

# Default PHP config
COPY php/php.ini /usr/local/etc/php/php.ini
COPY php/php-fpm.conf /usr/local/etc/php-fpm.conf

# Default nginx config
COPY nginx/default.conf /etc/nginx/conf.d/app.conf
ADD  nginx/nginx.conf /etc/nginx/

# Default supervisord config
COPY supervisor/supervisor.conf /etc/supervisor/conf.d/supervisord.conf

# SSH config
RUN echo 'root:jarcodev' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 9000 80 443 22

RUN useradd -ms /bin/bash www

USER www

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
