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
api_key = 'woogekiemeec4Phoh7ahz8quahv9gi'
tv = 1

url = "#{base_url}/api/v1/movies/#{tv}?api_key=#{api_key}"
puts "  #{url}"
response = HTTParty.get(url, format: :json)
puts "  HTTP: #{response.code}"

puts "write html/chooser.html..."
@topics = response.parsed_response["topics"]
IO.write("html/chooser.html", ERB.new(chooser_template).result(binding))

@movies = @topics.map{|topic| topic["tv_movies"]}.flatten.uniq
@movies.each do |movie|
  @movie = movie
  puts "write html/player-#{movie['id']}.html..."
  IO.write("html/player-#{movie['id']}.html", ERB.new(player_template).result(binding))
  movie_url = movie["movie"]["url"]
  puts "  download #{base_url}#{movie_url}"
  Down.download("#{base_url}#{movie_url}",
          destination: "html/videos/#{movie['id']}.mp4")


  thumbnail_url = movie["thumbnail"]["url"]
  puts "  download #{base_url}#{thumbnail_url}"
  Down.download("#{base_url}#{thumbnail_url}",
          destination: "html/thumbnails/#{movie['id']}.png")
end
