from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal, engine
from models import Base
from schemas import ProverbCreate
from crud import create_proverb, get_proverbs, get_proverb, delete_proverb, update_proverb
from keycloak_config import get_user_info

app = FastAPI()

Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# @app.post("/users/")
# def register_user(user: UserCreate, db: Session = Depends(get_db)):
#     return create_user(db, user)

@app.post("/proverbs/")
def add_proverb(proverb: ProverbCreate, token: str, db: Session = Depends(get_db)):
    user_info = get_user_info(token)
    user_id = user_info.get("sub")
    return create_proverb(db, proverb)

@app.get("/proverbs/")
def read_proverbs(db: Session = Depends(get_db)):
    return get_proverbs(db)

@app.get("/proverbs/{proverb_id}")
def read_proverb(proverb_id: int, db: Session = Depends(get_db)):
    proverb = get_proverb(db, proverb_id)
    if not proverb:
        raise HTTPException(status_code=404, detail="Proverb not found")
    return proverb

@app.delete("/proverbs/{proverb_id}")
def remove_proverb(proverb_id: int, token: str, db: Session = Depends(get_db)):
    user_info = get_user_info(token)
    user_id = user_info.get("sub")
    delete_proverb(db, proverb_id)
    return {"detail": "Proverb deleted"}

@app.put("/proverbs/{proverb_id}")
def modify_proverb(proverb_id: int, proverb: ProverbCreate, db: Session = Depends(get_db)):
    updated_proverb = update_proverb(db, proverb_id, proverb)
    if not updated_proverb:
        raise HTTPException(status_code=404, detail="Proverb not found")
    return updated_proverb
