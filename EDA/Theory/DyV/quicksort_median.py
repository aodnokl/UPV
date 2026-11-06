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

def quicksort_recurs(A, first, last):
    """
    Versión iterativa, solamente hace una de las 2 llamadas a
    quicksort_recurs, la otra se pasa a iterativa. Elije llamar de
    manera recursiva al lado más pequeño, lo cual garantiza que la
    profundidad de la pila de llamadas es O(log n)
    """
    while first < last:
        p = partition(A, first, last)
        if (p-1)-first > last - (p+1):
            quicksort_recurs(A, p+1, last)
            last = p-1
        else:
            quicksort_recurs(A, first, p-1)
            first = p+1

def partition_median_of_3(A, first, last):
    # asume first < last
    middle = (first+last)//2
    A[first],A[middle],A[last] = sorted([A[first],A[middle],A[last]])
    # intercambiamos penúltimo con el pivote:
    A[middle],A[last-1] = A[last-1],A[middle]
    return partition(A,first+1,last-1)

def insertionSort(A, first, last):
   # el bucle ppal va desde el 2o elemento:
   for index in range(first+1,last+1):
       # A[index] es el que hay que situar donde
       # le corresponda en la parte ya ordenada:
       key = A[index]
       # bucle secundario busca la posición donde situar key:
       pos = index
       while pos>first and A[pos-1]>key:
           A[pos]=A[pos-1]
           pos = pos-1
       A[pos]=key

def quicksort_recurs(A, first, last):
    if last - first < 3:
        insertionSort(A, first, last)
    else:
        p = partition_median_of_3(A, first, last)
        quicksort_recurs(A, first, p-1)
        quicksort_recurs(A, p+1, last)

# versión iterativa de quicksort_recurs para median_of_3        
# def quicksort_recurs(A, first, last):
#     while last - first > 3:
#         p = partition_median_of_3(A, first, last)
#         if (p-1)-first > last - (p+1):
#             quicksort_recurs(A, p+1, last)
#             last = p-1
#         else:
#             quicksort_recurs(A, first, p-1)
#             first = p+1
#     insertionSort(A, first, last)
    
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