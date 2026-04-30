import requests
import json
import os
from datetime import datetime
from zoneinfo import ZoneInfo

API_KEY = "<yourAPIkey>" #Enter your Jellyfin API key here
BASE_URL = "<local IP or domain of Jellyifn server>" #if your have your Jellyfin instance exposed to the web, you can just enter its IP here that you use to access it via a browser. 
OUTPUT_FILE = "/var/www/html/json/media.json"

timezone = ZoneInfo("Europe/Berlin") #This is for showing a 'last updated' message at the top. If you want this to be equivalent to your time, enter your timezone

headers = {
    "X-Emby-Token": API_KEY
}

def fetch_items():
    url = f"{BASE_URL}/Items"
    params = {
        "Recursive": True,
        "IncludeItemTypes": "Movie,Series",
        "Fields": "ProductionYear"
    }

    r = requests.get(url, headers=headers, params=params, timeout=10)
    r.raise_for_status()
    return r.json()["Items"]

def transform(items):
    movies, shows = [], []

    for item in items:
        entry = {
            "title": item.get("Name"),
            "year": item.get("ProductionYear")
        }

        if item.get("Type") == "Movie":
            movies.append(entry)
        elif item.get("Type") == "Series":
            shows.append(entry)

    return {
    "last_updated": datetime.now(timezone).isoformat(timespec="seconds"),
    "movies": sorted(movies, key=lambda x: x["title"] or ""),
    "shows": sorted(shows, key=lambda x: x["title"] or "")
}

def atomic_write(data, path):
    tmp = path + ".tmp"
    with open(tmp, "w") as f:
        json.dump(data, f)
    os.replace(tmp, path)

if __name__ == "__main__":
    try:
        items = fetch_items()
        data = transform(items)
        atomic_write(data, OUTPUT_FILE)
        print("Updated successfully")
    except Exception as e:
        print("Failed to update:", e)