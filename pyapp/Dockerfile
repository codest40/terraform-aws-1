# Stage 1: builder
FROM python:3.11-slim AS build

WORKDIR /app

# Copy requirements (important for caching)
COPY requirements.txt .

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt --no-cache-dir


# Stage 2: runtime
FROM python:3.11-slim

RUN useradd --create-home appuser

WORKDIR /app

# Copy Python dependencies and installed binaries
COPY --from=build /usr/local/lib/python3.11/site-packages \
     /usr/local/lib/python3.11/site-packages
COPY --from=build /usr/local/bin /usr/local/bin

# Copy your FastAPI code
COPY . /app

ENV PYTHONUNBUFFERED=1
ENV PORT=8000

USER appuser
EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
  CMD wget -qO- http://127.0.0.1:8000/ping || exit 1

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
