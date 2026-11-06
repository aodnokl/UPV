import random

def partition(A, first, last):
    i, pivot = first-1, A[last]
    for j in range(first, last+1):
        if A[j] <= pivot:
            i += 1
            A[i], A[j] = A[j], A[i]
    return i

def selection_recurs(A, first, last, k):
    if first==last:
        return A[first]
    pospivot = partition(A, first, last)
    if k == pospivot:
        return A[k]
    elif k < pospivot:
        return selection_recurs(A, first, pospivot-1, k)
    else:
        return selection_recurs(A, pospivot+1, last, k)

def selection_iter(A, k):
    first, last = 0, len(A)-1
    k -= 1 # para que k en la llamada sea un valor que empieza en 1
    while first<last:
        pospivot = partition(A, first, last)
        if k == pospivot:
            break
        elif k < pospivot:
            last = pospivot-1
        else:
            first = pospivot+1
    return A[k]
    
def selection(A, k):
    return selection_recurs(A, 0, len(A)-1, k-1)
    
if __name__ == '__main__':

    v = [31,23,90,0,77,52,49,87,60,15]
    k = 7
    print(selection(v,k))
    
    for i in range(100,2010,100):
        print(f"Testeando talla {i:4} ",end="")
        for veces in range(10):
            v = [random.randint(1,1000000) for j in range(i)]
            k = random.randint(int(0.3*i),int(0.7*i))
            w = v[:]
            w.sort()
            kesimo_via_sort = w[k-1]
            kesimo_recurs = selection(v,k)
            kesimo_iter = selection_iter(v,k)
            assert(kesimo_via_sort == kesimo_recurs and
                   kesimo_via_sort == kesimo_iter)
        print("(ok)")