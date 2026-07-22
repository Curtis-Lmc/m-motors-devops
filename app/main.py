from fastapi import FastAPI

app = FastAPI(
    title="M-Motors API",
    description="API de démonstration pour l'ECF Administrateur Système DevOps",
    version="1.0.0",
)


@app.get("/")
def read_root() -> dict[str, str]:
    """Retourne un message permettant de vérifier que l'API fonctionne."""
    return {"message": "Hello World"}


@app.get("/health")
def health_check() -> dict[str, str]:
    """Endpoint utilisé pour vérifier l'état de santé de l'application."""
    return {"status": "healthy"}