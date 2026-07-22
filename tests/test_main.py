from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_my_test() -> None:
    """Vérifie que la route principale retourne Hello World."""
    response = client.get("/")

    assert response.status_code == 200
    assert response.json() == {"message": "Hello World"}


def test_health_check() -> None:
    """Vérifie que l'application indique être en bonne santé."""
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}