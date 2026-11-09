from collections import deque
from typing import Deque, List, Set, Tuple
import sys


# ==========================================
# PROBLEM: Shortest Path in a Maze (Grid BFS)
# ==========================================
# Description:
# You are given a grid of size N x M representing a maze.
# - '.' represents an open cell you can walk through.
# - '#' represents a wall you cannot walk through.
# Find the minimum number of steps required to reach the bottom-right corner (N-1, M-1)
# from the top-left corner (0, 0) moving in 4 directions (Up, Down, Left, Right).
# If it is impossible to reach, output -1.
#
# SAMPLE INPUT:
# 5 5
# . . . . .
# . # # # .
# . . . # .
# # # . . .
# . . . # .
#
# SAMPLE OUTPUT:
# 8


def bfs(grid, start_r, start_c, target_r, target_c) -> int:
    rows = len(grid)
    cols = len(grid[0])

    queue: Deque = deque([(start_r, start_c, 0)])
    visited: Set = set()
    visited.add((start_r, start_c))

    dr = [-1, 1, 0, 0]
    dc = [0, 0, -1, 1]

    while queue:
        r, c, dist = queue.popleft()
        if r == target_r and c == target_c:
            return dist

        for i in range(4):
            new_r = r + dr[i]
            new_c = c + dc[i]

            if 0 <= new_r < rows and 0 <= new_c < cols:
                if grid[new_r][new_c] != '#' and (new_r, new_c) not in visited:
                    visited.add((new_r, new_c))
                    queue.append((new_r, new_c, dist + 1))

    return -1


input_data: List[str] = sys.stdin.read().split()
if input_data:
    n: int = int(input_data[0])
    m: int = int(input_data[1])

    grid: List[List[str]] = []
    idx = 2
    for _ in range(n):
        grid.append(input_data[idx : idx + m])
        idx += m

    print(bfs(grid, 0, 0, n - 1, m - 1))
    