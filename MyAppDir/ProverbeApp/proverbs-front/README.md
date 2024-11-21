# proverbs-front

## architecture

```lua
/app
  |-- /templates
      |-- home.html
      |-- login.html
      |-- proverbs.html
  |-- /static
  |-- app.py
  |-- .env

```

## dependence

```bash
pip install flask flask-wtf requests python-dotenv
```

## variable

```conf
KEYCLOAK_URL=http://localhost:8080
CLIENT_ID=flask-client
CLIENT_SECRET=your-client-secret
REALM=proverb-realm
REDIRECT_URI=http://localhost:5000/callback
```

## lancer l'app

```bash
python app
```