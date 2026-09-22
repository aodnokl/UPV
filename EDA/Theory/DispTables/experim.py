import hashlib

n = 4
a = [[] for _ in range(n)]
b = [[] for _ in range(n)]

def add_elem_to_A(elem:int):
    hash_elem_index = int(hashlib.md5(str(elem).encode()).hexdigest(), 16) % n
    a[hash_elem_index].append(elem)

def add_elem_to_B(elem: int):
    hash_elem_index = hash(elem) % n
    b[hash_elem_index].append(elem)


def print_add_elems_ab():  
    add_elem_to_A(3)
    add_elem_to_A(48)
    add_elem_to_B(3)
    add_elem_to_B(48)
    print(a)
    print(b)

print_add_elems_ab()


from typing import List
class HashTable:
    def __init__(self, initial_size: int) -> None:
        self.n: int = 0
        self._table: List[list] = [[] for _ in range(initial_size)]

    def __len__(self) -> int:
        return self.n

    def _hash_function(self, value):
        return hash(value) % len(self._table)

    def __getitem__(self, key):
        return self._table[key]

    def find(self, value: int) -> int:
        index = self._hash_function(value)
        return self._table[index]


    def insert(self, value: int) -> None:
        index = self._hash_function(value)

        if value not in self._table[index]:
            self._table[index].append(value)
            self.n += 1


