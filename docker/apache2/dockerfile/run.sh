#!/bin/bash

###############################define utility function#################################

# Fonction pour créer une configuration proxy Nginx
create_proxy_config() {
    local APP_HTTP_PORT=$1
    local APP_HTTPS_PATH=$2
    local APP_HTTP_PATH=$3

    # Configuration content for reverse proxy
    CONFIG_CONTENT="# Proxy config for app on http://localhost:$APP_HTTP_PORT$APP_HTTP_PATH
<Location $APP_HTTPS_PATH>
    ProxyPass \"http://localhost:$APP_HTTP_PORT$APP_HTTP_PATH\"
    ProxyPassReverse \"http://localhost:$APP_HTTP_PORT$APP_HTTP_PATH\"
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


    # activation du module ssl
    SSLEngine on


    # activation de config pour le reverse proxy
    ProxyRequests On
    SSLProxyEngine On


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
    if [[ $env_var =~ ^APP_(.*)_HTTP_PORT$ ]]; then
        APP_NAME="${BASH_REMATCH[1]}"
        HTTP_PORT_VAR="APP_${APP_NAME}_HTTP_PORT"
        HTTP_PATH_VAR="APP_${APP_NAME}_HTTP_PATH"
        HTTPS_PATH_VAR="APP_${APP_NAME}_HTTPS_PATH"

        # Check that port and path are define
        if [[ -n ${!HTTP_PORT_VAR} && -n ${!HTTPS_PATH_VAR} ]]; then
            # Create config the the app
            create_proxy_config "${!HTTP_PORT_VAR}" "${!HTTPS_PATH_VAR}" "${!HTTP_PATH_VAR}"
            echo "***config created for http_port = ${!HTTP_PORT_VAR}"
        else
            echo "*X* config skit for $APP_NAME for no 'https_path or http_port' define"
        fi
    fi
done

echo "#---> ** task done"

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

# Start apache 2
apache2ctl -D FOREGROUND
