import random

def partition(A, first, last):
    i, pivot = first-1, A[last]
    for j in range(first, last+1):
        if A[j] <= pivot:
            i += 1
            A[i], A[j] = A[j], A[i]
    return i

def quicksort_recurs(A, first, last):
    if first < last:
        p = partition(A, first, last)
        quicksort_recurs(A, first, p-1)
        quicksort_recurs(A, p+1, last)

def quicksort(A):
    quicksort_recurs(A, 0, len(A)-1)

if __name__ == '__main__':
    """
    Si se ejecuta este fichero como programa principal realiza una
    serie de comprobaciones comparando el resultado de quicksort con
    el de el método sort de Python.

    Atención: estas comprobaciones NO son en modo alguno una prueba de
    que el algoritmo sea correcto (si fallaran sí mostrarían que es
    incorrecto, pero si no fallan no "demuestran" nada).
    """
    for i in range(100,2010,100):
        print(f"Testeando talla {i:4} ",end="")
        for veces in range(10):
            v = [random.randint(1,1000000) for j in range(10*i)]
            w = v.copy() # similar a v[:]
            quicksort(v) # version in-place, por eso no es v = ...
            w.sort()
            assert(v == w)
        print("(ok)")