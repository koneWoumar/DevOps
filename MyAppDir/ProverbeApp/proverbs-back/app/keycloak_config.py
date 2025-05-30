from keycloak import KeycloakOpenID
from dotenv import load_dotenv
import os

# -------------------------------------------#

# load from .env the variable
area = os.getenv("ENVIRONMENT")
if (area != "container"):
    load_dotenv()


# get the value of variable
SERVER_URL = os.getenv('SERVER_URL')
CLIENT_ID = os.getenv('CLIENT_ID')
CLIENT_SECRET = os.getenv('CLIENT_SECRET')
REALM = os.getenv('REALM')


keycloak_openid = KeycloakOpenID(
    server_url= SERVER_URL,
    client_id=CLIENT_ID,
    realm_name=REALM,
    client_secret_key=CLIENT_SECRET
)

# --------------------------------------------#

def get_user_info(token: str):
    try:
        print("***avant***")
        user_info = keycloak_openid.introspect(token)
        print("***apres***")
        if user_info.get("active"):
            return user_info
        else:
            raise Exception("Token is not active")
    except Exception as e:
        raise Exception("Authentication failed: " + str(e))
