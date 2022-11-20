require 'sinatra'

$memory = []

get '/orders' do
  $memory.to_s
end
