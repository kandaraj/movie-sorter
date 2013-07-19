require_relative 'crawler'
require_relative 'movie_api'


movie_sorter = Crawler.new('E:/Hollywood','E:/',nil)

movie_list = movie_sorter.get_movie_list

puts "Renaming #{movie_list.length} files"

movie_list.each do |name|
  movie_info = MovieApi.fetch_movie_info(name)
  if movie_info.nil?
    puts "no idea #{ File.basename(name) }"
  else
    puts "renaming #{ File.basename(name) } ..."
    movie_sorter.move_file(name,movie_info)
  end
  sleep(0.5)
end

