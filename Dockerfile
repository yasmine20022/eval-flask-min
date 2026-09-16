FROM python:3.12-slim
RUN apt-get update && apt-get install -y --no-install-recommends build-essential python3-dev gcc && rm -rf /var/lib/apt/lists/*
RUN groupadd -r app && useradd -r -g app appuser
COPY . ./
RUN pip install --no-cache-dir -r requirements.txt || true
RUN pip install --no-cache-dir "gunicorn"
COPY . /app
WORKDIR /app
EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD curl -f http://localhost:5000/health || exit 1
USER appuser
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:5000"]
