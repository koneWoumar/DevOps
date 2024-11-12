#!/bin/bash

# Function to create proxy configuration
create_proxy_config() {
    APP_HTTP_PORT=$1
    APP_HTTPS_PATH=$2
    APP_HTTP_PATH=$3

    # Configuration content
    CONFIG_CONTENT="# Proxy config for app on http://localhost:$APP_HTTP_PORT$APP_HTTP_PATH
<Location $APP_HTTPS_PATH>
    ProxyPass \"http://localhost:$APP_HTTP_PORT$APP_HTTP_PATH\"
    ProxyPassReverse \"http://localhost:$APP_HTTP_PORT$APP_HTTP_PATH\"
</Location>"

    # Add configuration to the conf-available file
    echo "$CONFIG_CONTENT" >> $PROXY_CONFIG_FILE
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
