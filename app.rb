require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration

require './models/error'
require './models/file_attachment'

require './lib/parse_html'
require './lib/extract_data'

get '/' do
	if params[:filter] && params[:filter].downcase == "uniq"
		@errors = Error.select("message").group(:message).order('count_message DESC').count
		erb :error
	else
		@errors = Error.all
    	erb :index
	end
end

get '/feed_data' do
    ParseHtml.new
    erb :feed_data
end

get '/extract_data' do
    ExtractData.new
end