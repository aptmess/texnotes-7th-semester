import numpy as np

from knn.distances import euclidean_distance, cosine_distance, manhattan_distance


def get_best_ranks(ranks, top, axis=1, return_ranks=False):
    indices = np.take(np.argpartition(ranks, range(-top, 0), axis=axis),
                      range(-1, -top-1, -1), axis=axis)
    result = (indices, )
    if return_ranks:
        ranks = np.take_along_axis(ranks, indices, axis=axis)
        result = (ranks, ) + result
    return result if len(result) > 1 else result[0]


class NearestNeighborsFinder:
    def __init__(self, n_neighbors, metric="euclidean", W=False):
        '''

        Parameters
        ----------
        n_neighbors : int
            число K ближайших соседей в алгоритме ближайших соседей.
        metric : str, optional
            название метрики, по которой считается расстояние между объектами.
            Может принимать следующие значения:
                - 'euclidean' - евклидова метрика
                - 'cosine' - косинусная метрика
                - 'manhattan' - расстояние manhattan
                - 'manhattan_weighted' - взвешенное расстояние manhattan
            metric = "euclidean" является значение по умолчанию.

        Raises
        ------
        ValueError
            Metric is not supported.

        Returns
        -------
        None.

        '''
        self.n_neighbors = n_neighbors
        if metric == "euclidean":
            self._metric_func = euclidean_distance
            self.W = False
        elif metric == "cosine":
            self._metric_func = cosine_distance
            self.W = False
        elif metric == "manhattan":
            self._metric_func = manhattan_distance
            self.W = W
        else:
            raise ValueError("Metric is not supported", metric)
        self.metric = metric
        

    def fit(self, X, y=None):
        '''
        Метод производит обучение модели
        (алгоритм просто запоминает всю обучающую выборку)
        Parameters
        ----------
        X : np.ndarray размера N x D
            обучающая выборка размера N,
            где N - количество объектов в выборке,
                D - размер признакового пространства
        y : None
            ничего не означающий аргумент,
            нужен для поддержания единого интерфейса sklearn.
            y = None является значением по умолчанию.

        Returns
        -------
        TYPE
            DESCRIPTION.

        '''
        self._X = X
        return self

    def kneighbors(self, X, return_distance=False):
        '''
        Метод производит поиск ближайших соседей.

        Parameters
        ----------
        X : np.ndarray размера M x D
            тестовая выборка размера M.
        return_distance : bool, optional
            булев флаг, нужно ли вернуть расстояния для объектов.
            return_distance = False является значением по умолчанию.

        Raises
        ------
        NotImplementedError
            DESCRIPTION.

        Returns
        -------
        В случае return_distance = True
        возвращает кортеж (distances, indices)
        из двух np.ndarray размера M x K, где:
        - distances[i, j] - расстояние от i-го объекта, до его
        j-го ближайшего соседа
        - indices[i, j] - индекс ближайшего соседа из обучающей выборки
        до объекта с индексом i
        В случае return_distance = False,
        возвращает только второй из указанных массивов (indices[i, j])
        '''
        if type(self.W) == np.ndarray:
            metric_distance = self._metric_func(X, self._X, self.W)  # (X_test, X_train)
        elif self.W == False:
            metric_distance = self._metric_func(X, self._X)  # (X_test, X_train)
            
        distances, indices = get_best_ranks(-metric_distance,
                                            top=self.n_neighbors, axis=1,
                                            return_ranks=True)
        if return_distance is False:
            return indices
        else:
            return (np.abs(distances), indices)
