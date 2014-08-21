require 'hpricot'
require 'open-uri'
require 'json'

listing_pages = {
  :Sale   => 'http://streeteasy.com/for-sale/soho?sort_by=price_desc',
  :Rental => 'http://streeteasy.com/for-rent/soho/rental_type:frbo,brokernofee,brokerfee?sort_by=price_desc'
}

listing_pages.map do |listing_class, page|
  page_source = Hpricot(open(page))

  (page_source/'#results .listings .listing').collect do |listing|
    {
      :listing_class => listing_class,
      :address       => (listing/'.details_title h5 a').inner_html,
      :unit          => ((listing/'.details_title h5 a').inner_html.match(/^(.*#)(.*)/) || {})[2],
      :url           => '//streeteasy.com/' << (listing/'.details_title h5 a').first[:href].gsub(/\?.*/,'').to_s,
      :price         => (listing/'.price').inner_html.gsub(/[^0-9]/,'').to_i
    }
  end
end.flatten.sort do |a,b|
  b[:price] <=> a[:price]
end.first(20).to_json 


# 'listing_class' : 'Sale',
# 'address'       : '13 Crosby Street',
# 'unit'          : 'Floor 2',
# 'url'           : 'http               : //streeteasy.com/nyc/sale/1234567',
# 'price'         : 55000000

