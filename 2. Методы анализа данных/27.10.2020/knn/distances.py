import numpy as np


def euclidean_distance(x, y):
    '''

    Parameters
    ----------
    x : np.ndarray размера N x D
        обучающая выборка.
    y : np.ndarray размера M x D
        тестовая выборка.

    Raises
    ------
    NotImplementedError
        DESCRIPTION.

    Returns
    -------
    Функция возвращает np.ndarray размера N x M,
    каждый элемент которого - евклидово расстояния между
    соответствующей парой векторов из массивов x и y.
    Уменьшим число операций с помощью трюка, раскрывая скобки.
    '''
    x2 = np.sum(x**2, axis=1).reshape(-1, 1)
    y2 = np.sum(y**2, axis=1)
    result = np.sqrt(x2 + y2 - 2 * x @ y.T)
    return result


def cosine_distance(x, y):
    '''

    Parameters
    ----------
    x : np.ndarray размера N x D
        обучающая выборка.
    y : np.ndarray размера M x D
        тестовая выборка.

    Raises
    ------
    NotImplementedError
        DESCRIPTION.

    Returns
    -------
    Функция возвращает np.ndarray размера N x M,
    каждый элемент которого - косинусное расстояния между
    соответствующей парой векторов из массивов x и y.

    '''
    s = x @ y.T
    x2 = np.sqrt(np.sum(x**2, axis=1).reshape(-1, 1))
    y2 = np.sqrt(np.sum(y**2, axis=1))
    result = 1 - s / x2 / y2
    return result

def manhattan_distance(x, y, W=False):
    '''

    Parameters
    ----------
    x : np.ndarray размера N x D
        обучающая выборка.
    y : np.ndarray размера M x D
        тестовая выборка.

    Raises
    ------
    NotImplementedError
        DESCRIPTION.

    Returns
    -------
    Функция возвращает np.ndarray размера N x M,
    каждый элемент которого - расстояние манхэтэна между
    соответствующей парой векторов из массивов x и y.

    '''
    if type(W) == np.ndarray:
        result = np.sum(np.abs(x[:, None] - y) * W, axis=2)
    elif W == False:
        result = np.sum(np.abs(x[:, None] - y), axis=2) 
    return result
