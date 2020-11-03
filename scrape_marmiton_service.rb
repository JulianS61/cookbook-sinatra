require 'open-uri'
require 'nokogiri'

class ScrapeMarmitonService
  def initialize(keyword)
    @keyword = keyword
    file = "#{@keyword}.html"
    @doc = Nokogiri::HTML(File.open(file), nil, 'utf-8')
    # @doc = Nokogiri::HTML(open(get_url), nil, 'utf-8')
  end

  def get_url
    "https://www.marmiton.org/recettes/recherche.aspx?aqt=#{@keyword}"
  end

  def call
    list = []
    @doc.search('.recipe-card').first(5).each do |element|
      recipe_name = element.search('.recipe-card__title').text.strip
      recipe_description = element.search('.recipe-card__description').text.strip
      recipe_rating = element.search('.recipe-card__rating__value').text.strip
      recipe_duration = element.search('.recipe-card__duration__value').text.strip
      list << {name: recipe_name, description: recipe_description, rating: recipe_rating, prep_time: recipe_duration}
    end
    return list
  end
end
