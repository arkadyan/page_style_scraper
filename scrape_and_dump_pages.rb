require 'page'


page = Page.new('http://www.inmanoasis.com/')
puts "Page: http://www.inmanoasis.com/"
puts "================================"
page.properties.keys.each do |key|
	puts key.to_s + " => " + page.properties[key].to_s
end
puts
