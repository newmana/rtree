require_relative 'test_helper'

describe Rtree::Rnode do
  before do
    @p1 = Rtree::Point.new(1.0, 1.0)
    @p2 = Rtree::Point.new(0.75, 0.75)
    @p3 = Rtree::Point.new(0.4, 0.4)
    @p4 = Rtree::Point.new(2.0, 2.0)
    @p5 = Rtree::Point.new(1.0, 3.0)
    @p6 = Rtree::Point.new(6.0, 6.0)
    @p7 = Rtree::Point.new(7.0, 7.0)
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
      head = Rtree::Rnode.build(3, [@p1, @p4, @p5, @polyline1])
      head.bounding_box.must_equal Rtree::BoundingBox.new(@p1, Rtree::Point.new(2.0, 3.0))
      head.rnode_array.length.must_equal 2
      head.rnode_array.first.bounding_box.must_equal Rtree::BoundingBox.new(@p1, Rtree::Point.new(1.5, 3.0))
      head.rnode_array.last.bounding_box.must_equal Rtree::BoundingBox.new(@p4, @p4)
    end
  end

  describe "Get overlap", "all" do
    it "search outside" do
      tree = Rtree::Rnode.build(3, [@p1, @p4, @p5, @polyline1, @p6, @p7])
      bb_search = Rtree::BoundingBox.from_points([Rtree::Point.new(9.0, 9.0), Rtree::Point.new(10.5, 10.5)])
      result = tree.filter_by_bounding_box(bb_search)
      result.must_be_empty
    end

    it "search over large, shallow tree" do
      tree = Rtree::Rnode.build(2, [@p1, @p4, @p5, @polyline1, @p6, @p7])
      tree.size.must_equal 2
      bb_search = Rtree::BoundingBox.from_points([Rtree::Point.new(0.5, 0.5), Rtree::Point.new(1.5, 1.5)])
      result = tree.filter_by_bounding_box(bb_search)
      result.size.must_equal 1
    end
  end
end