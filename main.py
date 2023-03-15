import socket

from typing import Union

from fastapi import FastAPI

from datetime import datetime

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}

@app.get("/healthz")
async def healthcheck():
    """
    Healthcheck API Operation
    """
    return {
        "message": (
            "What you gonna do when things go wrong? "
            + "What you gonna do when it all cracks up? "
            + "Alive and kicking!"
        ),
        "server": socket.gethostname(),
        "timestamp": datetime.now().isoformat(),
    }
