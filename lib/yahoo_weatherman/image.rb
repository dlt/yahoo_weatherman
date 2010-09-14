# coding: utf-8
module Weatherman
  # == Image
  #
  # A hash-like object with the weather image attributes (width, height, url, etc..)
  #
  class Image
    def initialize(doc)
      @image_root = doc
    end

    def [](attr)
      @image_root.xpath(attr).first.content 
    end
  end
end
