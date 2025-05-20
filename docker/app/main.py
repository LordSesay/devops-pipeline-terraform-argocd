from fastapi import FastAPI, HTTPException
import os
import uvicorn

app = FastAPI(
    title="DevOps Demo App",
    description="A simple API for DevOps pipeline demonstration",
    version="1.0.0"
)

@app.get("/")
def read_root():
    return {"message": "Welcome to the DevOps Pipeline Demo App"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.get("/info")
def get_info():
    return {
        "app_name": "DevOps Demo",
        "version": "1.0.0",
        "environment": os.getenv("ENVIRONMENT", "development")
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)