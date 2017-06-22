# -*- coding: utf-8 -*-
"""
Created on Thu Jun 22 09:45:22 2017

@author: matlabyy
"""

import pickle
import numpy as np
with open('sensitive_analysis_37.pkl','r') as input37:
    result37 = pickle.load(input37)
with open('sensitive_analysis_39.pkl','r') as input39:
    result39 = pickle.load(input39)
result =list()
result.extend(result37)
result.extend(result39)
with open('sensitive_analysis_76.pkl','wb') as input76:
    pickle.dump(result,input76)
price_list =list()
for i in result37:
    price_list.append(i[-1])
for i in result39:
    price_list.append(i[-1])
    
result_array = np.array(price_list)
print(result_array.mean())
print(result_array.std())
    
