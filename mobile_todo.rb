require 'rubygems'
require 'sinatra'

configure :production do
  # configure stuff for production
end

get '/' do
  "Good! you're running a Sinatra application on Heroku!"
end

# app specific information. only for test
get '/env' do
  ENV.inspect
end

