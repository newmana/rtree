class Shape < Struct.new(:point_array, :bounding_box)
  def self.sort_by_bounding_box(shapes)
    shapes.sort_by { |s| s.bounding_box.top_left }
  end
end