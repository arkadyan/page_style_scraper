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
		
		# Find all external css files
		external_css_files = extract_external_css_files
		
		# Create parsers for each external css file
		@external_css_parsers = []
		external_css_files.each do |external_css_file|
			parser = CssParser::Parser.new
			parser.load_uri!(full_url(external_css_file, url))
			@external_css_parsers << parser
		end
		
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
	
	def extract_external_css_files
		external_css_files = []
		@doc.css('link').each do |link|
			if link['type'] && link['type'].eql?("text/css")
				external_css_files << link['href']
			end
		end
		external_css_files
	end
	
	def full_url(path, original_url)
		full_url = path
		# If the path doesn't begin with 'http://' or 'https://',
		# append the base url from the original url
		if !full_url.match('^https?://')
			full_url = original_url.match('^.*/').to_s + full_url
		end
		full_url
	end
	
	def scrape_all_properties
		scrape_logo
		scrape_primary_bg_color
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
	
	def scrape_primary_bg_color
		# Search all external css files for the first background-color 
		# set on the body element
		bg_color = nil
		@external_css_parsers.each do |parser|
			body_selectors = parser.find_by_selector('body')
			if body_selectors.length > 0
				body_selectors.each do |selector|
					if !@properties[:primary_bg_color] && selector.match('background-color:\s*(.*);')
						@properties[:primary_bg_color] = selector.match('background-color:\s*(.*);')[1]
					end
				end
			end
		end
	end
	
	def scrape_primary_font_family
		# Find the font-family defined on p tags
		# puts "p selector :: " +  @in_page_css_parser.find_by_selector('p').to_s
	end
	
end
