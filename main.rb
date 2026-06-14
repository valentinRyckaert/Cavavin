require 'bundler/setup'
require 'sinatra'
require 'csv'

get '/' do
    erb :index
end

get '/search' do
    listeVins = []
    CSV.foreach("db/database.csv", headers: true, skip_blanks: true) do |row|
        if row["appelation"].include?(params['query'])
            listeVins.push(row)
        end
    end
    erb :index, locals: { data: listeVins }
end
