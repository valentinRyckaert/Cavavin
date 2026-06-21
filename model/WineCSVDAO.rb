require_relative 'Wine'

class WineCSVDAO

  def initialize(dBpath)
    @dBpath = dBpath
  end

  def all
	wineList = []
    self.dbData.each do |row|
      wineList.push(Wine.new(*row.to_h.values))
    end
    wineList
  end

  def get(id)
    self.dbData.each do |row|
      return Wine.new(*row.to_h.values) if row["id"].to_i == id
    end
    false
  end

	def createOrUpdate(wine)
		rows = self.dbData
		existing_row_index = rows.find_index { |row| row["id"].to_i == wine.id }

		if existing_row_index
			rows[existing_row_index]["nbBottles"] = wine.nbBottles.to_s
		else
			rows << CSV::Row.new(wine.attributes)
		end

		CSV.open(@dBpath, "wb") do |csv|
			csv << rows.headers unless rows.empty?
			rows.each { |row| csv << row.fields }
		end

		true
	end


  def remove(id)
		rows = []

		self.dbData.each do |row|
			rows << row unless row["id"].to_i == id
		end

		CSV.open(@dBpath, "wb") do |csv|
			csv << rows.headers unless rows.empty?
			rows.each { |row| csv << row.fields }
		end

		true
  end

  def createCSVDBIfNotExists
    if !File.exist?(@dBpath)
        CSV.open(@dBpath, "wb") do |csv|
            csv << ["id", "appellation", "appearance", "region", "estate", "vintage", "nbBottles"]
        end
    end
  end

  private

		def dbData
			if File.exist?(@dBpath)
				CSV.read(@dBpath, headers: true, skip_blanks: true)
			else
				[]
			end
		end


end