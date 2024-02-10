import requests
from json import JSONEncoder
# from xml import XMLEncoder
url="https://api.indiankanoon.org/search/?formInput=theft&maxpages=100&pagenum=300"
api = "2852f54424a360a69edc0feebedf8b8a969e93b3"
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