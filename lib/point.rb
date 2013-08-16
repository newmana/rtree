require 'bounding_box'

class Point < Struct.new(:x, :y)
  def bounding_box
    BoundingBox.new(Point.new(x, y), Point.new(x, y))
  end

  def <=>(target)
    x_comp = self.x <=> target.x
    x_comp == 0 ? self.y <=> target.y : x_comp
  end
end