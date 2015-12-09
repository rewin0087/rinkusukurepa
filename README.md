# Rinkusukurepa

A library for Scraping a webpage by it's url and return the web page title, description, site name, images, favicon and video (if there's a video). Inspired by facebook url sharer.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rinkusukurepa'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rinkusukurepa

## Usage
  web_page = Rinkusukurepa.parse_url!('https://github.com/rewin0087/rinkusukurepa')
  web_page.title # return the web page title
  web_page.description # return the web page description
  web_page.images # return all the web page images
  web_page.site_name # return site name
  web_page.video # return video if present
  web_page.page_type # return page type
  web_page.page_document # return raw nokigiri document object
  web_page.attributes # return a hash with icon, title, description, images, site_name, video and page_type

  Scrape and get specific attribute

  web_page = Rinkusukurepa.new('https://github.com/rewin0087/rinkusukurepa')
  web_page.parse_url # it will scrape and return the document of the url
  web_page.get_icon  # it will find the icon from the document and return the icon
  web_page.get_title # it will find the title from the document and return the title
  web_page.get_description # it will find the description from the document and return the description
  web_page.get_images # it will find the images from the document and return the images
  web_page.get_site_name # it will find the site name from the document and return the site name
  web_page.get_video # it will find the video from the document and return the video
  web_page.get_page_type # it will find the page type from the document and return the page type

  To customize some of the configurations
  create a file in the config/initializers/rinkusukurepa.rb
  and put:
  Rinkusukurepa.configure do |config|
    config.image_min_width = 200 # default 150
    config.image_min_height = 200 # default 100
    config.max_image = 20 # default 20
    config.page_types = ['article', 'post'] # default ['website', 'video', 'sound']
    config.image_extensions = /(.png|.jpg)/ # default /(.png|PNG|.jpg|JPG|.jpeg|JPEG|BMP|.bmp|.gif|GIF)/
  end

## Contributing

  1. Fork it
  2. Create your feature branch (git checkout -b my-new-feature)
  3. Commit your changes (git commit -am 'Add some feature')
  4. Push to the branch (git push origin my-new-feature)
  5. Create new Pull Request


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

