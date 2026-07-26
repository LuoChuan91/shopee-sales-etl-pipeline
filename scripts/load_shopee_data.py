import pandas as pd
from sqlalchemy import create_engine

file_path = 'data/20240121_shopee_sample_data (1).csv'

df = pd.read_csv(file_path, encoding='utf-8-sig')

engine = create_engine('mysql+pymysql://root:***REMOVED***@localhost:3306/shopee_sales_2024?charset=utf8mb4')

df.to_sql(name='raw_shopee_sales', con=engine, if_exists='replace', index=False)
print("Data successfully imported into local MySQL!")
