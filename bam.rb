require 'rubygems'
require 'sinatra'
require 'haml'
require 'coffee-script'

class Object
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
  
  def new_hash( length )
    1.upto(length).to_a.map { rand(16).to_s(16) }.join
  end
end

post '/save' do
  @hash = new_hash(7) until !@hash.blank? && !File.exists?(File.join('data', @hash))
  File.open(File.join('data', @hash), 'w') {|f| f.write(params[:type]+"\n"+params[:message]) }
  layout false
  @hash
end

get %r{(.*)$} do |unsafe_hash|
  hashh = unsafe_hash.downcase.gsub(/[^a-z0-9]/, '')
  if hashh.blank? || !File.exists?(File.join('data', hashh))
    halt 404
  else
    @type, @message = File.read(File.join('data', hashh)).strip.split("\n")
    haml :index
  end
end

not_found do
  haml ":textile
  h1. That big arse message \ncouldn't be found"
end