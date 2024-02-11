import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials
import json

cred=credentials.Certificate("./firebase-sdk.json")
firebase_admin.initialize_app(cred)

db=firestore.client()

xz="murder"
with open(f"./database/{xz}"+"_cases.json") as f1:
    data=json.load(f1)
    # print(len(data))
    dict1 = {}
    dict2 = {}
    dict3 = {}
    dict4 = {}
    dict5 = {}
    l=[dict1, dict2, dict3, dict4, dict5]
    for i in range(0,len(data)):
        # print(i)
        if i<900:
            dict1[str(i)]=data[i]    
        elif i<1800:
            dict2[str(i)]=data[i]
        elif i<2700:
            dict3[str(i)]=data[i]
        elif i<3600:
            dict4[str(i)]=data[i]
        else:
            dict5[str(i)]=data[i]
    doc= db.collection("cases").document(f"{xz}1")
    doc.set(dict1)
    doc2= db.collection("cases").document(f"{xz}2")
    doc2.set(dict2)
    doc3= db.collection("cases").document(f"{xz}3")
    doc3.set(dict3)
    doc4= db.collection("cases").document(f"{xz}4")
    doc4.set(dict4)
    doc5= db.collection("cases").document(f"{xz}5")
    doc5.set(dict5)
        # print(doc)
        # doc.set(l[i])