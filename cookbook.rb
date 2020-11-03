require 'csv'
require_relative 'recipe'


class Cookbook
  def initialize(csv_file_path)
    @filepath = csv_file_path
    @recipes = []
    load_csv
  end

  def all
    return @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    write_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    write_csv
  end

  def mark_as_done(recipe_index)
    @recipes[recipe_index].mark_done!
    write_csv
  end

  private

  def write_csv
    headers = ["name","description","rating","prep_time","done"]
    CSV.open(@filepath, "wb") do |csv|
      csv << headers
      @recipes.each { |recipe| csv << [recipe.name, recipe.description, recipe.rating, recipe.prep_time, recipe.done] }
    end
  end

  def load_csv
    options = {headers: :first_row, header_converters: :symbol}
    CSV.foreach(@filepath, "r", options) do |row|
      row[:done] = row[:done] == "true"
      @recipes << Recipe.new(row)
    end
  end
end
