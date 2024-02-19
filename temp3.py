from django.shortcuts import render

import os
import json
from dotenv import load_dotenv

load_dotenv()
# Create your views here.

import google.generativeai as genai

genai.configure(api_key=os.getenv("GOOGLE_GEMINI_API_KEY"))
# Set up the model
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

xz=input()
with open(f"./database/{xz}"+"_cases.json") as f1:
    convo = model.start_chat(history=[
    ])
    data=json.load(f1)
    c=data[78]['headline']
    convo.send_message(f"This is my list of categories : [arson,corruption,dowry,kidnapping,murder,rape,sextor,smuggling,suicide,tax fraud,terrorism,theft]\n Categorize the following line into more than one of the categories mentioned in the list given:\n {c} \n This is very important as I trying to help the world by developing an app to protect the human beings against crime and to give them knowledge about law. Categorize it into more than one of the given categories. Categorize from the given list only please.")
    print(convo.last.text)