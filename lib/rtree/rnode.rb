module Rtree
  class Rnode < Struct.new(:bounding_box, :rnode_array)
    def self.from_leaves(leaves)
      bounding_boxes = leaves.map { |l| l.bounding_box }
      Rnode.new(BoundingBox.minimum_bounding_rectangle(bounding_boxes), leaves)
    end

    def self.build_nodes(chunks, leaves)
      return leaves if leaves.length == 1
      inner_nodes = leaves.each_slice(chunks)
      nodes = inner_nodes.map do |nodes|
        Rnode.from_leaves(nodes)
      end
      Rnode.build_nodes(chunks, nodes)
    end
  end
end
