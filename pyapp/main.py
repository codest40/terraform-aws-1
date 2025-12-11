from fastapi import FastAPI
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from fastapi.responses import PlainTextResponse

app = FastAPI()

# --- Prometheus Metrics ---
REQUEST_COUNT = Counter(
    "app_requests_total",
    "Total number of requests processed",
    ["endpoint"]
)

@app.get("/ping")
def health():
    REQUEST_COUNT.labels(endpoint="/ping").inc()
    return {"status": "ok"}

@app.get("/home")
def home():
    REQUEST_COUNT.labels(endpoint="/home").inc()
    return {"message": "Welcome to the FastAPI Python app!"}

@app.get("/metrics")
def metrics():
    REQUEST_COUNT.labels(endpoint="/metrics").inc()
    data = generate_latest()
    return PlainTextResponse(data, media_type=CONTENT_TYPE_LATEST)
