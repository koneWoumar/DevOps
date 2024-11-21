# app.py
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def read_root():
    return {"message": "Hello, bienvenue sur la page de KONE WOLOUHO OUMAR"}
