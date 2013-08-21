module Rtree
  class BoundingBox < Struct.new(:top_left, :bottom_right)

    def self.from_points(points)
      x0 = points.min { |a,b| a.x <=> b.x }.x
      y0 = points.min { |a,b| a.y <=> b.y }.y
      x1 = points.max { |a,b| a.x <=> b.x }.x
      y1 = points.max { |a,b| a.y <=> b.y }.y
      BoundingBox.new(Point.new(x0, y0), Point.new(x1, y1))
    end

    def self.merged_bound_box(shapes)
      self.minimum_bounding_rectangle(shapes.map { |s| s.bounding_box })
    end

    def self.minimum_bounding_rectangle(bounding_boxes)
      x0 = bounding_boxes.min { |a,b| a.top_left.x <=> b.top_left.x }.top_left.x
      y0 = bounding_boxes.min { |a,b| a.top_left.y <=> b.top_left.y }.top_left.y
      x1 = bounding_boxes.max { |a,b| a.bottom_right.x <=> b.bottom_right.x }.bottom_right.x
      y1 = bounding_boxes.max { |a,b| a.bottom_right.y <=> b.bottom_right.y }.bottom_right.y
      BoundingBox.new(Point.new(x0, y0), Point.new(x1, y1))
    end

    def overlap(other_bounding_box)
      x0, y0 = self.top_left.x, self.top_left.y
      x1, y1 = self.bottom_right.x, self.bottom_right.y
      x2, y2 = other_bounding_box.top_left.x, other_bounding_box.top_left.y
      x3, y3 = other_bounding_box.bottom_right.x, other_bounding_box.bottom_right.y
      half_w0, half_h0 = (x1-x0)/2, (y1-y0)/2
      half_w1, half_h1 = (x3-x2)/2, (y3-y2)/2
      within_x = ((x1+x0)/2 - (x3+x2)/2).abs <= half_w0 + half_w1
      within_y = ((y1+y0)/2 - (y3+y2)/2).abs <= half_h0 + half_h1
      within_x && within_y
    end
  end
end