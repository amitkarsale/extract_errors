#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'rubygems/package'
require 'zlib'
require 'pry'

class ParseHtml

	def initialize(path, case_no)
		# for f in ~/tmp/task-export/*; do tar xf $f; done
		@base_path = path
		index_page = Nokogiri::HTML(open(@base_path + "/index.html"))
		tablerows = index_page.css('tr')
		@case_no = case_no
		@files_to_parse = []
		@occured_at = []
		@error_msgs = []
		columns = ['message', 'occured_at', 'case_number']
		values = []
		parse_index(tablerows)
	end

	def parse_index(tablerows)
		tablerows.each do |tr|
			tabledatas = tr.children
			data_length = tabledatas.length
			if tabledatas[data_length - 1].children.text == "error"
				@files_to_parse << tabledatas[0].children[0].attributes["href"].value
				@occured_at << tabledatas[1].children[0].text
			end
		end
		extract_error_msg
	end

	def extract_error_msg
		@files_to_parse.each do |file|
			begin
				task = Nokogiri::HTML(open(@base_path +"/"+ file))
				@error_msgs << task.xpath('//ul[@class="plan-step"]/li/div[@class="action"]/pre').last.children.first.text.split(/\n{2}|\n\/opt/)[0]
			rescue
				next
			end
		end
			insert_messages
	end

	def insert_messages
		cases = ["#{@case_no}"] * @error_msgs.length
		values = @error_msgs.zip @occured_at, cases

		Error.import columns, values
	end
end

