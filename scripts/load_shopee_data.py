import os

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

load_dotenv()

file_path = 'data/20240121_shopee_sample_data (1).csv'

df = pd.read_csv(file_path, encoding='utf-8-sig')

url = URL.create(
    "mysql+pymysql",
    username=os.environ["DB_USER"],
    password=os.environ["DB_PASSWORD"],
    host="localhost",
    port=3306,
    database="shopee_sales_2024",
    query={"charset": "utf8mb4"},
)
engine = create_engine(url)

df.to_sql(name='raw_shopee_sales', con=engine, if_exists='replace', index=False)
print("Data successfully imported into local MySQL!")
