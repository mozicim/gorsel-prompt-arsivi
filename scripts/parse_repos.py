import json
import sys

try:
      data = json.load(sys.stdin)
except Exception:
      sys.exit(0)

for item in data.get("items", []):
      full_name = item.get("full_name", "")
      stars = item.get("stargazers_count", 0)
      html_url = item.get("html_url", "")
      print(f"{full_name}|{stars}|{html_url}")
  
