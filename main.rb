require 'bundler/setup'
require 'sinatra'
require 'csv'

helpers do

    def createDBIfNotExists
        if !File.exist?("database.csv")
            CSV.open("database.csv", "wb") do |csv|
                csv << ["id", "appelation", "robe", "region", "domaine", "annee", "nbBouteilles"]
            end
        end
    end

    def get_new_id
        if File.exist?("database.csv") && !File.empty?("database.csv")
            last_row = CSV.read("database.csv", headers: true, skip_blanks: true).to_a.last
            return last_row[0].to_i + 1
        else
            return 1 # Start with ID 1 if the file is empty or doesn't exist
        end
    end
end

get '/' do
    createDBIfNotExists
    erb :index, locals: { action: nil, listeVins: nil, nouveauVin: nil }
end

get '/search/consume' do
    createDBIfNotExists
    listeVins = []
    csvData = CSV.read("database.csv", headers: true, skip_blanks: true)
    csvData.each do |row|
        if row[params["searchType"]].include?(params['query'])
            listeVins.push(row)
        end
    end
    erb :index, locals: { action: 'consume', listeVins: listeVins, nouveauVin: nil }
end

get '/search/add' do
    createDBIfNotExists
    listeVins = []
    csvData = CSV.read("database.csv", headers: true, skip_blanks: true)
    csvData.each do |row|
        if row["appelation"].include?(params['appelation']) && row["annee"].to_i == params["annee"].to_i
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

post '/changequantity/:action' do |action|
    createDBIfNotExists
    rows = CSV.read("database.csv", headers: true, skip_blanks: true)
    rows.each do |row|
        p row["id"], params["vinId"]
        if row["id"].to_i == params["vinId"].to_i
            row["nbBouteilles"] = action.to_i == 1 ? row["nbBouteilles"].to_i + params["nbBouteilles"].to_i : row["nbBouteilles"].to_i - params["nbBouteilles"].to_i
        end
    end
    CSV.open("database.csv", "wb") do |csv|
        csv << rows.headers
        rows.each do |row|
            csv << row.fields
        end
    end
    erb :index, locals: { action: nil, listeVins: nil, nouveauVin: nil }
end


post '/new' do
    createDBIfNotExists
    CSV.open("database.csv", 'a') do |db|
        db << [
            get_new_id,
            params["appelation"],
            params["robe"],
            params["region"],
            params["domaine"],
            params["annee"],
            params["nbBouteilles"].to_i
        ]
    end
    erb :index, locals: { action: nil, listeVins: nil, nouveauVin: nil }
end
