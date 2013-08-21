module Rtree
  class Rleaf < Struct.new(:bounding_box, :shape_array)
    def self.from_shapes(shape_array)
      Rleaf.new(BoundingBox.merged_bound_box(shape_array.to_a), shape_array)
    end

    def self.split_shapes(chunks, shapes)
      splitted_shapes = Shape.sort_by_bounding_box(shapes).each_slice(chunks)
      splitted_shapes.map do |shape_array|
        Rleaf.from_shapes(shape_array)
      end
    end
  end
end
