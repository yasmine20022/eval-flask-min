FROM python:3.12-slim AS builder
ENV PYTHONUNBUFFERD=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends build-essential gcc python3-dev libffi-dev libssl-dev && rm -rf /var/lib/apt/lists/*
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir "gunicorn"
FROM python:3.12-slim AS runtime
ENV PYTHONUNBUFFERD=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1
WORKDIR /app
COPY --from=builder /app /app
RUN groupadd -r app && useradd -r -g app appuser
USER appuser
EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD curl -f http://localhost:5000/health || exit 1
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:5000"]
