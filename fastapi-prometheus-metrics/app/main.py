from fastapi import FastAPI, HTTPException
from prometheus_fastapi_instrumentator import Instrumentator
import random

app = FastAPI()
Instrumentator().instrument(app).expose(app)

@app.get("/ping")
def ping():
    return "pong"

@app.get("/flaky")
def flaky():
    if random.choice([True, False]):
        return "you got lucky"
    else:
        raise HTTPException(status_code=404, detail="Not Found")

@app.get("/bad-guy")
def bad_guy():
    raise HTTPException(status_code=500, detail="I'm a bad guy")

@app.get("/do-something")
def do_something():
    for _ in range(1000):
        random.random()
    return "done, that was easy"

@app.get("/do-a-lot")
def do_a_lot():
    for _ in range(99999999):
        random.random()
    return "done, but that was hard"
