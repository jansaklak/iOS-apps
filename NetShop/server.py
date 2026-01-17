from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
import uvicorn

app = FastAPI(title="Magazyn API")

class Category(BaseModel):
    id: int
    name: str

class Product(BaseModel):
    id: int
    name: str
    price: float
    category_id: int

class Order(BaseModel):
    id: int
    date: str
    total_amount: float
    status: str
    user_email: str
    product_ids: List[int]  

categories = [
    {"id": 1, "name": "Elektronika"},
    {"id": 2, "name": "Dom i Ogród"}
]

products = [
    {"id": 1, "name": "iPhone 15", "price": 4500.0, "category_id": 1},
    {"id": 2, "name": "Klawiatura Mechaniczna", "price": 350.0, "category_id": 1},
    {"id": 3, "name": "Lampa Stojąca", "price": 120.0, "category_id": 2}
]

orders = [
    {
        "id": 101,
        "date": datetime.now().isoformat(),
        "total_amount": 4850.0,
        "status": "Wysłane",
        "user_email": "jan.kowalski@example.com",
        "product_ids": [1, 2] # Relacja do produktów
    }
]

@app.get("/categories", response_model=List[Category])
def get_categories():
    return categories

@app.get("/products", response_model=List[Product])
def get_products():
    return products

@app.post("/products", status_code=201)
def add_product(product: Product):
    products.append(product.model_dump())
    return {"message": "Produkt dodany pomyślnie", "product": product}

@app.get("/orders", response_model=List[Order])
def get_orders():
    return orders

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)