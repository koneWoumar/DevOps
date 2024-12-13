# Proverbs back-end

# Architecture

```bash
backend/
├── main.py               # Point d'entrée de l'application
├── database.py           # Configuration de la base de données
├── models.py             # Modèles SQLAlchemy
├── schemas.py            # Schemas Pydantic
├── keycloak_config.py    # Configuration Keycloak
└── crud.py               # Opérations CRUD
```

## dependences

```bash
pip install fastapi uvicorn sqlalchemy psycopg2-binary python-keycloak pydantic
pip install pymysql

```

## execute app

```bash
uvicorn main:app --reload
```

## Build docker images


## Push the image to my docker bub registry
