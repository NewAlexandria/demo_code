require 'hpricot'
require 'open-uri'
require 'json'

class EasyStreetScraper
  attr_accessor :listing_pages, :listings

  def initialize listing_pages=nil
    @listing_pages = listing_pages || {
      :Sale   => 'http://streeteasy.com/for-sale/soho?sort_by=price_desc',
      :Rental => 'http://streeteasy.com/for-rent/soho/rental_type:frbo,brokernofee,brokerfee?sort_by=price_desc'
    }
  end

  def listings
    @listings ||= @listing_pages.map do |listing_class, page|
      page_source = Hpricot(open(page))

      (page_source/'#results .listings .listing').collect do |listing|
        {
          :listing_class => listing_class,
          :address       => street_address(listing),
          :unit          => unit(listing),
          :url           => url(listing),
          :price         => price(listing)
        }
      end
    end.flatten.sort do |a,b|
      b[:price] <=> a[:price]
    end
  end

  def export
    File.open('easystreet_top20_by_price.json') do 
      @listings.first(20).to_json 
    end
  end

  private

  def street_address listing
    address[:street]
  end

  def unit listing
    address[:unit]
  end

  def url listing
    '//streeteasy.com/' << title.first[:href].gsub(/\?.*/,'').to_s 
  end

  def price listing
    (listing/'.price').inner_html.gsub(/[^0-9]/,'').to_i 
  end

  def title listing
    @title ||= (listing/'.details_title h5 a') 
  end

  def address listing
    @address ||= title.inner_html.match(/^(?<street>.*)\#(?<unit>.*)/) 
  end
end


  # 'listing_class' : 'Sale',
  # 'address'       : '13 Crosby Street',
  # 'unit'          : 'Floor 2',
  # 'url'           : 'http               : //streeteasy.com/nyc/sale/1234567',
  # 'price'         : 55000000

