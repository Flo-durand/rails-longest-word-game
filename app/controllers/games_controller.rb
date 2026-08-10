require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def home
  end

  def new
    @letters = (1..10).map { ("A".."Z").to_a[rand(26)] }
  end

  def score
    def inside_grid?(attempt, grid)
      attempt_array = attempt.upcase.chars
      attempt_array.all? { |letter| grid.index(letter).nil? ? false : grid.delete_at(grid.index(letter)) }
    end

    # end_time = Time.now.to_i
    # start_time = params[:startTime].to_i
    time = Time.now.to_i - params[:startTime].to_i
    word = params[:word]
    letters = params[:letters].chars
    url = "https://dictionary.lewagon.com/#{word}"
    result_data = URI.parse(url).read
    result_hash = JSON.parse(result_data)
    @result = { word: word, score: ((word.length * 10) / time), message: "Well Done", time: time }

    @result =  { word: word, score: 0, message: "Not in the grid", time: time } unless inside_grid?(word, letters)

    @result =  { word: word, score: 0, message: "Not an English word", time: time } unless result_hash["found"]
  end
end
