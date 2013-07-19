require 'openssl'
require 'net/http'
require 'json'
require_relative 'config'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class MovieApi

  def self.clean_movie_name(movie_name)
    filename = File.basename(movie_name, '.*')             # remove file ext
    BLACKLIST_TERMS.each do |term|
        if filename[term]
          filename = filename.gsub(term, '')
        end
    end
    ILLEGAL_CHARACTERS.each { |char|
      filename.gsub!(char, '-')
    }
    filename.gsub('.',' ')
  end

  def self.fetch_movie_info(movie_title)
    movie_title = clean_movie_name(movie_title)

    uri = URI("http://private-e5c5-themoviedb.apiary.io/3/search/movie?query=#{URI::encode(movie_title)}&api_key=#{API_KEY}")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    result = JSON.parse(response.body)

    if result['total_results'] > 0
      fetch_movie_by_id result['results'][0]['id']
    end

  end

  def self.fetch_movie_by_id(id)
    uri = URI("http://private-e5c5-themoviedb.apiary.io/3/movie/#{id}?api_key=#{API_KEY}")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    detail = JSON.parse(response.body)
    movie = Hash.new

    begin
      movie['genre'] =  detail['genres'][0]['name']
    rescue
      movie['genre'] =  'Unknown'
    end

    movie['title'] = detail['title']
    movie
  end

end