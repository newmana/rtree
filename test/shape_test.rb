require './test/test_helper'
require 'point'
require 'polygon'
require 'polyline'
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
    @poly1 = Polygon.new(@points1, BoundingBox.from_points(@points1))
    @poly2 = Polygon.new(@points2, BoundingBox.from_points(@points2))
    @polyline1 = Polyline.new(@points1, BoundingBox.from_points(@points1))
    @polyline2 = Polyline.new(@points3, BoundingBox.from_points(@points3))
  end

  describe "Shape", "sort" do
    it "in order" do
      shapes = Shape.sort_by_bounding_box([@p1, @p2])
      shapes.must_equal [@p1, @p2]
    end

    it "swap" do
      shapes = Shape.sort_by_bounding_box([@p2, @p1])
      shapes.must_equal [@p1, @p2]
    end

    it "with polygon" do
      shapes = Shape.sort_by_bounding_box([@poly1, @p1])
      shapes.must_equal [@p1, @poly1]
    end

    it "swap polygon" do
      shapes = Shape.sort_by_bounding_box([@poly1, @poly2])
      shapes.must_equal [@poly2, @poly1]
    end

    it "with polyline" do
      shapes = Shape.sort_by_bounding_box([@polyline1, @p1])
      shapes.must_equal [@p1, @polyline1]
    end

    it "swap polyline" do
      shapes = Shape.sort_by_bounding_box([@p2, @polyline1])
      shapes.must_equal [@polyline1, @p2]
    end

    it "check many points" do
      shapes = Shape.sort_by_bounding_box([@p1, @p9, @p5, @polyline2])
      shapes.must_equal [@p1, @polyline2, @p9, @p5]
    end
  end

  describe "Bounding Box", "merge" do
    it "same shapes" do
      bounding_box = Shape.merged_bound_box([@p1, @p1])
      bounding_box.must_equal BoundingBox.new(@p1, @p1)
    end

    it "two points" do
      bounding_box = Shape.merged_bound_box([@p1, @p2])
      bounding_box.must_equal BoundingBox.new(@p1, @p2)
    end

    it "four shapes" do
      bounding_box = Shape.merged_bound_box([@poly1, @poly2, @polyline1, @polyline2])
      bounding_box.must_equal BoundingBox.new(@p6, @p5)
    end
  end
end