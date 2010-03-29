require 'rubygems'
require 'sinatra'
require 'haml'
require 'coffee-script'

get %r{(.*)\.js$} do |basename|
  content_type :js
  CoffeeScript.compile File.read(File.join options.views, "#{basename}.coffee")
end

get '/' do
  haml :index
end

get '/preview' do
  haml params[:style].to_sym
end

get '/save' do
  # save via ajax and return the url string
end

get '/help' do
  # redirect or redirect to another
end