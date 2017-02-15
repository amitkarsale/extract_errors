#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'pry'

class ExtractData

	def initialize
		binding.pry
		@task_cases = FileAttachment.select("casenumber").where("name like '%task-export%'")
		extract_case_attachment
	end

	def extract_case_attachment
		@task_cases.each do |kase|
			kase_number = "0" + kase.casenumber
			case_split = kase_number.scan(/.{3}/)
			if case_split[1].to_i  <= 600
				system("cp /home/akarsale/cases/#{case_split[0]}/#{case_split[1]}/#{case_split[2]}/attachments/task-export* /tmp")
			else
				case_split1 = case_split[1].scan(/.{1}/); case_split2 = case_split[2].scan(/.{1}/)
				secondary_split = case_split1 + case_split2
				path = "/"
				secondary_split.each do |i|
					path += "#{i}/"
				end
				system("cp /home/akarsale/cases/#{case_split[0]}/#{path}/attachments/task-export* /tmp")
			end
		end
	end

end

