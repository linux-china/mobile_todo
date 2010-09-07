require 'rubygems'
require 'sinatra'
require 'rio'
configure :production do
  # configure stuff for production
end

get '/' do
  "Good! you're running a Sinatra application on Heroku!"
end

get '/proxy/*' do
  rio(params[:splat][0]).contents
end

# app specific information. only for test
get '/env' do
  ENV.inspect
end

