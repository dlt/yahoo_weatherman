module Weatherman
  class Image
    def initialize(doc)
      @image_root = doc
    end

    def [](attr)
      @image_root.xpath(attr).first.content 
    end
  end
end
