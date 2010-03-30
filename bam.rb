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
  
  def new_hash( length )
      chars = ("a".."f").to_a + ("0".."9").to_a
      hashh = ""
      1.upto(length) { |i| hashh << chars[rand(chars.size-1)] }
      hashh
  end
end

post '/save' do
  @hash = new_hash( 7 )
  File.open('data/'+@hash, 'w') {|f| f.write(params[:type]+"\n"+params[:message]) }
  layout false
  @hash
end

get %r{(.*)$} do |unsafe_hash|
  hashh = unsafe_hash.gsub(/[^a-z0-9]/, '')
  if File.exists?('data/'+hashh)
    File.open('data/'+hashh, 'r') { |f| @type = f.gets; @message = f.gets; haml :index }
  else
    halt 404
  end
end