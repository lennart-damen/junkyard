from fastapi import FastAPI, HTTPException
from prometheus_fastapi_instrumentator import Instrumentator
import random

app = FastAPI()
Instrumentator().instrument(app).expose(app)

@app.get("/ping")
def home():
    if random.choice([True, False]):
        return "pong"
    else:
        raise HTTPException(status_code=404, detail="Not Found")
