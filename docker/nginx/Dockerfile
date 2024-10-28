## Use officiel nginx image
FROM nginx:latest

## Set up default environment variable

# --> stable configuration
ENV PROXY_CONFIG_FILE=/etc/nginx/proxy-location-dir/my-site-proxy.conf
ENV VHOST_CONFIG_FILE=/etc/nginx/conf.d/my-site.conf
ENV WELCOME_PAGE_DIR=/usr/share/nginx/my-site-nginx
ENV SSL_CERT_DIR=/etc/ssl/certs/my-autosigne-cert

# --> modifiable configurtaion
ENV SSL_CERTIFICAT_NAME=nginx.localhost.com+5.pem
ENV SSL_CERTIFICAT_KEY_NAME=nginx.localhost.com+5-key.pem
ENV SERVER_NAME=nginx.localhost.com
ENV SSL_CERTIFICAT=${SSL_CERT_DIR}/${SSL_CERTIFICAT_NAME}
ENV SSL_CERTIFICAT_KEY=${SSL_CERT_DIR}/${SSL_CERTIFICAT_KEY_NAME}

## create proxy config directory
RUN mkdir -p /etc/nginx/proxy-location-dir
RUN touch /etc/nginx/proxy-location-dir/my-site-proxy.conf

## Copy the run.sh in the container
COPY run.sh /usr/local/bin/run.sh

## Make the script executable
RUN chmod +x /usr/local/bin/run.sh

## Expose the port 80 et 443
EXPOSE 80 443

## Run the script to start the container
CMD ["/usr/local/bin/run.sh"]
