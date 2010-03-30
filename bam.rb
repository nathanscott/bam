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
  
  def new_key( length )
    1.upto(length).to_a.map { rand(16).to_s(16) }.join
  end
end

post '/save' do
  @key = new_key(7) until !@key.blank? && !File.exists?(File.join('data', @key))
  File.open(File.join('data', @key), 'w') {|f| f.write(params[:type]+"\n"+params[:message]) }
  layout false
  @key
end

get %r{([a-zA-Z0-9]*)$} do |key|
  filename = File.join('data', key.downcase)
  if key.blank? || !File.exists?(filename)
    halt 404
  else
    @type, @message = File.read(filename).strip.split("\n")
    puts "rendering #{key} (#{@type}, '#{@message}')"
    haml :index
  end
end

not_found do
  haml ":textile
  h1. That big arse message \ncouldn't be found"
end
