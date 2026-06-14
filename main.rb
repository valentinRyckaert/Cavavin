require 'bundler/setup'
require 'sinatra'
require 'csv'

get '/' do
    erb :index, locals: { listeVins: nil, action: nil }
end

get '/search/:action' do |action|
    listeVins = []
    csvData = CSV.read("db/database.csv", headers: true, skip_blanks: true)
    if action === 'consume'
        csvData.each do |row|
            if row[params["searchType"]].include?(params['query'])
                listeVins.push(row)
            end
        end
    elsif action === 'add'
        csvData.each do |row|
            if row["appelation"].include?(params['appelation']) && row["annee"].to_i === params["annee"].to_i
                listeVins.push(row)
            end
        end
    else
        halt 404, 'no route found' 
    end
    erb :index, locals: { listeVins: listeVins, action: action }
end
