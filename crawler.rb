require 'fileutils'
require_relative 'config'

class Crawler


  def initialize(file_path,dest_path,file_ext)

    @file_path = file_path
    @dest_path = dest_path
    @file_ext = file_ext

  end

  def get_movie_list
    movie_list = Array.new
    known_movie_format = Array['avi','mp4','mkv']

    @file_ext.split(',').each  { |extra| known_movie_format.push(extra) } unless @file_ext != nil?
    known_movie_format.each do |ff|
      Dir["#{@file_path}/**/*.#{ff}"].each { |f| movie_list.push(f)  }
    end
    movie_list
  end

  def move_file(source_file,movie_info)
    return if movie_info.nil?
    dest = @dest_path
    dest = @file_path if dest == nil?
    dest = File.join(dest,'RENAMED',movie_info['year'].to_s,movie_info['genre'])
    FileUtils.mkdir_p(dest) unless File.exists?(dest)
    clean_file_name = MovieApi.clean_movie_name(movie_info['title'])  + File.extname(source_file)
    new_file = File.join(dest,clean_file_name)
    File.rename(source_file,new_file)
  end

end