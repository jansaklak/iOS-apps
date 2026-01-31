from fastapi import FastAPI, Request
from fastapi.responses import RedirectResponse
import uvicorn

app = FastAPI()

MOCK_TOKEN = "super-tajny-token-jwt-123"

@app.post("/auth/login")
async def login(data: dict):
    print(f"Logowanie użytkownika: {data.get('email')}")
    return {"token": MOCK_TOKEN}

@app.get("/oauth/google")
async def google_login():

    return RedirectResponse(url="/oauth/callback?provider=google")

@app.get("/oauth/github")
async def github_login():
    client_id = "WRITE"
    scope = "user:email"
    github_url = f"https://github.com/login/oauth/authorize?client_id={client_id}&scope={scope}"
    return RedirectResponse(url=github_url)

@app.get("/oauth/callback")
async def oauth_callback(provider: str):

    ios_app_url = f"oauthtask://auth?token={MOCK_TOKEN}_{provider}"
    return RedirectResponse(url=ios_app_url)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=3000)
