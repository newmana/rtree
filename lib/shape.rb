class Shape < Struct.new(:point_array, :bounding_box)
  def self.sort_by_bounding_box(shapes)
    shapes.sort_by { |s| s.bounding_box.top_left }
  end

  def self.merged_bound_box(shapes)
    BoundingBox.minimum_bounding_rectangle(shapes.map { |s| s.bounding_box })
  end
end