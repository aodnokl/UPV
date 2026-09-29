class MinHeap:
    def __init__(self, initial=()):
        self._data = [v for v in initial]
        self._buildheap()

    def __len__(self):
        return len(self._data)

    def _heapify(self, pos):
        d = self._data # para simplificar la escritura
        size = len(d)  # para simplificar la escritura
        child_pos = 2*pos + 1 # posición del hijo izquierdo
        if child_pos < size: # existe hijo izquierdo
            # determinar el menor de los hijos:
            if child_pos+1 < size and d[child_pos+1] < d[child_pos]:
                # usaremos la posición del hijo derecho
                child_pos += 1
            # child_pos tiene la posición del menor de los hijos
            if d[pos] > d[child_pos]:
                # intercambiamos con el hijo
                d[pos],d[child_pos] = d[child_pos],d[pos]
                self._heapify(child_pos)

    def _buildheap(self):
        # se trata de ir aplicando _heapify a cada elemento desde el
        # último que tenga hijos hacia atrás hasta llegar a la raíz:
        if len(self._data) > 1: # no hace falta en otro caso
            ultimo_indice = len(self._data)-1
            padre_ultimo = (ultimo_indice-1)//2
            for pos in range(padre_ultimo, -1, -1): # hacia atras hasta 0
                self._heapify(pos)

    def min(self):
        if len(self._data) == 0:
            raise KeyError('MinHeap is empty.')
        return self._data[0]
    
    def remove_min(self):
        if len(self._data) == 0:
            raise KeyError('MinHeap is empty.')
        themin = self._data[0] # el que vamos a devolver
        last = self._data.pop() # quitamos el último
        if len(self._data) > 0: # si había > 1
            self._data[0] = last # sustituimos el 1º por el último
            self._heapify(0) # restaurar propiedad de heap
        return themin # devolvemos el mínimo

    def add(self, value):
        d = self._data # para simplificar la escritura:
        d.append(value) # añadimos el nuevo elemento
        pos = len(d)-1 # índice del nuevo elemento
        parent_pos = (pos-1)//2 # índice de su padre
        while (pos > 0 and d[pos] < d[parent_pos]):
            # los intercambiamos:
            d[pos], d[parent_pos] = d[parent_pos], d[pos]
            # y subimos
            pos = parent_pos
            parent_pos = (pos-1)//2 # índice de su padre
            

    def __repr__(self):
        return repr(self._data)
        