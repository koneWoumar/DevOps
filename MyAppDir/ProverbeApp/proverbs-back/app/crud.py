from sqlalchemy.orm import Session
from models import Proverb
from schemas import ProverbCreate

# def create_user(db: Session, user: UserCreate):
#     db_user = User(username=user.username, email=user.email)
#     db.add(db_user)
#     db.commit()
#     db.refresh(db_user)
#     return db_user

# def get_user(db: Session, user_id: int):
#     return db.query(User).filter(User.id == user_id).first()

def create_proverb(db: Session, proverb: ProverbCreate):
    db_proverb = Proverb(**proverb.dict())
    db.add(db_proverb)
    db.commit()
    db.refresh(db_proverb)
    return db_proverb

def get_proverbs(db: Session):
    return db.query(Proverb).all()

def get_proverb(db: Session, proverb_id: int):
    return db.query(Proverb).filter(Proverb.id == proverb_id).first()

def delete_proverb(db: Session, proverb_id: int):
    db_proverb = db.query(Proverb).filter(Proverb.id == proverb_id).first()
    if db_proverb:
        db.delete(db_proverb)
        db.commit()

def update_proverb(db: Session, proverb_id: int, updated_data: ProverbCreate):
    db_proverb = db.query(Proverb).filter(Proverb.id == proverb_id).first()
    if db_proverb:
        for key, value in updated_data.dict().items():
            setattr(db_proverb, key, value)
        db.commit()
        db.refresh(db_proverb)
        return db_proverb
