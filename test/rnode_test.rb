require_relative 'test_helper'

describe Rtree::Rnode do
  before do
    @p1 = Rtree::Point.new(1.0, 1.0)
    @p2 = Rtree::Point.new(0.75, 0.75)
    @p3 = Rtree::Point.new(0.4, 0.4)
    @p4 = Rtree::Point.new(2.0, 2.0)
    @p5 = Rtree::Point.new(1.0, 3.0)
    @points1 = [Rtree::Point.new(1.0, 1.5), Rtree::Point.new(1.5, 1.5)]
    @polyline1 = Rtree::Polyline.new(Rtree::BoundingBox.from_points(@points1), @points1)
  end

  describe "Create from leaves", "leave" do
    it "3 leaves" do
      leaves = [Rtree::Rleaf.from_shapes([@p1]), Rtree::Rleaf.from_shapes([@p2]), Rtree::Rleaf.from_shapes([@p3])]
      node = Rtree::Rnode.from_leaves(leaves)
      node.bounding_box.must_equal Rtree::BoundingBox.new(@p3, @p1)
      node.rnode_array.must_equal leaves
    end
  end

  describe "Build tree", "leave" do
    it "3 leaves" do
      leaves = Rtree::Rleaf.split_shapes(3, [@p1, @p4, @p5, @polyline1])
      head = Rtree::Rnode.build_nodes(3, leaves).first
      head.bounding_box.must_equal Rtree::BoundingBox.new(@p1, Rtree::Point.new(2.0, 3.0))
      head.rnode_array.length.must_equal 2
      head.rnode_array.first.bounding_box.must_equal Rtree::BoundingBox.new(@p1, Rtree::Point.new(1.5, 3.0))
      head.rnode_array.last.bounding_box.must_equal Rtree::BoundingBox.new(@p4, @p4)
    end
  end
end