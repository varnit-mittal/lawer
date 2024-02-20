import os
import json

from dotenv import load_dotenv

load_dotenv()
print(os.getenv('FIREBASE_SDK'))