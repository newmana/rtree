class Shape < Struct.new(:bounding_box, :point_array)
  def self.sort_by_bounding_box(shapes)
    shapes.sort_by { |s| s.bounding_box.top_left }
  end
end