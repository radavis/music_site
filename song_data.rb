require 'taglib'
require 'csv'
require 'pry'

files = Dir.glob("/Users/rd/Music/**/*.flac")

CSV.open("songs.csv", "w") do |csv|
  files.each do |file|
    TagLib::FileRef.open(file) do |fileref|
      unless fileref.null?
        tag = fileref.tag
        # tag.title   #=> "Wake Up"
        # tag.artist  #=> "Arcade Fire"
        # tag.album   #=> "Funeral"
        # tag.year    #=> 2004
        # tag.track   #=> 7
        # tag.genre   #=> "Indie Rock"
        # tag.comment #=> nil

        properties = fileref.audio_properties
        # properties.length  #=> 335 (song length in seconds)

        csv << [tag.title, tag.artist, tag.album, tag.year, tag.track, tag.genre, properties.length]
      end
    end
  end  # File is automatically closed at block end
end
