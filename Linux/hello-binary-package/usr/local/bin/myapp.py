#!/usr/bin/env python3
from flask import Flask, request
import datetime

# Lire configuration
conf_path = '/etc/myapp/myapp.conf'
with open(conf_path) as f:
    lines = f.readlines()
    port = int([l for l in lines if l.startswith('port')][0].split('=')[1].strip())
    chemin = [l for l in lines if l.startswith('chemin')][0].split('=')[1].strip()

data_path = "/var/lib/myapp/myapp.data"

app = Flask(__name__)

@app.route(chemin, methods=["GET"])
def hello():
    with open(data_path, "a") as f:
        f.write(f"{datetime.datetime.now()} - {request.url}\n")
    return "Ceci est un message de test depuis MyApp."

if __name__ == "__main__":
    app.run(port=port)
