import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials
import json

cred=credentials.Certificate("./firebase-sdk.json")
firebase_admin.initialize_app(cred)

db=firestore.client()

xz="theft"
with open(f"./database/{xz}"+"_laws.json") as f1:
    data=json.load(f1)
    # print(data)
    dict = {}
    for i in range(0,len(data)):
        dict[str(i)]=data[i]
    # print(dict)
    doc= db.collection("laws").document(f"{xz}")
    doc.set(dict)