require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def home
  end

  def new
    @letters = (1..10).map { ("A".."Z").to_a[rand(26)] }
  end

  def score
    time = Time.now.to_i - params[:startTime].to_i
    word = params[:word]
    letters = params[:letters].chars

    @result = generate_result(word, letters, time)
  end

  private

  def generate_result (word, letters, time)
    url = "https://dictionary.lewagon.com/#{word}"
    result_data = URI.parse(url).read
    result_hash = JSON.parse(result_data)

    return { word: word, score: 0, message: "Not in the grid", time: time } unless inside_grid?(word, letters)

    return { word: word, score: 0, message: "Not an English word", time: time } unless result_hash["found"]

    { word: word, score: ((word.length * 10) / time), message: "Well Done", time: time }
  end

   def inside_grid?(word, letters)
      word_array = word.upcase.chars
      word_array.all? { |letter| letters.index(letter).nil? ? false : letters.delete_at(letters.index(letter)) }
    end

end
