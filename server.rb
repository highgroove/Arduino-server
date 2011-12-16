require 'rubygems'
require 'sinatra'
require 'json'
require 'haml'

query = {}

get '/' do
  haml :root
end

post '/led/start' do
  query.merge! :led => true
  redirect '/led'
end

post '/led/stop' do
  query.merge! :led => false
  redirect '/led'
end

get '/query.json' do
  content_type :json
  query.to_json
end

post '/servo' do
  query.merge! :servo_angle => params[:angle]
end

__END__
@@ root
%html
  %head
    %title Control Arduino
  %body
    %form(action='/led/start' method='POST')
      %input(type='submit' value='Turn on')
    %form(action='/led/stop' method='POST')
      %input(type='submit' value='Turn off')
    %form(action='/servo' method='POST')
      %input(type='text' name='angle')
      %input(type='submit' value='Turn servo (-180-180)')