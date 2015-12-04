require "rinkusukurepa/version"

module Rinkusukurepa
  class << self
    TYPES = %w(website video sound)
    IMAGE_EXTENSIONS = /(.png|PNG|.jpg|JPG|.jpeg|JPEG|BMP|.bmp|.gif|GIF)/
    IMAGE_MIN_WIDTH = 150
    IMAGE_MIN_HEIGHT = 100
    MAX_IMAGE = 10

    attr_accessor :page_url,
      :icon,
      :title,
      :description,
      :images,
      :site_name,
      :video,
      :page_type,
      :page_document

    TYPES.each do |type|
      define_method "#{type.underscore}?" do
        self.type == type
      end

      define_singleton_method "#{type.underscore}" do
        type
      end
    end

    def self.parse_url!(url)
      thumbnailer = LinkScraper::Thumbnailer.new(url)
      thumbnailer.parse_url!
      thumbnailer
    end

    def initialize(url)
      @page_url = URI.parse(URI.encode(url))
      @images = []
    end

    def parse_url
      @page_document = Nokogiri::HTML(open(@page_url.to_s, :allow_redirections => :all))
    end

    def parse_url!
      parse_url
      get_icon
      get_title
      get_description
      get_images
      get_site_name
      get_video
      get_page_type
    end

    def attributes
      {
        icon: @icon,
        title: @title,
        description: @description,
        images: @images || [],
        site_name: @site_name,
        video: @video,
        page_type: @page_type
      }
    end

    def get_icon
      icon = @page_document.css('link[rel="icon"]')
      icon = @page_document.css('link[rel="shortcut icon"]') if icon.nil? || icon.empty?

      if !icon.nil? && !icon.empty?
        href = icon.first.attributes['href'].value
        uri = URI.parse(URI.encode(href))
        if uri.host.nil?
          @icon = "http://#{@page_url.host}#{uri.path}"
        else
          @icon = "http://#{uri.host}#{uri.path}"
        end
      end
    end

    def get_title
      # title
      title = @page_document.css('meta[property="og:title"]')
      if title.nil? || title.empty?
        @title = @page_document.css('title').text
      else
        # parse from meta
        @title = title.first.attributes['content'].value
      end
    end

    def get_description
      # Description
      description = @page_document.css('meta[property="og:description"]')
      if description.nil? || description.empty?
        description = @page_document.css('meta[name="description"]')
        if !description.nil? && !description.empty?
          @description = description.first.attributes['content'].value
        end
      else
        # parse from meta
        @description = description.first.attributes['content'].value
      end
    end

    def get_images
      # check if url is an image
      if File.extname(@page_url.to_s).match(IMAGE_EXTENSIONS)
        @images << @page_url.to_s
        return @images
      end

      # Image Preview
      preview = @page_document.css('meta[property="og:image"]')
      if preview.nil? || preview.empty?
        retrieve_all_images_from_document
      else
        # parse from meta
        @images = preview.map do |p|
          url = p.attributes['content'].value
          uri = URI.parse(URI.encode(url.strip! || url))
          if uri.to_s.match(IMAGE_EXTENSIONS) && uri.to_s.match(/http/)
            if uri.host.nil?
              "http://#{@page_url.host}#{uri.to_s}"
            else
              uri.to_s
            end
            if http_image = FastImage.size(uri.to_s)
              if http_image[0] > IMAGE_MIN_WIDTH && http_image[1] > IMAGE_MIN_HEIGHT
                uri.to_s
              end
            end
          end
        end.compact.uniq

        if @images.nil? || @images.empty?
          retrieve_all_images_from_document
        end
      end

      @images
    end

    def get_site_name
      # Site Name
      site_name = @page_document.css('meta[property="og:site_name"]')
      if site_name.nil? || site_name.empty?
        @site_name = @page_url.host
      else
        # parse from meta
        @site_name = site_name.first.attributes['content'].value
      end
    end

    def get_video
      # Video
      videos = @page_document.css('meta[property="og:video:secure_url"]')
      if !videos.nil? && !videos.empty?
        # parse from meta
        @video = videos.find { |v| v.attributes['content'].value.include?('embed') }.attributes['content'].value
      end
    end

    def get_page_type
      # Type
      type = @page_document.css('meta[property="og:type"]')
      if type.nil? || type.empty?
        @page_type = LinkScraper::Thumbnailer.website
      else
        # parse from meta
        page_type = type.first.attributes['content'].value
        @page_type = TYPES.include?(page_type) ? page_type : LinkScraper::Thumbnailer.website
      end
    end

    protected

    def retrieve_all_images_from_document
      # get all img
      preview = @page_document.css('img')
      if !preview.nil? && !preview.empty?
        previews = preview[0..MAX_IMAGE].map do |p|
          image = p.attributes['src']
          if image.present?
            url = nil
            if image.value.match(IMAGE_EXTENSIONS) && image.value.match(/http/)
               uri = URI.parse(URI.encode(image.value.strip! || image.value))
              if uri.host.nil?
                url = "http://#{@page_url.host}/#{uri.to_s}"
              else
                url = uri.to_s
              end
            end

            unless url.nil?
              # NOTE: fallback mini magick if fast image return's nil
              # fast image
              if http_image = FastImage.size(url)
                if http_image[0] > IMAGE_MIN_WIDTH && http_image[1] > IMAGE_MIN_HEIGHT
                  url
                end
              # mini magick
              else
                begin
                  http_image = MiniMagick::Image.open(url)
                  if http_image.present?
                    if http_image.width > IMAGE_MIN_WIDTH && http_image.height > IMAGE_MIN_HEIGHT
                      url
                    end
                  end
                rescue => e
                  nil
                end
              end
            end
          end
        end.compact.uniq
        # set scraped images
        @images = previews
      end
    end
  end
end
