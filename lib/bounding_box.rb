class BoundingBox < Struct.new(:top_left, :bottom_right)
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