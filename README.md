Nginx-php7
=== 

Composer installed

### To share ssh keys

Command:

    docker run -ti \
        --volumes-from ssh-data \
        -v ./:/app \
        -v ~/.ssh:/root/ssh
        -p 9000:9000 \
        -p 80:90 \
        -p 443:443 \
        leos/nginx-php7-composer
    
Using docker compose:

    server:
        image: leos/nginx-php7-composer
        ports:
            - "80:80"
            - "443:443"
            - "9000:9000"
        volumes_from:
            - ssh-data
        volumes:
            - ./:/app
