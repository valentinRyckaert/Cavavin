require 'bundler/setup'
require 'sinatra'
require 'csv'

get '/' do
    erb :index
end

get '/search' do
    listeVins = []
    CSV.foreach("db/database.csv", headers: true, skip_blanks: true) do |row|
        if row[params["searchType"]].include?(params['query'])
            listeVins.push(row)
        end
    end
    erb :index, locals: { listeVins: listeVins }
end
