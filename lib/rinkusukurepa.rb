require "rinkusukurepa/version"
require "rinkusukurepa/configuration"
require "rinkusukurepa/scraper"

module Rinkusukurepa
  class << self
    def new(url)
      scraper.new(url)
    end

    def scraper
      Rinkusukurepa::Scraper
    end

    def parse_url!(url)
      Rinkusukurepa::Scraper.parse_url!(url)
    end
  end
end
