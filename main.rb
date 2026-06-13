require 'bundler/setup'
require 'sinatra'
require 'csv'

get '/' do
    erb :index
end

get '/search' do
    
end