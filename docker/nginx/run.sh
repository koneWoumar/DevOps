#!/bin/bash

###############################define utility function#################################

# Fonction pour créer une configuration proxy Nginx
create_proxy_config() {
    local APP_HTTP_PORT=$1
    local APP_HTTPS_PATH=$2
    local APP_HTTP_PATH=$3

    # Contenu de la configuration pour Nginx
    CONFIG_CONTENT="# Proxy configuration for app on http://localhost:$APP_HTTP_PORT$APP_HTTP_PATH
location $APP_HTTPS_PATH {
    proxy_pass http://localhost:$APP_HTTP_PORT$APP_HTTP_PATH;
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
}"

    # Affiche ou enregistre la configuration générée (vous pouvez adapter l'emplacement du fichier)
    echo "$CONFIG_CONTENT" >> "$PROXY_CONFIG_FILE"
}

############################creating virtual host config file###########################

echo "#---> ** Creating virtual host configuration file"


cat << EOF > ${VHOST_CONFIG_FILE}
server {
    # Écouter sur le port 80 (HTTP) et rediriger vers HTTPS
    listen 80;
    server_name $SERVER_NAME;
    
    # Rediriger tout le trafic HTTP vers HTTPS
    return 301 https://\$host\$request_uri;
}

server {
    # Écouter sur le port 443 (HTTPS) avec SSL
    listen 443 ssl;
    server_name $SERVER_NAME;

    # Chemins vers les certificats SSL
    ssl_certificate $SSL_CERTIFICAT;
    ssl_certificate_key $SSL_CERTIFICAT_KEY;

    # Inclusion des fichiers location pour une configuration modulaire
    include $PROXY_CONFIG_FILE;

    # Proxy pass vers l'application backend
    location / {
        root $WELCOME_PAGE_DIR;
        index index.html;
        try_files \$uri \$uri/ =404; # Sert le fichier index.html ou renvoie une erreur 404 si le fichier n'existe pas
    }

    # Fichiers statiques (optionnel, si ton backend sert des fichiers statiques)
    location /static/ {
        root /var/www/doc-statics;
    }

    # Gestion des erreurs (optionnel)
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }

    # Sécurisation SSL recommandée
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # HTTP Strict Transport Security (HSTS)
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
}
EOF

echo "#---> ** task done"

###############################creating proxy configuration file###########################


echo "#---> ** Creating proxy config file"
echo > ${PROXY_CONFIG_FILE}

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
echo "${VHOST_CONFIG_FILE}:"
echo
cat ${VHOST_CONFIG_FILE}
echo
echo "#---> ** showing proxy configuration file content"
echo
echo "${PROXY_CONFIG_FILE}:"
echo
cat ${PROXY_CONFIG_FILE}
echo
###############################Starting nginx##############################

echo "#---> ** starting nginx"
# Start nginx
nginx -g 'daemon off;'