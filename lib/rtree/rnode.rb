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

    def self.build(chunks, shapes)
      leaves = Rtree::Rleaf.split_shapes(chunks, shapes)
      Rtree::Rnode.build_nodes(chunks, leaves).first
    end

    def filter_by_bounding_box(search_bounding_box)
      filtered_nodes = rnode_array.select { |node| node.bounding_box.overlap(search_bounding_box) }
      filtered_nodes.flat_map { |node| node.filter_by_bounding_box(search_bounding_box) }
    end

    def query(search_bounding_box)
      leaf = filter_by_bounding_box(search_bounding_box).first
      leaf.shape_array.select { |shape| shape.bounding_box.overlap(search_bounding_box) }
    end
  end
end
