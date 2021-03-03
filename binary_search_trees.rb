class Node
  attr_accessor :left, :right, :value

  def initialize(value = nil, left = nil, right = nil)
    @left = left
    @right = right
    @value = value
  end
end

class Tree
  attr_accessor :tree

  def initialize(arr)
    @tree = build_tree(arr.uniq.sort)
  end

  def insert(value, node = @tree)
    return if value == node.value

    # Since its the same for boths sides it feels like I should abstract the code somehow, but I can't think of anything
    if value < node.value
      if node.left.nil?
        node.left = Node.new(value)
      else
        insert(value, node.left)
      end
    end
    if value > node.value
      if node.right.nil?
        node.right = Node.new(value)
      else
        insert(value, node.right)
      end
    end
  end

  def delete(value, node = @tree)
    return if node.nil?
    return combine_children(node) if node.value == value

    if value > node.value
      node.right = delete(value, node.right)
      return node
    end
    if value < node.value
      node.left = delete(value, node.left)
      node
    end
  end

  def find(value, node = @tree)
    return if node.nil?
    return node if node.value == value

    return find(value, node.right) if value > node.value
    return find(value, node.left) if value < node.value
  end

  def level_order_iterative(node = @tree)
    queue = [node.left, node.right]
    visited = [node.value]
    while queue.any?
      child = queue.shift
      queue << child.left unless child.left.nil?
      queue << child.right unless child.right.nil?
      visited << child.value
    end
    visited
  end

  def level_order_recursive(node = @tree, queue = [], visited = [])
    return if node.nil? # Only needed to handle an empty start-tree

    visited << node.value
    queue << node.left unless node.left.nil?
    queue << node.right unless node.right.nil?

    level_order_recursive(queue.shift, queue, visited) if queue.any?
    visited
  end

  def preorder(node = @tree, visited = [])
    return if node.nil?

    visited << node.value
    preorder(node.left, visited)
    preorder(node.right, visited)
    visited
  end

  def inorder(node = @tree, visited = [])
    return if node.nil?

    inorder(node.left, visited)
    visited << node.value
    inorder(node.right, visited)
    visited
  end

  def postorder(node = @tree, visited = [])
    return if node.nil?

    postorder(node.left, visited)
    postorder(node.right, visited)
    visited << node.value
    visited
  end

  def height(node = @tree, height = -1)
    return height if node.nil?

    left = height(node.left, height + 1)
    right = height(node.right, height + 1)
    [left, right].max
  end

  def depth(node_value, root = @tree, height = 0)
    return -1 if root.nil?
    return height if root.value == node_value

    return depth(node_value, root.right, height + 1) if node_value > root.value
    return depth(node_value, root.left, height + 1) if node_value < root.value
  end

  def balanced?(node = @tree)
    (height(node.left) - height(node.right)).abs <= 1
  end

  def rebalance(node = @tree)
    build_tree(inorder(node))
  end

  def rebalance!
    @tree = build_tree(inorder(@tree))
  end

  def pretty_print(node = @tree, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def combine_children(tree)
    return nil if no_children?(tree)
    return tree.right || tree.left if only_one_child?(tree)

    if two_children?(tree)
      leftmost_value = leftmost_child_value(tree.right)
      root = Node.new(leftmost_value)
      root.left = tree.left
      root.right = delete(leftmost_value, tree.right)
      root
    end
  end

  def leftmost_child_value(subtree)
    if subtree.left.nil?
      subtree.value
    else
      leftmost_child_value(subtree.left)
    end
  end

  def no_children?(node)
    node.left.nil? && node.right.nil?
  end

  def only_one_child?(node)
    node.left.nil? ^ node.right.nil?
  end

  def two_children?(node)
    !node.left.nil? && !node.right.nil?
  end

  def build_tree(arr)
    # Assumes a sorted list with no duplicates
    return if arr.empty?

    left, right = split_arr_in_two(arr)
    root = right.shift

    Node.new(root, build_tree(left), build_tree(right))
  end

  def split_arr_in_two(arr)
    # If the number of elements is uneven the right side gets the extra one
    [arr[0...arr.size / 2], arr[arr.size / 2..-1]]
  end
end
