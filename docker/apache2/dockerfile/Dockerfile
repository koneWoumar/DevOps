## Use a Debian Slim image as the base
FROM debian:bookworm-slim

## Install Apache2 and clean cache files
RUN apt-get update && \
    apt-get install -y --no-install-recommends apache2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## Set environment variables

# --> stable configuration
ENV PROXY_CONFIG_FILE=my-site-proxy.conf
ENV VHOST_CONFIG_FILE=my-site.conf
ENV WELCOME_PAGE_DIR=/var/www/my-site-apache
ENV SSL_CERT_DIR=/etc/ssl/certs/my-autosigne-cert

# --> configurable settings
ENV SSL_CERTIFICAT_NAME=nginx.localhost.com+5.pem
ENV SSL_CERTIFICAT_KEY_NAME=nginx.localhost.com+5-key.pem
ENV SERVER_NAME=apache.localhost.com
ENV SSL_CERTIFICAT=${SSL_CERT_DIR}/${SSL_CERTIFICAT_NAME}
ENV SSL_CERTIFICAT_KEY=${SSL_CERT_DIR}/${SSL_CERTIFICAT_KEY_NAME}

## Configure Apache to enable SSL, proxy, and rewrite modules
RUN a2enmod ssl && \
    a2enmod proxy && \
    a2enmod proxy_http && \
    a2enmod rewrite

## Copy the run.sh script into the container
COPY run.sh /usr/local/bin/run.sh

## Make the script executable
RUN chmod +x /usr/local/bin/run.sh

## Expose ports 80 and 443
EXPOSE 80 443

## Run the script to start the container
CMD ["/usr/local/bin/run.sh"]
