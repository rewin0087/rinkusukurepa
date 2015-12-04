require 'spec_helper'

describe Rinkusukurepa do
  let(:url) { 'https://github.com/rewin0087/rinkusukurepa' }

  it { expect(Rinkusukurepa::VERSION).not_to be nil }
  it { expect(Rinkusukurepa.new(url)).to be_a(Rinkusukurepa::Scraper) }
end
