from flask import Blueprint, render_template, redirect, request, session, url_for
import requests
import os

app_bp = Blueprint('app', __name__)


from service import *

@app_bp.route("/welcome")
def welcome():
    return render_template("welcome.html")
    #faut il verifier si l'auth est necessaire


@app_bp.route("/home")
def home():
    return render_template("home.html")
    #faut il verifier si l'auth est necessaire


@app_bp.route("/manage/proverbs")
def manage_proverbs():
    token = session.get('access_token')
    # check that user is connected
    if not token:
        return(ask_for_auth("Vous devez être authentifié pour supprimer des proverbes"))
    # check that user have right to perform this action
       # check the role of the user

    response = requests.get('http://localhost:8000/proverbs')
    if response.status_code == 200:
        proverbs_data = response.json()
        return render_template("manage_proverbs.html", proverbs=proverbs_data)
    return "Erreur lors du chargement des proverbes", 400





# lister proverbes

# ajouter proverbes


