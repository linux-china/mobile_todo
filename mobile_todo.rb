require 'rubygems'
require 'sinatra'
require 'httpclient'

configure :production do
  # configure stuff for production
end

get '/' do
  "Good! you're running a Sinatra application on Heroku!"
end

get '/proxy/*' do

  url = "#{params[:splat][0]}"
  url = "http://#{url}" if (!url.start_with?("http"))
   clnt = HTTPClient.new
  response = clnt.get(url)
  ccontent_type response.contenttype
  response.content
end

# app specific information. only for test
get '/env' do
  ENV.inspect
end

