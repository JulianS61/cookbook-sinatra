require 'rubygems'
require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end


require_relative 'cookbook'
require_relative 'recipe'
require_relative 'scrape_marmiton_service'

#cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))


get '/' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  @recipes = cookbook.all
  erb :index
end

get '/:id' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  cookbook.mark_as_done(params[:id].to_i)
  redirect '/'
end

get '/new' do
  erb :new
end

post '/recipes' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  cookbook.add_recipe(Recipe.new(params))
  redirect '/'
end

get '/recipes/:id' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  cookbook.remove_recipe(params[:id].to_i)
  redirect '/'
end

get '/import' do
  erb :import
end

post '/import' do
  import_book = Cookbook.new(File.join(__dir__, 'import.csv'))
  @keyword = params[:keyword]
  scrape = ScrapeMarmitonService.new(@keyword).call
  scrape.each do |recipe|
    import_book.add_recipe(Recipe.new(recipe)) unless import_book.all.map { |item| item.name }.include?(recipe[:name])
  end
  @import_recipes = import_book.all
  erb :import
end

get '/import/:id' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  import_book = Cookbook.new(File.join(__dir__, 'import.csv'))
  cookbook.add_recipe(import_book.all[params[:id].to_i])
  (import_book.all.length).times { import_book.remove_recipe(0) }
  redirect '/'
end

