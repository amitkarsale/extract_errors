require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration

require './models/error'
require './lib/parse_html'

get '/' do
	@errors = Error.all
    erb :index
end

get '/feed_data' do
    ParseHtml.new
end

post '/submit' do
	@model = Error.new(params[:error])
	if @model.save
		redirect '/errors'
	else
		"Sorry, there was an error!"
	end
end