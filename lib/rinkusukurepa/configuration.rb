module Rinkusukurepa
  module Configuration
    attr_accessor :image_min_width,
      :image_min_height,
      :max_image,
      :page_types,
      :image_extensions

    def configure
      yield self
    end

    def image_min_width
      @image_min_width || 150
    end

    def image_min_height
      @image_min_height || 100
    end

    def max_image
      @max_image || 10
    end

    def page_types
      @page_types || %w(website video sound)
    end

    def image_extensions
      @image_extensions || /(.png|PNG|.jpg|JPG|.jpeg|JPEG|BMP|.bmp|.gif|GIF)/
    end
  end
end