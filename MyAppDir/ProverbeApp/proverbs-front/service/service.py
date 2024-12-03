import os
from urllib.parse import urlparse
from flask import request

# Configuration Keycloak
KEYCLOAK_URL = os.getenv('KEYCLOAK_URL')
CLIENT_ID = os.getenv('CLIENT_ID')
CLIENT_SECRET = os.getenv('CLIENT_SECRET')
REALM = os.getenv('REALM')
FQDN = os.getenv('FQDN')
SCHEME = os.getenv('SCHEME')
BACK_URL = os.getenv('BACK_URL')


# URLs pour Keycloak
AUTH_URL = f"{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/auth"
TOKEN_URL = f"{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/token"
USERINFO_URL = f"{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/userinfo"
LOGOUT_URL = f"{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/logout"

# Front Url Config
FRONT_URL = f'{SCHEME}://{FQDN}'



def generate_error(back_url,message):

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Erreur</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 20%;
        }}
        .container {{
            padding: 20px;
        }}
        .error-message {{
            font-size: 20px;
            color: red;
            margin-bottom: 20px;
        }}
        .back-button {{
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
        }}
        .back-button:hover {{
            background-color: #0056b3;
        }}
    </style>
</head>
<body>
    <div class="container">
        <div class="error-message">{message}</div>
        <a href="{back_url}" class="back-button">Retour</a>
    </div>
</body>
</html>"""



def ask_for_auth(message):
    print("in ask for auth")
    return f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f9f9f9;
        }}
        .container {{
            text-align: center;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }}
        .btn {{
            display: inline-block;
            padding: 10px 20px;
            margin-top: 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }}
        .btn:hover {{
            background-color: #0056b3;
        }}
    </style>
</head>
<body>
    <div class="container">
        <h2>{message}</h2>
        <a href="/front/auth/login" class="btn">Se connecter</a>
    </div>
</body>
</html>"""
