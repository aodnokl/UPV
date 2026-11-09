# ==========================================
# PROBLEM: Shortest Path in Binary Matrix (LeetCode 1091)
# ==========================================
# Description:
# Given an n x n binary matrix `grid`, return the length of the shortest clear path in the matrix.
# If there is no clear path, return -1.
# A clear path starts from top-left (0, 0) and ends at bottom-right (n-1, n-1) such that:
# - All visited cells are 0.
# - Adjacent cells of the path are 8-directionally connected (sharing an edge or a corner).
# The length of a clear path is the number of visited cells.
#
# (Example 2):
# Input Grid:         Path Traversal:
#  0  0  0             [0]    [0]   0
#  1  1  0             1      1    [0]
#                      1      1    [0]  
#  1  1  0              
#                      
#
# SAMPLE INPUT:
# 3
# 0 0 0
# 1 1 0
# 1 1 0
#
# SAMPLE OUTPUT:
# 4

from collections import deque
from typing import Deque, List, Tuple

class Solution:
    def shortestPathBinaryMatrix(self, grid: list[list[int]]) -> int:
        n = len(grid)

        # If the start or end cell is blocked, no path is possible
        if grid[0][0] == 1 or grid[n - 1][n - 1] == 1:
            return -1

        # Row, col, path_length
        queue: Deque[Tuple[int, int, int]] = deque([(0, 0, 1)])

        # Mark as visited blocking the cell
        # Avoids using data structures for visited cells
        grid[0][0] = 1 

        # Possible directions
        directions: List[Tuple[int, int]] = [
            (-1, -1),
            (-1, 0),
            (-1, 1),
            (0, -1),
            (0, 1),
            (1, -1),
            (1, 0),
            (1, 1),
        ]

        while queue:
            r, c, dist = queue.popleft()

            # If we reach the target (bottom right)
            if r == n - 1 and c == n - 1:
                return dist
            
            # Explore neighbors
            for dr, dc in directions:
                new_r, new_c = r + dr, c + dc

                # Check the edges if the cell is valid for exploring
                if 0 <= new_r < n and 0 <= new_c < n and grid[new_r][new_c] == 0:
                    # Mark as visited
                    grid[new_r][new_c] = 1
                    queue.append((new_r, new_c, dist + 1))

        return -1



# Read input data and execute using standard input()
n: int = int(input())

grid: List[List[int]] = []
for _ in range(n):
  grid.append([int(x) for x in input().split()])

solver = Solution()
print(solver.shortestPathBinaryMatrix(grid))