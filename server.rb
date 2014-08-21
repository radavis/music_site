require 'sinatra'
require 'csv'
require 'pry'

MUSIC_DATA = 'songs.csv'
RESULTS_PER_PAGE = 20

def import_csv(filename=MUSIC_DATA)
  result = []
  CSV.read(filename, headers: true).each do |row|
    result << row
  end
  result
end

helpers do
  def seconds_to_time(sec)
    sec = sec.to_i
    minutes = sec / 60
    seconds = sec % 60
    "#{minutes}:#{seconds.to_s.rjust(2, '0')}"
  end

  def slugify(string)
    string.gsub(/\s/, '_')
  end

  def unslugify(string)
    string.gsub(/_/, ' ')
  end
end

get '/' do
  redirect to '/albums'
end

get '/albums' do
  songs = import_csv
  @albums = songs.map { |song| "#{song['artist']} - #{song['album']}" }.uniq
  erb :albums
end

get '/albums/:album' do
  @songs = import_csv
  @album = unslugify(params[:album])

  @album_songs = @songs.select { |song| song['album'] == @album }
  @artist = @album_songs[0]['artist']
  @year = @album_songs[0]['year']
  @genre = @album_songs[0]['genre']

  erb :album
end

get '/songs' do
  @songs = import_csv

  # pagination!
  @page = (params['page'] || 1).to_i
  start_index = RESULTS_PER_PAGE * (@page - 1)
  end_index = RESULTS_PER_PAGE * (@page - 1) + (RESULTS_PER_PAGE - 1)
  @songs = @songs[start_index..end_index]

  erb :songs
end
