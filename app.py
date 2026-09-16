from flask import Flask

app = Flask(__name__)


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/")
def index():
    return {"service": "eval-flask-min"}


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)


# DevOps Autopilot: Prometheus instrumentation
try:
    from prometheus_flask_exporter import PrometheusMetrics as _DapPrometheusMetrics
    _DapPrometheusMetrics(app)
except Exception:
    pass
