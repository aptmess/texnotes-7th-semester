import numpy as np

def entropy(p):
    return -p * np.log2(p) - (1 - p) * np.log2(1 - p) if 0 < p < 1 else 0

def gini(p):
    return 2 * p * (1-p)

def IG(v, U0, U1, which='entropy'):
    if which == 'entropy':
        inf = entropy
    elif which =='gini':
        inf = gini
    N, N1, N2 = list(map(len, [v, U0, U1]))
    if N1 == 0 or N2 == 0:
        return 0
    else:
        S0, S1, S2 = list(map(inf, [np.mean(v), np.mean(U0), np.mean(U1)]))
        return S0 - N1 * S1 / N - N2 * S2 / N
    
def get_data(train_data, train_labels, d: dict):
    if d['which_x'] == 'x2':
        m = train_data[:, 1] < d['v']
    elif d['which_x'] == 'x1':
        m = train_data[:, 0] < d['v']
    return m