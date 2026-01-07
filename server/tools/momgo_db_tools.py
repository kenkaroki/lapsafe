from pymongo import MongoClient
import os


################for  local test ##################
from dotenv import load_dotenv
load_dotenv()

MONGO_URI = os.environ.get("MONGO_URI", "mongodb://localhost:27017")

# Initialize MongoDB client (the cluster/connection)
client = MongoClient(MONGO_URI)

lapsafe_db = client["lapsafe"]

#for backwards compatability

setattr(client, "lapsafe", lapsafe_db)

user_collection = lapsafe_db.users
reports_collection = lapsafe_db.reports
