# -*- coding: utf-8 -*-
"""
Created on Tue Sep  1 16:42:50 2020

@author: shiro
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt



np.random.seed(0)

def gen(x):
    return np.cos(1.5*np.pi*x)

def get_points(n: int = 1000):
    x =  np.linspace(0, 1, num = n)
    y = np.cos(1.5*np.pi*x) + np.random.normal(0,1,n)*0.2
    return x, y

x, y = get_points(n=1000)
plt.scatter(x, y)
plt.show()

def f(x):
  return x**2


def grad_f(x): 

  return 2 * x

def grad_descent_2d(f, grad_f, lr = 0.01, num_iter=100, x0=None):
    if x0 is None:
        x0 = np.random.random(1)
        
    history = [] # аргументы и функции
    
    curr_x = x0.copy()
    for iter_num in range(num_iter):
        entry = np.hstack((curr_x, f(curr_x)))
        history.append(entry)
        curr_x -=  grad_f(curr_x)*lr
        
    return np.vstack(history)

steps = grad_descent_2d(f, grad_f, lr=0.4, num_iter=20)

