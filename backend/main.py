import base64
import os
import re

import httpx
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

load_dotenv()

app = FastAPI(title="ShapeShift API")

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
GEMINI_MODEL = os.getenv("GEMINI_MODEL", "gemini-2.5-flash")
GEMINI_URL = (
    "https://generativelanguage.googleapis.com/v1beta/models/"
    f"{GEMINI_MODEL}:generateContent"
)


class AnalyzeRequest(BaseModel):
    description: str = Field(default="", max_length=4000)
    imageBase64: str | None = Field(default=None, max_length=12_000_000)


@app.get("/health")
async def health():
    return {"status": "ok"}


@app.post("/analyze")
async def analyze_meal(payload: AnalyzeRequest):
    if not GEMINI_API_KEY:
        raise HTTPException(status_code=500, detail="Gemini API key is not configured.")

    prompt = f"""
Analise esta refeição: {payload.description}.
Identifique cada alimento separadamente.

REGRAS IMPORTANTES:
- Se o usuário informou a quantidade de um alimento na descrição, use exatamente essa quantidade.
- Para alimentos que aparecem na foto mas não foram mencionados, estime a quantidade visualmente.
- Retorne APENAS um JSON com este formato exato, sem markdown, sem explicação:
{{
  "mealName": "string",
  "items": [
    {{
      "name": "string",
      "weightGrams": 0.0,
      "caloriesPer100g": 0.0,
      "proteinPer100g": 0.0,
      "carbsPer100g": 0.0,
      "fatPer100g": 0.0
    }}
  ]
}}
"""

    parts = [{"text": prompt}]

    if payload.imageBase64:
        try:
            image_bytes = base64.b64decode(payload.imageBase64, validate=True)
        except (ValueError, base64.binascii.Error):
            raise HTTPException(status_code=400, detail="Invalid image encoding.")

        if len(image_bytes) > 8 * 1024 * 1024:
            raise HTTPException(status_code=413, detail="Image is too large.")

        parts.append({
            "inlineData": {
                "mimeType": "image/jpeg",
                "data": base64.b64encode(image_bytes).decode("ascii"),
            }
        })

    try:
        async with httpx.AsyncClient(timeout=60) as client:
            response = await client.post(
                GEMINI_URL,
                headers={"x-goog-api-key": GEMINI_API_KEY},
                json={"contents": [{"parts": parts}]},
            )
            response.raise_for_status()
            result = response.json()
    except httpx.HTTPStatusError as exc:
        raise HTTPException(
            status_code=502,
            detail="The AI provider rejected the request.",
        ) from exc
    except httpx.HTTPError as exc:
        raise HTTPException(
            status_code=502,
            detail="Could not reach the AI provider.",
        ) from exc

    try:
        text = result["candidates"][0]["content"]["parts"][0]["text"]
    except (KeyError, IndexError, TypeError):
        raise HTTPException(
            status_code=502,
            detail="Unexpected response from the AI provider.",
        )

    text = re.sub(r"^\s*```(?:json)?\s*|\s*```\s*$", "", text, flags=re.IGNORECASE)
    return {"result": text.strip()}
