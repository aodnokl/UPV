import random

# elije cualquiera de estos 3 choose_pivot:

def choose_pivot(A):
    return A[random.randrange(0,len(A))]

# def choose_pivot(A):
#     return A[0]

# def choose_pivot(A):
#     return median_of_3(A[0],A[(len(A)-1)//2],A[-1],)

def quicksort(A):
    if len(A) >= 2:
        pivot = choose_pivot(A) # DIVIDIR
        L, E, R = [], [], []
        for x in A:
            if x < pivot:
                L.append(x)
            elif x == pivot:
                E.append(x)
            else:
                R.append(x)
        L = quicksort(L)        # VENCER
        R = quicksort(R)
        A = L + E + R           # COMBINAR
    return A

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
            v = quicksort(v)
            w.sort()
            assert(v == w)
        print("(ok)")