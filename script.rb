require_relative 'binary_search_trees'

def main
  tree = Tree.new(Array.new(15) { rand(1..100) })
  puts "Balanced: #{tree.balanced?}"
  puts "Pre-order: #{tree.preorder}"
  puts "Post-order: #{tree.postorder}"
  puts "In-order: #{tree.inorder} \n\n"

  Array.new(25) { rand(1..100) }.each { |number| tree.insert(number) }
  tree.rebalance! unless tree.balanced?
  puts "Balanced: #{tree.balanced?}"
  puts "Pre-order: #{tree.preorder}"
  puts "Post-order: #{tree.postorder}"
  puts "In-order: #{tree.inorder}"
end

main if $PROGRAM_NAME == __FILE__
