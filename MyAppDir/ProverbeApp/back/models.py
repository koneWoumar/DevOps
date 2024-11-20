from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from database import Base

class Proverb(Base):
    __tablename__ = "proverbs"
    id = Column(Integer, primary_key=True, index=True)
    enonce = Column(String(255), nullable=False)       # Longueur maximale 255 caractères pour l'énoncé
    origine = Column(String(100), nullable=False)      # Longueur maximale 100 caractères pour l'origine
    explication = Column(String(500), nullable=False)  # Longueur maximale 500 caractères pour l'explication
    genre = Column(String(50), nullable=False)         # Longueur maximale 50 caractères pour le genre
    user_id = Column(Integer, ForeignKey("users.id"))

    user = relationship("User", back_populates="proverbs")

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, nullable=False)  # Longueur maximale 50 caractères pour le nom d'utilisateur
    email = Column(String(100), unique=True, nullable=False)    # Longueur maximale 100 caractères pour l'email

    proverbs = relationship("Proverb", back_populates="user")
