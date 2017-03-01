require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration

require './models/error'
require './models/file_attachment'

require './lib/parse_html'
require './lib/extract_data'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
	if params[:filter] && params[:filter].downcase == "uniq"
		@errors = Error.select("message").group(:message).order('count_message DESC').limit(500).count
		erb :error
	elsif params[:message]
		msg = params[:message].gsub("/n","\n")
		@errors = Error.where(:message => params[:message])
		erb :message
	else
		@errors = Error.all.limit(500)
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