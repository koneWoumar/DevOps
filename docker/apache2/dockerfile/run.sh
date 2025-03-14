#!/bin/bash

###############################define utility function#################################

# Fonction pour créer une configuration proxy Nginx
create_proxy_config() {
    local APP_UPSTREAM_PORT=$1
    local APP_HTTPS_PATH=$2
    local APP_UPSTREAM_PATH=$3
    local APP_UPSTREAM_ADDR=$4

    # Configuration content for reverse proxy
    CONFIG_CONTENT="# Proxy config for app on ${APP_UPSTREAM_ADDR}:$APP_UPSTREAM_PORT$APP_UPSTREAM_PATH
<Location $APP_HTTPS_PATH>
    ProxyPass \"${APP_UPSTREAM_ADDR}:$APP_UPSTREAM_PORT$APP_UPSTREAM_PATH\"
    ProxyPassReverse \"${APP_UPSTREAM_ADDR}:$APP_UPSTREAM_PORT$APP_UPSTREAM_PATH\"
    RequestHeader set X-Forwarded-Proto "https"
    RequestHeader set X-Forwarded-For "%{REMOTE_ADDR}s"
</Location>"

    # Affiche ou enregistre la configuration générée (vous pouvez adapter l'emplacement du fichier)
    echo "$CONFIG_CONTENT" >> "/etc/apache2/conf-available/$PROXY_CONFIG_FILE"
}

############################creating virtual host config file###########################

echo "#---> ** Creating virtual host configuration file"


cat << EOF > /etc/apache2/sites-available/${VHOST_CONFIG_FILE}
<VirtualHost *:443>
    ServerAdmin admin@$SERVER_NAME
    ServerName $SERVER_NAME

    DocumentRoot $WELCOME_PAGE_DIR


    # Activation du module SSL
    SSLEngine on
    SSLProxyEngine on

    # Désactiver le mode Proxy direct
    ProxyRequests Off


    # specifié le ceritificat et sa clé privé
    SSLCertificateFile $SSL_CERTIFICAT
    SSLCertificateKeyFile $SSL_CERTIFICAT_KEY


    <FilesMatch "\.(cgi|shtml|phtml|php)$">
        SSLOptions +StdEnvVars
    </FilesMatch>

    <Directory /usr/lib/cgi-bin>
        SSLOptions +StdEnvVars
    </Directory>


    # Inclusion du fichier de configuration externalisé
    Include "/etc/apache2/conf-enabled/$PROXY_CONFIG_FILE"


    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
EOF

echo "#---> ** task done"

###############################creating proxy configuration file###########################


echo "#---> ** Creating proxy config file"
echo > /etc/apache2/conf-available/$PROXY_CONFIG_FILE

# Parcourir les variables d'environnement pour trouver les triplets
for env_var in $(compgen -e); do
    if [[ $env_var =~ ^APP_(.*)_UPSTREAM_PORT$ ]]; then
        APP_NAME="${BASH_REMATCH[1]}"
        UPSTREAM_PORT_VAR="APP_${APP_NAME}_UPSTREAM_PORT"
        UPSTREAM_PATH_VAR="APP_${APP_NAME}_UPSTREAM_PATH"
        UPSTREAM_ADDR_VAR="APP_${APP_NAME}_UPSTREAM_ADDR"
        HTTPS_PATH_VAR="APP_${APP_NAME}_HTTPS_PATH"

        # Check that port and path are define
        if [[ -n ${!UPSTREAM_PORT_VAR} && -n ${!HTTPS_PATH_VAR} && -n ${!UPSTREAM_ADDR_VAR} ]]; then
            # Create config the the app
            create_proxy_config "${!UPSTREAM_PORT_VAR}" "${!HTTPS_PATH_VAR}" "${!UPSTREAM_PATH_VAR}" "${!UPSTREAM_ADDR_VAR}"
            echo "***config created for upstream app listening on = ${!UPSTREAM_ADDR_VAR}:${UPSTREAM_PORT_VAR}/${UPSTREAM_PATH_VAR}"
        else
            echo "*X* config skit for $APP_NAME for no 'https_path, upstream_port or upstream_scheme' define"
        fi
    fi
done

###############################Showing the content of config files##############################
echo
echo "#---> ** showing virtual host configuration file content"
echo
echo "################################--/etc/apache2/sites-available/--${VHOST_CONFIG_FILE}##################################"
echo
cat /etc/apache2/sites-available/${VHOST_CONFIG_FILE}
echo
echo "#######################################################################################################################"
echo
echo "#---> ** showing proxy configuration file content"
echo
echo "################################--/etc/apache2/conf-available/$PROXY_CONFIG_FILE--################################"
echo
cat /etc/apache2/conf-available/$PROXY_CONFIG_FILE
echo
echo "#######################################################################################################################"
echo
###############################Starting apache2##############################

echo "#---> ** starting apache2"

# Enable site configurations if needed
a2enconf $PROXY_CONFIG_FILE
a2ensite $VHOST_CONFIG_FILE

# Enable necessary modules
a2enmod proxy
a2enmod proxy_http
a2enmod ssl
a2enmod headers


# Start apache 2
apache2ctl -D FOREGROUND
