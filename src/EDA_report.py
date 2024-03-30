import pandas as pd
import subprocess
import os
import sys
from ydata_profiling import ProfileReport

parent_path = str(sys.argv[2])
orig_filename = str(sys.argv[3])

df_data = pd.read_csv(parent_path+"dataset.csv")
df_dic = pd.read_csv(parent_path+"data_dic.csv")

profile = df_data.profile_report(
    title="Profile Report for "+orig_filename,
    minimal = True,
    infer_dtypes=True,
    orange_mode=True,
    dataset={
        "description": "Profile Report for "+orig_filename
        # "copyright_holder": "ODC-SCI; Ferguson Lab, UCSF",
        # "copyright_year": "2022",
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

profile.to_file(output_file=parent_path+'Profile.html', silent = False)

# profile.to_notebook_iframe()
