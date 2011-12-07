require 'rubygems'
require 'sinatra'
require 'json'
require 'haml'

params = {}

get '/led' do
  haml :led
end

post '/led/start' do
  params.merge! :led => true
  redirect '/led'
end

post '/led/stop' do
  params.merge! :led => false
  redirect '/led'
end

get '/query.json' do
  content_type :json
  params.to_json
end

__END__
@@ led
%html
  %head
    %title Control LED
  %body
    %form(action='/led/start' method='POST')
      %input(type='submit' value='Turn on')
    %form(action='/led/stop' method='POST')
      %input(type='submit' value='Turn off')