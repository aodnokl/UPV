class MFset:
    def __init__(self):
        self._p = {}

    def find(self, x):
        while x in self._p:
            x = self._p[x]
        return x
    
    def merge(self, x, y):
        rx = self.find(x)
        ry = self.find(y)
        if rx != ry:
            self._p[rx] = ry

    # Mira si los elementos estan relacionados
    def related(self, x, y):
        return self.find(x) == self.find(y)

    # Mirar que pasa con el peor de los casos
    def worst_case(self, N):
        mf = MFset()
        [mf.merge(0, x) for x in range(1, N)]
        return mf

    # Version mas rapida
    # def caso_peor(self, N):
    #     mf = MFset()
    #     for i in range(N):
    #        mf.merge(i, i+1) 


    def __repr__(self):
        h = {} # a cada padre una lista de sus hijos
        for x,px in self._p.items():
            h.setdefault(px,[]).append(x)
        # los representantes son padres que no son hijos de nadie:
        r = [x for x in h if x not in self._p]
        # resultado final:
        def aux(x): # función auxiliar recursiva
            resul = repr(x) # representación de x como cadena
            if x in h: # si tiene hijos los añadimos:
                resul += "(" + ",".join(aux(y) for y in h[x]) + ")"
            return resul
        return 'MFset('+" ".join(aux(x) for x in r)+')'





# Implementaion with the range compression

class MFset:
    def __init__(self):
        self._p = {}
        self._r = {}  # New dict for every key(parentes) how many nodes are connected to it

    def find(self, x):
        while x in self._p:
            x = self._p[x]
        return x
    
    def merge(self, x, y):
        rx = self.find(x)
        ry = self.find(y)
        if rx != ry:
            nx = self._r.get(rx, 1)
            ny = self._r.get(ry, 1)

            if nx < ny:
                rx, ry = ry, rx
                nx, ny = ny, nx
            self._p[ry] = rx
            self._r[rx] = nx + ny

            if ry in self._r:
                del self._r[ry]


    def __repr__(self):
        h = {} # a cada padre una lista de sus hijos
        for x,px in self._p.items():
            h.setdefault(px,[]).append(x)
        # los representantes son padres que no son hijos de nadie:
        r = [x for x in h if x not in self._p]
        # resultado final:
        def aux(x): # función auxiliar recursiva
            resul = repr(x) # representación de x como cadena
            if x in h: # si tiene hijos los añadimos:
                resul += "(" + ",".join(aux(y) for y in h[x]) + ")"
            return resul
        return 'MFset('+" ".join(aux(x) for x in r)+')'


# Implementation with Path Compression
class MFset:

    def __init__(self):
        self._p = {}

    def find(self, x):
        rx = x

        while rx in self._p:
            # Buscamos el representante
            rx = self._p[rx]

        # x no ha cambiado, rx tiene al representante de x
        while x != rx:
            # Volvemos a recorrer el camino
            tmp = self._p[x]
            # Hacemos que todos tengan como padre a rx
            self._p[x] = rx
            x = tmp

        return rx

    def merge(self, x, y):
        rx = self.find(x)
        ry = self.find(y)

        if rx != ry:
            self._p[rx] = ry



# Classical implementation of MergeFindSet using lists
class MFset:
    def __init__(self, n:int):
        self.v = [i for i in range(n)]


    def find(self, x):
        while self.v[x] != x:
            x = self.v[x]

        return x

    def merge(self, x, y):
        rx = self.find(x)
        ry = self.find(y)

        if rx != ry:
            self.v[rx] = ry


