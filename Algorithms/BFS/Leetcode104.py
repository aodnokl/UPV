# ==========================================
# PROBLEM: Maximum Depth of Binary Tree (LeetCode 104)
# ==========================================
# Description:
# Given the root of a binary tree, find its maximum depth (number of levels).
#
# ASCII VISUALIZATION:
#       3         <-- Level 1
#      / \
#     9  20       <-- Level 2
#       /  \
#      15   7     <-- Level 3
#
# Output: 3 (Levels count)

from collections import deque
from typing import Optional

class TreeNode:
    def __init__(self, val: int = 0, left = None, right = None):
        self.val = val
        self.left = left 
        self.right = right


class Solution:
    def maxDepth(self, root: Optional[TreeNode]) -> int:

        # Base case if root is None or does not exist
        if not root:
            return 0

        depth = 0
        queue = deque([root])

        while queue:

            # All nodes for the current level
            for _ in range(len(queue)):
                node = queue.popleft()

                # Add children to queue for the next level
                if node.left:
                    queue.append(node.left)
                if node.right:
                    queue.append(node.right)

            # After finishing a level increment depth
            depth += 1
        return depth

