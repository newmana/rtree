require './test/test_helper'
require 'point'
require 'polygon'
require 'polyline'
require 'rleaf'
require 'shape'
require 'bounding_box'

describe Shape do
  before do
    @p1 = Point.new(0.25, 0.25)
    @p2 = Point.new(0.75, 0.75)
    @p3 = Point.new(0.4, 0.4)
    @p4 = Point.new(0.6, 0.6)
    @p5 = Point.new(0.9, 0.9)
    @p6 = Point.new(0.1, 0.1)
    @p7 = Point.new(0.25, 0.5)
    @p8 = Point.new(0.5, 0.5)
    @p9 = Point.new(0.25, 0.6)
    @points1 = [@p3, @p4, @p5]
    @points2 = [@p1, @p2, @p6]
    @points3 = [@p7, @p8]
    @poly1 = Polygon.new(BoundingBox.from_points(@points1), @points1)
    @poly2 = Polygon.new(BoundingBox.from_points(@points2), @points2)
    @polyline1 = Polyline.new(BoundingBox.from_points(@points1), @points1)
    @polyline2 = Polyline.new(BoundingBox.from_points(@points3), @points3)
  end

  describe "Split sorted shapes", "split" do
    it "split by 1" do
      shapes = Rleaf.split_shapes(1, [@p1, @p2, @p3])
      shapes.must_equal [Rleaf.from_shapes([@p1]), Rleaf.from_shapes([@p3]), Rleaf.from_shapes([@p2])]
    end

    it "split by 2" do
      shapes = Rleaf.split_shapes(2, [@p1, @p2, @p3])
      shapes.must_equal [Rleaf.from_shapes([@p1, @p3]), Rleaf.from_shapes([@p2])]
    end

    it "split by 3" do
      shapes = Rleaf.split_shapes(3, [@p1, @p9, @p5, @polyline2])
      shapes.must_equal [Rleaf.from_shapes([@p1, @polyline2, @p9]), Rleaf.from_shapes([@p5])]
    end
  end
end