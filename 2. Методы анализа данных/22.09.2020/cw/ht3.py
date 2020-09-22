# -*- coding: utf-8 -*-
"""
Created on Tue Sep 22 13:36:21 2020

@author: shiro
"""
import numpy as np
import pandas as pd

def preprocess(file_name: str, amount_of_columns: int = 2):
    dict_columns = {2:['k', 'nu'],
                    3:['k-1', 'k', 'nu']}
    with open(file_name, 'r') as file:
        lines = file.readlines()
    count_words = np.array(list(map(lambda x: x.split(), lines)))
    k_words = pd.DataFrame(data=count_words, columns=dict_columns[amount_of_columns])
    k_words['nu'] = k_words['nu'].astype(dtype=np.int64)
    return k_words

onegrams = preprocess(file_name='count_1w.txt', amount_of_columns=2)
bigrams = preprocess(file_name='count_2w.txt', amount_of_columns=3)

onegrams[r'P(w_k)'] = onegrams['nu'] / onegrams['nu'].sum()
onegrams[r'log P(w_k)'] = np.log(onegrams[r'P(w_k)'])
bigrams['log P(w_k-1|w_k)'] = np.log(bigrams['nu'] / bigrams['nu'].sum())

test = bigrams['k'].isin(onegrams['k'])
bigrams_full = bigrams[test]

def predict_next_word(onegrams,bigrams_full, word):
   candidates =bigrams_full[bigrams_full['k-1']==word]
   logs = onegrams[onegrams['k'].isin(candidates['k'])].iloc[:,3] + candidates.iloc[:,3].values
   try:
       result = onegrams.iloc[logs.index[np.argmax(logs)]]['k']
       return result
   except:
       return f"Word {word} is not in vocalbulary"
    
predict_next_word(onegrams, bigrams_full, word = 'will')

word = 'Best'

for i in range(11):
    print(word, end=' ')
    word = predict_next_word(onegrams, bigrams_full, word)
    
print(word + '!')


# -*- coding: utf-8 -*-
"""
Created on Tue Sep 22 13:36:21 2020

@author: shiro
"""
import numpy as np
import pandas as pd
import re
import string

def text_prepare(text):
    """
        text: a string

        return: modified string
    """
    # Перевести символы в нижний регистр
    text = text.lower() #your code

    # Заменить символы пунктуации на пробелы
    text = re.sub(r'[{}]'.format(string.punctuation), ' ', text)

    # Удалить "плохие" символы
    text = re.sub('[^A-Za-z0-9 ]', '', text)
    return text

def preprocess(file_name: str, amount_of_columns: int = 2):
    dict_columns = {2:['k', 'nu'],
                    3:['k-1', 'k', 'nu']}
    with open(file_name, 'r') as file:
        lines = file.readlines()
    count_words = np.array(list(map(lambda x: x.split(), lines)))
    k_words = pd.DataFrame(data=count_words, columns=dict_columns[amount_of_columns])
    k_words['nu'] = k_words['nu'].astype(dtype=np.int64)
    k_words['k'] = k_words['k'].apply(text_prepare)
    if amount_of_columns == 3:
        k_words['k-1'] = k_words['k-1'].apply(text_prepare)
    return k_words

def predict_next_word(onegrams,bigrams, word):
   candidates = bigrams[bigrams['k-1']==word]
   logs = onegrams[onegrams['k'].isin(candidates['k'])].iloc[:,3] + candidates.iloc[:,3].values
   try:
       result = onegrams.iloc[logs.index[np.argmax(logs)]]['k']
       return result
   except:
       return f"Word {word} is not in vocalbulary"
   
onegrams = preprocess(file_name='count_1w.txt', amount_of_columns=2)
bigrams = preprocess(file_name='count_2w.txt', amount_of_columns=3)

onegrams[r'P(w_k)'] = onegrams['nu'] / onegrams['nu'].sum()
onegrams[r'log P(w_k)'] = np.log(onegrams[r'P(w_k)'])
bigrams['log P(w_k-1|w_k)'] = np.log(bigrams['nu'] / bigrams['nu'].sum())



predict_next_word(onegrams, bigrams , word = 'will')
