class Wine

    attr_accessor :id, :appellation, :appearance, :region, :estate, :vintage, :nbBottles

    def initialize(id, appellation, appearance, region, estate, vintage, nbBottles)
        @id = id.to_i
        @appellation = appellation
        @appearance = appearance
        @region = region
        @estate = estate
        @vintage = vintage.to_i
        @nbBottles = nbBottles.to_i
    end

    # même ordre que les colonnes du CSV (cf. WineCSVDAO#createCSVDBIfNotExists)
    def attributes
        {
            "id" => @id, "appellation" => @appellation, "appearance" => @appearance, "region" => @region,
            "estate" => @estate, "vintage" => @vintage, "nbBottles" => @nbBottles
        }
    end
end