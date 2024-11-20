from keycloak import KeycloakOpenID

keycloak_openid = KeycloakOpenID(
    server_url="http://localhost:8080/auth/",
    client_id="proverbs-platform",
    realm_name="your-realm",
    client_secret_key="your-client-secret"
)

def get_user_info(token: str):
    try:
        user_info = keycloak_openid.introspect(token)
        if user_info.get("active"):
            return user_info
        else:
            raise Exception("Token is not active")
    except Exception as e:
        raise Exception("Authentication failed: " + str(e))
