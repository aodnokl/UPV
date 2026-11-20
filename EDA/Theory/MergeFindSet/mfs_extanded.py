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