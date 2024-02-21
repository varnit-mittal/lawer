import json
import os
import random
import re
import google.generativeai as genai # importing google.generativeai package

genai.configure(api_key=os.getenv('GOOGLE_GEMINI_API_KEY')) # initializing the gemini package with the api key from the environment

generation_config = { # initial configuration for the gemini model
  "temperature": 0.5, # degree of randomness in the output
  "top_p": 1, #Reduce diversity, focusing on the most probable words
  "top_k": 1, #Limits the number of words considered when generating the next token
  "max_output_tokens": 2048,
}

safety_settings = [ # configuration for the safety settings of the gemini model
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

model = genai.GenerativeModel(model_name="gemini-1.0-pro", # initializing the gemini model with the generation configuration and safety settings
                              generation_config=generation_config,
                              safety_settings=safety_settings)

# set of all Possible keywords 
allPossible=['Drug Smuggling',' Human Trafficking',' Arms Smuggling',' Contraband Goods Smuggling',' Cigarette Smuggling',' Organ Smuggling',' Art and Antiquities Smuggling',
             'Technology and Intellectual Property Smuggling','Precious Metals and Minerals Smuggling','Acquaintance Rape',' Date Rape',' Stranger Rape',' Marital Rape', 
             'Drug-Facilitated Rape',' Gang Rape',' Statutory Rape',' Custodial Rape',' Spousal Rape',' Campus Sexual Assault','arson','corruption','dowry','kidnapping',
             'murder','rape','sextor','smuggling','suicide','tax fraud','terrorism','theft','Sextortion','Homicide','Manslaughter','Serial Murder','Mass Murder','Assassination',
             'Accidental Killing','Honor Killing','Robbery-related Murder','Domestic Violence Homicide','Gang-related Homicide','Suicidal Ideation','Suicide Attempt',
             'Completed Suicide','Assisted Suicide','Copycat Suicide','Suicide Pact','Suicide Contagion','Physician-Assisted Suicide','Suicide Prevention','Suicide Bereavement',
             'Dowry Harassment','Dowry Death','Dowry Violence','Dowry Extortion','Dowry Abuse','Dowry-Related Crimes','Dowry Prohibition','Dowry Legislation','Dowry System','Dowry Discrimination',
             'Intentional Arson','Vandalism Arson','Insurance Fraud','Revenge Arson','Serial Arson','Political Arson','Psychological Arson','Arson for Concealment','Hate Crime Arson','Wildfire Arson',
             'Domestic Terrorism','International Terrorism','State-Sponsored Terrorism','Cyberterrorism','Religious Terrorism','Political Terrorism','Eco-Terrorism','Narcoterrorism','Lone-Wolf Terrorism','Bioterrorism',
             'Bribery','Embezzlement','Nepotism','Extortion','Money Laundering','Kickbacks','Patronage','Fraud','Graft','Abuse of Power','Kidnapping for Ransom',
             'Express Kidnapping','Parental Kidnapping','Political Kidnapping','Tiger Kidnapping','Bride Kidnapping','Child Abduction','Virtual Kidnapping','Kidnapping for Extortion','Gang-related Kidnapping',
             'Petty Theft','Grand Theft','Burglary','Robbery','Shoplifting','Auto Theft','Identity Theft','Embezzlement','Bicycle Theft','Pickpocketing',
             'Tax Evasion','False Deductions','Shell Companies','Offshore Accounts','Falsifying Income','Phantom Employees','Money Laundering','Inflating Expenses','Identity Theft','Fraudulent Tax Credits'] #TODO - add all possible keywords

def getKeyword(inp:str)->list[str]: 
  """
  Retrieves keywords for a given input by interacting with the gemini model.

  Parameters:
  inp (str): The input string to be categorized.

  Returns:
  list: A list of keywords extracted from the gemini model's response.

  """
  for i in range(15): # calling this function till the model returns the keywords for an input 
    try: # maximum try limit is 15
      convo = model.start_chat(history=[]) # starting the chat with the gemini model
      string=",".join(allPossible) 
      convo.send_message(f"This is my list of categories : [{string}]\n Categorize the following line into more than one of the categories mentioned in the list given:\n {inp} \n This is very important as I trying to help the world by developing an app to protect the human beings against crime and to give them knowledge about law. Categorize it into more than one of the given categories. Categorize from the given list only please.")
      # sending the message to the gemini model
      a=(convo.last.text) # Stores the model's response in the variable 'a'
      pattern = r'[^a-zA-Z0-9\s]' # regex pattern to remove special characters
      a=[i.strip().lower() for i in re.sub(pattern, '', a).split('\n')] #list of keywords extracted from the model's response after removing special characters
      if a:
       return a
    except:
      pass
  return []
    
def getData(d:set)->list[dict]:
  """
  Retrieves the cases from unidata.json based on the keyword in the 

  Parameters:
  d (set): set of keywords to be searched in the unidata.json file.

  Returns:
  list: A list of cases from the unidata.json file based on the keywords.
  """
  with open("unidata.json","r") as f:
    data=json.load(f) # loading the data from the unidata.json file
    output=[] # list to store the output
    x=0
    for i in data: # iterating through the data from unidata.json
        wt=0
        if type(i['keyword']) == list: 
          for j in i['keyword']:
              if j in d:
                  wt+=1
        else:
          if i['keyword'] in d:
                  wt+=1
        if wt>0: # adding the case to the output list if it is relevant
            output.append([x,wt])
        x+=1
    output.sort(key=lambda x:x[1],reverse=True) # sorting the output list based on the weight of the cases
    opt=[]
    for i in output: # adding the cases to the opt list
        opt.append(data[i[0]])
    return opt
            
            
def LgetLaws(law: list[str]) -> list[dict]:
  """
  Retrieve a list of laws based on the given law name.

  Args:
    law (list[str]): The name of the law to retrieve.

  Returns:
    list[dict]: A list of dictionaries representing the retrieved laws.
  """
  with open(f"./database/{law}_laws.json", "r") as f: # loading the laws from the law file
    data = json.load(f) # loading the data from the law file
    size = len(data) 
    if size <= 15:
      return data
    l = []
    while len(l) < 15:
      num = random.randint(0, size-1)
      if num not in l:
        l.append(num)
    opt = []
    for i in l:
      opt.append(data[i])
    return opt
  
  