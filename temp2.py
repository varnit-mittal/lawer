import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials
import json

cred=credentials.Certificate("./firebase-sdk.json")
firebase_admin.initialize_app(cred)

db=firestore.client()

xz="theft"
with open(f"./database/{xz}"+"_cases.json") as f1:
    data=json.load(f1)
    # print(len(data))
    dict1 = {}
    dict2 = {}
    dict3 = {}
    dict4 = {}
    dict5 = {}
    dict6 = {}
    dict7 = {}
    dict8 = {}
    dict9 = {}
    dict10 = {}
    dict11= {}
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
        elif i<4500:
            dict5[str(i)]=data[i]
        elif i<5400:
            dict6[str(i)]=data[i]
        elif i<6300:
            dict7[str(i)]=data[i]
        elif i<7200:
            dict8[str(i)]=data[i]
        elif i<8100:
            dict9[str(i)]=data[i]
        elif i<9000:
            dict10[str(i)]=data[i]
        else:
            dict11[str(i)]=data[i]
    if dict1:
        doc= db.collection("cases").document(f"{xz}1")
        doc.set(dict1)
    if dict2:
        doc2= db.collection("cases").document(f"{xz}2")
        doc2.set(dict2)
    if dict3:
        doc3= db.collection("cases").document(f"{xz}3")
        doc3.set(dict3)
    if dict4:
        doc4= db.collection("cases").document(f"{xz}4")
        doc4.set(dict4)
    if dict5:
        doc5= db.collection("cases").document(f"{xz}5")
        doc5.set(dict5)
    if dict6:
        doc6= db.collection("cases").document(f"{xz}6")
        doc6.set(dict6)
    if dict7:
        doc7= db.collection("cases").document(f"{xz}7")
        doc7.set(dict7)
    if dict8:
        doc8= db.collection("cases").document(f"{xz}8")
        doc8.set(dict8)
    if dict9:
        doc9= db.collection("cases").document(f"{xz}9")
        doc9.set(dict9)
    if dict10:
        doc10= db.collection("cases").document(f"{xz}10")
        doc10.set(dict10)
    if dict11:
        doc11= db.collection("cases").document(f"{xz}11")
        doc11.set(dict11)
        
        # print(doc)
        # doc.set(l[i])