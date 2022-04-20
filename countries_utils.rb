require "json"

class CountriesUtils
  def load_countries()
    path = "./countries.json"
  
    JSON.parse(File.read(path)).map { |country| country.downcase }
  end
  
  def choose_country_between(min = 5, max = 12)
    size = @countries.length
    country = nil
  
    while !country
      random_country = @countries[rand(size)]
  
      if random_country.size >= min and random_country.size <= max
        country = random_country
      end
    end
  
    country
  end

  def initialize()
    @countries = load_countries()
  end
end