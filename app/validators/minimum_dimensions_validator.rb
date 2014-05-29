# coding: utf-8
class MinimumDimensionsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # I'm not sure about this:
    dimensions = Paperclip::Geometry.from_file(value.queued_for_write[:original].path)
    # But this is what you need to know:
    width = options[:width]
    height = options[:height] 

    record.errors[attribute] << "deve ter largura maior ou igual a #{width}px" unless dimensions.width >= width
    record.errors[attribute] << "deve ter altura maior ou igual a #{height}px" unless dimensions.height >= height
  rescue
  end
end
