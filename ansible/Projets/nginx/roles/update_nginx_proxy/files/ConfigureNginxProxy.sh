#!/bin/bash

# Function to create proxy configuration
create_proxy_config() {
    APP_HTTP_PORT=$1
    APP_HTTPS_PATH=$2
    APP_HTTP_PATH=$3

    # Configuration content for Nginx
    CONFIG_CONTENT="# Proxy configuration for app on http://localhost:$APP_HTTP_PORT$APP_HTTP_PATH
location $APP_HTTPS_PATH {
    proxy_pass http://localhost:$APP_HTTP_PORT$APP_HTTP_PATH;
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
}"

    # Append the configuration to the specified Nginx configuration file
    echo "$CONFIG_CONTENT" >> "$PROXY_CONFIG_FILE"
}

# Base directory
# CONFIG_DIR="/home/albarry/Bureau/Configurations"
CONFIG_DIR=$CONFIG_DIR_PATH

# Set the proxy-file empty
echo > $PROXY_CONFIG_FILE

# Loop through each directory in configurations
for dir in "$CONFIG_DIR"/*/; do

    # Check if .env file exists in the directory
    if [[ -f "$dir.env" ]]; then
        # Extract variables from the .env file
        source "$dir.env"

        # Check if the required variables are set
        if [[ -n "$APP_HTTP_PORT" && -n "$APP_HTTPS_PATH" ]]; then
            # Call the function to create the proxy config
            create_proxy_config "$APP_HTTP_PORT" "$APP_HTTPS_PATH" "$APP_HTTP_PATH"
        else
            echo "Info: APP_HTTP_PORT or APP_HTTPS_PATH missing in $dir"
        fi
    else
        echo -e "Info: No .env file found in $dir"
    fi
done

