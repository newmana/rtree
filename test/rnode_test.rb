require './test/test_helper'
require 'point'
require 'polygon'
require 'polyline'
require 'rleaf'
require 'rnode'
require 'shape'
require 'bounding_box'

describe Rnode do
  before do
    @p1 = Point.new(1.0, 1.0)
    @p2 = Point.new(0.75, 0.75)
    @p3 = Point.new(0.4, 0.4)
    @p4 = Point.new(2.0, 2.0)
    @p5 = Point.new(1.0, 3.0)
    @points1 = [Point.new(1.0, 1.5), Point.new(1.5, 1.5)]
    @polyline1 = Polyline.new(BoundingBox.from_points(@points1), @points1)
  end

  describe "Create from leaves", "leave" do
    it "3 leaves" do
      leaves = [Rleaf.from_shapes([@p1]), Rleaf.from_shapes([@p2]), Rleaf.from_shapes([@p3])]
      node = Rnode.from_leaves(leaves)
      node.bounding_box.must_equal BoundingBox.new(@p3, @p1)
      node.rnode_array.must_equal leaves
    end
  end

  describe "Build tree", "leave" do
    it "3 leaves" do
      leaves = Rleaf.split_shapes(3, [@p1, @p4, @p5, @polyline1])
      head = Rnode.build_nodes(3, leaves).first
      head.bounding_box.must_equal BoundingBox.new(@p1, Point.new(2.0, 3.0))
      head.rnode_array.length.must_equal 2
      head.rnode_array.first.bounding_box.must_equal BoundingBox.new(@p1, Point.new(1.5, 3.0))
      head.rnode_array.last.bounding_box.must_equal BoundingBox.new(@p4, @p4)
    end
  end
end