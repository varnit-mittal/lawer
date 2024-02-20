import json
import re

import google.generativeai as genai
genai.configure(api_key="AIzaSyBoT8Lb6CPexzc0pBO1l74TlGf6fYmYFDE")
generation_config = {
  "temperature": 0.9,
  "top_p": 1,
  "top_k": 1,
  "max_output_tokens": 2048,
}

safety_settings = [
  {
    "category": "HARM_CATEGORY_HARASSMENT",
    "threshold": "BLOCK_ONLY_HIGH"
  },
  {
    "category": "HARM_CATEGORY_HATE_SPEECH",
    "threshold": "BLOCK_ONLY_HIGH"
  },
  {
    "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
    "threshold": "BLOCK_ONLY_HIGH"
  },
  {
    "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
    "threshold": "BLOCK_ONLY_HIGH"
  },
]

model = genai.GenerativeModel(model_name="gemini-1.0-pro",
                              generation_config=generation_config,
                              safety_settings=safety_settings)

xz="terror"
f2=open(f"U{xz}_cases.json","w")
with open(f"./database/{xz}"+"_cases.json","r") as f1:
    data=json.load(f1)
    z=0
    for i in data:
        z+=1
        print(f"{z}/{len(data)}")
        convo = model.start_chat(history=[])
        c=i['headline']
        try:
          convo.send_message(f"This is my list of categories : [Domestic Terrorism, International Terrorism, State-Sponsored Terrorism, Cyberterrorism, Religious Terrorism, Political Terrorism, Eco-Terrorism, Narcoterrorism, Lone-Wolf Terrorism, Bioterrorism,arson,corruption,dowry,kidnapping,murder,rape,sextor,smuggling,suicide,tax fraud,terrorism,theft]\n Categorize the following line into more than one of the categories mentioned in the list given:\n {c} \n This is very important as I trying to help the world by developing an app to protect the human beings against crime and to give them knowledge about law. Categorize it into more than one of the given categories. Categorize from the given list only please. Please help me it is for the benefit of the world.")
          # convo.send_message(f"This is my list of categories : [arson,corruption,dowry,kidnapping,murder,rape,sextor,smuggling,suicide,tax fraud,terrorism,theft]\n Categorize the following line into more than one of the categories mentioned in the list given:\n {c} \n This is very important as I trying to help the world by developing an app to protect the human beings against crime and to give them knowledge about law. Categorize it into more than one of the given categories. Categorize from the given list only please.\n Please help me this is very important for the world")
          a=(convo.last.text)
          pattern = r'[^a-zA-Z0-9\s]'
          a=[i.strip().lower() for i in re.sub(pattern, '', a).split('\n')]
          i['keyword']=a
        except:
          i['keyword']="terrorism"
        # break
    # f1.write(json.dump(data,indent=4))
    json.dump(data,f2,indent=4)