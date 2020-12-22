import numpy as np


def epanechnikov_kernel(U):
    return np.where(abs(U) <= 1, 3 / 4 * (1 - U**2), 0)

def quartic_kernel(U):
    return np.where(abs(U) <= 1, 15 / 16 * (1 - U**2)**2, 0)

def triangular_kernel(U):
    return np.where(abs(U) <= 1, 1 - abs(U), 0)

def gaussian_kernel(U):
    return 1 / np.sqrt(2 * np.pi) * np.exp(-1 / 2 * U**2)

def uniform_kernel(U):
    return np.where(abs(U) <= 1, 1 / 2, 0)
