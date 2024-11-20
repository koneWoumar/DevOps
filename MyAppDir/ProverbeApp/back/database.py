from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# Connexion MySQL
SQLALCHEMY_DATABASE_URL = "mysql+pymysql://root:00932@127.0.0.1/proverbs_db"

# Créer le moteur SQLAlchemy
engine = create_engine(SQLALCHEMY_DATABASE_URL)

# Créer une session locale
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base pour les modèles
Base = declarative_base()
