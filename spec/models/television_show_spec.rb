require "spec_helper"

describe TelevisionShow do
  let(:friends) { TelevisionShow.new('Friends', 'NBC', '1994', 'Comedy', 'Six friends living in NYC')}

  describe '.new' do
    it 'takes a title, network, starting year, genre, and synopsis as arguments' do
      expect(friends).to be_a(TelevisionShow)
      expect(friends.title).to eq('Friends')
      expect(friends.network).to eq('NBC')
      expect(friends.starting_year).to eq('1994')
      expect(friends.genre).to eq('Comedy')
      expect(friends.synopsis).to eq('Six friends living in NYC')
    end
  end

  describe 'self#all' do
    it 'contains all of the shows in the CSV file' do
      CSV.open('television-shows.csv', 'a') do |csv|
        csv << ['Friends', 'NBC', '1994', 'Comedy', 'Six friends living in NYC']
      end
      CSV.open('television-shows.csv', 'a') do |csv|
        csv << ['TestTitle', 'TestNetwork', '1994', 'Action', 'Synopsis']
      end

      expect(TelevisionShow.all).to be_a(Array)
      expect(TelevisionShow.all.length).to eq(2)

      all_shows = []
      CSV.foreach('television-shows.csv', headers: true, header_converters: :symbol) do |row|
        info = row.to_hash
        all_shows << info
      end

      TelevisionShow.all.each_with_index do |show, index|
        expect(show.title).to eq(all_shows[index][:title])
        expect(show.network).to eq(all_shows[index][:network])
        expect(show.starting_year).to eq(all_shows[index][:starting_year])
        expect(show.genre).to eq(all_shows[index][:genre])
        expect(show.synopsis).to eq(all_shows[index][:synopsis])
      end
    end
  end

  describe '#save' do
    it 'receives error for submitting the same entry twice' do
      CSV.open('television-shows.csv', 'a') do |csv|
        csv << ['Friends', 'NBC', '1994', 'Comedy', 'Six friends living in NYC']
      end

      expect(friends.save).to eq(false)
      expect(friends.errors.length).to eq(1)
      expect(friends.errors[0]).to eq("The show has already been added")
    end

    it 'receives error for incomplete fields' do
      a = TelevisionShow.new("","","",'hello',"")
      expect(a.save).to eq(false)
      expect(a.errors.length).to eq(1)
      expect(a.errors[0]).to eq("Please fill in all required fields")
    end

    it 'recieves errors for submitting the same entry twice and having incomplete fields' do
      CSV.open('television-shows.csv', 'a') do |csv|
        csv << ["", 'NBC', '1994', 'Comedy', 'Six friends living in NYC']
      end

      a = TelevisionShow.new("","","",'hello',"")
      expect(a.save).to eq(false)

      expect(a.errors.length).to eq(2)
      expect(a.errors[0]).to eq("Please fill in all required fields")
      expect(a.errors[1]).to eq("The show has already been added")


    end
  end
end
