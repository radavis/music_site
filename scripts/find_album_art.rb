require 'last_fm'
require 'csv'
require 'pry'

path = File.expand_path(File.dirname(__FILE__))

# read csv
songs = []
CSV.read("#{path}/../songs.csv", headers: true).each do |row|
  songs << row.to_hash
end

# get album art
albums = songs.map { |song| song['album'] }.uniq
album_art = {}
albums.each do |album|
  results = LastFM::Album.search(album) rescue next
  puts "found #{album}"
  album_art[album] = results.first.images[:extralarge] || results.first.image
end

# output to csv
CSV.open("#{path}/../songs_with_album_art.csv", "w") do |csv|
  header = songs.first.keys
  header.push('image')
  csv << header
  songs.each do |song|
    song['image'] = album_art[song['album']]
    csv << song.values
  end
end
