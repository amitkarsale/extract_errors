#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'pry'

class ExtractData

	def initialize
		@task_cases = FileAttachment.select("casenumber").where("name like '%task-export%'")
		extract_case_attachment
	end

	def extract_case_attachment
		@task_cases.each do |kase|
			kase_number = "0" + kase.casenumber
			case_split = kase_number.scan(/.{3}/)
			if case_split[1].to_i  <= 600
				system("mkdir -p ~/tmp/task-export; 
					cp ~/cases/#{case_split[0]}/#{case_split[1]}/#{case_split[2]}/attachments/task-export* ~/tmp/task-export;
					for f in ~/tmp/task-export/*; do tar xf $f; done; ")
			else
				case_split1 = case_split[1].scan(/.{1}/); case_split2 = case_split[2].scan(/.{1}/)
				secondary_split = case_split1 + case_split2
				path = "/"
				secondary_split.each do |i|
					path += "#{i}/"
				end
				system("mkdir -p /tmp/task-export; 
					cp ~/cases/#{case_split[0]}/#{path}/attachments/task-export* ~/tmp/task-export;
					 ")
			end

			Dir.chdir("/home/akarsale/tmp/task-export")
			pwd = Dir.pwd
			files = Dir.glob "task-export*"
			files.each do |file|
				path  = pwd + "/" + file
				system("for f in #{path}; do tar xf $f; done;")
				dir_path = Dir.glob "tmp/*"
				extract_path = pwd +"/"+ dir_path[0]
				ParseHtml.new(extract_path, kase_number)
				system("rm -rf #{extract_path}; rm -rf #{file}")
			end
		end
	end

end

