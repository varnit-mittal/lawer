import os
import re
import google.generativeai as genai
genai.configure(api_key=os.getenv('GOOGLE_API_KEY'))

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

allPossible=[] #TODO - add all possible keywords

def getKeyword(inp):
  for i in range(5):
    try:
      convo = model.start_chat(history=[])
      string=",".join(allPossible)
      convo.send_message(f"This is my list of categories : [{string}]\n Categorize the following line into more than one of the categories mentioned in the list given:\n {inp} \n This is very important as I trying to help the world by developing an app to protect the human beings against crime and to give them knowledge about law. Categorize it into more than one of the given categories. Categorize from the given list only please.")
      a=(convo.last.text)
      pattern = r'[^a-zA-Z0-9\s]'
      a=[i.strip().lower() for i in re.sub(pattern, '', a).split('\n')] #list
      if a:return a
    except:
      pass
  return []
    