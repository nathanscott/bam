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
      chars = ("A".."F").to_a + ("0".."9").to_a
      hashh = ""
      1.upto(length) { |i| hashh << chars[rand(chars.size-1)] }
      hashh
  end
end

post '/save' do
  # save via ajax and return the url string
  @hash = new_hash( 10 )
  # save params[:message] to file called @hash
  File.open('data/'+@hash, 'w') {|f| f.write(params[:message]) }
  layout false
  @hash
end

get '/help' do
  # redirect or redirect to another
end