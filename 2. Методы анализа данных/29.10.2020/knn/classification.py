import numpy as np

from sklearn.neighbors import NearestNeighbors
from knn.nearest_neighbors import NearestNeighborsFinder
from knn.kernels import *


class KNNClassifier:
    EPS = 1e-5

    def __init__(self, n_neighbors, algorithm='my_own', metric='euclidean', weights='uniform', W=False, h=0.1, kernel='epanechnikov'):
        '''

        Parameters
        ----------
        n_neighbors : int
            число ближайших соседей в алгоритме ближайших соседей K.
        algorithm : str, optional
            алгоритм поиска ближайших соседей.
            Может принимать следующие значения:
                - 'my_own'
                : knn.nearest_neighbors.NearestNeighborsFinder();
                - 'brute'
                : sklearn.neighbors.NearestNeighbors(algorithm=’brute’);
                - 'kd_tree'
                : sklearn.neighbors.NearestNeighbors(algorithm=’kd_tree’);
                - 'ball_tree'
                : sklearn.neighbors.NearestNeighbors(algorithm=’ball_tree’);
            algorithm = 'my_own' является значением по умолчанию.
        metric : str, optional
            название метрики, по которой считается расстояние между объектами.
            metric = "euclidean" является значение по умолчанию.
        weights : np.ndarray, optional
            алгоритм взвешивания. Может принимать следующие значения:
                - 'uniform' - обычный метод ближайшего соседа,
                где вес каждого объекта равен 1;
                - 'distance' - взвешенный метод ближайшего соседа,
                где вес каждого объекта равен
                weight = 1 / (distance + e),
                где e = 10e-5 (см. KNNClassifier.EPS)
        Raises
        ------
        ValueError
            DESCRIPTION.

        Returns
        -------
        None.

        '''
        self.W = W
        if algorithm == 'my_own':
            finder = NearestNeighborsFinder(n_neighbors=n_neighbors, metric=metric, W=self.W)
        elif algorithm in ('brute', 'ball_tree', 'kd_tree',):
            finder = NearestNeighbors(n_neighbors=n_neighbors, algorithm=algorithm, metric=metric)
        else:
            raise ValueError("Algorithm is not supported", metric)

        if weights not in ('uniform', 'distance', 'kernel'):
            raise ValueError("Weighted algorithm is not supported", weights)
            
        self._finder = finder
        self._weights = weights
        self._h = h
        if kernel == "epanechnikov":
            self._kernel = epanechnikov_kernel
        elif kernel == "quartic":
            self._kernel = quartic_kernel
        elif kernel == "triangular":
            self._kernel = triangular_kernel
        elif kernel == "gaussian":
            self._kernel = gaussian_kernel
        elif kernel == "uniform":
            self._kernel = uniform_kernel
        else:
            raise ValueError("Kernel is not supported", kernel)
        
            

    def fit(self, X, y=None):
        '''
        Метод производит обучение алгоритма с учётом стратегии указанной в параметре algorithm

        Parameters
        ----------
        X : np.ndarray размера N x D
            обучающая выборка размера N.
        y : np.ndarray размера N, optional
            ответы объектов на обучающей выборке. The default is None.

        Returns
        -------
        TYPE
            DESCRIPTION.

        '''
        self._finder.fit(X)
        self._labels = np.asarray(y)
        return self

    def _predict_precomputed(self, indices, distances):
        '''
        Parameters
        ----------
        indices : np.ndarray M x K
            массив индексов.
        distances : np.ndarray M x K
            массив расстояний

        Raises
        ------
        NotImplementedError
            DESCRIPTION.

        Returns
        -------
        Вспомогательный метод, который должен вернуть одномерный
        np.ndarray размера M, состоящий из предсказаний алгоритма
        (меток классов) для объектов тестовой выборки по заданным массивам
        расстояний и индексов
        '''
        pred = []
        classes = np.unique(self._labels)
        if self._weights == 'uniform':
            for element in indices:
                # result = [np.sum((self._labels[element] == c)) for c in classes]
                # pred.append(np.argmax(result))
                values, count = np.unique(self._labels[element], return_counts=True)
                pred.append(values[np.argmax(count)])
        elif self._weights == 'distance':
            for d, element in zip(distances, indices):
                w = 1 / (d + KNNClassifier.EPS)
                result = [np.sum((self._labels[element] == c) * w) for c in classes]
                pred.append(np.argmax(result))
        elif self._weights == 'kernel':
            for d, element in zip(distances, indices):
                w = self._kernel(d / self._h)
                result = [np.sum((self._labels[element] == c) * w) for c in classes]
                pred.append(np.argmax(result))
        
        return np.array(pred)

    def kneighbors(self, X, return_distance=False):
        '''
        Логика метода аналогичена методу
        knn.nearest_neighbors.NearestNeighborsFinder.kneighbors.

        Parameters
        ----------
        X : np.ndarray M x D
            тестовая выборка размера M.
        return_distance : bool, optional
            булев флаг, нужно ли вернуть расстояния для объектов.
            The default is False.

        Returns
        -------
        TYPE
            DESCRIPTION.

        '''
        return self._finder.kneighbors(X, return_distance=return_distance)

    def predict(self, X):
        '''

        Parameters
        ----------
        X : np.ndarray M x D
            тестовая выбора размера M.

        Returns
        -------
        np.ndarray M
            метод должен вернуть одномерный np.ndarray размера M,
            состоящий из предсказаний алгоиртма (меток классов)
            для объектов тестовой выборки по заданным массивам
            расстояний и индексов

        '''
        distances, indices = self.kneighbors(X, return_distance=True)
        return self._predict_precomputed(indices, distances)


class BatchedMixin:
    def __init__(self):
        self.batch_size = None

    def kneighbors(self, X, return_distance=False):
        if not hasattr(self,  'batch_size'):
            self.batch_size = None
        batch_size = self.batch_size or X.shape[0]
        distances, indices = [], []

        for i_min in range(0, X.shape[0], batch_size):
            i_max = min(i_min + batch_size, X.shape[0])
            X_batch = X[i_min:i_max]
            indices_ = super().kneighbors(X_batch, return_distance=return_distance)
            if return_distance:
                distances_, indices_ = indices_
            else:
                distances_ = None

            indices.append(indices_)
            if distances_ is not None:
                distances.append(distances_)

        indices = np.vstack(indices)
        distances = np.vstack(distances) if distances else None

        result = (indices,)
        if return_distance:
            result = (distances,) + result
        return result if len(result) > 1 else result[0]

    def set_batch_size(self, batch_size):
        self.batch_size = batch_size


class BatchedKNNClassifier(BatchedMixin, KNNClassifier):
    def __init__(self, *args, **kwargs):
        KNNClassifier.__init__(self, *args, **kwargs)
        BatchedMixin.__init__(self)
