require 'sinatra'

get '/hello' do
  '<h1>Hello world ! </h1>'
end

get '/bonjour' do
  '<h1>Bonjour, monde !</h1>'
end
