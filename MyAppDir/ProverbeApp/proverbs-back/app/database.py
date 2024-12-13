from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
import os


# ------------------------------------------------#

# Charger variable from .env
area = os.getenv("ENVIRONMENT")
if (area != "container"):
    load_dotenv()

# Accéder aux variables d'environnement
DB_URL = os.getenv("DATABASE_URL")
DB_USER = os.getenv("DATABASE_USER")
DB_PASSWORD = os.getenv("DATABASE_PASSWORD")
DB_NAME = os.getenv("DATABASE_NAME")


# Connexion MySQL
SQLALCHEMY_DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_URL}/{DB_NAME}"

# ------------------------------------------------#


# Connexion MySQL
#SQLALCHEMY_DATABASE_URL = "mysql+pymysql://root:00932@127.0.0.1/proverbs_db"


# Créer le moteur SQLAlchemy
engine = create_engine(SQLALCHEMY_DATABASE_URL)

# Créer une session locale
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base pour les modèles
Base = declarative_base()
