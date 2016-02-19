Nginx-php7
===

Composer installed with Xdebug extension && ssh server for IDE connection.

### To share ssh keys

Create a ssh volume:

    docker run \
        --name ssh-data \
        -v /root/.ssh \
        -v ${USER_PRIVATE_KEY}:/root/.ssh/id_rsa \
        busybox \
        sh -c 'chown -R root:root ~/.ssh && chmod -R 400 ~/.ssh'
  
### Run

Command:

    docker run -ti \
        --volumes-from ssh-data \
        -v ./:/app \
        -p 9000:9000 \
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
        volumes_from:
            - ssh-data
        volumes:
            - ./:/app
