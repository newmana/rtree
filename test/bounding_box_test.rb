require './test/test_helper'
require 'point'
require 'bounding_box'

describe BoundingBox do
  before do
    @r0 = BoundingBox.new(Point.new(0.25, 0.25), Point.new(0.75, 0.75))
    @r1 = BoundingBox.new(Point.new(0.4, 0.4), Point.new(0.6, 0.6))
    @r2 = BoundingBox.new(Point.new(0.1, 0.1), Point.new(0.9, 0.9))
    @r3 = BoundingBox.new(Point.new(0.2, 0.2), Point.new(0.6, 0.6))
    @r4 = BoundingBox.new(Point.new(0.2, 0.2), Point.new(0.6, 0.6))
    @r5 = BoundingBox.new(Point.new(0.3, 0.3), Point.new(0.8, 0.5))
    @r6 = BoundingBox.new(Point.new(0.3, 0.3), Point.new(0.5, 0.8))
    @r7 = BoundingBox.new(Point.new(0.3, 0.3), Point.new(0.5, 0.8))
    @r8  = BoundingBox.new(Point.new(0.1, 0.1), Point.new(0.2, 0.2))
    @r9  = BoundingBox.new(Point.new(0.1, 0.1), Point.new(0.2, 0.8))
    @r10  = BoundingBox.new(Point.new(0.1, 0.1), Point.new(0.8, 0.2))
  end

  describe "BoundingBox" do
    it "overlaps" do
      @r0.overlap(@r1).must_be :==, true
      @r0.overlap(@r2).must_be :==, true
      @r0.overlap(@r3).must_be :==, true
      @r0.overlap(@r4).must_be :==, true
      @r0.overlap(@r5).must_be :==, true
      @r0.overlap(@r6).must_be :==, true
      @r0.overlap(@r7).must_be :==, true
    end

    it "doesn't overlap" do
      @r0.overlap(@r8).must_be :==, false
      @r0.overlap(@r9).must_be :==, false
      @r0.overlap(@r10).must_be :==, false
    end
  end
end