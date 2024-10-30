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
    echo "Configuration générée pour l'application sur le port HTTP $APP_HTTP_PORT."
}


PROXY_CONFIG_FILE="proxy.conf"
export APP_WKE_HTTP_PORT="8080"
export APP_WKE_HTTP_PATH="/wke"
export APP_WKE_HTTPS_PATH="/wke"

echo > ${PROXY_CONFIG_FILE}

# Parcourir les variables d'environnement pour trouver les triplets
for env_var in $(compgen -e); do
    if [[ $env_var =~ ^APP_(.*)_HTTP_PORT$ ]]; then
        APP_NAME="${BASH_REMATCH[1]}"
        HTTP_PORT_VAR="APP_${APP_NAME}_HTTP_PORT"
        HTTP_PATH_VAR="APP_${APP_NAME}_HTTP_PATH"
        HTTPS_PATH_VAR="APP_${APP_NAME}_HTTPS_PATH"

        # Vérifier si toutes les variables d'environnement nécessaires sont définies
        if [[ -n ${!HTTP_PORT_VAR} && -n ${!HTTPS_PATH_VAR} ]]; then
            # Appeler la fonction avec les valeurs des variables d'environnement
            create_proxy_config "${!HTTP_PORT_VAR}" "${!HTTPS_PATH_VAR}" "${!HTTP_PATH_VAR}"
        else
            echo "Les variables d'environnement pour $APP_NAME sont incomplètes."
        fi
    fi
done

