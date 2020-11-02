from collections import defaultdict

import numpy as np

from sklearn.model_selection import KFold, BaseCrossValidator
from sklearn.metrics import accuracy_score

from knn.classification import KNNClassifier
from knn.classification import BatchedKNNClassifier


def knn_cross_val_score(X, y, k_list, scoring, cv=None, **kwargs):
    '''

    Parameters
    ----------
    X : TYPE
        обучающая выборка.
    y : TYPE
        ответы объектов на обучающей выборке.
    k_list : TYPE
        список из проверяемых значений для числа ближайших соседей.
    scoring : TYPE
        название метрики, по которой оценивается качество алгоритма.
        Обязательно должна быть реализована метрика 'accuracy'
        (доля правильно предсказанных объектов)
    cv : TYPE, optional
        класс, реализующий следующий интерфейс:
        sklearn.model_selection.BaseCrossValidator для кросс-валидации,
        например, класс sklearn.model_selection.KFold.
    **kwargs : TYPE
        параметры конструктора класса knn.classifier.KNNClassifier

    Raises
    ------
    ValueError
        DESCRIPTION.
    TypeError
        DESCRIPTION.
    not
        DESCRIPTION.

    Returns
    -------
    Функция должна возвращать словарь, где ключами являются
    значения K из k_list, а элементами np.ndarray размера len(cv) с
    качеством на каждом фолде.

    '''
    y = np.asarray(y)

    if scoring == "accuracy":
        scorer = accuracy_score
    else:
        raise ValueError("Unknown scoring metric", scoring)

    if cv is None:
        cv = KFold(n_splits=5)
    elif not isinstance(cv, BaseCrossValidator):
        raise TypeError("cv should be BaseCrossValidator instance", type(cv))
    res_dict = {k: np.empty(0) for k in k_list}
    k_list_sorted = np.unique(k_list)[::-1]
    batch_size = kwargs.pop('batch_size', None)
    knn = BatchedKNNClassifier(n_neighbors=k_list_sorted[0], **kwargs)
    knn.set_batch_size(batch_size)
    for train_index, test_index in cv.split(X):
        knn.fit(X[train_index], y[train_index])
        dist_max_k, ind_max_k = knn.kneighbors(X[test_index], return_distance=True)
        for k in k_list_sorted:
            y_pred = knn._predict_precomputed(indices=ind_max_k[:, :k],
                                              distances=dist_max_k[:, :k])
            res_dict[k] = np.append(res_dict[k], scorer(y[test_index], y_pred))
    return res_dict
