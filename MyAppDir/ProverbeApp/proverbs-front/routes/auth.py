from flask import Blueprint, redirect, request, session, url_for, make_response
import os
import requests
from urllib.parse import urlparse

auth_bp = Blueprint('auth', __name__)

from service import *


# methode login qui :
# qui recupere le chemin de redirection apres login 
# qui tape sur keycloack avec le chemin de redirection pour le login en argument
# pour que keycloak tap à son tour sur callback
@auth_bp.route("/login", methods=["GET", "POST"])
def login():
    print("*****Login*****")   ### log of debug
    # previous_url = urlparse(request.referrer).path
    path = urlparse(request.referrer).path
    # scheme = previous_url.scheme
    # host = previous_url.netloc
    # redirect_url = f'{scheme}://{host}/front/auth/callback?next={path}'
    redirect_url = f'{FRONT_URL}/front/auth/callback?next={path}'
    print("*****> redirecr_url=",redirect_url)  ### log of debug
    return redirect(f"{AUTH_URL}?client_id={CLIENT_ID}&redirect_uri={redirect_url}&response_type=code&scope=openid")


@auth_bp.route("/logout", methods=["GET"])
def logout():
    """Gère la déconnexion en redirigeant l'utilisateur vers Keycloak, puis vers /app/welcome."""
    # Récupérer le token de l'utilisateur depuis la session
    token = session.get('access_token')

    previous_url = request.referrer
    logout_to_home_list = ["/front/proverbs/add","/front/app/manage/proverbs"]
    url_path = urlparse(request.referrer).path
    url_base = urlparse(request.referrer).netloc
    if url_path in logout_to_home_list :
        scheme = urlparse(request.referrer).scheme
        previous_url = f'{scheme}://{url_base}/front/app/home'


    # Si un token est présent, rediriger vers Keycloak pour la déconnexion
    if token:
        # Effacer la session côté serveur
        id_token = session['id_token']
        session.clear()

        return redirect(f"{LOGOUT_URL}?client_id={CLIENT_ID}&post_logout_redirect_uri={previous_url}&id_token_hint={id_token}&response_type=code&scope=openid")

    # Si aucun token, rediriger directement vers la page d'accueil
    return redirect(previous_url)



# method callback qui :
# recuperer le token, la stock dans la session
# puis redirige vers le chemin reçu dans la request
@auth_bp.route("/callback", methods=["GET", "POST"])
def callback():
    """Callback pour récupérer le token depuis Keycloak."""
    print("*****Callback*****")   ### log of debug
    code = request.args.get('code')
    path = request.args.get('next', '/')
    # scheme = request.scheme
    # host = request.host
    # login_redirect_url = f'{scheme}://{host}/front/auth/callback?next={path}'
    login_redirect_url = f'{FRONT_URL}/front/auth/callback?next={path}'
    redirect_rout = path

    print("*** request.arg", request.args)

    response = requests.post(
        TOKEN_URL,
        data={
            'code': code,
            'client_id': CLIENT_ID,
            'client_secret': CLIENT_SECRET,
            'redirect_uri': login_redirect_url,
            'grant_type': 'authorization_code'
        },
        headers={'Content-Type': 'application/x-www-form-urlencoded'}
    )

    if response.status_code == 200:
        tokens = response.json()
        access_token = tokens['access_token']
        id_token = tokens['id_token']
        session['access_token'] = access_token
        session['id_token'] = id_token

        # Obtenir les informations utilisateur
        user_info = requests.get(
            USERINFO_URL,
            headers={'Authorization': f'Bearer {access_token}'}
        )
        user_info_data = user_info.json()
        session['username'] = user_info_data['preferred_username']
        
        # redirection vers la page appropriée
        return redirect(redirect_rout)
    else:
        return(generate_error(path,"ERROR: Something went wrong when getting the authentication token from keycloack"))