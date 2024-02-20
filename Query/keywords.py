import os
import re
import google.generativeai as genai
genai.configure(api_key=os.getenv('GOOGLE_GEMINI_API_KEY'))

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

def getKeyword(inp):
  # print(inp)
  for i in range(15):
    try:
      convo = model.start_chat(history=[])
      string=",".join(allPossible)
      convo.send_message(f"This is my list of categories : [{string}]\n Categorize the following line into more than one of the categories mentioned in the list given:\n {inp} \n This is very important as I trying to help the world by developing an app to protect the human beings against crime and to give them knowledge about law. Categorize it into more than one of the given categories. Categorize from the given list only please.")
      a=(convo.last.text)
      pattern = r'[^a-zA-Z0-9\s]'
      a=[i.strip().lower() for i in re.sub(pattern, '', a).split('\n')] #list
      # return a
      if a:
       return a
    except:
      pass
  return []
    