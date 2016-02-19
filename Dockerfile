FROM leos/nginx-php7-composer:latest

RUN pecl install xdebug-beta \
    && docker-php-ext-enable xdebug

RUN apt-get update && apt-get install -y openssh-server
    && mkdir -p /var/run/sshd

COPY supervisor/supervisor.conf /etc/supervisor/conf.d/supervisord.conf

# SSH config
RUN echo 'root:jarcodev' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 9000 80 443 22

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
