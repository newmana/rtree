require_relative 'test_helper'

describe Rtree::Rleaf do
  before do
    @p1 = Rtree::Point.new(0.25, 0.25)
    @p2 = Rtree::Point.new(0.75, 0.75)
    @p3 = Rtree::Point.new(0.4, 0.4)
    @p4 = Rtree::Point.new(0.6, 0.6)
    @p5 = Rtree::Point.new(0.9, 0.9)
    @p6 = Rtree::Point.new(0.1, 0.1)
    @p7 = Rtree::Point.new(0.25, 0.5)
    @p8 = Rtree::Point.new(0.5, 0.5)
    @p9 = Rtree::Point.new(0.25, 0.6)
    @points1 = [@p3, @p4, @p5]
    @points2 = [@p1, @p2, @p6]
    @points3 = [@p7, @p8]
    @poly1 = Rtree::Polygon.new(Rtree::BoundingBox.from_points(@points1), @points1)
    @poly2 = Rtree::Polygon.new(Rtree::BoundingBox.from_points(@points2), @points2)
    @polyline1 = Rtree::Polyline.new(Rtree::BoundingBox.from_points(@points1), @points1)
    @polyline2 = Rtree::Polyline.new(Rtree::BoundingBox.from_points(@points3), @points3)
  end

  describe "Split sorted shapes", "split" do
    it "split by 1" do
      shapes = Rtree::Rleaf.split_shapes(1, [@p1, @p2, @p3])
      shapes.must_equal [Rtree::Rleaf.from_shapes([@p1]), Rtree::Rleaf.from_shapes([@p3]), Rtree::Rleaf.from_shapes([@p2])]
    end

    it "split by 2" do
      shapes = Rtree::Rleaf.split_shapes(2, [@p1, @p2, @p3])
      shapes.must_equal [Rtree::Rleaf.from_shapes([@p1, @p3]), Rtree::Rleaf.from_shapes([@p2])]
    end

    it "split by 3" do
      shapes = Rtree::Rleaf.split_shapes(3, [@p1, @p9, @p5, @polyline2])
      shapes.must_equal [Rtree::Rleaf.from_shapes([@p1, @polyline2, @p9]), Rtree::Rleaf.from_shapes([@p5])]
    end
  end
end