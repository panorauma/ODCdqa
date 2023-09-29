import pandas as pd

#parent folder path
path = "/Ex_Data/"

df = pd.read_csv(path+"Example ODC dataset.csv")

#num rows to keep
new_df = df.head(10)
new_df.to_csv(path+"subset_df.csv")
