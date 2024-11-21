import os
import requests
from flask import Flask, render_template, redirect, request, url_for, session
from dotenv import load_dotenv
from flask import flash

load_dotenv()

app = Flask(__name__)
app.secret_key = os.urandom(24)

# Configuration Keycloak
KEYCLOAK_URL = os.getenv('KEYCLOAK_URL')
CLIENT_ID = os.getenv('CLIENT_ID')
CLIENT_SECRET = os.getenv('CLIENT_SECRET')
REALM = os.getenv('REALM')
REDIRECT_URI = os.getenv('REDIRECT_URI')



# URLs pour Keycloak
AUTH_URL = f"{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/auth"
TOKEN_URL = f"{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/token"
USERINFO_URL = f"{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/userinfo"


@app.route("/")
def home():
    return render_template("home.html")
    #faut il verifier si l'auth est necessaire


@app.route("/login", methods=["GET", "POST"])
def login():
    return redirect(f"{AUTH_URL}?client_id={CLIENT_ID}&redirect_uri={REDIRECT_URI}&response_type=code&scope=openid")


@app.route('/logout', methods=['GET'])
def logout():
    """
    Gère la déconnexion en supprimant les données de session liées à l'utilisateur,
    puis redirige vers la page d'accueil.
    """
    # Supprimez toutes les données de session
    session.clear()

    # Redirige vers la page d'accueil
    return redirect(url_for('home'))


@app.route("/callback")
def callback():
    # Récupérer le code d'autorisation de Keycloak
    code = request.args.get('code')

    # Obtenir le token d'accès via Keycloak
    response = requests.post(
        TOKEN_URL,
        data={
            'code': code,
            'client_id': CLIENT_ID,
            'client_secret': CLIENT_SECRET,
            'redirect_uri': REDIRECT_URI,
            'grant_type': 'authorization_code'
        },
        headers={'Content-Type': 'application/x-www-form-urlencoded'}
    )

    # Vérifier la réponse
    if response.status_code == 200:
        tokens = response.json()
        access_token = tokens['access_token']
        session['access_token'] = access_token

        # Obtenir les informations de l'utilisateur
        user_info = requests.get(
            USERINFO_URL,
            headers={'Authorization': f'Bearer {access_token}'}
        )
        user_info_data = user_info.json()

        session['username'] = user_info_data['preferred_username']
        return redirect(url_for('proverbs'))
    else:
        return "Error getting tokens", 400


@app.route("/proverbs")
def proverbs():
    if 'access_token' not in session:
        return redirect(url_for('login'))

    # Lister les proverbes depuis l'API FastAPI
    headers = {'Authorization': f"Bearer {session['access_token']}"}
    response = requests.get('http://localhost:8000/proverbs', headers=headers)
    if response.status_code == 200:
        proverbs_data = response.json()
        return render_template("proverbs.html", proverbs=proverbs_data)
    return "Error loading proverbs", 400


@app.route('/add_proverb', methods=['GET', 'POST'])
def add_proverb():
    if request.method == "POST":
        # Récupération des données du formulaire
        enonce = request.form['enonce']
        origine = request.form['origine']
        explication = request.form['explication']
        genre = request.form['genre']

        # Récupérer le token d'authentification depuis la session
        token = session.get('access_token')
        if not token:
            # Si le token n'existe pas, afficher un message avec un bouton pour rediriger
            return """
            <div style="text-align: center; margin-top: 20%;">
                <h2>Vous devez être authentifié pour ajouter un proverbe.</h2>
                <a href="/login" style="padding: 10px 20px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px;">Se connecter</a>
            </div>
            """

        # Construire l'URL avec le token comme paramètre
        url = f'http://127.0.0.1:8000/proverbs/?token={token}'

        # Effectuer la requête POST vers l'API FastAPI
        response = requests.post(
            url,
            json={
                'enonce': enonce,
                'origine': origine,
                'explication': explication,
                'genre': genre
            },
            headers={
                'accept': 'application/json',
                'Content-Type': 'application/json'
            }
        )

        # Vérifier la réponse
        if response.status_code == 200:
            return redirect(url_for('add_proverb'))  # Rester sur la page d'ajout
        else:
            return f"Erreur lors de l'ajout du proverbe : {response.text}", response.status_code

    return render_template("add_proverbs.html")


@app.route('/delete_proverb/<int:proverb_id>', methods=['POST', 'DELETE'])
def delete_proverb(proverb_id):

    # Récupérer le token d'authentification depuis la session
    token = session.get('access_token')
    if not token:
        # Si le token n'existe pas, afficher un message avec un bouton pour rediriger
        return """
        <div style="text-align: center; margin-top: 20%;">
            <h2>Vous devez être authentifié pour ajouter un proverbe.</h2>
            <a href="/login" style="padding: 10px 20px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px;">Se connecter</a>
        </div>
        """


    # Construire l'URL avec le token comme paramètre
    url = f'http://127.0.0.1:8000/proverbs/{proverb_id}?token={token}'

    # Effectuer la requête DELETE vers l'API
    response = requests.delete(
        url,
        headers={
            'accept': 'application/json'
        }
    )

    # Vérifier la réponse
    if response.status_code == 200:
        return redirect(url_for('proverbs'))
    else:
        return f"Erreur lors de la suppression du proverbe : {response.text}", response.status_code



if __name__ == "__main__":
    app.run(debug=True)

