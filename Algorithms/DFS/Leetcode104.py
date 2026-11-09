# ==========================================
# PROBLEM: Maximum Depth of Binary Tree (LeetCode 104) - DFS Approach
# ==========================================
# Description:
# Given the root of a binary tree, find its maximum depth (number of levels) 
# using a Depth-First Search (DFS) recursive strategy.
#
# ASCII VISUALIZATION:
#       3         <-- Depth 1
#      / \
#     9  20       <-- Depth 2
#       /  \
#      15   7     <-- Depth 3
#
# Output: 3


from typing import Optional

class TreeNode:
  def __init__(self, val: int = 0, left: Optional["TreeNode"] = None, right: Optional["TreeNode"] = None) -> None:
    self.val: int = val
    self.left: Optional[TreeNode] = left
    self.right: Optional[TreeNode] = right


class Solution:
  def maxDepth(self, root: Optional[TreeNode]) -> int:
    # Helper function to traverse the tree recursively via DFS
    def dfs(node: Optional[TreeNode], depth: int) -> int:
      # Base case: if the node is None, return the accumulated depth
      if not node:
        return depth
      # Recursively find the max depth of the left and right subtrees
      return max(dfs(node.left, depth + 1), dfs(node.right, depth + 1))

    # Start recursion from the root at initial depth 0
    return dfs(root, 0)