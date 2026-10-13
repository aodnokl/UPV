class BST:

    class _Node:
        def __init__(self, key, value, left=None, right=None):
            self._key = key
            self._value = value
            self._left = left
            self._right = right
            
    def __init__(self): # create empty binary tree
        self._root = None
        self._size = 0

    def __len__(self):
        return self._size

    # VERSION RECURSIVA DE GETITEM, SOLAMENTE SE HA VISTO LA ITERATIVA:
    def __aux_getitem__(self, node, key):
        if node is None:
            raise KeyError("Key Error: " + repr(key))
        elif key == node._key:
            return node._value
        elif key < node._key:
            return self.__aux_getitem__(node._left, key)
        else:
            return self.__aux_getitem__(node._right, key)

    def __getitem__(self, key):
        return self.__aux_getitem__(self._root, key)

    # VERSION ITERATIVA DE GETITEM, LA QUE HEMOS VISTO:
    def __getitem__(self, key):
        node = self._root
        while node is not None:
            if key == node._key:
                return node._value
            elif key < node._key:
                node = node._left
            else:
                node = node._right
        raise KeyError("Key Error: " + repr(key))

    def __contains__(self, key):
        node = self._root
        while node is not None:
            if key == node._key:
                return True
            elif key < node._key:
                node = node._left
            else:
                node = node._right
        return False

    def __setitem__(self, key, value):
        prev, node = None, self._root
        while node is not None:
            prev = node
            if key == node._key:
                node._value = value
                return
            elif key < node._key:
                node = node._left
            else:
                node = node._right
        newchild = BST._Node(key, value)
        self._size += 1
        if prev is None:
            self._root = newchild
        elif key < prev._key:
            prev._left = newchild
        else:
            prev._right = newchild

    def setdefault(self, key, default):
        prev = None
        node = self._root
        while node is not None:
            prev = node
            if key == node._key:
                return node._value
            elif key < node._key:
                node = node._left
            else:
                node = node._right
        newchild = BST._Node(key, default)
        self._size += 1
        if prev is None:
            self._root = newchild
        elif key < prev._key:
            prev._left = newchild
        else:
            prev._root = newchild

    def find_min(self):
        node = self._root
        if node is None:
            return None
        while node._left is not None:
            node = node._left
        return (node._key, node._value)

    def find_max(self):
        node = self._root
        if node is None:
            return None
        while node._right is not None:
            node = node._right
        return (node._key, node._value)
    
    def find_gt_iter(self, key): # sucesor iterativo
        def aux(nodo):
            """
            es como un inorder pero únicamente visita claves > key
            """
            if nodo is not None:
                if nodo._key > key:
                    yield from aux(nodo._left)
                    yield (nodo._key, nodo._value)
                yield from aux(nodo._right)
        yield from aux(self._root)

    def find_gt(self, key): # sucesor
        return next(self.find_gt_iter(key), None)
    
    def __delitem__ (self, key):
        prev, node = None, self._root
        while node is not None and node._key != key:
            prev = node
            if key <  node._key:
                node = node._left
            else:
                node = node._right
        if node is None: # key not found
            raise KeyError("Key Error: " + repr(key))
        # key has been found, we have to remove it
        self._size -= 1
        if node._left is None or node._right is None:
             # one child of a leaf
            if node._left is not None:
                replace = node._left
            else:
                replace = node._right
            if prev is None:
                self._root = replace
            elif prev._left == node:
                prev._left = replace
            else:
                prev._right = replace
        else: # two children
            # el mínimo de su subárbol derecho ocupa su lugar:
            parentmin, themin = node, node._right
            while themin._left is not None:
                parentmin, themin = themin, themin._left
            node._key, node._value = themin._key, themin._value
            # remove themin:
            if parentmin._left == themin:
                parentmin._left = themin._right
            else:
                parentmin._right = themin._right

    def _inorder_traversal(self, node):
        if node is not None:
            yield from self._inorder_traversal(node._left)
            yield node
            yield from self._inorder_traversal(node._right)
                
    def __iter__(self): # recorre claves, lo que se ejecuta si iteras self
        for node in self._inorder_traversal(self._root):
            yield node._key
            
    def items(self): # recorre pares (tuplas) clave, valor
        for node in self._inorder_traversal(self._root):
            yield (node._key, node._value)

    # mostrar árbol como diccionario python
    def __repr__(self):
        return "{" + ",".join(repr(k)+':'+repr(v) for k,v in self.items()) + "}"

    
    # mostrar árbol como árbol como nodos y Nones
    # ejemplo: '[15:15]([5:5]([3:3](None,None),[12:12]([10:10]([6:6](None,[7:7](None,None)),None),[13:13](None,None))),[16:16](None,[20:20]([18:18](None,None),[23:23](None,None))))'
    def __aux_repr_tree__(self, node):
        if node is None:
            return 'None'
        return ('['+repr(node._key)+":"+repr(node._value) + '](' +
                self.__aux_repr_tree__(node._left)    + ',' +
                self.__aux_repr_tree__(node._right)   + ')')
    
    # mostrar árbol como árbol mediante parentizado
    # ejemplo: '15(5(3(,),12(10(6(,7(,)),),13(,))),16(,20(18(,),23(,))))'
    def __aux_repr_tree__(self, node):
        if node is None:
            return ''
        return (repr(node._key) + '(' +
                self.__aux_repr_tree__(node._left)    + ',' +
                self.__aux_repr_tree__(node._right)   + ')')
        
    def __repr_tree__(self):
        return self.__aux_repr_tree__(self._root)

if __name__ == '__main__':
    bst = BST()
    for i in [15,5,16,3,12,20,10,13,18,23,6,7]:
        bst[i] = i
