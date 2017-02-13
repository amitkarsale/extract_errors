require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration

require './models/error'
require './lib/parse_html'

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
end