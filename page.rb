require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'css_parser'


class	Page
	
	attr_accessor :properties
	
	
	def initialize(url)
		# Get a Nokogiri::HTML:Document for the page we’re interested in...
		@doc = Nokogiri::HTML(open(url))
		
		# Get a CSS Parser for in-page css rules
		# @in_page_css_parser = CssParser::Parser.new
		# @in_page_css_parser.load_uri!(url)
		
		# Set up page properties
		@properties = {
			:logo => nil,
			:primary_bg_color => nil,
			:secondary_bg_color => nil,
			:other_bg_colors => [],
			:primary_color => nil,
			:secondary_color => nil,
			:other_colors => [],
			:primary_font_family => nil,
			:heading_font_family => nil,
			:other_font_families => []
		}
		
		scrape_all_properties
	end
	
	
	private
	
	def scrape_all_properties
		scrape_logo
		# scrape_primary_bg_color
		scrape_primary_font_family
	end
	
	def scrape_logo
		# Find the first image with 'logo' in the filename
		@doc.css('img').each do |image|
			lowercase_image_src = image['src'].downcase
			if !@properties[:logo] && lowercase_image_src.include?('logo')
				# Exclude the Constant Contact SafeSubscribe logo from the results
				if !lowercase_image_src.include?('safe_subscribe_logo')
					@properties[:logo] = image['src']
				end
			end
		end
	end
	
	def scrape_primary_font_family
		# Find the font-family defined on p tags
		# puts "p selector :: " +  @in_page_css_parser.find_by_selector('p').to_s
	end
	
end
