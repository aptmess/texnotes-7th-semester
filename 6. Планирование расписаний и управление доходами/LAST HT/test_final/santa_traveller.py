# -*- coding: utf-8 -*-
"""
Created on Sun Dec 20 18:59:43 2020

@author: shiro
"""
import numpy as np

class Wishes:
    
    def __init__(self, 
                 wish_id: int, 
                 wish_lat: float, 
                 wish_long: float, 
                 wish_w: float):
        '''
        Wishes:

        Parameters
        ----------
        wish_id : int
            Уникальный идентификатор города, 
            в котором находится подарок ребёнку.
        wish_lat : float
            latitude (широта) города.
        wish_long : float
            longitude (долгота) города.
        wish_w : float
            вес желаемого подарка (граммы).

        Returns
        -------
        None.

        '''
        self.wish_id = wish_id
        self.wish_lat = wish_lat
        self.wish_long = wish_long
        self.wish_w = wish_w
        
from math import radians, sin, cos, asin, sqrt, pi, atan, atan2, fabs
def great_circle(point1, point2, EARTH_MEAN_RADIUS=6371008.8):
    '''
        Calculating great-circle distance
        (see https://en.wikipedia.org/wiki/Great-circle_distance)
    '''
    lat1, lon1 = (radians(coord) for coord in point1)
    lat2, lon2 = (radians(coord) for coord in point2)

    dlon = fabs(lon1 - lon2)
    dlat = fabs(lat1 - lat2)

    numerator = sqrt(
        (cos(lat2) * sin(dlon))**2 +
        ((cos(lat1) * sin(lat2)) - (sin(lat1) * cos(lat2) * cos(dlon)))**2)

    denominator = (
        (sin(lat1) * sin(lat2)) +
        (cos(lat1) * cos(lat2) * cos(dlon)))

    c = atan2(numerator, denominator)
    return EARTH_MEAN_RADIUS * c / 1000

class Edges:
    def __init__(self, v1: Wishes, v2: Wishes):
        '''
        Edges:
            Данный класс содержит информацию о ребре между двумя городами
            с подарками и информацию о расстоянии между городами

        Parameters
        ----------
        v1 : Wishes
            экземпляр класса Wishes #1.
        v2 : Wishes
            экземпляр класса Wishes #2.
        self.e : (Wishes_1, Wishes_2)
            ребро, соединяющее два города
        self.dist : (float)
            расстояние между городами на сфере(в километрах)

        Returns
        -------
        None.

        '''
        self.e = (v1, v2) if v1.wish_id < v2.wish_id else (v2, v1)
        self.dist = great_circle((v1.wish_lat, v1.wish_long), 
                                 (v2.wish_lat, v2.wish_long))
        
    def __str__(self):
        '''
        Перегрузка оператора str()

        Returns
        -------
        str
            возвращается строка, где 
            первый элемент - wish_id начальной вершины,
            второй элемент - wish_id конечной вершины
            example: (1, 2)

        '''
        return str((self.e[0].wish_id, 
                    self.e[1].wish_id))
    
    def __contains__(self, wish: Wishes):
        '''
        Перегрузка оператора in

        Parameters
        ----------
        wish : Wishes
            экземпляр класса Wishes.

        Returns
        -------
        bool
            Возвращает:
                True - если вершина находится в данном экземпляре 
                                    класса Edges
                False - в противном случае

        '''
        return (self.e[0].wish_id == wish.wish_id) or (self.e[1].wish_id == wish.wish_id)
    
class SantaPulka:
    
    def __init__(self, max_weight: int=10000*1000):
        '''
        SantaPulka:
            класс, характеризующий информацию о Санях Санта-Клауса. 
            Формирует маршрут, по которому поедет Санта в очередной свой путь.

        Parameters
        ----------
        max_weight : int, optional
            максимальная вместимость саней (в грамах). The default is 10000*1000.
        self.visit : list
            список посещённых городов
        self.load : float
            текущая наполненность саней (в грамах). the default is 0.

        Returns
        -------
        None.

        '''
        self.visit = []
        self.load = 0
        self.max_weight = max_weight
        
    def add(self, vertex):
        '''
        Метод add доваляет вершину vertex в маршрут visit,
        если текущая наполненность саней + вес подарка в vertex.wish_w 
        не превосходит max.weight саней Санта Клауса.

        Parameters
        ----------
        vertex : Wishes
            экземпляр класса Wishes.

        Returns
        -------
        bool
            возвращает:
                True: если мы можем посетить данный город, 
                не переполнив вместимость саней Санта-Клауса. Вершина 
                vertex добавляется в маршрут, наполненность саней
                увеличивается на величину веса подарка в данной вершине
                                                (vertex.wish_w)
                False:
                    если:
                        - вершина уже есть в маршруте (на всякий случай)
                        - при добавлении вершины в маршрут превышается 
                        вместимость саней Санта-Клауса

        '''
        if vertex in self.visit:
            return False
        
        if self.load + vertex.wish_w <= self.max_weight:
            self.visit.append(vertex)
            self.load += vertex.wish_w
            return True
        return False

    def clear(self):
        self.visit.clear()
        
class Tour:
    
    def __init__(self):
        '''
        Tour: 
            данный класс содержит информацию о машруте, который задаётся
            списком рёбер (экземпляры класса Edges)
            Содержит в себе следующие методы:
                add(edg) : добавление очередного ребра в путь
                get_cost : возвращается длина машрута
                is_valid : является ли маршрут корректным
        
        self.edges : list
            содержит список рёбер маршрута. default is [].

        Returns
        -------
        None.

        '''
        self.edges = []
        
    def add(self, edg):
        '''
        Метод add добавляет очередное ребро в маршрут (если это возможно).

        Parameters
        ----------
        edg : Edges
            экземпляр класса Edges.

        Returns
        -------
        bool
            возвращает:
                True: если ребро edg не находится в текущем маршруте.
                    Ребро edg добавляется в маршрут.
                False: если ребро edg есть в маршруте.

        '''
        if edg in self.edges:
            return False
        else:
            self.edges.append(edg)
            return True

    def get_cost(self):
        '''
        Высчитывает длину текущего маршрута.

        Returns
        -------
        float
            длина текущего машрута из рёбер (км).

        '''
        return sum([e.dist for e in self.edges])

    def is_valid(self):
        if len(self.edges) == 0:
            return False
        a = []
        for edg in self.edges:
            c1, c2 = edg.e
            a.append(c1.wish_id)
            a.append(c2.wish_id)
        b = np.unique(a, return_counts = True)
        return len(b[1]) == len(np.where(b[1] == 2)[0])
    
def travel(s: SantaPulka, start: Wishes):
    '''
    Формирование путешествия Санта Клауса на его волшебных санях (Pulka).

    Parameters
    ----------
    s : SantaPulka
        экземпляр класса SantaPulka, наполненный городами, 
            которые он собирается посетить в очередном маршруте.
    start : Wishes
        экземпляр класса Wishes.

    Returns
    -------
    t : Tour
        экземпляр класса Tour, составленный из рёбер маршрута, с началом
        в вершине start, содержащий все ребра маршрута из намеченных городов
        Сантой, и заканчивающий так же в вершине start.

    '''
    a = s.visit
    t = Tour()
    e = Edges(start, a[0])
    t.add(e)
    for i in range(len(a) - 1):
        e = Edges(a[i], a[i + 1])
        t.add(e)
    e = Edges(a[-1], start)
    t.add(e)
    return t 