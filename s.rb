require 'sinatra'

set :bind, '0.0.0.0'
set :port, 4000

get '/' do
  'hi'
end

post '/' do
  request.body.rewind
  puts request.body.read
end
