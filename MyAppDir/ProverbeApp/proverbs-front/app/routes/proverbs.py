from flask import Blueprint, render_template, redirect, request, session, url_for
import requests
from service import *

proverbs_bp = Blueprint('proverbs', __name__)


@proverbs_bp.route("/get")
def get_proverbs():

    print("****back_url : ", BACK_URL)

    response = requests.get(f'{BACK_URL}/proverbs')
    if response.status_code == 200:
        proverbs_data = response.json()
        return render_template("proverbs.html", proverbs=proverbs_data)
    return (generate_error("/front/proverbs/get",f"ERROR {response.status_code} : Something went wrong when loading proverbs list"))



@proverbs_bp.route('/add', methods=['GET', 'POST'])
def add_proverb():

    token = session.get('access_token')
    print("**token:",token)
    if not token:
        print("i proverb")
        return(ask_for_auth("Vous devez être authentifié pour ajouter un proverbe"))

    if request.method == "POST":
        enonce = request.form['enonce']
        origine = request.form['origine']
        explication = request.form['explication']
        genre = request.form['genre']

        url = f'{BACK_URL}/proverbs/?token={token}'
        response = requests.post(
            url,
            json={'enonce': enonce, 'origine': origine, 'explication': explication, 'genre': genre},
            headers={'accept': 'application/json', 'Content-Type': 'application/json'}
        )

        if response.status_code == 200:
            return redirect(url_for('proverbs.add_proverb'))
        else:
            return (generate_error("/front/proverbs/add",f"ERROR {response.status_code} : Something went wrong when adding proverb"))
            # {response.text} --> for details

    return render_template("add_proverbs.html")


@proverbs_bp.route('/delete/<int:proverb_id>', methods=['POST', 'DELETE'])
def delete_proverb(proverb_id):
    token = session.get('access_token')
    if not token:
        return(redirect(url_for('app.manage_proverbs')))

    url = f'{BACK_URL}/proverbs/{proverb_id}?token={token}'
    response = requests.delete(url, headers={'accept': 'application/json'})

    if response.status_code == 200:
        return redirect(url_for('app.manage_proverbs'))
    else:
        return (generate_error("/front/manage/proverbs",f"ERROR {response.status_code} : Something went wrong when deleting proverb"))
