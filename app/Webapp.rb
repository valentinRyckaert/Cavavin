require 'bundler/setup'
require 'sinatra'
require 'csv'
require_relative 'model/WineCSVDAO'
require_relative 'model/Wine'
require 'dotenv'

class WebApp < Sinatra::Base

    configure do
        Dotenv.load('.env')
        set :WineDAO, WineCSVDAO.new(ENV["DB_PATH"])
    end

    helpers do

        def get_new_id
            if File.exist?(ENV["DB_PATH"]) && !File.empty?(ENV["DB_PATH"])
                last_row = CSV.read(ENV["DB_PATH"], headers: true, skip_blanks: true).to_a.last
                return last_row[0].to_i + 1
            else
                return 1 # Start with ID 1 if the file is empty or doesn't exist
            end
        end
    end

    get '/' do
        erb :index, locals: { action: 'consume', listeVins: settings.WineDAO.all, nouveauVin: nil }
    end

    get '/search/consume' do
        listeVins = []
        settings.WineDAO.all.each do |wine|
            if wine.instance_variable_get("@#{params["searchType"]}").include?(params['query'])
                listeVins.push(wine)
            end
        end
        erb :index, locals: { action: 'consume', listeVins: listeVins, nouveauVin: nil }
    end

    get '/search/add' do
        listeVins = []
        settings.WineDAO.all.each do |wine|
            if wine.appellation.include?(params['appellation']) && wine.vintage == params["vintage"].to_i
                listeVins.push(wine)
            end
        end
        erb :index, locals: {
            action: 'add',
            listeVins: listeVins,
            nouveauVin: {
                :appellation => params['appellation'],
                :vintage => params["vintage"].to_i
            }
        }
    end

    post '/changequantity/:action' do |action|
        settings.WineDAO.all.each do |wine|
            if wine.id == params["vinId"].to_i
                wine.nbBottles = action == "add" ? 
                    wine.nbBottles.to_i + params["nbBottles"].to_i :
                    wine.nbBottles.to_i - params["nbBottles"].to_i
                settings.WineDAO.createOrUpdate(wine)
            end
        end
        redirect '/'
    end


    post '/new' do
        settings.WineDAO.createOrUpdate(Wine.new(
            get_new_id,
            params["appellation"],
            params["appearance"],
            params["region"],
            params["estate"],
            params["vintage"],
            params["nbBottles"].to_i
        ))
        redirect '/'
    end
end