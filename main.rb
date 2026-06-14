require 'bundler/setup'
require 'sinatra'
require 'csv'

helpers do
  def get_new_id
    if File.exist?("db/database.csv") && !File.empty?("db/database.csv")
        last_row = CSV.read("db/database.csv", headers: true).to_a.last
        return last_row[0].to_i + 1
    else
        return 1 # Start with ID 1 if the file is empty or doesn't exist
    end
  end
end

get '/' do
    erb :index, locals: { action: nil, listeVins: nil, nouveauVin: nil }
end

get '/search/consume' do
    listeVins = []
    csvData = CSV.read("db/database.csv", headers: true, skip_blanks: true)
    csvData.each do |row|
        if row[params["searchType"]].include?(params['query'])
            listeVins.push(row)
        end
    end
    erb :index, locals: { action: 'consume', listeVins: listeVins, nouveauVin: nil }
end

get '/search/add' do
    listeVins = []
    csvData = CSV.read("db/database.csv", headers: true, skip_blanks: true)
    csvData.each do |row|
        if row["appelation"].include?(params['appelation']) && row["annee"].to_i === params["annee"].to_i
            listeVins.push(row)
        end
    end
    erb :index, locals: {
        action: 'add',
        listeVins: listeVins,
        nouveauVin: {
            :appelation => params['appelation'],
            :annee => params["annee"].to_i
        }
    }
end

post '/new' do
    CSV.open("db/database.csv", 'a') do |db|
        db << [
            get_new_id,
            params["appelation"],
            params["robe"],
            params["region"],
            params["domaine"],
            params["annee"],
            params["nbBouteille"].to_i
        ]
    end
    erb :index, locals: { action: nil, listeVins: nil, nouveauVin: nil }
end
