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