import requests
import os
from json import JSONEncoder
# from xml import XMLEncoder
xz=input()
url=f"https://api.indiankanoon.org/doc/{xz}/"
api = os.getenv('KANNON')
headers={
    "Authorization": "Token " + api,
    "format": "json"
}
response = requests.post(url, headers=headers)
if response.status_code == 200:
    data = response.json()  # Assuming API returns JSON
    print(JSONEncoder().encode(data))
else:
    print("Request failed with status code:", response.status_code)