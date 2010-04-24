require 'rubygems'
require 'nokogiri'
require 'open-uri'


class	Page
	
	attr_accessor :properties
	
	
	def initialize(url)
		# Make sure we were passed a URL
		if !url
			raise "A URL is required to initialize a Page object"
		end
		
		# Get a Nokogiri::HTML:Document for the page we’re interested in...
		@doc = Nokogiri::HTML(open(url))
		
		# Set up page properties
		@properties = {
			:logo => nil,
			:primary_bg_color => nil,
			:secondary_bg_color => nil,
			:other_bg_colors => [],
			:primary_color => nil,
			:secondary_color => nil,
			:other_colors => [],
			:primary_font => nil,
			:heading_font => nil,
			:other_fonts => []
		}
		
		scrape_all_properties
	end
	
	
	private
	
	def scrape_all_properties
		scrape_logo
		# scrape_primary_bg_color
		
	end
	
	def scrape_logo
		# Find the first image with 'logo' in the filename
		@doc.css('img').each do |image|
			if !@properties[:logo] && image['src'].downcase.include?('logo')
				@properties[:logo] = image['src']
			end
		end
	end
	
end
