Nginx-php7
=== 

Composer installed

### To share ssh keys

Command:

    docker run -ti \
        -v ./:/app \
        -v ~/.ssh:/root/ssh \
        -p 80:90 \
        -p 443:443 \
        leos/nginx-php7-composer
    
Using docker compose:

    server:
        image: leos/nginx-php7-composer
        ports:
            - "80:80"
            - "443:443"
        volumes:
            - ./:/app
            - ~/.ssh:/root/ssh
