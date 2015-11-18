require 'sinatra'
require 'csv'
require_relative "app/models/television_show"

set :views, File.join(File.dirname(__FILE__), "app/views")

current_show = nil

get '/television_shows' do
  @all_shows = TelevisionShow.all
  erb :index
end

get '/television_shows/new' do
  if current_show
    @error = current_show.errors
  else
    @error = ""
  end
  erb :new
end

post '/television_shows/new' do
  new_show = TelevisionShow.new(params[:title], params[:network], params[:starting_year], params[:synopsis], params[:genre])
  current_show = new_show
  if new_show.save
    redirect '/television_shows'
  else
    redirect '/television_shows/new'
  end
end
