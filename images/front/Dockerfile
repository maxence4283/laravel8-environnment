FROM nginx:alpine

COPY ressources /

RUN mkdir -p /var/www/html  ; sed -i '3 a chown nginx:www-data /var/www/html' /docker-entrypoint.sh

VOLUME [ "/var/www/html" ]

