# script that exports song data to csv

require 'taglib'
require 'csv'

MUSIC_FOLDER = '/Users/rd/Music'

files = Dir.glob("#{MUSIC_FOLDER}/**/*.flac")

songs = []
files.each do |file|
  TagLib::FileRef.open(file) do |fileref|
    next if fileref.null?
    tag = fileref.tag
    properties = fileref.audio_properties
    songs << [tag.title, tag.artist, tag.album, tag.year, tag.track, tag.genre, properties.length]
  end
end

path = File.expand_path(File.dirname(__FILE__))
CSV.open("#{path}/../songs.csv", "w") do |csv|
  csv << %w(title artist album year track genre length)
  songs.each { |song| csv << song }
end
