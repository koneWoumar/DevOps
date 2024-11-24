import os
from flask import Flask
from dotenv import load_dotenv

# Charger les variables d'environnement
load_dotenv()

# Créer l'application Flask
app = Flask(__name__)
app.secret_key = os.urandom(24)

# Enregistrer les routes
from routes.auth import auth_bp
from routes.proverbs import proverbs_bp
from routes.app import app_bp

app.register_blueprint(app_bp, url_prefix='/app')  # Routes liées aux proverbes
app.register_blueprint(auth_bp, url_prefix='/auth')  # Routes d'authentification
app.register_blueprint(proverbs_bp, url_prefix='/proverbs')  # Routes liées aux proverbes

if __name__ == "__main__":
    app.run(debug=True)
