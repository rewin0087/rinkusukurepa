require 'spec_helper'
require 'pry'

describe Rinkusukurepa::Scraper do
  let(:url) { 'https://github.com/rewin0087' }
  let(:scraper) { Rinkusukurepa.new(url) }

  context 'singleton' do
    it { expect(Rinkusukurepa::Scraper).to respond_to(:parse_url!) }
  end

  context 'instance variables' do
    it { expect(scraper).to respond_to(:page_url) }
    it { expect(scraper).to respond_to(:icon) }
    it { expect(scraper).to respond_to(:title) }
    it { expect(scraper).to respond_to(:description) }
    it { expect(scraper).to respond_to(:images) }
    it { expect(scraper).to respond_to(:site_name) }
    it { expect(scraper).to respond_to(:video) }
    it { expect(scraper).to respond_to(:page_type) }
    it { expect(scraper).to respond_to(:page_document) }
  end

  context 'methods' do
    it { expect(scraper).to respond_to(:parse_url) }
    it { expect(scraper).to respond_to(:attributes) }
    it { expect(scraper).to respond_to(:get_icon) }
    it { expect(scraper).to respond_to(:get_title) }
    it { expect(scraper).to respond_to(:get_description) }
    it { expect(scraper).to respond_to(:get_images) }
    it { expect(scraper).to respond_to(:get_site_name) }
    it { expect(scraper).to respond_to(:get_video) }
    it { expect(scraper).to respond_to(:get_page_type) }
  end

  context 'regression' do
    subject { scraper.parse_url }

    context 'scraper' do
      it { expect(subject).not_to be_nil }
      it { expect(subject).to be_a(Rinkusukurepa::Scraper) }

      context '@page_document' do
        it { expect(subject.page_document).not_to be_nil }
        it { expect(subject.page_document).to be_a(Nokogiri::HTML::Document) }
      end
    end

    context '#get_icon' do
      it { expect(subject.get_icon).not_to be_nil }
      it { expect(subject.get_icon).to be_a(String) }
      it { expect(URI.parse(subject.get_icon)).to be_a(URI) }

      context '@icon' do
        before { subject.get_icon }
        it { expect(subject.icon).to be_a(String) }
        it { expect(URI.parse(subject.icon)).to be_a(URI) }
        it { expect(subject.icon).not_to be_nil }
      end
    end

    context '#get_title' do
      it { expect(subject.get_title).not_to be_nil }
      it { expect(subject.get_title).to be_a(String) }

      context '@title' do
        before { subject.get_title }
        it { expect(subject.title).to be_a(String) }
        it { expect(subject.title).not_to be_nil }
      end
    end

    context '#get_description' do
      it { expect(subject.get_description).not_to be_nil }
      it { expect(subject.get_description).to be_a(String) }

      context '@description' do
        before { subject.get_description }
        it { expect(subject.description).to be_a(String) }
        it { expect(subject.description).not_to be_nil }
      end
    end

    context '#get_images' do
      it { expect(subject.get_images).not_to be_nil }
      it { expect(subject.get_images).to be_a(Array) }
      it { expect(subject.get_images).not_to be_empty }

      context '@images' do
        before { subject.get_images }
        it { expect(subject.images).not_to be_nil }
        it { expect(subject.images).to be_a(Array) }
        it { expect(subject.images).not_to be_empty }
      end
    end

    context '#get_site_name' do
      it { expect(subject.get_site_name).not_to be_nil }
      it { expect(subject.get_site_name).to be_a(String) }

      context '@site_name' do
        before { subject.get_site_name }
        it { expect(subject.site_name).to be_a(String) }
        it { expect(subject.site_name).not_to be_nil }
      end
    end

    context '#get_video' do
      context 'url link without video' do
        it { expect(subject.get_video).to be_nil }

        context '@video' do
          before { subject.get_video }
          it { expect(subject.video).to be_nil }
        end
      end

      context 'url link with video' do
        let(:url_with_video) { 'https://www.youtube.com/watch?v=GY7Ps8fqGdc' }
        let(:scraper_with_video) { Rinkusukurepa.new(url_with_video).parse_url }

        it { expect(scraper_with_video.get_video).to be_a(String) }
        it { expect(scraper_with_video.get_video).not_to be_nil }
        it { expect(URI.parse(scraper_with_video.get_video)).to be_a(URI) }
      end
    end

    context '#get_page_type' do
      it { expect(subject.get_page_type).not_to be_nil }
      it { expect(subject.get_page_type).to be_a(String) }

      context '@page_type' do
        before { subject.get_page_type }
        it { expect(subject.page_type).to be_a(String) }
        it { expect(subject.page_type).not_to be_nil }
      end
    end
  end
end
