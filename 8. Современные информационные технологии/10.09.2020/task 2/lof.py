import numpy as np

class LOF:

    def __init__(self, X, k):
        self.X = X
        self.k = k
        self.ids = np.arange(X.shape[0])
        self.distance_matrix = None
    
    def euclidian_distance(self, x, y):
        return np.sqrt(np.sum((x - y) ** 2))
    
    def compute_distances(self):
        n = self.X.shape[0]
        distance_matrix = np.zeros((n, n))
        for i in range(n):
            for j in range(i + 1, n):
                distance = self.euclidian_distance(self.X[i], self.X[j])
                distance_matrix[i, j] = distance
                distance_matrix[j, i] = distance
        self.distance_matrix = distance_matrix
        
    def k_distance(self, A):
        return np.sort(self.distance_matrix[A])[self.k]
    
    def reachable_distance(self, A, B):
        return np.max([self.k_distance(A), self.distance_matrix[A, B]])
        
    def lrd(self, A):
        nka = np.array(list(map(lambda x: list(self.X[A]).index(x), np.sort(self.X[A])[1 : self.k + 1])))
        return 1 / (np.sum(list(map(lambda x: self.reachable_distance(A, x), nka))) / nka.shape[0])
    
    def lof(self, A):
        nka = np.array(list(map(lambda x: list(self.X[A]).index(x), np.sort(self.X[A])[1 : self.k + 1])))
        return np.sum(list(map(lambda x: self.lrd(x), nka))) / (self.lrd(A) * nka.shape[0])

    def compute_destinies(self):
        self.compute_distances()
        result_destinies = dict()
        for i in range(self.X.shape[0]):
            lof_i = self.lof(i)
            result_destinies[self.ids[i]] = lof_i
        self.result_destinies = result_destinies
        return result_destinies