require 'csv'
require 'pry'

class TelevisionShow
  GENRES = ["Action", "Mystery", "Drama", "Comedy", "Fantasy"]
  attr_reader :title, :network, :starting_year, :genre, :synopsis, :errors, :valid

  def initialize(title, network, starting_year, genre, synopsis)
    @title = title
    @network = network
    @starting_year = starting_year
    @genre = genre
    @synopsis = synopsis
    @errors = []
  end

  def valid?
    valid_input = !all_properties.any? { |property| property == "" }
    all_shows = []
    CSV.foreach('television-shows.csv', headers: true, header_converters: :symbol) do |row|
      info = row.to_hash
      all_shows << info
    end
    valid_no_duplicate = !all_shows.any? { |show| show[:title] == title }

    @valid = valid_input && valid_no_duplicate

    if !valid_input && !valid_no_duplicate
      errors << "Please fill in all required fields"
      errors << "The show has already been added"
    elsif !valid_input
      errors << "Please fill in all required fields"
    elsif !valid_no_duplicate
      errors << "The show has already been added"
    end

    @valid
  end


  def self.all
    all_shows = []
    CSV.foreach('television-shows.csv', headers: true, header_converters: :symbol) do |row|
      row_hash = row.to_hash
      show = TelevisionShow.new(row_hash[:title], row_hash[:network], row_hash[:starting_year], row_hash[:genre], row_hash[:synopsis])
      all_shows << show
    end
    all_shows
  end

  def save
    valid?
    if @valid
      CSV.open('television-shows.csv', 'a') do |csv|
        csv << all_properties
      end
    end
    @valid
  end


  private
  def all_properties
    [title, network, starting_year, genre, synopsis]
  end

end
