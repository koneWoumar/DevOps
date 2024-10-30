# APACHE 2 

This is a docker projet to deploy quitly apache reverse proxy.

## Configuration

To add a reverse proxy config for an app, you need to add this tree envar format type in the .env : 

```conf
APP_XXX_HTTP_PORT="8080"
APP_XXX_HTTP_PATH="/wks"
APP_XXX_HTTPS_PATH="/wke"
# where XXX is any string (not containing a "_"), wich can be for exemple the name of your application.

# an example:
APP_WKEAPP_HTTP_PORT="8080"
APP_WKEAPP_HTTP_PATH="/wks"
APP_WKEAPP_HTTPS_PATH="/wke"

```
## Deploiement

To deploy the reverse proxy, you need to :

- Execute the command : 

```bash
docker compose up
```


