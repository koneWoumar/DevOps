from pydantic import BaseModel
from typing import Optional, List

class ProverbBase(BaseModel):
    enonce: str
    origine: str
    explication: str
    genre: str

class ProverbCreate(ProverbBase):
    pass

class Proverb(ProverbBase):
    id: int
    user_id: int

    class Config:
        orm_mode = True

# class UserBase(BaseModel):
#     username: str
#     email: str

# class UserCreate(UserBase):
#     pass

# class User(UserBase):
#     id: int
#     proverbs: List[Proverb] = []

#     class Config:
#         orm_mode = True
