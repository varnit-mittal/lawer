import json

xz="theft"
f= open(f"{xz}_laws.json","w+")
f2=open(f"{xz}_cases.json","w+")
f.write("[")
f.write("\n")
f2.write("[")
f2.write("\n")
for i in range(1,5):
    file=f"{xz}"+str(i)+".json"
    with open(f"./database/{xz}"+str(i)+".json") as f1:
        # exit()

        # print(f1.readline())
        # exit()
        # content = f1.read()
        data=json.load(f1)
        # print(data)
        a=data['docs']
        for doc in a:
            x= str(doc['title'])
            x=x.lower()
            x=x.split()
            if("section" in x or "penal" in x):
                f.write(json.dumps(doc))
                f.write(",\n")
            else:
                f2.write(json.dumps(doc))
                f2.write(",\n")

f.write("]")
f2.write("]")
