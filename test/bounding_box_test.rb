require './test/test_helper'
require 'point'
require 'bounding_box'

describe BoundingBox do
  before do
    @p1 = Point.new(0.25, 0.25)
    @p2 = Point.new(0.75, 0.75)
    @p3 = Point.new(0.4, 0.4)
    @p4 = Point.new(0.6, 0.6)
    @p5 = Point.new(0.9, 0.9)
    @p6 = Point.new(0.1, 0.1)
    @r0 = BoundingBox.new(@p1, @p2)
    @r1 = BoundingBox.new(@p3, @p4)
    @r2 = BoundingBox.new(@p6, @p5)
    @r3 = BoundingBox.new(Point.new(0.2, 0.2), @p4)
    @r4 = BoundingBox.new(Point.new(0.2, 0.2), @p4)
    @r5 = BoundingBox.new(Point.new(0.3, 0.3), Point.new(0.8, 0.5))
    @r6 = BoundingBox.new(Point.new(0.3, 0.3), Point.new(0.5, 0.8))
    @r7 = BoundingBox.new(Point.new(0.3, 0.3), Point.new(0.5, 0.8))
    @r8  = BoundingBox.new(@p6, Point.new(0.2, 0.2))
    @r9  = BoundingBox.new(@p6, Point.new(0.2, 0.8))
    @r10  = BoundingBox.new(@p6, Point.new(0.8, 0.2))
  end

  describe "BoundingBox", "overlap" do
    it "inside" do
      @r0.overlap(@r1).must_equal true
      @r0.overlap(@r2).must_equal true
    end

    it "intersects" do
      @r0.overlap(@r3).must_equal true
      @r0.overlap(@r4).must_equal true
      @r0.overlap(@r5).must_equal true
      @r0.overlap(@r6).must_equal true
      @r0.overlap(@r7).must_equal true
    end

    it "outside" do
      @r0.overlap(@r8).must_equal false
      @r0.overlap(@r9).must_equal false
      @r0.overlap(@r10).must_equal false
    end
  end

  describe "BoundingBox", "from points" do
    it "same points" do
      bounds = BoundingBox.from_points([@p1, @p1])
      bounds.top_left.must_equal @p1
      bounds.bottom_right.must_equal @p1
    end

    it "larger" do
      bounds = BoundingBox.from_points([@p1, @p2])
      bounds.top_left.must_equal @p1
      bounds.bottom_right.must_equal @p2
    end
  end

  describe "BoundingBox", "total bounding box" do
    it "same box" do
      total = BoundingBox.minimum_bounding_rectangle([@r0, @r0])
      total.top_left.must_equal @r0.top_left
      total.bottom_right.must_equal @r0.bottom_right
    end

    it "smaller box" do
      total = BoundingBox.minimum_bounding_rectangle([@r0, @r1])
      total.top_left.must_equal @r0.top_left
      total.bottom_right.must_equal @r0.bottom_right
    end

    it "larger box" do
      total = BoundingBox.minimum_bounding_rectangle([@r0, @r2])
      total.top_left.must_equal @r2.top_left
      total.bottom_right.must_equal @r2.bottom_right
    end

    it "off to the left box" do
      total = BoundingBox.minimum_bounding_rectangle([@r0, @r8])
      total.top_left.must_equal @r8.top_left
      total.bottom_right.must_equal @r0.bottom_right
    end

    it "overlapping" do
      total = BoundingBox.minimum_bounding_rectangle([@r0, @r7])
      total.top_left.must_equal @r0.top_left
      total.bottom_right.x.must_equal @r0.bottom_right.x
      total.bottom_right.y.must_equal @r7.bottom_right.y
    end
  end
end