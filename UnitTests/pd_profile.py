#modified ver of EDA_report.py for Docker testing

import pandas as pd
from ydata_profiling import ProfileReport as pr

# df_data = pd.read_csv("tempFiles/"+str(sys.argv[1])+"dataset.csv")
# df_dic = pd.read_csv("tempFiles/"+str(sys.argv[1])+"data_dic.csv")

df_data = pd.read_csv("Ex_Data/Example ODC dataset.csv") #dataset
df_dic = pd.read_csv("Ex_Data/Example ODC data dictionary.csv") #data dic

profile = df_data.profile_report(
    title="Profile Report for ",
    minimal = True,
    infer_dtypes=True,
    orange_mode=True,
    dataset={
        "description": "Profile Report for "
    },    
    correlations={
        "pearson": {"calculate": False},
        "spearman": {"calculate": False},
        "kendall": {"calculate": False},
        "phi_k": {"calculate": False},
        "cramers": {"calculate": False},
    },
    variables={
        "descriptions":df_dic.set_index("VariableName").to_dict()["Title"]
    },
)

# profile.to_file(output_file='htmlFiles/'+str(sys.argv[1])+'Profile.html', silent = False)