"""Funciones auxiliares de la Práctica 5B (divide y vencerás, sesión 2).

No es necesario leer ni modificar este fichero: basta con saber qué hace
cada función (ver su docstring).
"""
import random
import matplotlib.pyplot as plt


def probar_particion(particion, pruebas=500):
    """Comprueba que `particion(A, first, last)` es correcta: deja a la
    izquierda del pivote elementos <= pivote, a la derecha elementos >=
    pivote, devuelve la posición del pivote y no toca nada fuera de
    A[first..last]."""
    casos = [[7]*12, list(range(10)), list(range(10, 0, -1)), [3, 1, 2, 3, 1, 2, 3, 1]]
    for _ in range(pruebas):
        n = random.randint(4, 30)
        maximo = random.choice([2, 5, 100])
        casos.append([random.randint(0, maximo) for _ in range(n)])
    for v in casos:
        n = len(v)
        # particionamos A[2..n+1]; los dos extremos de cada lado no deben tocarse
        A = [10**9, 10**9] + v + [-1, -1]
        first, last = 2, n+1
        try:
            p = particion(A, first, last)
            ok = (A[:2] == [10**9]*2 and A[-2:] == [-1]*2 and
                  sorted(A[first:last+1]) == sorted(v) and first <= p <= last and
                  all(x <= A[p] for x in A[first:p]) and
                  all(x >= A[p] for x in A[p+1:last+1]))
        except IndexError:
            ok = False
        if not ok:
            print("FALLA con", v)
            print("  queda:", A[first:last+1])
            return False
    print(f"Partición correcta en {len(casos)} casos :)")
    return True


def probar_quicksort(quicksort, particion):
    """Comprueba que `quicksort(A, 0, len(A)-1, particion)` ordena A."""
    casos = [[], [5], [2, 1], [3, 1, 2], list(range(200)), list(range(200, 0, -1)), [7]*200]
    for _ in range(100):
        n = random.randint(0, 200)
        casos.append([random.randint(0, random.choice([3, 1000])) for _ in range(n)])
    for v in casos:
        A = v[:]
        quicksort(A, 0, len(A)-1, particion)
        if A != sorted(v):
            print("FALLA con", v)
            return False
    print(f"Quicksort correcto en {len(casos)} casos :)")
    return True


def generar_vector(tipo, n):
    """Devuelve un vector de talla n de tipo 'aleatorio', 'ordenado' o 'iguales'."""
    if tipo == 'aleatorio':
        return [random.randrange(10*n) for _ in range(n)]
    if tipo == 'ordenado':
        return list(range(n))
    if tipo == 'iguales':
        return [7]*n
    raise ValueError("tipo desconocido: " + tipo)


def grafica_coste(quicksort, variantes, tipo, tallas=range(100, 801, 100), repeticiones=5):
    """Dibuja el coste (nº de comparaciones aprox.) que devuelve
    `quicksort` con cada variante de partición para vectores de un tipo."""
    plt.figure(figsize=(9, 6))
    for nombre, particion in variantes.items():
        costes = []
        try:
            for n in tallas:
                reps = repeticiones if tipo == 'aleatorio' else 1
                total = 0
                for _ in range(reps):
                    A = generar_vector(tipo, n)
                    total += quicksort(A, 0, n-1, particion)
                costes.append(total / reps)
        except NotImplementedError:
            print(f"'{nombre}': no implementada, no se dibuja")
            continue
        plt.plot(list(tallas), costes, 'o-', label=nombre)
    plt.plot(list(tallas), [n*n/2 for n in tallas], 'k--', label='$n^2/2$ (referencia)')
    plt.title(f'Nº de comparaciones de quicksort, vector {tipo}')
    plt.xlabel('talla $n$')
    plt.ylabel('comparaciones')
    plt.legend(loc='upper left')
    plt.grid(alpha=0.3)
    plt.show()