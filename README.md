Nginx-php7
===

Composer installed with Xdebug extension && ssh server for IDE connection.

### To share ssh keys

Command:

    docker run -ti \
        -v ./:/app \
        -v ~/.ssh:/root/ssh
        -p 9000:9000 \
        -v ~/.ssh:/root/ssh \
        -p 80:90 \
        -p 443:443 \
        -p 2222 \
        leos/nginx-php7-composer
    
Using docker compose:

    server:
        image: leos/nginx-php7-composer
        ports:
            - "80:80"
            - "443:443"
            - "9000:9000"
            - "2222:22"
        volumes:
            - ./:/app
            - ~/.ssh:/root/ssh
