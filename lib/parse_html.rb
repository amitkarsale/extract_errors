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
			@error_msgs.each_with_index do |error,i|
				@error = Error.new("message" => error, "occured_at" => @occured_at[i], "case_number" => @case_no)
				status = "Parsed Successfully"
				if @error.save
					next
				else
					status = "Parsing Failed"
				end
				status
			end
	end
end

