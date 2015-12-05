require 'spec_helper'
require 'pry'

describe Rinkusukurepa::Configuration do
  context 'defaults' do
    subject { Rinkusukurepa }

    context '#image_min_width' do
      it { expect(subject.image_min_width).to eql(150) }
    end

    context '#image_min_height' do
      it { expect(subject.image_min_height).to eql(100) }
    end

    context '#max_image' do
      it { expect(subject.max_image).to eql(10) }
    end

    context '#page_types' do
      it { expect(subject.page_types).to eql(%w(website video sound)) }
    end
  end

  context 'custom values' do
    before do
      Rinkusukurepa.configure do |config|
        config.image_min_width = 200
        config.image_min_height = 200
        config.max_image = 20
        config.page_types = ['article', 'post']
      end
    end

    subject { Rinkusukurepa }

    context 'when #image_min_width is set to 200' do
      it { expect(subject.image_min_width).to eql(200) }
    end

    context 'when #image_min_height is set to 200' do
      it { expect(subject.image_min_height).to eql(200) }
    end

    context 'when #max_image is set to 20' do
      it { expect(subject.max_image).to eql(20) }
    end

    context 'when #page_types is set to [article, post]' do
      it { expect(subject.page_types).to eql(%w(article post)) }
    end
  end
end