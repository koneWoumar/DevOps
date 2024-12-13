import os
from flask import Flask
from dotenv import load_dotenv
from service import *

# Charger variable from .env
area = os.getenv("ENVIRONMENT")
if (area != "container"):
    load_dotenv()

print()

# Créer l'application Flask
root_path = "/front"
app = Flask(__name__)
app.secret_key = os.urandom(24)

# Enregistrer les routes
from routes.auth import auth_bp
from routes.proverbs import proverbs_bp
from routes.app import app_bp

app.register_blueprint(app_bp, url_prefix=f'{root_path}/app')  # Routes liées aux proverbes
app.register_blueprint(auth_bp, url_prefix=f'{root_path}/auth')  # Routes d'authentification
app.register_blueprint(proverbs_bp, url_prefix=f'{root_path}/proverbs')  # Routes liées aux proverbes


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=PORT)
