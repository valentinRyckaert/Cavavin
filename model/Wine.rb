class Wine

    attr_accessor :id, :appellation, :appearance, :region, :estate, :vintage, :nbBottles

    def initialize(id, appellation, appearance, region, estate, vintage, nbBottles)
        @id = id.to_i
        @appellation = appellation
        @appearance = appearance
        @region = region
        @estate = estate
        @vintage = vintage
        @nbBottles = nbBottles.to_i
    end
end