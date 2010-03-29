require 'rubygems'
require 'sinatra'
require 'haml'
require 'coffee-script'

class String
  def blank?
    nil? || empty?
  end
end

get %r{(.*)\.js$} do |basename|
  content_type :js
  CoffeeScript.compile File.read(File.join options.views, "#{basename}.coffee")
end

get '/' do
  haml :index
end

helpers do
  def message
    @style = (params['style'] || 'basic').downcase
    @message = params['message'].blank? ? 'Big Arse Message' : params['message']
  end
end

post '/save' do
  # save via ajax and return the url string
  haml :message
end

get '/help' do
  # redirect or redirect to another
end