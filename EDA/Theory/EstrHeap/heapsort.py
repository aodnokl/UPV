def heapify(v, pos, size):
    child_pos = 2 * pos + 1
    if child_pos < size:
        if (child_pos + 1 < size and v[child_pos+1] > v[child_pos]):
            child_pos += 1 

        if v[pos] < v[child_pos]:
            v[pos], v[child_pos] = v[child_pos], v[pos]
            heapify(v, child_pos, size)



def heap_sort(v):
    sz = len(v)
    for pos in range(sz // 2 - 1, -1 , -1):
        heapify(v, pos, sz)

    while sz > 1:
        v[sz - 1], v[0] = v[0], v[sz - 1]
        sz += -1
        heapify(v, 0, sz)

    return v

import random
vector = [random.randint(0, 10) for _ in range(10)]
print(heap_sort(vector))