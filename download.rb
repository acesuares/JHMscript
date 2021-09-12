#encoding: utf-8
require "down"
require "erb"
require "httparty"
require "json"
require 'open-uri'

puts "making the dirs..."
%w(html html/videos html/thumbnails).each do |dir|
  puts "  #{dir}"
  Dir.mkdir(dir) unless File.exists?(dir)
end

puts "load the templates..."
chooser_template = IO.read("chooser.html.erb")
player_template  = IO.read("player.html.erb")

puts "get the data from the server..."
base_url = "https://jhm.suares.com"
base_url = "http://localhost:3000"
url = "#{base_url}/api/v1/movies/tvp"
puts "  #{url}"
response = HTTParty.get(url, format: :json)
puts "  HTTP: #{response.code}"

puts "write html/chooser.html..."
@topics = response.parsed_response["topics"]
IO.write("html/chooser.html", ERB.new(chooser_template).result(binding))

@movies = @topics.map{|topic| topic["movies"]}.flatten.uniq
@movies.each do |movie|
  @movie = movie
  puts "write html/player-#{movie['id']}.html..."
  IO.write("html/player-#{movie['id']}.html", ERB.new(player_template).result(binding))
  movie_url = movie["movie"]["url"]
  puts "  download #{base_url}#{movie_url}"
  # File.open("html/videos/#{File.basename(movie_url)}", "wb") do |file|
  #   file.write URI.open("#{base_url}#{movie_url}").read
  # end
  # Down.download("#{base_url}#{movie_url}",
          # destination: "html/videos/#{movie['id']}.mp4")


  thumbnail_url = movie["thumbnail"]["url"]
  puts "  download #{base_url}#{thumbnail_url}"
  # File.open("html/thumbnails/#{File.basename(thumbnail_url)}", "wb") do |file|
  #   file.write URI.open("#{base_url}#{thumbnail_url}").read
  # end
  # Down.download("#{base_url}#{thumbnail_url}",
          # destination: "html/thumbnails/#{movie['id']}.png")
end
